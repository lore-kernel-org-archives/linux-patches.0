Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8393E3AA4F9;
	Tue, 21 Jul 2026 22:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673011; cv=none; b=BTtY7kWJ1TMzzLuO/qwH9bM7NuETt++vCMwQJeO8z20fNzFfHPBPmFy2OkNpbfKYOF8dVhEkrE6zFiPigLKfugkDKiRVeOKR31eq8NZtK1O+k56LUTLIU2qvnjqX5Muo1CxokTOZQPFs77erhBgBZ6tb7q1IFQ4kNiei46PTaX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673011; c=relaxed/simple;
	bh=xRisEr2muCNQBkkdxCdM9OiHdmdLti2ApxP9EgyRMUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jSIvWu4CobV5vwil+vVsf0JNWMbBGDFq25+KAZEEADEZ7meKqzemDH+eLS76KdTIktseqw6UTnxwpDCHDqhQs/AUXegktTeCDP0uhgCtXNg9W0JfWGdJKhuH9N1IL3MpaDolgd1tta88hC8e0sIvKcoCjZ/2ml4N4fB3qEEKV5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DJ651NZc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DJ651NZc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA55F1F000E9;
	Tue, 21 Jul 2026 22:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673010;
	bh=2qtO2ZuM/vMzKvZO9zIl1nSmhOoPw5obXhnVNsVjsAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DJ651NZcwbwiTB3nIzCrzG8o50rCpOEWAC1dGu0g1XPKvGdCxt9rhVblP6zsQhv8x
	 eE5xcAfyX7R1MYHSVqKdKWvrm7ieyYYzUzoSy+aBSWD1cTpC14CUbB0FcCCehheZTb
	 Jhly9ft2w/rI51uTVM7qWHGS6wTfts+rGa1ZlcPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 841/843] ALSA: seq: Check UMP support for midi_version change
Date: Tue, 21 Jul 2026 17:27:56 +0200
Message-ID: <20260721152424.996517108@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

commit 8765429279e7d3d68d39ace5f84af2815174bb1e upstream.

When the kernel is built without UMP support but a user-space app
requires the midi_version > 0, the kernel should return an error.
Otherwise user-space assumes as if it were possible to deal,
eventually hitting serious errors later.

Fixes: 46397622a3fa ("ALSA: seq: Add UMP support")
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20241231145358.21946-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/seq/seq_clientmgr.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/sound/core/seq/seq_clientmgr.c
+++ b/sound/core/seq/seq_clientmgr.c
@@ -1330,10 +1330,16 @@ static int snd_seq_ioctl_set_client_info
 	if (client->type != client_info->type)
 		return -EINVAL;
 
-	/* check validity of midi_version field */
-	if (client->user_pversion >= SNDRV_PROTOCOL_VERSION(1, 0, 3) &&
-	    client_info->midi_version > SNDRV_SEQ_CLIENT_UMP_MIDI_2_0)
-		return -EINVAL;
+	if (client->user_pversion >= SNDRV_PROTOCOL_VERSION(1, 0, 3)) {
+		/* check validity of midi_version field */
+		if (client_info->midi_version > SNDRV_SEQ_CLIENT_UMP_MIDI_2_0)
+			return -EINVAL;
+
+		/* check if UMP is supported in kernel */
+		if (!IS_ENABLED(CONFIG_SND_SEQ_UMP) &&
+		    client_info->midi_version > 0)
+			return -EINVAL;
+	}
 
 	/* fill the info fields */
 	if (client_info->name[0])


