Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF7163AC0D3;
	Mon, 23 Mar 2026 16:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282240; cv=none; b=hDHU1KOhBZWiL/kosqLoSBKNT2Z4Q8+ZAjLwtg28or4ibuuzPo59Q5XuxKfdMO2R8ke6Dyv3b9zZH4D+pAQZQGC1g6ZPNO3yyearLtAJSbQRA//ZoegKsuu9odydZkcsHpT1VD1VrogSONYJ+0FmfPNcO4dylOzJt5zOXWfXRU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282240; c=relaxed/simple;
	bh=2hWQqKOVDbWx23kSD+MR8VRTnt4RWr/e+33H+gEmgBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L6s988zpYn9aUV2evWya59DP9yi+bzggPjw0udyQbqvrB8QMv2IfSZKMSXibU//pYrmd9cPyoAseGCJkmKIg3itVL2klTdBEPni+jk7ZGX910/WVP5bcpm11dLv09HnRqSaIHZk3n3J/YoVFE90+sv9828cBg+PAj+gwGh7vZAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U71FxVNa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U71FxVNa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24650C4CEF7;
	Mon, 23 Mar 2026 16:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282240;
	bh=2hWQqKOVDbWx23kSD+MR8VRTnt4RWr/e+33H+gEmgBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U71FxVNawVV6rM1Cq9WGNQXUTm3ifSNXPRNqqQYW+skko7WbLWPjc+QdXz7hHkZML
	 Es8OBAOdw/+bahHcMJfHUHYV7zDOE3nLth3QddOFND3jqfPeDE7hvYO1WLnJGRHKbu
	 OXFgZ4wWFRPpxvlnsW7fK6je0XkXYRPGybHbPEzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jun Seo <jun.seo.93@proton.me>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 082/481] ALSA: usb-audio: Use correct version for UAC3 header validation
Date: Mon, 23 Mar 2026 14:41:04 +0100
Message-ID: <20260323134527.257617542@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

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
 sound/usb/validate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/usb/validate.c
+++ b/sound/usb/validate.c
@@ -281,7 +281,7 @@ static const struct usb_desc_validator a
 	/* UAC_VERSION_2, UAC2_SAMPLE_RATE_CONVERTER: not implemented yet */
 
 	/* UAC3 */
-	FIXED(UAC_VERSION_2, UAC_HEADER, struct uac3_ac_header_descriptor),
+	FIXED(UAC_VERSION_3, UAC_HEADER, struct uac3_ac_header_descriptor),
 	FIXED(UAC_VERSION_3, UAC_INPUT_TERMINAL,
 	      struct uac3_input_terminal_descriptor),
 	FIXED(UAC_VERSION_3, UAC_OUTPUT_TERMINAL,


