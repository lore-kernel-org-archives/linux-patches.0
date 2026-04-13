Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053052F8BC3;
	Mon, 13 Apr 2026 16:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097309; cv=none; b=AzIG8Gec7LT59mzPoTSv8qdYe8ACg/KIfRsSzbVz0VV0e5sDuniB4KqNNTB7CxjFPXEaGZBRuVQYzgPqs/XO9yrT4So+LPRfm6IFrnsK+Hb7tVQEcJFxC1WBoX63R9Qfx/q8qwndYz2bHGHzag9a70ssjbB9HKjTDqUB+aY2yIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097309; c=relaxed/simple;
	bh=R47UOziVHoNS1pbzy2wIlpXs92a6xi2YpIVd25S282c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BMZ32DK51P90rdN5OfCcZEA0nEdx1F+yMdnE+xfh5mHIyTFwnfeYVvhJ303souwd1QYJgbiu/fmxj4tFKWI+tiOpTxf7rUs4Y6a6t3mgB1umEGwn6Z7kqsS+1NYXfzSUX53DbSeRBwN5OXz7OSXVK/LbOBmmYMKhklv2UfEKaj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vc5575Za; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vc5575Za"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D530C2BCAF;
	Mon, 13 Apr 2026 16:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097308;
	bh=R47UOziVHoNS1pbzy2wIlpXs92a6xi2YpIVd25S282c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vc5575ZaTGJrxq/D/R7dR/CajkwZnPAv2rN/6BeA49CvoYCNrFlgKkh195mUwtIvr
	 65jAa6J0IgiY4QUANw491MX/EoAQ7op+MWzEZrlgzasLUvyK7CAxo95kEhwATCqTmC
	 oZpGi8X+uZkNxUED+E3AXwkOXDG/14u6OUdK/o00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jun Seo <jun.seo.93@proton.me>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 054/570] ALSA: usb-audio: Use correct version for UAC3 header validation
Date: Mon, 13 Apr 2026 17:53:05 +0200
Message-ID: <20260413155832.466645576@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


