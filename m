Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2A112F59C;
	Tue, 23 Jan 2024 01:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971758; cv=none; b=Ed1iRZHRL/ysmRzOKyNFevf6QyUXuAPo0J4nkDOv2kwm6zGftKqRMbkyskN1bxa+ouKgIVEWdYMRwNBiJ1RWNxTJPif7iK1VuMVFEOBPqdZYh/fq+wcGNqbzRUuQnqRLXgPkioNpT0UgUg1Ih3nwS+zpLb21t3kWp6NreSP5tQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971758; c=relaxed/simple;
	bh=a8AzFp5d5/5w8NaD93HmPyzhUjZpkVWNId3QZLCyHFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uvC+iKcz0LTrNEN5RbzD0FS30ZUzboQnmifpbYG6G5r8y5nytMv2QVAiTYVitYJVkPxZozstO3edTmrzfsT8DdxqVxmOEqHMcdoIMrGImSgQz8iHtzCll6zEAI/yaHDu5h31TSQvdhpKkhR/Si4w51Nf2D6+1zfxI1cjydEJmcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m04GrtfM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m04GrtfM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A650FC433C7;
	Tue, 23 Jan 2024 01:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971757;
	bh=a8AzFp5d5/5w8NaD93HmPyzhUjZpkVWNId3QZLCyHFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m04GrtfMau33PrlM8KG9OEAGQTrxgMUstqiF9TkNwFw/eNZwbKwNeZ/IQr3YB0fUb
	 iZd6kxf5bEXEXyzM/xVzhy11JqKZ+bowSagEwlNxuc5bpb1oGJxFUJ4vffI5yrYqlm
	 CJ0bUOguPLbyM1fE1COJ5Ik4774UnlWWVDw5nDUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 220/286] ALSA: oxygen: Fix right channel of capture volume mixer
Date: Mon, 22 Jan 2024 15:58:46 -0800
Message-ID: <20240122235740.544557991@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


