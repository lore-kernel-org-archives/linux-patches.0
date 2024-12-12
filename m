Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58ADE23EC14;
	Thu, 12 Dec 2024 16:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019965; cv=none; b=JRiAXb3yiOJyoGcRU168nIUaig1QHCbibR/ku3mIy3qG2KONkRTC3h22Vmkfykmr3FSDwLzT6evTVOSh00QXN2GNx62fV9hPmckJQMfzynI+fWDNA0srctvcrK8iaIAOGuuyrq3USUYLU80/s61fV8ARJ+tn3KwOZNal+Ba/g8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019965; c=relaxed/simple;
	bh=05y15PdB042DknqvH+lgkJKNnQB7KdKvNT1EUJhr/aw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NwhlMXB3E9EVW423bdq92dOafivInnJ7bcI+9m+cdfumMEnlbPBjTouTjGMoVCNhdB6+eafVkUo2aWbrw2r3dgG1QntDAQBZWEbxcPXrYQuPxRGLTLI9vUgOKM7NNLyyaDGb+WOdvzvza+Cxes5gM1FN8SNNDeBusfBJtugMbHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ikkImmTp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ikkImmTp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3D9EC4CEDE;
	Thu, 12 Dec 2024 16:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019965;
	bh=05y15PdB042DknqvH+lgkJKNnQB7KdKvNT1EUJhr/aw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ikkImmTpcqlUQ61/WXEVwevbm7CqXFp2pDN9yz1KZmZna/kkfG0GTbTtBIKhEULr1
	 hyB2d80cD8Qul+VHX540e1OcI7QoRy6n0RIC2agl5s/6zAusKjQe8UiCXDiOH9VQgQ
	 NDe9EraQas1Pf6YqWXI858jDAsc3GihGgOLfURSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Beno=C3=AEt=20Sevens?= <bsevens@google.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 343/772] ALSA: usb-audio: Fix out of bounds reads when finding clock sources
Date: Thu, 12 Dec 2024 15:54:48 +0100
Message-ID: <20241212144404.082525884@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit a3dd4d63eeb452cfb064a13862fb376ab108f6a6 upstream.

The current USB-audio driver code doesn't check bLength of each
descriptor at traversing for clock descriptors.  That is, when a
device provides a bogus descriptor with a shorter bLength, the driver
might hit out-of-bounds reads.

For addressing it, this patch adds sanity checks to the validator
functions for the clock descriptor traversal.  When the descriptor
length is shorter than expected, it's skipped in the loop.

For the clock source and clock multiplier descriptors, we can just
check bLength against the sizeof() of each descriptor type.
OTOH, the clock selector descriptor of UAC2 and UAC3 has an array
of bNrInPins elements and two more fields at its tail, hence those
have to be checked in addition to the sizeof() check.

Reported-by: Benoît Sevens <bsevens@google.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/20241121140613.3651-1-bsevens@google.com
Link: https://patch.msgid.link/20241125144629.20757-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/clock.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

--- a/sound/usb/clock.c
+++ b/sound/usb/clock.c
@@ -36,6 +36,12 @@ union uac23_clock_multiplier_desc {
 	struct uac_clock_multiplier_descriptor v3;
 };
 
+/* check whether the descriptor bLength has the minimal length */
+#define DESC_LENGTH_CHECK(p, proto) \
+	((proto) == UAC_VERSION_3 ? \
+	 ((p)->v3.bLength >= sizeof((p)->v3)) :	\
+	 ((p)->v2.bLength >= sizeof((p)->v2)))
+
 #define GET_VAL(p, proto, field) \
 	((proto) == UAC_VERSION_3 ? (p)->v3.field : (p)->v2.field)
 
@@ -58,6 +64,8 @@ static bool validate_clock_source(void *
 {
 	union uac23_clock_source_desc *cs = p;
 
+	if (!DESC_LENGTH_CHECK(cs, proto))
+		return false;
 	return GET_VAL(cs, proto, bClockID) == id;
 }
 
@@ -65,13 +73,27 @@ static bool validate_clock_selector(void
 {
 	union uac23_clock_selector_desc *cs = p;
 
-	return GET_VAL(cs, proto, bClockID) == id;
+	if (!DESC_LENGTH_CHECK(cs, proto))
+		return false;
+	if (GET_VAL(cs, proto, bClockID) != id)
+		return false;
+	/* additional length check for baCSourceID array (in bNrInPins size)
+	 * and two more fields (which sizes depend on the protocol)
+	 */
+	if (proto == UAC_VERSION_3)
+		return cs->v3.bLength >= sizeof(cs->v3) + cs->v3.bNrInPins +
+			4 /* bmControls */ + 2 /* wCSelectorDescrStr */;
+	else
+		return cs->v2.bLength >= sizeof(cs->v2) + cs->v2.bNrInPins +
+			1 /* bmControls */ + 1 /* iClockSelector */;
 }
 
 static bool validate_clock_multiplier(void *p, int id, int proto)
 {
 	union uac23_clock_multiplier_desc *cs = p;
 
+	if (!DESC_LENGTH_CHECK(cs, proto))
+		return false;
 	return GET_VAL(cs, proto, bClockID) == id;
 }
 


