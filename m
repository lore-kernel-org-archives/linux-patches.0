Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 607E3C8E6;
	Mon, 22 Sep 2025 19:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569544; cv=none; b=tWFiDWPlYRiou7ECkQmdNJGYHxUVonpPbNxNAaggQvdZWthiVlTf0d2pC9JIKJctfR0zQiP1z2GzsExDJzmTpEqzN96S2SD3m5cTMxtJ2w0CVdOZs00HGIomYtCjxNfyoNDZKbpfC4tsw18hz2CsII5bKhgaBsFjNMm27PfVAZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569544; c=relaxed/simple;
	bh=I9Qm24cn+DKRtgVN3i1lMgQ0Zi+OH2qtTKYIfKoEyn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C4zmwldgVnm5q2yWg6iuEtqo/NBJRct3u2HPtPEpC3XkfM3u+evTjDIn1J0pwG2RMSs3O8aRBQGaQhHCZ0K4IOtMgc02ApJ2Hv3Qu2pu5jsa9ILgeenIs8pRVXV8UKIlHhDRTcf6ETh/hI8FMaYJKRkJorph7YUJCYHeQR7vGbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zui917lR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zui917lR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A92B8C4CEF0;
	Mon, 22 Sep 2025 19:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569544;
	bh=I9Qm24cn+DKRtgVN3i1lMgQ0Zi+OH2qtTKYIfKoEyn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zui917lRx/Ez1gpapJrHxbd0sMnMmbRG4+7Daw5zhyZOE/hO+IBM7pK+efbC4+d8S
	 B9y41w4x3/8H2YmOjdNzt5Eb9mOAeVvTXaSEVyiTEkH4XkV4YXKXOSEfZouiUqN92r
	 b/C/q7LR2iPF3se/ujOEKOg7n0EjySXBllHq180Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.1 12/61] i40e: remove redundant memory barrier when cleaning Tx descs
Date: Mon, 22 Sep 2025 21:29:05 +0200
Message-ID: <20250922192403.884638115@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192403.524848428@linuxfoundation.org>
References: <20250922192403.524848428@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit e37084a26070c546ae7961ee135bbfb15fbe13fd ]

i40e has a feature which writes to memory location last descriptor
successfully sent. Memory barrier in i40e_clean_tx_irq() was used to
avoid forward-reading descriptor fields in case DD bit was not set.
Having mentioned feature in place implies that such situation will not
happen as we know in advance how many descriptors HW has dealt with.

Besides, this barrier placement was wrong. Idea is to have this
protection *after* reading DD bit from HW descriptor, not before.
Digging through git history showed me that indeed barrier was before DD
bit check, anyways the commit introducing i40e_get_head() should have
wiped it out altogether.

Also, there was one commit doing s/read_barrier_depends/smp_rmb when get
head feature was already in place, but it was only theoretical based on
ixgbe experiences, which is different in these terms as that driver has
to read DD bit from HW descriptor.

Fixes: 1943d8ba9507 ("i40e/i40evf: enable hardware feature head write back")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 3d83fccf742b1..2ede35ba3919b 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -949,9 +949,6 @@ static bool i40e_clean_tx_irq(struct i40e_vsi *vsi,
 		if (!eop_desc)
 			break;
 
-		/* prevent any other reads prior to eop_desc */
-		smp_rmb();
-
 		i40e_trace(clean_tx_irq, tx_ring, tx_desc, tx_buf);
 		/* we have caught up to head, no work left to do */
 		if (tx_head == tx_desc)
-- 
2.51.0



