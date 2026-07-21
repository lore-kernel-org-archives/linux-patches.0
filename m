Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E3F46EF73;
	Tue, 21 Jul 2026 19:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661925; cv=none; b=sfEyzAOzz0w19kCqv9fn7WyHcufOLKtOYWWQh53T6ZiUiP5Xha1oYmRff3sxr4ZHInDRqRB2DO49sDP96OFHOUwhiJ24deq0hgJEFaB/S9Wm667SQUI+GFs0trRvpEBw9gvRivuJRunx13KjIVjvD4wSAco6VRTxG8x8J9nYg1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661925; c=relaxed/simple;
	bh=tmKnNfmsJJz2zeDNeQ/niyTzWJVuegJLS6CfkShcYF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZgK0XsgeqPTFHraBGqsqXOscrFidiDpyLPdQ/L5zhS4f9CW0+TtdfM1+W/oINmERmIXwQWDpuHN6+vBZJ8jw44x5FibJ/nVUcOhGB4c3ys/IlAJ/BbbTvkxzlQTVxGtbaShkFxyXVcvXeNWZp7o9ca+6FK7XWxXHH+r6yQDHxtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hl3jccnz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hl3jccnz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 872291F000E9;
	Tue, 21 Jul 2026 19:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661924;
	bh=qo2sqR4orSrVo+ZyccBLVP+1dDSGJcxkGUjnjihb4To=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hl3jccnzeuJhogwkXRC2T5wTzan/S33kyFkqPgh7sjChH/iGT0wslMC/OXt8rGhFC
	 ZmqsC6oQp6hJzjPIhGHxmUymLNCtGcNNoZOO7bF9swlVz+RH3sg5cGHkwKOtaSpuaK
	 SqATGD/wYM0iPGdyD/orEDN2a+wNQ5MratqFSh4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0250/1276] RDMA/irdma: Initialize iwmr->access during MR registration
Date: Tue, 21 Jul 2026 17:11:33 +0200
Message-ID: <20260721152451.682480462@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Jacob Moroni <jmoroni@google.com>

[ Upstream commit 1521d560b7a1a39e437d37fffd9b55435d329ad1 ]

Initialize iwmr->access during initial user mem registration so
that it contains a valid value during a subsequent rereg_mr.

Otherwise, a rereg_mr that doesn't set IB_MR_REREG_ACCESS (for
example, one that only changes the PD) ends up clearing the
access flags in HW since iwmr->access is zero-initialized, which
is not intended.

Fixes: 5ac388db27c4 ("RDMA/irdma: Add support to re-register a memory region")
Link: https://patch.msgid.link/r/20260604154104.4035581-1-jmoroni@google.com
Signed-off-by: Jacob Moroni <jmoroni@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 9f74bec7120e4f..92b56338819ef8 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -2854,6 +2854,7 @@ static int irdma_reg_user_mr_type_mem(struct irdma_mr *iwmr, int access,
 	int err;
 
 	lvl = iwmr->page_cnt != 1 ? PBLE_LEVEL_1 | PBLE_LEVEL_2 : PBLE_LEVEL_0;
+	iwmr->access = access;
 
 	err = irdma_setup_pbles(iwdev->rf, iwmr, lvl);
 	if (err)
-- 
2.53.0



