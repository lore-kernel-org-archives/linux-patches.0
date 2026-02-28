Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BADDE3314C3
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301233; cv=none; b=lLIGUs6ykwfXOGbKG0ZrXfD2MMxXgBr9jQOe3RdJYiAC1xxoCZ8LemruKZmh7U9Jgnlh/QBUV38PepjLAJJ8zphT5U1CiHOusQSin0uJ8bOeyNNHopXxoddEl8mUUrxOzSuSFcoKnG8GiBl9fjRtTx6SQdSVbJzDWgZfnHGJH38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301233; c=relaxed/simple;
	bh=hkZ2n54AlkjGxXwF2H/Mb3qOowbgZ2acfFX3qi6iW2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qqP6moBnfokQLI/iCwMOrDmP6ASru2XpRxoTr+akg7jJyPNgJ/0Flv5p8xU2cGnICqsZwRqUzTKnYCKyFyANrEpyrSUtmJKWev7RqcyMNWQzpcmEIYCLe25IRFKjfpDL7DHdstPROLMdEHTCdiu57jw4uMX2wM6ZwdHW+kXcy08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g7StYk3Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g7StYk3Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06869C19423;
	Sat, 28 Feb 2026 17:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301233;
	bh=hkZ2n54AlkjGxXwF2H/Mb3qOowbgZ2acfFX3qi6iW2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g7StYk3YKWG7wKyMJsYe6JqyP+QDOo8DFbm7Vdgsrxc6g+RqtJ3dYWSc7u8OKZrWM
	 Vmc8jcnBaxnqgdrqL6XtAnH0Kj9GwgYRrtyI1mxgjJiCgiauXiNKZMFmuZ1zHlwN+7
	 RRTqFA6Fus0f7N+FApMsy1qxwf+NwSNWrT2hC9ZeNHZcZHGZBgXQL8z12J5IvdZLym
	 ID7P7ziO7sTcuOmQglgiCV71d3gG3qtqwNtVE+PpXLRbdmrvU7smlz3RDNbv9hX2HP
	 TazD6R3iFbgHdwbBZgC7OXV+JCFamVI1mnsON/v7p8gGHZG/l1KsLiItjNJF1FFjkg
	 dPKKxNqIdk/VA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 412/752] bnxt_en: Fix deleting of Ntuple filters
Date: Sat, 28 Feb 2026 12:42:03 -0500
Message-ID: <20260228174750.1542406-412-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Pavan Chebbi <pavan.chebbi@broadcom.com>

[ Upstream commit c1bbd9900d65ac65b9fce9f129e3369a04871570 ]

Ntuple filters can be deleted when the interface
is down. The current code blindly sends the filter
delete command to FW. When the interface is down, all
the VNICs are deleted in the FW. When the VNIC is
freed in the FW, all the associated filters are also
freed. We need not send the free command explicitly.
Sending such command will generate FW error in the
dmesg.

In order to fix this, we can safely return from
bnxt_hwrm_cfa_ntuple_filter_free() when BNXT_STATE_OPEN
is not true which confirms the VNICs have been deleted.

Fixes: 8336a974f37d ("bnxt_en: Save user configured filters in a lookup list")
Suggested-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20260219185313.2682148-3-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 427eb02ae5056..2b9c039d347d5 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6201,6 +6201,9 @@ int bnxt_hwrm_cfa_ntuple_filter_free(struct bnxt *bp,
 	int rc;
 
 	set_bit(BNXT_FLTR_FW_DELETED, &fltr->base.state);
+	if (!test_bit(BNXT_STATE_OPEN, &bp->state))
+		return 0;
+
 	rc = hwrm_req_init(bp, req, HWRM_CFA_NTUPLE_FILTER_FREE);
 	if (rc)
 		return rc;
-- 
2.51.0

