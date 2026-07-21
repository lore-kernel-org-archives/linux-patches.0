Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB72199920;
	Tue, 21 Jul 2026 20:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665959; cv=none; b=G6rCUqWj4lngdzGtIkQ1E3my4X7BjCqnUBfG/VglbnjOjBTToZNLgPnWObB20Z/Jl7H7m1OUki4Zp8t6LO/78FyopxqAwyW6BY7ncFt1M8O4rErfOhq6AoWtWZcOS69uFOFwa+2Rw7ktnsMQfUYDrdTy+xrSYX7oDgEKrD57ves=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665959; c=relaxed/simple;
	bh=OaKANYesg8VvCphJZ0nqFwJXuvrTPiZHCLSdUkVwCOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G0ovyDZfBI0z/G4abSFBuFpT95kpTVW1Zx4BgeFWv253nkTuB8cvL8b/LUKByERAhpJm0dAUun4U/QilG5+j9YAypLCzUoe2sgg7FFGemMqsT1/JClZRB2G1GKoi7KoHRk+iIdi0wiBIbNT3aY0Dmo5XMHEZfCr90NPHlnaSz/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TyS+NOq+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TyS+NOq+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A741F000E9;
	Tue, 21 Jul 2026 20:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665958;
	bh=fQpGZX/S37lOyU5e7FVWLjOVMl/dufR9WwKlB/jE2WU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TyS+NOq+6c1B/uSKm96h1BLlpnkd2ECRP/Rg52IsOy41yZEZp3SFN9QgF3bPboVqO
	 xPOjfVnpipogQJVgX805+VHQ1kDcF4Dx5+fNwVmsquJivKoo4isWljHoMctk8SGab8
	 qctGEd/scwcrh0NPT9Ble0Ef9TyKHfSmLvLu7f10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0499/1266] RDMA/irdma: Initialize iwmr->access during MR registration
Date: Tue, 21 Jul 2026 17:15:36 +0200
Message-ID: <20260721152453.008467419@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
index 6928888b068eaa..8ffbc790c1681e 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -2853,6 +2853,7 @@ static int irdma_reg_user_mr_type_mem(struct irdma_mr *iwmr, int access,
 	int err;
 
 	lvl = iwmr->page_cnt != 1 ? PBLE_LEVEL_1 | PBLE_LEVEL_2 : PBLE_LEVEL_0;
+	iwmr->access = access;
 
 	err = irdma_setup_pbles(iwdev->rf, iwmr, lvl);
 	if (err)
-- 
2.53.0



