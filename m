Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 301582D24B7;
	Tue, 10 Mar 2026 11:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141124; cv=none; b=EKnEbrpPPJtVyzrMTUpqJk9CbAjgecz3SiDsBUdekh/p1GqY7vvj4InIz1p9YnFCV7eKUpITtMhnAu79T9qvEF1xeOUVJvm2WTLCuessGc4AUdjuhgEJUNEVAirVkA0RLojtIJyMInqD1qR1c6fmGMr8gw/yPLflsbRtwOtxTkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141124; c=relaxed/simple;
	bh=l9kLO1oKEpgJrZan1MZykpVgHkPaAwe6749VxCWgqm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fOodsstu6k+lKSKNz4FRsiZ4UPTMVSj0CM2W8bZOKR4t6/nxFatgnW833V32mKgq9oUPVrmPe6CEp9HbFlveKQIhsMDc0pGIFb4XbRBM02mlbnNqN1MAuYS+gGng+vsX+0evTQMygm2SMo05KPYR/L6T+z2Ab468I6JKVFNSaJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z0qrdb8X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z0qrdb8X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D041C19423;
	Tue, 10 Mar 2026 11:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141124;
	bh=l9kLO1oKEpgJrZan1MZykpVgHkPaAwe6749VxCWgqm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z0qrdb8XdlgwpBeF3PKvpVsEvqSoVOmKWptIjB6VtMU/6ANZcz61hWSiyq8Fht28v
	 py49vfFzYtWRyezjE4NCVtT5jNSlpQmLSVgwXD3nkPl1l12nsnWgbGgDrdMNrnq5r0
	 3QtOH9225oNcDKw+WaPyQMwir1nLu6uTkCvHQfIEKKCaZTuEusTnIl+0CtYEWYpm/L
	 ceYDOzzAGUvZ4IE+Te4267P7zD+g3a12dA0vGVn1gJJXSiPi4KGozLp26Kxvpril+v
	 FaECZ1OA6ky9CkSJYWosjZ+bunpJmsdlWzOkhUd9cLtaY9vnjlEFcSM71EsRk91tWW
	 JcSlfhZ/Lb3Ag==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jun Seo <jun.seo.93@proton.me>,
	Takashi Iwai <tiwai@suse.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.19 126/311] ALSA: usb-audio: Use correct version for UAC3 header validation
Date: Tue, 10 Mar 2026 07:02:53 -0400
Message-ID: <562015ab4cc9a10036e55b92dc19b4ef15cbd717.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jun Seo <jun.seo.93@proton.me>

commit 54f9d645a5453d0bfece0c465d34aaf072ea99fa upstream.

The entry of the validators table for UAC3 AC header descriptor is
defined with the wrong protocol version UAC_VERSION_2, while it should
have been UAC_VERSION_3.  This results in the validator never matching
for actual UAC3 devices (protocol == UAC_VERSION_3), causing their
header descriptors to bypass validation entirely.  A malicious USB
device presenting a truncated UAC3 header could exploit this to cause
out-of-bounds reads when the driver later accesses unvalidated
descriptor fields.

The bug was introduced in the same commit as the recently fixed UAC3
feature unit sub-type typo, and appears to be from the same copy-paste
error when the UAC3 section was created from the UAC2 section.

Fixes: 57f8770620e9 ("ALSA: usb-audio: More validations of descriptor units")
Cc: <stable@vger.kernel.org>
Signed-off-by: Jun Seo <jun.seo.93@proton.me>
Link: https://patch.msgid.link/20260226010820.36529-1-jun.seo.93@proton.me
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/validate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/validate.c b/sound/usb/validate.c
index 4bb4893f6e74f..f62b7cc041dc9 100644
--- a/sound/usb/validate.c
+++ b/sound/usb/validate.c
@@ -281,7 +281,7 @@ static const struct usb_desc_validator audio_validators[] = {
 	/* UAC_VERSION_2, UAC2_SAMPLE_RATE_CONVERTER: not implemented yet */
 
 	/* UAC3 */
-	FIXED(UAC_VERSION_2, UAC_HEADER, struct uac3_ac_header_descriptor),
+	FIXED(UAC_VERSION_3, UAC_HEADER, struct uac3_ac_header_descriptor),
 	FIXED(UAC_VERSION_3, UAC_INPUT_TERMINAL,
 	      struct uac3_input_terminal_descriptor),
 	FIXED(UAC_VERSION_3, UAC_OUTPUT_TERMINAL,
-- 
2.51.0

