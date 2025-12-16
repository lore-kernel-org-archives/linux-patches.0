Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D3E34253D;
	Tue, 16 Dec 2025 12:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887122; cv=none; b=moifEK90mTR8tFdF9BDgjxa2ypAdTLoUO6yJfmRPhWTMHEBsfK7CRsa61gtb9ga2m1KUwUEnJaslhKmUkhcvec///ou3ugzTordmbHWUFd/Q8WJFJyPlC0+RbnTFNe3bT8YKmdNX+Tu3QfKbsYBKtfzmDAOcvDwy9uc9pMqmR/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887122; c=relaxed/simple;
	bh=FXC5K0JwnnDgWZHCgWQXuRu4v2Rpeso8V7dhnQrT5/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o1rPws9p2+WoJ6x7g+6scFX/FYPBWDjYOXA8XNgS2vOCtOr/qjlKqDR4Z9mUKlAWTe1vz6ay0PCokLdxlNQRzeKpseKE47ZME1IaQhx75p0maVVIYN0tI2qv8IeP7rhoOxw6TsrLSV719Kbb46tbIcq8innTrgvdSTG2rYFJsCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jmbuVjVf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jmbuVjVf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7950C4CEF1;
	Tue, 16 Dec 2025 12:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887122;
	bh=FXC5K0JwnnDgWZHCgWQXuRu4v2Rpeso8V7dhnQrT5/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jmbuVjVfy+xTcQ/HYpsplPBLzh0VhLKcEUysh26XbTMgZbPQrj6qKny0/+Wp5VDXq
	 kaHU1ZgP2JejFT0lntaQfMFF29An5EpVdmqlwP1IpiEsb2ykFHC/TbSjVQ889LDfFM
	 lafUL4qTLQ/51f/vUse3oIAYI2NbqNx+SkfkSiZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.18 100/614] ice: ice_init_pf: destroy mutexes and xarrays on memory alloc failure
Date: Tue, 16 Dec 2025 12:07:47 +0100
Message-ID: <20251216111404.946692977@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Przemek Kitszel <przemyslaw.kitszel@intel.com>

[ Upstream commit 71430451f81bd6550e46d89b69103a111fc42982 ]

Unroll actions of ice_init_pf() when it fails.
ice_deinit_pf() happens to be perfect to call here.

Signed-off-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: 1390b8b3d2be ("ice: remove duplicate call to ice_deinit_hw() on error paths")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 31 +++++++++--------------
 1 file changed, 12 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 13db83fb383e6..80349aed1f9d6 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3951,6 +3951,8 @@ u16 ice_get_avail_rxq_count(struct ice_pf *pf)
  */
 static void ice_deinit_pf(struct ice_pf *pf)
 {
+	/* note that we unroll also on ice_init_pf() failure here */
+
 	mutex_destroy(&pf->lag_mutex);
 	mutex_destroy(&pf->adev_mutex);
 	mutex_destroy(&pf->sw_mutex);
@@ -4055,25 +4057,6 @@ static int ice_init_pf(struct ice_pf *pf)
 	init_waitqueue_head(&pf->reset_wait_queue);
 
 	mutex_init(&pf->avail_q_mutex);
-	pf->avail_txqs = bitmap_zalloc(pf->max_pf_txqs, GFP_KERNEL);
-	if (!pf->avail_txqs)
-		return -ENOMEM;
-
-	pf->avail_rxqs = bitmap_zalloc(pf->max_pf_rxqs, GFP_KERNEL);
-	if (!pf->avail_rxqs) {
-		bitmap_free(pf->avail_txqs);
-		pf->avail_txqs = NULL;
-		return -ENOMEM;
-	}
-
-	pf->txtime_txqs = bitmap_zalloc(pf->max_pf_txqs, GFP_KERNEL);
-	if (!pf->txtime_txqs) {
-		bitmap_free(pf->avail_txqs);
-		pf->avail_txqs = NULL;
-		bitmap_free(pf->avail_rxqs);
-		pf->avail_rxqs = NULL;
-		return -ENOMEM;
-	}
 
 	mutex_init(&pf->vfs.table_lock);
 	hash_init(pf->vfs.table);
@@ -4086,7 +4069,17 @@ static int ice_init_pf(struct ice_pf *pf)
 	xa_init(&pf->dyn_ports);
 	xa_init(&pf->sf_nums);
 
+	pf->avail_txqs = bitmap_zalloc(pf->max_pf_txqs, GFP_KERNEL);
+	pf->avail_rxqs = bitmap_zalloc(pf->max_pf_rxqs, GFP_KERNEL);
+	pf->txtime_txqs = bitmap_zalloc(pf->max_pf_txqs, GFP_KERNEL);
+	if (!pf->avail_txqs || !pf->avail_rxqs || !pf->txtime_txqs)
+		goto undo_init;
+
 	return 0;
+undo_init:
+	/* deinit handles half-initialized pf just fine */
+	ice_deinit_pf(pf);
+	return -ENOMEM;
 }
 
 /**
-- 
2.51.0



