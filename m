Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E9814F12D;
	Mon,  6 Jan 2025 15:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177959; cv=none; b=qSPXRluTSylb+cZihSBSTubw4Us538/0UHza2mIgclWy2H/uBCg7Z1EQ4Kkf46pcZCBJcnAJuUYaaq7WNfWORyVMJiE1DX+AH5/IMnSCU5N6wmf8WUDue9nMn+H6WyVwxHQjTGiS9roM9WeuKgNyrBuhGqAO1s8ZBSbs9f4YWJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177959; c=relaxed/simple;
	bh=Vmavikv3cBMfdXkiLCpUPzNL8dshj9S62z0ulDR/638=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TQ1IgdXTR64nXAFSLT1DzCD0zWju86KIdHXTUgV9vf34TD9oEHzThcZz5spi/3q17Ee1UyR2ixwhvHyShKPRJy/L93UWpWeULpglFb0pNMli1x7kluHMTA6mSYv3zBuOYvh9sjm6zD+LkUipHgqdOqDQgJAQ+kRcccIY6sw81Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dunj+qYp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dunj+qYp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A876C4CED2;
	Mon,  6 Jan 2025 15:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177959;
	bh=Vmavikv3cBMfdXkiLCpUPzNL8dshj9S62z0ulDR/638=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dunj+qYpOPy60Hj+dKgGCj4OhthDAyvjksDjEfTa8ORWiv1LJJDodW+AoT/fxqJCx
	 IKw71vbfIAwKw7c2tfv9Fm+pgAj4ax/7gvZ3KngwgBgWsR6cBrI9qBJj8++K4eqUyg
	 ym4c+jYxuitDXARc/8xay6n4+aL6GFyAOOwCElO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 113/156] ALSA: seq: Check UMP support for midi_version change
Date: Mon,  6 Jan 2025 16:16:39 +0100
Message-ID: <20250106151145.983023481@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1275,10 +1275,16 @@ static int snd_seq_ioctl_set_client_info
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


