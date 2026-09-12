Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2744A39EF0B;
	Sat, 12 Sep 2026 20:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243357; cv=none; b=buomOdZw6oOzLDxyTC08ozmDtezblixmYRNzKLjzeyz+VEHPJ9AlpIWk6GxqCIbg+QWzBunArCiJ9n1nbj+RHqtlJ8lPa+9ysFN0+YFfdg059Kijktyh2w0qH/a5p9e7Utt8bZw+9z+e0JaLvh3nJOySLw8bneFqRzllabQPwSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243357; c=relaxed/simple;
	bh=VHvKASjtXfVptown0t8iZpgW8agbNoH9m/aD+VJRC4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I6RBOfFBl5MImLOZ4mGH8vW7JWh64pPqxsNmJDMBZw66lV/DSq+q7z83gmefBL8LybDa8Ppazs8Eizi9SK+ihY670+NdMXoX6K3zdloHOhVQiiTJKA9aZc4g1/fRAveaHSqty1CxnmfqxJZv73Ylcgy3K+0mKRlJ/x98fTjRVEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vb5cz8hT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vb5cz8hT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED46F1F00893;
	Sat, 12 Sep 2026 20:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243353;
	bh=Y13XP8Zz3rsiIuQrBdKmdDQtBw17kbVsAIkAIAkmSBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vb5cz8hTDvsan+25eB4veNLJT2f0ktsfEMzhz+PE2KZ8rAA/mvkSutmhYbCyfubX5
	 Bfp+1y7MmalCi482Ee8b9ZL7cZKrhj8Wds5QNsVXzEYXyIzt5utfaOP8ARPLjXAECU
	 IB7PPcsapN6dqGrV6j5e+Esu3bdhYOyWVTylPBEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sechang Lim <rhkrqnwk98@gmail.com>,
	Junseo Lim <zirajs7@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 725/798] net: kcm: Hold RCU read lock while running BPF parser
Date: Sat, 12 Sep 2026 09:05:53 +0200
Message-ID: <20260912065533.698644441@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junseo Lim <zirajs7@gmail.com>

[ Upstream commit b0346dd64e4905291cc9c479f2e6cf1884ced4e6 ]

kcm_parse_func_strparser() calls bpf_prog_run_pin_on_cpu() which
prevents CPU migration, but does not establish an RCU read-side
critical section. Consequently, BPF map operations can trigger
WARN_ON_ONCE(!bpf_rcu_lock_held()) when called from the KCM strparser
program.

Hold the RCU read lock while running the program.

Fixes: 9b73896a81dc ("kcm: Use stream parser")
Reported-by: Sechang Lim <rhkrqnwk98@gmail.com>
Signed-off-by: Junseo Lim <zirajs7@gmail.com>
Link: https://patch.msgid.link/20260813035136.106167-1-zirajs7@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/kcm/kcmsock.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index df3ca6a9791e6..e2d55d344deb8 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -5,6 +5,7 @@
  * Copyright (c) 2016 Tom Herbert <tom@herbertland.com>
  */
 
+#include <linux/rcupdate.h>
 #include <linux/bpf.h>
 #include <linux/errno.h>
 #include <linux/errqueue.h>
@@ -385,7 +386,9 @@ static int kcm_parse_func_strparser(struct strparser *strp, struct sk_buff *skb)
 	struct bpf_prog *prog = psock->bpf_prog;
 	int res;
 
+	rcu_read_lock();
 	res = bpf_prog_run_pin_on_cpu(prog, skb);
+	rcu_read_unlock();
 	return res;
 }
 
-- 
2.53.0



