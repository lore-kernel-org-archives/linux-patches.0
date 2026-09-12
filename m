Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0942F3A5E88;
	Sat, 12 Sep 2026 19:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240311; cv=none; b=IRkx+6CDORpCBFCaMXAqOGU0nJC8HLlpxZNemAE1Iqnhpvxq4zDGOHE8qtcUWhMYoS/NnZ2pjdLqL+67pTE8Oo7GWiqh+ha7boQks58SLMWDk4DR5MMqVprUjwyO8RxWTcXyWaWq+dgx9gZ+YEVKUtVmv3iSk9YQzeGFmGObIW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240311; c=relaxed/simple;
	bh=qW7F1xIKMi4yzjgPwK9P+LqfhDO6LJl/IYLa02V8+CQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kjN8YKeyaeczywinaMjGh+d0IPZgxDTTkQ7ga+FA8FAqJkC3T0hpMwOKaBHBgyBBTmVlIjEa4ghK7GSXz9UoOZnCFN/u8Ooqxu96nNFD6NGR2tRTuUZ8D78D7/8pH5vNkdrno0R1D7z37nXALIOjgT/2S1HIdZGZ/Rwz3x+nDxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mz58s9rz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mz58s9rz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20EE81F000FF;
	Sat, 12 Sep 2026 19:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240309;
	bh=LQC2Eiw86O+5PVKI8u/h8BkX5UNj3Jdz277mM0o6xCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mz58s9rzow4pFp0cAwFUyfudsqxomh6nid+s3RruSl17rhnSk4dXaBslp5cqF2uyy
	 RbCQ4GevGrYW4yDpYT8yDorhsMWE4wcF9E7X1ubPa/+hZ0gYkUq/jse9KqpEPJ/36A
	 klzGy1KgeWllGk/lKjiISP0GUr7I6/JaFQsYU/TE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sechang Lim <rhkrqnwk98@gmail.com>,
	Junseo Lim <zirajs7@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 841/935] net: kcm: Hold RCU read lock while running BPF parser
Date: Sat, 12 Sep 2026 09:04:31 +0200
Message-ID: <20260912065546.116088344@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a0533400af808..8136519e61377 100644
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



