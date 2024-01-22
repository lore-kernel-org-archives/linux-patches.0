Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E3B605DF;
	Tue, 23 Jan 2024 01:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974716; cv=none; b=jWZ8+X+6RRHhvtLVFD2XBX3cceqtCRtpjW0L9QZYyDejtye1pl1SYh3lSBn1ligexPwqMSfAx/is+jC+J5urx2Jf/hgmHz199I3ny92FF1BsmgbLf1b82wZSwEaOtr01acfSCwXdhQ1z4/lCBbTLmg/tvd25Ce6/LI2vRX3KU3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974716; c=relaxed/simple;
	bh=6V+bxqUjsjKc0YmTGuEbJ8c8W/pHI4PwEEZS+PsXagE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kg9FeaQlxiMArDiXZPqkbchaG20yPGvENSdUDvjdE9hdvL7sORgfHWEbYEoE+MI78mVZsWEtFeA45j4Ce/ob6Y6RROiV0sZrYBO6QI+EKXrcGvCxna/kZcttXE+Ob9+ycpidv2Kx9eMt1Ry4jAlR7Le+OX5D8F3MgR3pxtGRHI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L7Z/SZCG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L7Z/SZCG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFB62C43399;
	Tue, 23 Jan 2024 01:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974716;
	bh=6V+bxqUjsjKc0YmTGuEbJ8c8W/pHI4PwEEZS+PsXagE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L7Z/SZCGzgWcqsX2vU+qelpCeaKdQQ/+VmPsg3DWBMtsO/I79fiU1/j3xlcrOvpor
	 4pffYl9smt8ctkpE/TJxmi2mYpbFdyUg8Gax0j5gvU3zE61h5OFX9We0ko/dJg7LlN
	 Ftjry3xq/jiFRDqoUTmHYSYXnf516gPztaIgtR5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 265/374] ALSA: oxygen: Fix right channel of capture volume mixer
Date: Mon, 22 Jan 2024 15:58:41 -0800
Message-ID: <20240122235753.989272387@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit a03cfad512ac24a35184d7d87ec0d5489e1cb763 upstream.

There was a typo in oxygen mixer code that didn't update the right
channel value properly for the capture volume.  Let's fix it.

This trivial fix was originally reported on Bugzilla.

Fixes: a3601560496d ("[ALSA] oxygen: add front panel controls")
Cc: <stable@vger.kernel.org>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=156561
Link: https://lore.kernel.org/r/20240112111023.6208-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/oxygen/oxygen_mixer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/oxygen/oxygen_mixer.c
+++ b/sound/pci/oxygen/oxygen_mixer.c
@@ -718,7 +718,7 @@ static int ac97_fp_rec_volume_put(struct
 	oldreg = oxygen_read_ac97(chip, 1, AC97_REC_GAIN);
 	newreg = oldreg & ~0x0707;
 	newreg = newreg | (value->value.integer.value[0] & 7);
-	newreg = newreg | ((value->value.integer.value[0] & 7) << 8);
+	newreg = newreg | ((value->value.integer.value[1] & 7) << 8);
 	change = newreg != oldreg;
 	if (change)
 		oxygen_write_ac97(chip, 1, AC97_REC_GAIN, newreg);


