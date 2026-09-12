Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29DBB35E549;
	Sat, 12 Sep 2026 11:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211586; cv=none; b=uQ/W5TvEKnQS0Swc36Q3uPfdOL4kdUxYwZICO/7gJjcLQ3dtLkIko3qXvynP+YwRK3RvyMHdQrJlkfjeQLdKp1x/hEUIFwAZYatx2b2weAMMuqlha02PRyIBe3BELifcd/rbui+3DGoo/6zDcxmLUwDOy0Kf7OInrsxuEr43JOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211586; c=relaxed/simple;
	bh=RVWD9U0dEAiVHyc/2olwjmEHseGEk+G+/9wtS1lys1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K3krdBP+Kb9cWP0IxGEmhDpSpIV8sYZgjMKhd5mNzinfpok4RxP1UEGem0Eg21C74GYZHTORERoxbGX/zRmzCYIAUIfbpOJXqPIjoN1dvADoFdhcYwlUzPBCLV94SuoCNREf4bH0QsF7wrA/mzwPexXD0jCEXRB7xgzoUEJZ6js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YrHcgF/U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YrHcgF/U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDEBB1F000FF;
	Sat, 12 Sep 2026 11:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211584;
	bh=b78sE7DXY1r3XbnubbokMUrDynUk9mNIxpx5raj0xuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YrHcgF/U3KYf86mS3OnnyRhLvtMYLLp1DGBVT7EQKb4hGbT3qnNdAMujgUlg0ibpM
	 xqQ1pVxK5WwFMAd8k+RbWepGRjiW1R0jiJQStqTGl1VTJcmUP8+vjFylM9g19120ys
	 ebQK/fufJxTDxFA1yY/Aw/y6hEdvKTq8AyRVCzIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sechang Lim <rhkrqnwk98@gmail.com>,
	Junseo Lim <zirajs7@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1261/1518] net: kcm: Hold RCU read lock while running BPF parser
Date: Sat, 12 Sep 2026 08:57:10 +0200
Message-ID: <20260912065652.037721719@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index dc126f7f030c4..0753af2a5128b 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -5,6 +5,7 @@
  * Copyright (c) 2016 Tom Herbert <tom@herbertland.com>
  */
 
+#include <linux/rcupdate.h>
 #include <linux/bpf.h>
 #include <linux/errno.h>
 #include <linux/errqueue.h>
@@ -390,7 +391,9 @@ static int kcm_parse_func_strparser(struct strparser *strp, struct sk_buff *skb)
 	struct bpf_prog *prog = psock->bpf_prog;
 	int res;
 
+	rcu_read_lock();
 	res = bpf_prog_run_pin_on_cpu(prog, skb);
+	rcu_read_unlock();
 	return res;
 }
 
-- 
2.53.0



