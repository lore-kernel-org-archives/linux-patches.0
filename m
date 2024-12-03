Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C183F1F6696;
	Tue,  3 Dec 2024 15:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239483; cv=none; b=WqTrklmkaNU1JHNxA5U0urNrjTHqyvH0RFR7yydhQDYOBnoL0bnfCWfky0pvXYQcOsGPIRYZBRgHA6v80O3m/8V6xpxBcmlmgkCEPYa44O1YzhKe1g77XQtR4t2GwpxoiQIl7tgfUCA0IuUzacRWR4l8kq1+oAOofD0pLKT8s7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239483; c=relaxed/simple;
	bh=Td8qliLq6kYdQJMfbavyDCIesQC3qppJrzOaS9CDxi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y+KYS9iaRua1pQa6srEp8Bakeh5T1e0Qb9+L1R2C6x74Nfbgpvvc3tBs6fuFBR1zf73lpKiMybAmAmV+Pa1sbAQHEM85nTYvW8sw3OZx9MLt8pDTjHUkxaOl3e/2iOgBPWZqcQJgGY7Tkw/LrdQsTncw19TI+sF14UddzzgYn9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TzLajudk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TzLajudk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC245C4CECF;
	Tue,  3 Dec 2024 15:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239483;
	bh=Td8qliLq6kYdQJMfbavyDCIesQC3qppJrzOaS9CDxi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TzLajudkJ64BA5ojyRwDHdfk6tD3inkAb60TrWuWiXSHM35QEr9fXq90OdxaDe93f
	 i9AkuEB0nFcCZ9JfRrjuRNe/iG6cbh1GUwAzgVr7+ew9uS3R1rL12qyv484EKr5tjw
	 S0lSHvBpmHZZxgbNqxBszXnUteEkFRzfc+Sb3PgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Beno=C3=AEt=20Sevens?= <bsevens@google.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.11 629/817] ALSA: usb-audio: Fix out of bounds reads when finding clock sources
Date: Tue,  3 Dec 2024 15:43:21 +0100
Message-ID: <20241203144020.489362889@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
 


