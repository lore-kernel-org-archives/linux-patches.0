Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0307229A0;
	Wed,  7 May 2025 19:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644491; cv=none; b=FPTpYngua9OuEU5rFV8DoKLn7LIlw7tHycSC0qL0D1XTBEqT6qL+1cOa/0smvziaMrNwGPe3t5o7YH/vEXGRq60PT2aBNKerj/DnvsC6z71BdTM/pN1PJ0w3Pu8b3jTrtCLpMrz7+XZNLg++Q5hnlS/aEcgrx2SDsZox7H/ECe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644491; c=relaxed/simple;
	bh=Pse9Vp93eWVImtvunIXiRgddVGz+tX6n+wB8cTPAYZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qjusGo+9ouUgVqO0BrmIfjAH2U+CWp1Hj0qsJOxup00sR/e7aZZN9f1ADeJjbE4O9oPBM1geVxE33HRxgWx6ctBEUDePAPFu9Kt5n/nYcO/8pfAkqa1kJqqaDWt8dZnHJmglxxc9IeL9idajplp2KMaksND3dKJldlhz1A+I0NY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UuH0uzgx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UuH0uzgx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78463C4CEE2;
	Wed,  7 May 2025 19:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644490;
	bh=Pse9Vp93eWVImtvunIXiRgddVGz+tX6n+wB8cTPAYZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UuH0uzgxOfhXVCbMbIYjTc3kqogxtif9smxsX7800EWVcyfTWxtgiYuSUzmUkqqMC
	 G4KNI+8fW7RE00ZUPvjglsvzBryVsYmxIjz1fVT1JllPTjW/ZajXp5Hnh1iZY8mWjm
	 jhQee1stv+VUx4txGxBTYJaKY8zCb34zAmcPFmyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 030/164] wifi: brcm80211: fmac: Add error handling for brcmf_usb_dl_writeimage()
Date: Wed,  7 May 2025 20:38:35 +0200
Message-ID: <20250507183822.089977950@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit 8e089e7b585d95122c8122d732d1d5ef8f879396 upstream.

The function brcmf_usb_dl_writeimage() calls the function
brcmf_usb_dl_cmd() but dose not check its return value. The
'state.state' and the 'state.bytes' are uninitialized if the
function brcmf_usb_dl_cmd() fails. It is dangerous to use
uninitialized variables in the conditions.

Add error handling for brcmf_usb_dl_cmd() to jump to error
handling path if the brcmf_usb_dl_cmd() fails and the
'state.state' and the 'state.bytes' are uninitialized.

Improve the error message to report more detailed error
information.

Fixes: 71bb244ba2fd ("brcm80211: fmac: add USB support for bcm43235/6/8 chipsets")
Cc: stable@vger.kernel.org # v3.4+
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Link: https://patch.msgid.link/20250422042203.2259-1-vulab@iscas.ac.cn
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
@@ -896,14 +896,16 @@ brcmf_usb_dl_writeimage(struct brcmf_usb
 	}
 
 	/* 1) Prepare USB boot loader for runtime image */
-	brcmf_usb_dl_cmd(devinfo, DL_START, &state, sizeof(state));
+	err = brcmf_usb_dl_cmd(devinfo, DL_START, &state, sizeof(state));
+	if (err)
+		goto fail;
 
 	rdlstate = le32_to_cpu(state.state);
 	rdlbytes = le32_to_cpu(state.bytes);
 
 	/* 2) Check we are in the Waiting state */
 	if (rdlstate != DL_WAITING) {
-		brcmf_err("Failed to DL_START\n");
+		brcmf_err("Invalid DL state: %u\n", rdlstate);
 		err = -EINVAL;
 		goto fail;
 	}


