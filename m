Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73508148832;
	Fri,  6 Dec 2024 15:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497853; cv=none; b=k2LYW+118qxkT5tDoiDkUTKaQ3SdfsURQMb7b9PrGCPOYfttWybXZznn+TNW6q4OWox95k3Wqoph3b6Hu6OOaMVD3bWieKJ4OgahK3xtvD1piewVReiL4vJq/riKZAJCXB8Phb4TL+Ew0OWaV30+rD9VLf5PNeQG9TlTutmPuIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497853; c=relaxed/simple;
	bh=DBeAN6nXh0jpMFmdLR/+LHH17ycGV7m576Tms4AQeMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cx0+9Ps/4Qs0h6F0dvpvJ8gteFeMxzDCy8hfNoFDoMpMGR9l3AQnc/0K36XS1s2Qx05FMHD38U4mJ1BphL6OWN015R7Jg/F+NzbXaC6iDY3t3+WxbJUf4MOLftdTSdCNUppomdKmT1/BfGQ7Diu4ErT46LIXQ6yZ2xUq3eOlWEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hh6HKNyD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hh6HKNyD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91BD6C2BCF4;
	Fri,  6 Dec 2024 15:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497853;
	bh=DBeAN6nXh0jpMFmdLR/+LHH17ycGV7m576Tms4AQeMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hh6HKNyD+Lp0EtJWAW80QS0VoqeNGBh01l8tYT1kRRgOIU34giZBa9Z2VtGRdXvX7
	 ubSxFbBfwP12AfGCD2EJW+SaKkNI9PlrrOQ/TSMib7VGOLJ6i1EfINI9fm9CgonzCi
	 EfJCDYsMp0kiiEXNw627AgSmctwesgNMM2odSFM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 411/676] octeontx2-af: RPM: fix stale RSFEC counters
Date: Fri,  6 Dec 2024 15:33:50 +0100
Message-ID: <20241206143709.399801730@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hariprasad Kelam <hkelam@marvell.com>

[ Upstream commit 07cd1eb166a3fa7244afa74d48bd13c9df7c559d ]

The earlier patch sets the 'Stats control register' for RPM
receive/transmit statistics instead of RSFEC statistics,
causing the driver to return stale FEC counters.

Fixes: 84ad3642115d ("octeontx2-af: Add FEC stats for RPM/RPM_USX block")
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rpm.c | 13 +++++++++----
 drivers/net/ethernet/marvell/octeontx2/af/rpm.h |  4 +++-
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
index 22dd50a3fcd3a..70629f94c27ef 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
@@ -699,6 +699,10 @@ int rpm_get_fec_stats(void *rpmd, int lmac_id, struct cgx_fec_stats_rsp *rsp)
 	if (rpm->lmac_idmap[lmac_id]->link_info.fec == OTX2_FEC_NONE)
 		return 0;
 
+	/* latched registers FCFECX_CW_HI/RSFEC_STAT_FAST_DATA_HI_CDC are common
+	 * for all counters. Acquire lock to ensure serialized reads
+	 */
+	mutex_lock(&rpm->lock);
 	if (rpm->lmac_idmap[lmac_id]->link_info.fec == OTX2_FEC_BASER) {
 		val_lo = rpm_read(rpm, lmac_id, RPMX_MTI_FCFECX_VL0_CCW_LO);
 		val_hi = rpm_read(rpm, lmac_id, RPMX_MTI_FCFECX_CW_HI);
@@ -725,20 +729,21 @@ int rpm_get_fec_stats(void *rpmd, int lmac_id, struct cgx_fec_stats_rsp *rsp)
 		}
 	} else {
 		/* enable RS-FEC capture */
-		cfg = rpm_read(rpm, 0, RPMX_MTI_STAT_STATN_CONTROL);
+		cfg = rpm_read(rpm, 0, RPMX_MTI_RSFEC_STAT_STATN_CONTROL);
 		cfg |= RPMX_RSFEC_RX_CAPTURE | BIT(lmac_id);
-		rpm_write(rpm, 0, RPMX_MTI_STAT_STATN_CONTROL, cfg);
+		rpm_write(rpm, 0, RPMX_MTI_RSFEC_STAT_STATN_CONTROL, cfg);
 
 		val_lo = rpm_read(rpm, 0,
 				  RPMX_MTI_RSFEC_STAT_COUNTER_CAPTURE_2);
-		val_hi = rpm_read(rpm, 0, RPMX_MTI_STAT_DATA_HI_CDC);
+		val_hi = rpm_read(rpm, 0, RPMX_MTI_RSFEC_STAT_FAST_DATA_HI_CDC);
 		rsp->fec_corr_blks = (val_hi << 32 | val_lo);
 
 		val_lo = rpm_read(rpm, 0,
 				  RPMX_MTI_RSFEC_STAT_COUNTER_CAPTURE_3);
-		val_hi = rpm_read(rpm, 0, RPMX_MTI_STAT_DATA_HI_CDC);
+		val_hi = rpm_read(rpm, 0, RPMX_MTI_RSFEC_STAT_FAST_DATA_HI_CDC);
 		rsp->fec_uncorr_blks = (val_hi << 32 | val_lo);
 	}
+	mutex_unlock(&rpm->lock);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.h b/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
index 34b11deb0f3c1..a5773fbacaff8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
@@ -84,9 +84,11 @@
 /* FEC stats */
 #define RPMX_MTI_STAT_STATN_CONTROL			0x10018
 #define RPMX_MTI_STAT_DATA_HI_CDC			0x10038
-#define RPMX_RSFEC_RX_CAPTURE				BIT_ULL(27)
+#define RPMX_RSFEC_RX_CAPTURE				BIT_ULL(28)
 #define RPMX_CMD_CLEAR_RX				BIT_ULL(30)
 #define RPMX_CMD_CLEAR_TX				BIT_ULL(31)
+#define RPMX_MTI_RSFEC_STAT_STATN_CONTROL               0x40018
+#define RPMX_MTI_RSFEC_STAT_FAST_DATA_HI_CDC            0x40000
 #define RPMX_MTI_RSFEC_STAT_COUNTER_CAPTURE_2		0x40050
 #define RPMX_MTI_RSFEC_STAT_COUNTER_CAPTURE_3		0x40058
 #define RPMX_MTI_FCFECX_VL0_CCW_LO			0x38618
-- 
2.43.0



