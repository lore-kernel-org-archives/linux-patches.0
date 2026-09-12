Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A3947CA67;
	Sat, 12 Sep 2026 16:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231664; cv=none; b=a6oQat3l/QC8mf8RA/KaIP3JhBx1kd/v+eqDDzhlJCIn4QRsCAaIKD5jp1uEC5oNuUbtrJ3n05f54ODqDndsJZ6ALrt5h9dMPH8oJPr1CBWoa15JZswMN6AVT32jUd9aAzpu2HbpfwOgeyoaiAkK7oKl3hBB30iE4BgcEN8fGQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231664; c=relaxed/simple;
	bh=d0OnBSuVSgeBJ/bQc8G3msqPCeqtqNGwPGteLlTIz0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aarnM7AnELLzzL6lSCXUSbFfP6xSFOJIozgO8OfPl1lzAjE48lYx7KswiDse+fiUTj5qcoDm22qTneBzbF4VF5hh2qTPs9KdUyOZHhGXfoMesHxTbghneY0XnTRXix82rxSvhRPJPz9UJA1Ua1TnsGHASXbJTyUB24sEIw04i0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oh819JF/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oh819JF/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6B1A1F000FF;
	Sat, 12 Sep 2026 16:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231662;
	bh=aKDmWXiM+EG3iXACUBLI633C9XQ/t/t2jmsVbvxZM3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oh819JF/9rPCIikJmmi6+rHxgOe1bymKW8CHKS/XLqjk8V4kjOgAalMoCPHbRqnlf
	 uOFj3w0Xw5c2er+cxtecSJz+fiA4EFamfXqwBdoc4eYu+Sh16995zTazvUDUJhUDMF
	 EXzKF5LkWCvze+kT0iEk8CJ05FNzHC3JOoEjx7cs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sechang Lim <rhkrqnwk98@gmail.com>,
	Junseo Lim <zirajs7@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1044/1191] net: kcm: Hold RCU read lock while running BPF parser
Date: Sat, 12 Sep 2026 09:02:52 +0200
Message-ID: <20260912065611.626118411@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ba221c6a8cbd7..ab7629cee1bd0 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -5,6 +5,7 @@
  * Copyright (c) 2016 Tom Herbert <tom@herbertland.com>
  */
 
+#include <linux/rcupdate.h>
 #include <linux/bpf.h>
 #include <linux/errno.h>
 #include <linux/errqueue.h>
@@ -386,7 +387,9 @@ static int kcm_parse_func_strparser(struct strparser *strp, struct sk_buff *skb)
 	struct bpf_prog *prog = psock->bpf_prog;
 	int res;
 
+	rcu_read_lock();
 	res = bpf_prog_run_pin_on_cpu(prog, skb);
+	rcu_read_unlock();
 	return res;
 }
 
-- 
2.53.0



