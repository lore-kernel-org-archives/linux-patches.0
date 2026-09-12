Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDCC738655A;
	Sat, 12 Sep 2026 13:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218675; cv=none; b=mtRT6sVcYcIzGq/sm54Dg3c8MqzfQFQxDrQek2Vz5rOmeTeRwdouUjT5ODfkQN3jr9ySz4CmmegkoePQEuFMyZtcgKr29iIvZol1xpg3FCsq+ccthTHflB0dwPRyrCgc7wTdAj6IvekcpqBjmXpyk6J4TOCpUv61eTc0jhu0jYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218675; c=relaxed/simple;
	bh=2dpL8gso7X4szcyFkNd7EH3HcTbgOTP6xs8HBJGfOVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y385LAW8bEKZ1DNm0US/WiOK1vdaDBwKcsqBENLYrZFR1KbEQziGsi25FRVi7fxUAHR9+vm+mO46/7cX+MlDYxBV/JzJW8QfkcFTzhsoLu7EqgMsbPqWgG5EE3RW/QhcsT1dm4hNa50+L+pd42WYFoI7kyFQ93vOKWpidoot3f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A+mymgAC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A+mymgAC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B81641F000FF;
	Sat, 12 Sep 2026 13:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218674;
	bh=Zkxf7Cm0C3HdYnXHjSauYK9hgc89dKfGwHuDZ1BJbqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A+mymgACEcfOBWJkKdn4H9nn6Bwj5hWTsdIQeNXSaeMwiKyToacLm9l51QRUiNSt3
	 GupizkNUXlaFqqQjJzx0+IZvu59yB1hZ84FHOSgm8Abx3/PgnzrLEfEX/uWO8Jsl/L
	 WbSfYiCKMfPmT0U+izQduv1tAl8Lppl5+WdzaMdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sechang Lim <rhkrqnwk98@gmail.com>,
	Junseo Lim <zirajs7@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1192/1376] net: kcm: Hold RCU read lock while running BPF parser
Date: Sat, 12 Sep 2026 09:00:18 +0200
Message-ID: <20260912065634.117255293@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5736f06d81432..0340db5174a94 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -5,6 +5,7 @@
  * Copyright (c) 2016 Tom Herbert <tom@herbertland.com>
  */
 
+#include <linux/rcupdate.h>
 #include <linux/bpf.h>
 #include <linux/errno.h>
 #include <linux/errqueue.h>
@@ -389,7 +390,9 @@ static int kcm_parse_func_strparser(struct strparser *strp, struct sk_buff *skb)
 	struct bpf_prog *prog = psock->bpf_prog;
 	int res;
 
+	rcu_read_lock();
 	res = bpf_prog_run_pin_on_cpu(prog, skb);
+	rcu_read_unlock();
 	return res;
 }
 
-- 
2.53.0



