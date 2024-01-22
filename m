Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68BBB4E1AD;
	Tue, 23 Jan 2024 01:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971615; cv=none; b=pKlc/vbT9dBYO491i2foQGUGfziVcn/fPufZCBLq/nlsoe22I4z6BIR70zmw2vSYLBp7Nx/5rqxTc6gXdNqT0J2cf15c+0A9ekpQpguxLV2bv6APjVVjThaS38VelKflCtk5ZY9dDuihHJAIgeNSdKwcbtXehKFYBpIENbaWwNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971615; c=relaxed/simple;
	bh=VX3MmpQkC75k6MkhjMp0FUfOFut7nTIlf6omCdnDSUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IOQSEiNk+JLOhm+PCZ8F96hRk2wmFENcXWr7iAas8J6RME9raVkTXn/RkbINUAsakkMsJCTwfitsYdm6ycmCsZTY74ibsMKdrfNcGzO1X7PfHmRVONqtpFGsQ0qJqjAL6wmQWcN2grUqfee7hoKthw6y/L5b8MFsD7QuMSWQJD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a4imNfVq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a4imNfVq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2833AC43390;
	Tue, 23 Jan 2024 01:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971615;
	bh=VX3MmpQkC75k6MkhjMp0FUfOFut7nTIlf6omCdnDSUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a4imNfVq6WHoLOck1mSjYnGfqly07MH6HnNAYTGPj3pzBmInmK2z8Qc6hJZ6dhFCa
	 zfkkG5EU93B75r2SMTWk2u27BU0Wtg48Sn7LlNaKLp/6rliz3HOJyporjZRoNeqHtT
	 0s3YkuIf6Jf+ZYCsk9//Zl5inYoJ4DhLpHDWFgVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 279/417] ALSA: oxygen: Fix right channel of capture volume mixer
Date: Mon, 22 Jan 2024 15:57:27 -0800
Message-ID: <20240122235801.509215654@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


