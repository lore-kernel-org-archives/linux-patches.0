Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B3C37F01B;
	Wed,  8 Apr 2026 18:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672969; cv=none; b=Wno/C2rxIyQ53IPO8Vh2GHyvGkvY7VpVDU+5+C5ZNbv7DrpxQH2+vyj/0cTm7k8TSkr/F4zMIn+dw/B2XyXUiciQOjD8nSPbET3zqrbYx1AFg341FzJFqR+MbhsdgR9ay9GqEPG1r8P/R04mxm50bH3ocfmVDKQ3VxjvfGoJzTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672969; c=relaxed/simple;
	bh=mBAo5M/4+N2Xs+tPWrIuyMVk5AYD1gLdPTsK4d0pCWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FwnpOeqpUTy9BxagXd6Sqbd4W40JOWlDfp0POj3AW8vJFFe4b0eWlyfsDq2v+96ptHIwG/QfTEasmaPgIPvFaMgQPNGWVinmOAr3/ptOdH7lIh3vuOwlXx/yf+9j3zqPamSvP1dc+CuEs0dGx1VchNBu7pI/N0rxowhz59U2LDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wmT5I7p4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wmT5I7p4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11018C19421;
	Wed,  8 Apr 2026 18:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672969;
	bh=mBAo5M/4+N2Xs+tPWrIuyMVk5AYD1gLdPTsK4d0pCWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wmT5I7p4pL7RXGUul4u1yQ9my3rsLP7gg0mqoBPwNdnRUm9uU2aixjx550RkT6aob
	 G4dJLTBUOfhL/j3JpnsHYyBro2ubMOXggN79AfPPGOWzbXK5+HQXP7BqvOoCOIrqd3
	 3Vg6c4gV7ymCNWUn2PHwJAwVIVb1BcC0mNGrmjwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yochai Eisenrich <echelonh@gmail.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 051/277] net: sched: cls_api: fix tc_chain_fill_node to initialize tcm_info to zero to prevent an info-leak
Date: Wed,  8 Apr 2026 20:00:36 +0200
Message-ID: <20260408175935.763835439@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

From: Yochai Eisenrich <echelonh@gmail.com>

[ Upstream commit e6e3eb5ee89ac4c163d46429391c889a1bb5e404 ]

When building netlink messages, tc_chain_fill_node() never initializes
the tcm_info field of struct tcmsg. Since the allocation is not zeroed,
kernel heap memory is leaked to userspace through this 4-byte field.

The fix simply zeroes tcm_info alongside the other fields that are
already initialized.

Fixes: 32a4f5ecd738 ("net: sched: introduce chain object to uapi")
Signed-off-by: Yochai Eisenrich <echelonh@gmail.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20260328211436.1010152-1-echelonh@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index bac9cd71ff8e9..b03dc4fe20e52 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -2969,6 +2969,7 @@ static int tc_chain_fill_node(const struct tcf_proto_ops *tmplt_ops,
 	tcm->tcm__pad1 = 0;
 	tcm->tcm__pad2 = 0;
 	tcm->tcm_handle = 0;
+	tcm->tcm_info = 0;
 	if (block->q) {
 		tcm->tcm_ifindex = qdisc_dev(block->q)->ifindex;
 		tcm->tcm_parent = block->q->handle;
-- 
2.53.0



