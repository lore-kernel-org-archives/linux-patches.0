Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE041272B5;
	Tue, 23 Jan 2024 00:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968509; cv=none; b=swHS8YkUr3uRthZ42SedqdQLMdKlEW8afmP9zo/JkrwOtkALysN6RkMbqFSIFizJPQRIn5ULhfvTj3+I+bxXy8Z7Lo+LCnc5/+gIV3Hh3vbw3WjoDMYTPuIV2MxGc9ZJDA9XZZDxzo4fxyD+qM+kbnG3IM3tLIssYJ2OJoHSGbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968509; c=relaxed/simple;
	bh=Sa1qC7URSzzVCOy/R7Cq45lPsOAZzJZaTx/PugHcl3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n8OUwu0qaAspWIaCffK/VTfcPMI21aI3elOavTbYhIcn5+12xU4SjJBEbmlJK5latFuIMTQ8jadKyvevdWD+ilcQ1JswhYNxRpwdwzBeHZm5o55O46CI71EHb1/yr2OJIysNDQDrd+4RaB9DG8ZGNwz80LEXTgJf8f+h6IZQ2XI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mmn0Yuom; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mmn0Yuom"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93932C433C7;
	Tue, 23 Jan 2024 00:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968509;
	bh=Sa1qC7URSzzVCOy/R7Cq45lPsOAZzJZaTx/PugHcl3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mmn0YuomPeqbWvzWganQi3Yw08UQY9NBrVQwtXGpfhDeA9LmHXQ+S2Jwx3Ny5fY5Z
	 4UshDV4vlPmNe33tVT8glfohPfhsHPJMXUznlzYD8HSn0YfBrcQC2YIFnM//cnkQHm
	 jRwhQD1vIog6J9PU39CgE0kOFFYZTSIeaBDFf0u4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 127/148] ALSA: oxygen: Fix right channel of capture volume mixer
Date: Mon, 22 Jan 2024 15:58:03 -0800
Message-ID: <20240122235717.671487637@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -730,7 +730,7 @@ static int ac97_fp_rec_volume_put(struct
 	oldreg = oxygen_read_ac97(chip, 1, AC97_REC_GAIN);
 	newreg = oldreg & ~0x0707;
 	newreg = newreg | (value->value.integer.value[0] & 7);
-	newreg = newreg | ((value->value.integer.value[0] & 7) << 8);
+	newreg = newreg | ((value->value.integer.value[1] & 7) << 8);
 	change = newreg != oldreg;
 	if (change)
 		oxygen_write_ac97(chip, 1, AC97_REC_GAIN, newreg);


