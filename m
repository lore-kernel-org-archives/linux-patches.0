Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF6A373BF3;
	Sat, 12 Sep 2026 09:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204208; cv=none; b=AzV9HxqgvMlS4fW3NNC8tGCNLmsIDgejvu996GOMOuh5An4/zAQ7fzJpYZ9z0EV9Cdai4b+tVwYMHvkITQ5MtD703UZOk0N9hifDwDXskdJSGHqvFAkSQWelEeXKj7a4IZ7D/T+AVF4dKGP3mciMPAzqDM4jLroGFyj5RaZXeZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204208; c=relaxed/simple;
	bh=1PWm8Ob5fWiVVm8TBUdscytWKMKwdOLwHj9/z0iUy0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hDvYiQKr9MDKG4QHFASsWrsiaeK9rr7tt9i3gyRQQIaG/Hwc1eY4MAPozG8Idphnq8sjn9zRg/Fo7XUFC4oW2LAzY0Aj3tZoUsKpmAmnlC7hFr1i/Kd7cNx6cxnPGqi6kG2qYsSK2cnxtGBo4e+Xk4OKgetb4T0M0qeiqTMii5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JBXF5Led; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JBXF5Led"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 642351F000FF;
	Sat, 12 Sep 2026 09:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204207;
	bh=mJxMYmpWorEmBLR8JfydsV0RPt7Rc7GwqO1HxEErUr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JBXF5LeddeupWiMv18B9D7e4I3zO6FYAQh8Hpq+rMbFYyI5fmUAWocGUaBOGBu9Xl
	 McovJfm92iq7Uw4Sb/4T0Wi/g86TRYn4/grdp0WcFocTxqxiksQK/zU0qtK3gjvr+6
	 HWYQH5XPvLStAwQBYS4M0LVSmvGP2BOOJl2MKJmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sechang Lim <rhkrqnwk98@gmail.com>,
	Junseo Lim <zirajs7@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1566/1815] net: kcm: Hold RCU read lock while running BPF parser
Date: Sat, 12 Sep 2026 08:55:16 +0200
Message-ID: <20260912065725.756924399@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index d469abcd989b4..71af69d442f21 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -5,6 +5,7 @@
  * Copyright (c) 2016 Tom Herbert <tom@herbertland.com>
  */
 
+#include <linux/rcupdate.h>
 #include <linux/bpf.h>
 #include <linux/errno.h>
 #include <linux/errqueue.h>
@@ -391,7 +392,9 @@ static int kcm_parse_func_strparser(struct strparser *strp, struct sk_buff *skb)
 	struct bpf_prog *prog = psock->bpf_prog;
 	int res;
 
+	rcu_read_lock();
 	res = bpf_prog_run_pin_on_cpu(prog, skb);
+	rcu_read_unlock();
 	return res;
 }
 
-- 
2.53.0



