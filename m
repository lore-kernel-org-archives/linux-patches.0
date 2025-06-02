Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25EFA22B5A1;
	Mon,  2 Jun 2025 14:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874438; cv=none; b=fBVVpFIVytX1Dqnoi8ZXClhUXP2m/JCpiactZiggC9NeHwiTnDdvmyxWfkGOS3Pqbz3JPj75qnbTC0eSKGhKZMx8bt1b4MB5nIzJF5HPV6KK5mR+z6OjYw9FNL0FdhjzKaFV0INY0/mzwFZWK2Gld9r0JagT0GiDA65SEnsTGS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874438; c=relaxed/simple;
	bh=LMcCvw2i3ZaO2ZpcCgyLKCmA+8C33EGAR7A/y282QhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EmdChI+5KJCXN0GxhUpk9W5GN8BA5jGIU0kO3R112p9UnmJ7z2TXldyH65yCXo9Q1/OjDm7ZTay542AcYYIosPfJ49UiajD1+Ft3ISOcidjAmDfajdPYHzw7ip2CxMnmfBouaIH3lToRWqwcXCY//NNP/y0TAJ2pLeTf0mNRcKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qDcFpRUx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qDcFpRUx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82584C4CEEE;
	Mon,  2 Jun 2025 14:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874438;
	bh=LMcCvw2i3ZaO2ZpcCgyLKCmA+8C33EGAR7A/y282QhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qDcFpRUxccqOzc4EYaN346dTgOxWR+jDcwpb+PTnT5KdamNrMu/FxTmQsFXLYhudr
	 rdGpS7AlTm17NNkwAPIsHuKTeFcJwln0untIa5HzdGOs3hFlmqvSC42skyIRNoiUTR
	 MnLL0j6IPTCcR8Na+pso5/GFANTiXzMn2+bgNphg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.4 006/204] wifi: brcm80211: fmac: Add error handling for brcmf_usb_dl_writeimage()
Date: Mon,  2 Jun 2025 15:45:39 +0200
Message-ID: <20250602134255.717395050@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -866,14 +866,16 @@ brcmf_usb_dl_writeimage(struct brcmf_usb
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


