Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1779415F1C;
	Tue, 21 Jul 2026 17:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656351; cv=none; b=dExEWQK0ycI+Iqdu9VPcX8zQCupLqQoTFIBdj2a0NwujVO+tH7Ms51h9emxk6egJbcKRtAvPXBip3IarDvh88TSwGMm1U6bi7JV/0VRy4vWP/BvmqX8Wg9gkSomRxG8w97HujT6G6wzgj8mw4glv+fVTK49sP97muh19puqw/Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656351; c=relaxed/simple;
	bh=lqocsCMV5An0uUyZwka0l1Wl2QwvatzaEjh2UoMD/Ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MJxXd6djgFjWrA3DORicuNqMrEUVz+DS40KSkxBq5vduAnGuKzXK8kRfPiEpMIyM5QbSBUT7cIehRD5gA+cPDQXdJRcO04Zcn7xAvaszdEsdPxqiPImAzwiEfXYoJJvU/W6I/1pWWh3zZDLXLtRsRHC61neefLmveHJiDGr876o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SFA6xwvD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SFA6xwvD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 641991F000E9;
	Tue, 21 Jul 2026 17:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656349;
	bh=h8CjqUp5DipKspH7ZUgK5pG9D7ki7blcobVGXpb9Rag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SFA6xwvDOrIgp7dDiEGPJ8YxA3PR68YEl9l0u8s2a53BFrkOfOaTPWk0JuQoAvWkr
	 xiqFTuZW43J08qyVORtGhOTzzWpyBlv8v3JZoE8soQvu5mzm7E6DPMQP5h2xN5AG00
	 wMo0jFr+dFUvvEaSSvY87/GisiOci1v24dW1Ugx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0354/1611] RDMA/irdma: Initialize iwmr->access during MR registration
Date: Tue, 21 Jul 2026 17:07:50 +0200
Message-ID: <20260721152523.102804627@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 80e9cdef5baff3..2b85e32134a5b8 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -3312,6 +3312,7 @@ static int irdma_reg_user_mr_type_mem(struct irdma_mr *iwmr, int access,
 	int err;
 
 	lvl = iwmr->page_cnt != 1 ? PBLE_LEVEL_1 | PBLE_LEVEL_2 : PBLE_LEVEL_0;
+	iwmr->access = access;
 
 	err = irdma_setup_pbles(iwdev->rf, iwmr, lvl);
 	if (err)
-- 
2.53.0



