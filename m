Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556FF37C92C;
	Thu, 30 Jul 2026 15:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424757; cv=none; b=bTYVR8sOJFajcN/yraQRblEFFRFgEDyACLExoTTlLFVmvzqcVUxr+dHqd1wMpNxxESJ9LK7wC53ubjgVHGMgSQhydK5Tben5AOfWa+42il3Ae16VX1hjhT0JYgKCapkbrVk8RIJPu5A9oEysGtZm4LQdArjb/Ius0Arhop3PQ7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424757; c=relaxed/simple;
	bh=+aMzfz/QWy5TG6mKJGLHsNQWT7A2EdBNaetUGcbZJgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ousm606e3bwdcLcmE0HqJVXOI/bYJC1cGHSFfAKYi4ge8hZp6tNlETa5PhVrCU0Tk6qaC3Yu/qGXtHn/iw4LEg7eTDVoQAPe+ZPfWkQZHtCdv7QO1Lrh8CHRgCG54IDOWmjmUC/mjyBrscZ10fEbG1iHuYQAU6HDZenGEmrX3+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wyc5Y0Fh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wyc5Y0Fh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65B121F000E9;
	Thu, 30 Jul 2026 15:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424754;
	bh=KRTEV/pDHix6NwBVCUuY2g/8j15rubJJCfaymcSs2yA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wyc5Y0FheaTmmDb3MSGiYzA/TxJFY3IURgBTbWlWZyCn8lhT1h9GwLGIBdtfMfaKP
	 C5A2MpMgxFZ84p5bXqjU4klkp2VejPlMTGe2ArdtzZerdSHAMChuHbbELs5ut5uEXa
	 gqZleWgq4BdFwOKaoxXkoc8T+pVQ2ugF1sg84fvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	LiangCheng Wang <zaq14760@gmail.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.18 460/675] wifi: brcmfmac: set F2 blocksize to 256 for BCM43752
Date: Thu, 30 Jul 2026 16:13:10 +0200
Message-ID: <20260730141454.907328280@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: LiangCheng Wang <zaq14760@gmail.com>

commit 29ab31f3f27157648f2f7e6d5e1fd9792fdf0614 upstream.

The BCM43752 is not reliable with the default 512-byte SDIO function 2
block size: on an i.MX8MP board with an AMPAK AP6275S module at
SDR104 / 200 MHz, an iperf TX stress test kills WLAN within seconds:

  mmc_submit_one: CMD53 sg block write failed -84
  brcmf_sdio_dpc: failed backplane access over SDIO, halting operation

Commit d2587c57ffd8 ("brcmfmac: add 43752 SDIO ids and initialization")
set up the 43752 like the 4373 for the F2 watermark but missed the F2
block size, which the 4373 limits to 256 bytes. The vendor driver
(bcmdhd) also programs a 256-byte F2 block size for this chip and runs
the same hardware without errors.

Group the 43752 with the 4373, matching the F2 watermark handling.
With this change a 10-minute bidirectional iperf3 soak completes with
zero SDIO errors at ~270 Mbit/s in each direction.

Backporting note: kernels before v6.18 name this id
SDIO_DEVICE_ID_BROADCOM_CYPRESS_43752, so on those trees the case
label added by this patch must be adjusted to that name. Cherry-picking
the rename commit 74e2ef72bd4b ("wifi: brcmfmac: fix 43752 SDIO FWVID
incorrectly labelled as Cypress (CYW)") first is not a clean
alternative: on trees before v6.17 its context collides with the 43751
additions, and trees before v6.2 lack the FWVID framework it touches.

Fixes: d2587c57ffd8 ("brcmfmac: add 43752 SDIO ids and initialization")
Cc: stable@vger.kernel.org # see patch description, needs adjustments for <= 6.17
Signed-off-by: LiangCheng Wang <zaq14760@gmail.com>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Link: https://patch.msgid.link/20260715-b43752-f2-blksz-v2-1-f9be49856050@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -911,6 +911,7 @@ int brcmf_sdiod_probe(struct brcmf_sdio_
 		return ret;
 	}
 	switch (sdiodev->func2->device) {
+	case SDIO_DEVICE_ID_BROADCOM_43752:
 	case SDIO_DEVICE_ID_BROADCOM_CYPRESS_4373:
 		f2_blksz = SDIO_4373_FUNC2_BLOCKSIZE;
 		break;


