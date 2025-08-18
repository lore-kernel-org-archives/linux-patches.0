Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40BB52E717D;
	Mon, 18 Aug 2025 13:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522910; cv=none; b=D9M/n8RSLS8zv7gqauUGeeKqm2iM2iIbvtlaQAjeRGFSveA9kxKl1CSM+d6yoYvCDh41tsSQQEpsIdlAn3M3l/uw0WQVfYoVibXiBtTJUUB+uMgLmx0CbCSYdr8yndIT2VdrmT4ybeGutK7mkvbLEC86nM3gcj5BwJPOah48Iss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522910; c=relaxed/simple;
	bh=p256z2EvQeM2AYaE14uik+40hkIehXnQSXi27livSSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fWrfxhQYASJIX7dofeg/iSxpnzXPbwciAt7A6X52t8D7NkAe4gytSlwBDf0rJFRwAUIm/p5Sts/rHNwYCQQOyVsE3ieT62UufdBja7rDG+yP28JBZcI5B9f5df3pQSN5lqjzcn9qNaNL9P+r4V6e4GgxIlod4yoNfNJ99MjiHqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gRpDn2WS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gRpDn2WS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5293C4CEEB;
	Mon, 18 Aug 2025 13:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522910;
	bh=p256z2EvQeM2AYaE14uik+40hkIehXnQSXi27livSSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gRpDn2WSgIYHjMpsCMkW1yTLItrk04OyqccX+s2o6BGq0xH2DcDJiYNEYUZKIx9wp
	 HWGQQ/twdgTxi5SDcm4NOA6F/mOlHNoCjCLX5KB8qmWbJJ+ZX5T9aX6xC2RwWrqCzi
	 mUZMq47YuwOoDSgc+Uz3u9bwDly+ehvVpjamTW6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Youngjun Lee <yjjuny.lee@samsung.com>
Subject: [PATCH 6.15 005/515] ALSA: usb-audio: Validate UAC3 power domain descriptors, too
Date: Mon, 18 Aug 2025 14:39:51 +0200
Message-ID: <20250818124458.540228755@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit d832ccbc301fbd9e5a1d691bdcf461cdb514595f upstream.

UAC3 power domain descriptors need to be verified with its variable
bLength for avoiding the unexpected OOB accesses by malicious
firmware, too.

Fixes: 9a2fe9b801f5 ("ALSA: usb: initial USB Audio Device Class 3.0 support")
Reported-and-tested-by: Youngjun Lee <yjjuny.lee@samsung.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20250814081245.8902-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/validate.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/sound/usb/validate.c
+++ b/sound/usb/validate.c
@@ -221,6 +221,17 @@ static bool validate_uac3_feature_unit(c
 	return d->bLength >= sizeof(*d) + 4 + 2;
 }
 
+static bool validate_uac3_power_domain_unit(const void *p,
+					    const struct usb_desc_validator *v)
+{
+	const struct uac3_power_domain_descriptor *d = p;
+
+	if (d->bLength < sizeof(*d))
+		return false;
+	/* baEntities[] + wPDomainDescrStr */
+	return d->bLength >= sizeof(*d) + d->bNrEntities + 2;
+}
+
 static bool validate_midi_out_jack(const void *p,
 				   const struct usb_desc_validator *v)
 {
@@ -285,6 +296,7 @@ static const struct usb_desc_validator a
 	      struct uac3_clock_multiplier_descriptor),
 	/* UAC_VERSION_3, UAC3_SAMPLE_RATE_CONVERTER: not implemented yet */
 	/* UAC_VERSION_3, UAC3_CONNECTORS: not implemented yet */
+	FUNC(UAC_VERSION_3, UAC3_POWER_DOMAIN, validate_uac3_power_domain_unit),
 	{ } /* terminator */
 };
 


