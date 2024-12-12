Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2A6213E6B;
	Thu, 12 Dec 2024 15:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018647; cv=none; b=Oui0tb/JZujIy3PzEBUcg9cntJRU/T+Y6hWoH9Om1L1A7g77YUuW+KmWT7B+yPy1rE56Ts9odStupBC/f8ThnmN7aF99oYzkzBgRJaiQEpmEscHlD94M1GoHBP+e+fv1M1KfOQbydWpokgzOi+MjtvqlXZWdIFTjiY3HbiIpRBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018647; c=relaxed/simple;
	bh=niN/MSaFJxk9XpHYtH7XnvrxW9x3T8jPwNwPJG4yzfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XO4z45lf7Vh67Zp1JSDg/CLZOM3O7ZzINuIxGZQIWQhS/xMPzTKEL4k191RogepYM3k+mDJzfXoLiAUOvq1opMDQH3QiMdWoWEqbQKfNs2GRje5pZVl/Arl4QExEZpG/acjdzcuxMqzZgxwCakiyR2gBl+Y+3iYFPiyKhyfBqwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vLQu9yah; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vLQu9yah"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B9EFC4CECE;
	Thu, 12 Dec 2024 15:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018647;
	bh=niN/MSaFJxk9XpHYtH7XnvrxW9x3T8jPwNwPJG4yzfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vLQu9yahluZPAuz70+FZIrguwKbD90sLNg5mqrR7jq4jhV/6xkz2lpw9ES6wWg1Pd
	 vEqqOa9+p73rbKN7qgmQ7AahG0wu1GP3JqKnUJ4uViy1f6ng4nyj0ADDKDgi1VJ8Yg
	 KVaW+1WWQszLD6i6UWzTLoqpArmnp1cmQ2HbcbZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 349/356] ALSA: hda: Fix build error without CONFIG_SND_DEBUG
Date: Thu, 12 Dec 2024 16:01:08 +0100
Message-ID: <20241212144258.356792569@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
User-Agent: quilt/0.67
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

commit 0ddf2784d6c29e59409a62b8f32dc5abe56135a4 upstream.

The macro should have been defined without setting the non-existing
name field in the case of CONFIG_SND_DEBUG=n.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lore.kernel.org/20241011131046.5eb3905a@canb.auug.org.au
Fixes: 5b1913a79c3e ("ALSA: hda: Use own quirk lookup helper")
Link: https://patch.msgid.link/20241011072152.14657-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/hda_local.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/sound/pci/hda/hda_local.h
+++ b/sound/pci/hda/hda_local.h
@@ -308,9 +308,15 @@ struct hda_quirk {
 #endif
 };
 
+#ifdef CONFIG_SND_DEBUG_VERBOSE
 #define HDA_CODEC_QUIRK(vend, dev, xname, val) \
 	{ _SND_PCI_QUIRK_ID(vend, dev), .value = (val), .name = (xname),\
 			.match_codec_ssid = true }
+#else
+#define HDA_CODEC_QUIRK(vend, dev, xname, val) \
+	{ _SND_PCI_QUIRK_ID(vend, dev), .value = (val), \
+			.match_codec_ssid = true }
+#endif
 
 struct snd_hda_pin_quirk {
 	unsigned int codec;             /* Codec vendor/device ID */


