Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 965EC221DA4;
	Thu, 12 Dec 2024 17:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025883; cv=none; b=GNi7oVXjW7Nt/oe/5DX063/GS7MrPqnF95peuKz2nkoKlbpiYq05FyG5mtTsPYp2sfbg4cQGNrf/4sUMCoouYeZ+z0JoF7xhUYKWXJpvAZ5VMKiyyjTIR89umvxQTHZIpYdvl5uoccM/+v5ydmfSoNBkfkTYRJ+8vpnCUGRNnAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025883; c=relaxed/simple;
	bh=fkh248eWj9lt3yglmgaSXxxx6rO+HV8F3/Iz592fofQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KDBGYzOWb4RYHy0Eyb3ORNQGOM6CdTZAKY26JGWIZwAiB/WHl14Facfv2vI8fIri/hwhlT4N2qXInFXlXetzhxqi39symAnafoBbEPdo9eLEBVUT5Rv3NKOnARmW98aOBGjJuVPAZHh20lfAz2mKxilwd17NyKMZ3waM1lIjFR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G2jmc+xL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G2jmc+xL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D911C4CECE;
	Thu, 12 Dec 2024 17:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025883;
	bh=fkh248eWj9lt3yglmgaSXxxx6rO+HV8F3/Iz592fofQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G2jmc+xLcE2/EABTXc6wFU/fN4+UGl0frqknpvnGdeanmw2E5q95ip1LAarIXJMG8
	 WOjMyYFhaMrYFBJADlq/GnZZ9ggBS2EkrPG4JdljppPJ4OKjlJGuGGB2k8Zb1e5aQS
	 9/RmRmZP85XDuOmcW94f41vyxkPbXXN3x3Hw0C84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Beno=C3=AEt=20Sevens?= <bsevens@google.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 320/321] ALSA: usb-audio: Fix out of bounds reads when finding clock sources
Date: Thu, 12 Dec 2024 16:03:58 +0100
Message-ID: <20241212144242.621146156@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Benoît Sevens <bsevens@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/clock.c |   32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

--- a/sound/usb/clock.c
+++ b/sound/usb/clock.c
@@ -21,6 +21,10 @@
 #include "clock.h"
 #include "quirks.h"
 
+/* check whether the descriptor bLength has the minimal length */
+#define DESC_LENGTH_CHECK(p) \
+	 (p->bLength >= sizeof(*p))
+
 static void *find_uac_clock_desc(struct usb_host_interface *iface, int id,
 				 bool (*validator)(void *, int), u8 type)
 {
@@ -38,36 +42,60 @@ static void *find_uac_clock_desc(struct
 static bool validate_clock_source_v2(void *p, int id)
 {
 	struct uac_clock_source_descriptor *cs = p;
+	if (!DESC_LENGTH_CHECK(cs))
+		return false;
 	return cs->bClockID == id;
 }
 
 static bool validate_clock_source_v3(void *p, int id)
 {
 	struct uac3_clock_source_descriptor *cs = p;
+	if (!DESC_LENGTH_CHECK(cs))
+		return false;
 	return cs->bClockID == id;
 }
 
 static bool validate_clock_selector_v2(void *p, int id)
 {
 	struct uac_clock_selector_descriptor *cs = p;
-	return cs->bClockID == id;
+	if (!DESC_LENGTH_CHECK(cs))
+		return false;
+	if (cs->bClockID != id)
+		return false;
+	/* additional length check for baCSourceID array (in bNrInPins size)
+	 * and two more fields (which sizes depend on the protocol)
+	 */
+	return cs->bLength >= sizeof(*cs) + cs->bNrInPins +
+		1 /* bmControls */ + 1 /* iClockSelector */;
 }
 
 static bool validate_clock_selector_v3(void *p, int id)
 {
 	struct uac3_clock_selector_descriptor *cs = p;
-	return cs->bClockID == id;
+	if (!DESC_LENGTH_CHECK(cs))
+		return false;
+	if (cs->bClockID != id)
+		return false;
+	/* additional length check for baCSourceID array (in bNrInPins size)
+	 * and two more fields (which sizes depend on the protocol)
+	 */
+	return cs->bLength >= sizeof(*cs) + cs->bNrInPins +
+		4 /* bmControls */ + 2 /* wCSelectorDescrStr */;
 }
 
 static bool validate_clock_multiplier_v2(void *p, int id)
 {
 	struct uac_clock_multiplier_descriptor *cs = p;
+	if (!DESC_LENGTH_CHECK(cs))
+		return false;
 	return cs->bClockID == id;
 }
 
 static bool validate_clock_multiplier_v3(void *p, int id)
 {
 	struct uac3_clock_multiplier_descriptor *cs = p;
+	if (!DESC_LENGTH_CHECK(cs))
+		return false;
 	return cs->bClockID == id;
 }
 


