Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED35F18024;
	Tue, 26 Aug 2025 12:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212594; cv=none; b=qO3vLXmdImkxa7vXQFwEaTCzpwKcNhFzAJiy4v1U44fFxfND69dZyZzDaOSCqaIpCWr1TAe4/UQNRraLK9A3lShB4Qp8ZW8NSi6FGFSXCBb5betCDJaFAu8ihqxtOi4e1Ro/RDNy5WLfT8EkyGjonzR5Aze5kk7fJ1PykjJ6DyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212594; c=relaxed/simple;
	bh=KQJ3ifsxiNHR3QpVIgm5Yn7LQDsgX6LZHKd6IY2+Qpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S7IhOPzSOWfXuNSJ3kW7hVUy0FhgNZkaHAR7UTsNzy7uZ0aPsPquPTyKBQg09H3GqdMMMS26cyq8PK4xGE/DUsQNk0S6do49Yn8SHo7rzte4+9xRPr2UfA6uSqY+TRxqdGamjEekgax0csY6rqAeQLnS8KybXmHIRXQrwUIHXHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dy6yWIg1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dy6yWIg1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F1CAC4CEF4;
	Tue, 26 Aug 2025 12:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212593;
	bh=KQJ3ifsxiNHR3QpVIgm5Yn7LQDsgX6LZHKd6IY2+Qpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dy6yWIg1LYGZBR55vmG/XwDeb4FB1Lk2QmxERuD6p03TNtP08YxDGl6rwI1KgsMFD
	 vCeZhDrYCqzxL5V5GWVlx0/ELFgCSTqQvqk1EgVf6UUxCercXSf9GN+1Udt2KIOXuO
	 2IMCUeOSpJftvLbXjjFYYMMI9AiEePbF5nNJKEvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Youngjun Lee <yjjuny.lee@samsung.com>
Subject: [PATCH 6.6 002/587] ALSA: usb-audio: Validate UAC3 power domain descriptors, too
Date: Tue, 26 Aug 2025 13:02:31 +0200
Message-ID: <20250826110953.009879346@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


