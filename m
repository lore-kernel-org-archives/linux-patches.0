Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B10FD372B32;
	Tue, 21 Jul 2026 15:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649253; cv=none; b=lxUadI1ryOOJkoMgdUOkf+FfTq4lpEqg5CSe2Qe/iE5qNOzLSGKrtBOAlloF2kXrlIwXOMB+7BIY0BvHtCdH47Qo/B2NQ5F3VYt74pK7n57VJ315UfoeJ3ivXUmt5wNIyqY92myWi8sv1bZEUp5odBat1oOo1uVwvchm/WLTjGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649253; c=relaxed/simple;
	bh=9ycNeYynupDXyLJJEcJxf92JAIdBankjW1KJnjS4/SM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PSp9+/8qXRwZvmYuPF/WRUzIk7tJkGA3EBnviZTZbs1i2RluPxvB++zuXOCwGFF+bYdulJtLCZK30LsLoGhhxvVjpkFmvot3Pj4wcMZW3mulbgVvWzWAHahPhDTBOCQ5/6NMrqmKZJiIOuDKGxxuoiYiyB2mToBXekg05CWgzZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kh9JkgvL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kh9JkgvL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FD531F000E9;
	Tue, 21 Jul 2026 15:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649252;
	bh=pA3LFLGtzD1cl8amqwZpnQiifvqdjA6SH354YG6STFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kh9JkgvLE5IFTChBcxPU4FEecmIRK/5vd3GQYEry+I0LoyZ/F1TVUthXgXGAqgpyg
	 JnxRl86fPA3n8ofCGw3CG6fFWUw1CA91hu/7c1Mt9lhoiyuknA1KvsDjCP9dT2yoKW
	 iVJxbZMJKCbATKFO4WJTJT7NTsec7zeWfVXR3xBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0501/2077] RDMA/irdma: Initialize iwmr->access during MR registration
Date: Tue, 21 Jul 2026 17:02:54 +0200
Message-ID: <20260721152604.630446901@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index d79e130d98ee2a..7da7a7e8b30ca2 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -3325,6 +3325,7 @@ static int irdma_reg_user_mr_type_mem(struct irdma_mr *iwmr, int access,
 	int err;
 
 	lvl = iwmr->page_cnt != 1 ? PBLE_LEVEL_1 | PBLE_LEVEL_2 : PBLE_LEVEL_0;
+	iwmr->access = access;
 
 	err = irdma_setup_pbles(iwdev->rf, iwmr, lvl);
 	if (err)
-- 
2.53.0



