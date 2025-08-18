Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA1A335BAA;
	Mon, 18 Aug 2025 13:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524681; cv=none; b=hzQHxG7R/9LpJHV/lQc//G82959Z6H1e+689nbk2VjxMmSXNDgZozgQYM68+v0jpWzuYzXuGRAwK3yDAqg2nN7+2QkGiS3C6Ex21C2FItKE7HPhk4TNhBUKwKaMlgl93j+hlpcqHqUNplsXQcAxEndzaWB+/BYLDjFACJpDiS14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524681; c=relaxed/simple;
	bh=a0wyPP12id+vWmQndJIynSJPrONYp1YAQ2rjmU6k0y0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=prp/SlLKpN10Min6IN6RVsabUVXeHckVnk/lWSYiI88lqBkawY6WPLEE195fCQdRGQB+jVVr007CXJ2HRd3BpkEBT7GErvxKkEoZ3pW57E953shBvkNLkBa9uKc18A1XIVO1A27r+u5ZOEN2zitJcHpHE+xrZ4jarhKcK+bWxnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ByVGDpGS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ByVGDpGS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE17C4CEEB;
	Mon, 18 Aug 2025 13:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524681;
	bh=a0wyPP12id+vWmQndJIynSJPrONYp1YAQ2rjmU6k0y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ByVGDpGSAZ9fvlYVvB0qgIJvuFKDdpY2pu6ePyVcm7YnU31GcYPprFyN3U/ySw294
	 8Nb7FVt5JAQGMfl5VM5Ddm5GFtjsC5pyc5zQq00osoIq7PTZFlNiE26/nSVL1sLE/n
	 qJMW+iOZBCGqt8HuOY1ovbfO9bB4J5Hgq/92FP7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Youngjun Lee <yjjuny.lee@samsung.com>
Subject: [PATCH 6.16 006/570] ALSA: usb-audio: Validate UAC3 power domain descriptors, too
Date: Mon, 18 Aug 2025 14:39:53 +0200
Message-ID: <20250818124506.033071163@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
 


