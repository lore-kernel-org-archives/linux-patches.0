Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C734B301700;
	Wed,  3 Dec 2025 15:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776133; cv=none; b=VBYsDM4G3riA5buR2muQ1FOSeTAU/lkNiBX7uUfsm3C0tpYP8dg3f76BCnFDY/5/fc+nHvph6ypCy2KT9Yv7YLXO2AXpWPMxusu45EHqnEtNOHHd8NS8RmomyLvqu1ZsKXfYncI0foGwWU/6BmJFJzy8PosHSiYyFEM9NWz5L+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776133; c=relaxed/simple;
	bh=RICmmYjKuybs419OkruZgfVryTPeH6nCqi+8zy5x+W4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oSmk8zUJg0FR92L61T/pCsHYVvJy1tp2Evx60F1Lc629Qw9HXoEaGsEfSj+Am3M12r3ltl+IfF4bQTfZcyJuNAOiK8KtMQyOQ5sVVY/UsvDv55hfpn4IXGLsaK2JdTRWe+/5Z4bxsJRDmjjZK3hNU8KjWb73ySB+1HsoBANDDZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RYFBBOE8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RYFBBOE8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2CD8C4CEF5;
	Wed,  3 Dec 2025 15:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776133;
	bh=RICmmYjKuybs419OkruZgfVryTPeH6nCqi+8zy5x+W4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RYFBBOE8UwGS0G8vgo3E87Hk7ciGgNjvMIe1IQ7evYC7H7A8CQ7pf3wZ9TvqSMwGy
	 lvif/eSzfkBS+QGgCPB3JuO1l07q8wKSZJgrxP+ZiWebR3xbRq6zsSTsMqGLsq+qP8
	 1BXmfFfrL45sffqgCgWhwHUjKCXetR29hR555BlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 090/300] ALSA: usb-audio: Add validation of UAC2/UAC3 effect units
Date: Wed,  3 Dec 2025 16:24:54 +0100
Message-ID: <20251203152403.957531231@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 2aec0b6a6b5395bca7d6fde9c7e9dc391d329698 ]

Just add fixed struct size validations for UAC2 and UAC3 effect
units.  The descriptor has a variable-length array, so it should be
validated with a proper function later once when the unit is really
parsed and used by the driver (currently only referred partially for
the input terminal parsing).

Link: https://patch.msgid.link/20250821151751.12100-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/validate.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/sound/usb/validate.c b/sound/usb/validate.c
index a0d55b77c9941..4bb4893f6e74f 100644
--- a/sound/usb/validate.c
+++ b/sound/usb/validate.c
@@ -266,7 +266,11 @@ static const struct usb_desc_validator audio_validators[] = {
 	FUNC(UAC_VERSION_2, UAC_MIXER_UNIT, validate_mixer_unit),
 	FUNC(UAC_VERSION_2, UAC_SELECTOR_UNIT, validate_selector_unit),
 	FUNC(UAC_VERSION_2, UAC_FEATURE_UNIT, validate_uac2_feature_unit),
-	/* UAC_VERSION_2, UAC2_EFFECT_UNIT: not implemented yet */
+	/* just a stop-gap, it should be a proper function for the array
+	 * once if the unit is really parsed/used
+	 */
+	FIXED(UAC_VERSION_2, UAC2_EFFECT_UNIT,
+	      struct uac2_effect_unit_descriptor),
 	FUNC(UAC_VERSION_2, UAC2_PROCESSING_UNIT_V2, validate_processing_unit),
 	FUNC(UAC_VERSION_2, UAC2_EXTENSION_UNIT_V2, validate_processing_unit),
 	FIXED(UAC_VERSION_2, UAC2_CLOCK_SOURCE,
@@ -286,7 +290,8 @@ static const struct usb_desc_validator audio_validators[] = {
 	FUNC(UAC_VERSION_3, UAC3_MIXER_UNIT, validate_mixer_unit),
 	FUNC(UAC_VERSION_3, UAC3_SELECTOR_UNIT, validate_selector_unit),
 	FUNC(UAC_VERSION_3, UAC3_FEATURE_UNIT, validate_uac3_feature_unit),
-	/*  UAC_VERSION_3, UAC3_EFFECT_UNIT: not implemented yet */
+	FIXED(UAC_VERSION_3, UAC3_EFFECT_UNIT,
+	      struct uac2_effect_unit_descriptor), /* sharing the same struct */
 	FUNC(UAC_VERSION_3, UAC3_PROCESSING_UNIT, validate_processing_unit),
 	FUNC(UAC_VERSION_3, UAC3_EXTENSION_UNIT, validate_processing_unit),
 	FIXED(UAC_VERSION_3, UAC3_CLOCK_SOURCE,
-- 
2.51.0



