Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE603D9053;
	Wed,  8 Apr 2026 18:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672566; cv=none; b=S6zTQZm6FmYSCAP4Z3PwSipW/DsTO2xBz4hJ3S/ATwTX6C7HCsc/fHWLCJ4s577RzzVJQtCQiSRXOKnbnjeC6PdZrRMIbxepXOoVXcqhEOBlADHjrwjbef3XC+qqPMyzV2bReH5jIIZLPSUQ496xtIENyG+ZP0cw6rl6VaJkveo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672566; c=relaxed/simple;
	bh=mlddO7CZYYYWTz76MIjrkD7YA5BdrXNszloB0UNiZTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cSqajwY4QQvRhjGvck4uGHSJmUcduQ5I+5FB6ATxrmCP0ewzrFWI5SIQ4vE82q5+A9/X/h22Mz6C7pDxRIVqNE1qEfo+B6rRC8jlN8RYa3mSz7HjAkTFrdrlr4F68S5x8j7/dOHel72sOEnTZGzpBJ72j3pJwg4nxNYuSZg5u78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cmvErksW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cmvErksW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21435C19421;
	Wed,  8 Apr 2026 18:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672566;
	bh=mlddO7CZYYYWTz76MIjrkD7YA5BdrXNszloB0UNiZTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cmvErksWglwXW37h2BL5jaWCNIb+clpUSSmxfl9D8pE3XnwYi/51Gcw4nHcSa+la8
	 8RD8lKACizpKmjoPkL2L5ytMyU1dVh905qkZ0HuU8/XAAxE5D7OjlRjNpvEbpM57I4
	 s0d+AkVcbDWof3wbaoaG6uh6Q8whmQiba9xqrabo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yochai Eisenrich <echelonh@gmail.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 029/160] net: sched: cls_api: fix tc_chain_fill_node to initialize tcm_info to zero to prevent an info-leak
Date: Wed,  8 Apr 2026 20:01:56 +0200
Message-ID: <20260408175914.297422782@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a90a7b01f3f36..45124fd64d6b4 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -2886,6 +2886,7 @@ static int tc_chain_fill_node(const struct tcf_proto_ops *tmplt_ops,
 	tcm->tcm__pad1 = 0;
 	tcm->tcm__pad2 = 0;
 	tcm->tcm_handle = 0;
+	tcm->tcm_info = 0;
 	if (block->q) {
 		tcm->tcm_ifindex = qdisc_dev(block->q)->ifindex;
 		tcm->tcm_parent = block->q->handle;
-- 
2.53.0



