Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE57239E8B;
	Tue, 26 Aug 2025 13:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216037; cv=none; b=IGiSi4jTXMh+DJZumefVJX1+1T2T9tSrlcAf8wpmNRbnPh5lUO5ExGmWt4KxJ/O1/Gt2XzYBC3TvVr4YYL+gfpZ4Ldcv7H1JIFnBNBtqgOlSg9Fmut+z0UvODz3eq6XWNnxCmRaRM8TJJNMiorK5gUV5vUygPgNe2J7I4rEEKok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216037; c=relaxed/simple;
	bh=YijJo4Dhjr9uKhf9RidH5gehdTxnDIwTa7L2LjZsaSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kxmwPt1Eos1lHBi3uSt+nFCoW8YJZ9bM/Cfpv5vGS1X1xTANVnZrrHHZvYVZqigxpnd+YtYJWp0aI8s9OnMiFWjZnMsSOJEWlEeRCyOnQUBG7Dcclsv40CId8wzqlysWTCO8VHb+yb/D6b3JkFPE/pHxhDZgVqyUFFqjyhf6lLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FAD3b7S1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FAD3b7S1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BBE3C4CEF1;
	Tue, 26 Aug 2025 13:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216037;
	bh=YijJo4Dhjr9uKhf9RidH5gehdTxnDIwTa7L2LjZsaSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FAD3b7S1eEzZWuWgf5uzhTCs87LU4ujTBtLrG2AwoANpwnoRc23fK6neG0i2kVjVf
	 x9RMHI31dI4cNwAegFWZ0UI/p418I4g3+5IxFceNDNbzLRGzDp2YwuM0IIV8ts4xMF
	 +MERC7HYKTBW54fBSq27DGN+fqfWZwSo9nxMD5Ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Youngjun Lee <yjjuny.lee@samsung.com>
Subject: [PATCH 5.15 259/644] ALSA: usb-audio: Validate UAC3 power domain descriptors, too
Date: Tue, 26 Aug 2025 13:05:50 +0200
Message-ID: <20250826110952.796459752@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


