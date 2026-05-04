Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C083DDDCC;
	Mon,  4 May 2026 13:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777902904; cv=none; b=bCwl7fzXgRquuZZ4X1mv6azrz72ha15J0mMgVJWo+p0ovUmjOnAaObCbKywzZmjy2c5sb2qL9HdDJM5sdQRnJpBJ63ohDtSAU6z7ASD/ME+l59JFpsqsUpo+GT0dinrjekPlcR+RhZjA9XVSeFq+4JnyjAw6DyRLzEN7hFjNLVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777902904; c=relaxed/simple;
	bh=LAsLrhZkK8V3/9mQepubcSF22HBaatERRYaS2YMcW08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rvf6mmIqlvF7+JH4/jhFu1f9aGtCCC8wmpyNp+V1UTaoNTeCEjrRygLns1WAwj8MZlzpHV1i21jvZ0QuMog8t42z6rudRlcGhIF3i+TtYUfC2zQaG6uR2aMZHnN/F6etHCyKLNdxjbhLprgoFCOnNhgj+YBUGPOXZn/MbjZHp8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1OYSk8P+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1OYSk8P+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC0B7C2BCC4;
	Mon,  4 May 2026 13:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777902904;
	bh=LAsLrhZkK8V3/9mQepubcSF22HBaatERRYaS2YMcW08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1OYSk8P+b/cHLJolHoPNtH9BPqFC6sZopw/ZWAm/W/KGhoBqJ56ZQ084KsLCag7qk
	 EXi+Nh7zqj7IiKdIxH7wDfbyY5RpUQUfQNue3cKjE55A7r29wqAKMynAGxSCNQt0l+
	 zNhsIep0Ca2Taz+zPYc74w0qez+4yuX1gr0zc3hM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.0 003/307] ALSA: usb-audio: Fix Audio Advantage Micro II SPDIF switch
Date: Mon,  4 May 2026 15:48:08 +0200
Message-ID: <20260504135142.950983593@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

commit a9224f26b754b5034719248891ff3c2ea0d11144 upstream.

snd_microii_spdif_switch_put() returns 0 when the requested
vendor register value differs from the cached one.

This comparison was inverted by the resume-support conversion,
so real SPDIF switch toggles are ignored while no-op writes still
issue SET_CUR and report success.

Return early only when the requested value matches the cached one.

Fixes: 288673beae6c ("ALSA: usb-audio: Add resume support for MicroII SPDIF ctls")
Cc: stable@vger.kernel.org
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260421-microii-spdif-switch-fix-v1-1-5c50dc28b88f@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer_quirks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -2027,7 +2027,7 @@ static int snd_microii_spdif_switch_put(
 	int err;
 
 	reg = ucontrol->value.integer.value[0] ? 0x28 : 0x2a;
-	if (reg != list->kctl->private_value)
+	if (reg == list->kctl->private_value)
 		return 0;
 
 	kcontrol->private_value = reg;


