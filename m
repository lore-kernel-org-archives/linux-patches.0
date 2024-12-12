Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02FFF222D67;
	Thu, 12 Dec 2024 17:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024919; cv=none; b=W3m9Ig5QZ/al/YeHcSsyK154fDaUnLSxCkfxFaio7kOvJndTHJ9AiCvGi6x6j9zPwKVOoGcvJRd9Nhdv7jx5QHWhAHgIcYhWaqgSjKeNsJwePSDj0Z9TirxLMqiH89dVe2wgncVt8+E8vMN0gqZJhvWNMpzVC7diJQaMfLYuY8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024919; c=relaxed/simple;
	bh=DElNAvIEpfGX/KL1+fCri6peBFyw/dbPWC6F587CKzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dFFAuJGkh8pXhAGzuxBK3VdFJbvRwo8Egu6ixYM1Nk2kMwnno7gEUeVsy8gpdrGNHrKuRdddx3Z5JjeUGKqGbr4rsOLEnm6uW7xkKgNQJulWkJGt1HaFiWmfHHTiVh6ssuLMEgjLTX1BXCR2oGeZhoLQereCkpXiNPJ7QxbnSk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=awcBIPLt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="awcBIPLt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75D55C4CECE;
	Thu, 12 Dec 2024 17:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024918;
	bh=DElNAvIEpfGX/KL1+fCri6peBFyw/dbPWC6F587CKzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=awcBIPLtlO6y0VQkWG2JL95rE71WYc5HxGKBa65hOfrmrg+Gjpp2WJTQqrKGC5Dv+
	 Xf7oaVj8VshpRO+HDUVmmEzCBYpjN1TjdSWsJWIpIzfub5uQeoDJ4LwJTCBJr9ZoCp
	 b/tpO4hjlgI+HFTv+Ci++Cx+axytcnaSgcs3WDJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Beno=C3=AEt=20Sevens?= <bsevens@google.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 456/459] ALSA: usb-audio: Fix out of bounds reads when finding clock sources
Date: Thu, 12 Dec 2024 16:03:14 +0100
Message-ID: <20241212144311.783674625@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 


