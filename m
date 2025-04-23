Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269F728B4F4;
	Wed, 23 Apr 2025 15:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421829; cv=none; b=M3iBxwmJSskDR0MDSb7y6uOeitcQnJQhxvWNsZJMAm71krneAJF/YfARwWy5Q6NEAaZN+lKcUmL0iF2cuICl3yRmeDMVcLldDR3U908xaTkaSfBOd2RBdMbUzYdut6aYz24fMRo6pAjAnDubI2Y/BkDP3ClBe6bLHzsJGVhQ9BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421829; c=relaxed/simple;
	bh=X0ijJ55qql9APwH73dAZtusvSs67Xee350O2w40OR+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HdBUKQ4V5Van8ofulkDFTyke9x+OzdL5nIA6xQCjJ0BaI3viwFGrKcBtLpcu4exhqHtsPwSZbqPk/jCuRkFyeJAo2/Xt6vC03UocEd5aIqTLtbALih8+uVNra5xb8SY3QnS+pVXc1ImWSbYg1ypXe33PQ9ILuvbxUjqE8fxFtGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q+lW0Wn1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q+lW0Wn1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56455C4CEE2;
	Wed, 23 Apr 2025 15:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421828;
	bh=X0ijJ55qql9APwH73dAZtusvSs67Xee350O2w40OR+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q+lW0Wn1MiHt81kZiysyzWhG5f+iKVqBiVye2nJBJjOv3J3I5IQO6KKGvwQ921gqk
	 DL6rh0Fh/fi+KE5oKsmM8uvOSWsKNF9ybYarTz2bOOj0ilBf2HUGo+979VPJgexTYC
	 BAcgoUqBecqOIvaD8Seba/2q4OAtUvHxSyoMufdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christopher S M Hall <christopher.s.hall@intel.com>,
	Corinna Vinschen <vinschen@redhat.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Mor Bar-Gabay <morx.bar.gabay@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 183/291] igc: cleanup PTP module if probe fails
Date: Wed, 23 Apr 2025 16:42:52 +0200
Message-ID: <20250423142631.857382878@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

From: Christopher S M Hall <christopher.s.hall@intel.com>

[ Upstream commit 1f025759ba394dd53e434d2668cb0597886d9b69 ]

Make sure that the PTP module is cleaned up if the igc_probe() fails by
calling igc_ptp_stop() on exit.

Fixes: d89f88419f99 ("igc: Add skeletal frame for Intel(R) 2.5G Ethernet Controller support")
Signed-off-by: Christopher S M Hall <christopher.s.hall@intel.com>
Reviewed-by: Corinna Vinschen <vinschen@redhat.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Mor Bar-Gabay <morx.bar.gabay@intel.com>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 6ae2d0b723c82..082f78beeb4ed 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6725,6 +6725,7 @@ static int igc_probe(struct pci_dev *pdev,
 
 err_register:
 	igc_release_hw_control(adapter);
+	igc_ptp_stop(adapter);
 err_eeprom:
 	if (!igc_check_reset_block(hw))
 		igc_reset_phy(hw);
-- 
2.39.5



