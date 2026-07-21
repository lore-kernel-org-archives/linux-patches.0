Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C9934189DA;
	Tue, 21 Jul 2026 21:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670795; cv=none; b=K8R4Qk4cuVp5y+m4AHzwW+CA7QaIJQqycHTJ2tr7sb1QOlAh/w23403gFSQEXk43mHUax5pcpUeIbTjzMiGCd4m8s4udy2O0aXvoHCOAm/ktlKXIToHb+q8BuaIdFYFx5dNZ4Eb5HibtqCcqJ/GJRpP2N4mfOJRy3+qfw8da/D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670795; c=relaxed/simple;
	bh=60jWjUMTk/Q5ugfp6oMBpUPJJyRKK9yMCCXzA00+kBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jQsm7mlxnuv2HYnOoApaC+GUlNex5xGFcr88RLSGvfNdV0JWWqdANLE8N+Cmt90U/Ab+Ms00fzHvEI9boaMwRZU5ZFNt3ocumJGrLSMP58eo4OHUkK/F71QF0hXon5bhcZVqEc5BtMyZaJZW8taAlN0F/ewNswc6NASiEkgGOeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Puav7yHe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Puav7yHe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A45311F000E9;
	Tue, 21 Jul 2026 21:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670794;
	bh=NY5QDWU7ehJBgsYPAAhCfxaD1Kybhe4m1SvsR1/GyZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Puav7yHeSrgQ228T1eNr9oAj3fg71MwsFPIaODl4yfIpL+6RFo5vHq/XPi0fDjugY
	 P0HiijQuiA1xbNHAQPfUNlQLEvOpNLswp7hNw6+dym4voiFWvQryxaMDl/r+xIx9dl
	 fPSRBPqhYrBWtssLJSwf363ASMXp5KzjArHsxedM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 1065/1067] ALSA: seq: Check UMP support for midi_version change
Date: Tue, 21 Jul 2026 17:27:46 +0200
Message-ID: <20260721152448.411460766@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
@@ -1329,10 +1329,16 @@ static int snd_seq_ioctl_set_client_info
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


