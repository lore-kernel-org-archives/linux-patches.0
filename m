Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855921F76BF;
	Tue,  3 Dec 2024 16:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242028; cv=none; b=MHE5VgT16MfDl3WZhPenkx+GKRNQbIp4l108ZEAXR+kHSukSAt2cGLlEflg7MpgMW+wtB/m6nGkQFxeEt4A20hWohdlZgfqHj7MJxJSlPC7X3/l5k0KG9sHkzpEawF9qvkmflROJg+lIrpXgAJAYEybYR9P+AHLS88XJNbl/hBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242028; c=relaxed/simple;
	bh=+NqvCWQDgmfggBAwdQy+p9jf1g7oSwXhXFoOPITfJGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lzkNiUyxm6u9BmYT5jGG/qMyraqaFy27aQ6D20+FzTSkCWrAQ3dS0Jiz+iGXPX3GM6fF9u7bN5ziSkDUdIIqvTKs0QjY7UiW3R71Ur/dwPeuzimgS7wgHWjk5Yc2EZfF8YWTSHCzgN1Bn06ImXgtJYykcIh7dG2jtXmshxXYVF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HTwpVVEA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HTwpVVEA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BECA3C4CECF;
	Tue,  3 Dec 2024 16:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242028;
	bh=+NqvCWQDgmfggBAwdQy+p9jf1g7oSwXhXFoOPITfJGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HTwpVVEAYPRQVW5wEehnaGdx44dkqtDA6Nx/Zrhz+e7CTFprCR74cYbztMotlh+Im
	 2mVeU+mTzI6ZQ2ZDc2CSgEBFUx+d9jnogZ+9nE4lAfMxPs+3tLdl527H3ReiNuSjiF
	 btr62+R/8PBl4W0OmXCbqel9YozZE8opt0NClXH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Wei <dw@davidwei.uk>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 579/826] bnxt_en: Fix queue start to update vnic RSS table
Date: Tue,  3 Dec 2024 15:45:06 +0100
Message-ID: <20241203144806.336118675@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Somnath Kotur <somnath.kotur@broadcom.com>

[ Upstream commit 5ac066b7b062ee753a14557ea11bdc62364c8090 ]

HWRM_RING_FREE followed by a HWRM_RING_ALLOC is not guaranteed to
have the same FW ring ID as before.  So we must reinitialize the
RSS table with the correct ring IDs.  Otherwise, traffic may not
resume properly if the restarted ring ID is stale.  Since this
feature is only supported on P5_PLUS chips, we call
bnxt_vnic_set_rss_p5() to update the HW RSS table.

Fixes: 2d694c27d32e ("bnxt_en: implement netdev_queue_mgmt_ops")
Cc: David Wei <dw@davidwei.uk>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
Signed-off-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 20a8cb26bc0a6..908ce838eedbb 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -15231,6 +15231,13 @@ static int bnxt_queue_start(struct net_device *dev, void *qmem, int idx)
 
 	for (i = 0; i <= BNXT_VNIC_NTUPLE; i++) {
 		vnic = &bp->vnic_info[i];
+
+		rc = bnxt_hwrm_vnic_set_rss_p5(bp, vnic, true);
+		if (rc) {
+			netdev_err(bp->dev, "hwrm vnic %d set rss failure rc: %d\n",
+				   vnic->vnic_id, rc);
+			return rc;
+		}
 		vnic->mru = bp->dev->mtu + ETH_HLEN + VLAN_HLEN;
 		bnxt_hwrm_vnic_update(bp, vnic,
 				      VNIC_UPDATE_REQ_ENABLES_MRU_VALID);
-- 
2.43.0



