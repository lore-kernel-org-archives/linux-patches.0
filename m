Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACCCB1A76A1;
	Tue, 30 Jul 2024 17:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360308; cv=none; b=MY+lNU9516wmQJoEK+6LK75zQymEtQT09DPEItq/XnYVrg2VLoRBzWfNB2KZNo2HFYdpPfMCbwXchLP6ToSrKyQCLwMzfPmLjt5lvxYb1jo98V3iRIUUOGOm6D3y9eMRwEEHaI1lFEzvYg7A+JQkqiSPf9u1R7Z6+yUl8zgbIM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360308; c=relaxed/simple;
	bh=mVZM4FU0g0slzbK+0cBwkQ+ntw2uFRBqUAYVPOoB6Zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P5i9b6TUVqUkOVbq/YPtbkQYZPzYtiEdiGnpIjz+5V1hEeYwAtCY/ap1XvJE0fpdl+n9WVpQkqI2YiLaOsd8yWM9G2XsQDcmFIYbEj08brvcFWk5T+ET5T0+pyI+tUGuJ7LRmn4Kg3iiYpZXV7R3IcoY8QrwvM+pV3g6NHLD2G4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ha4xp7y2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ha4xp7y2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F8D5C4AF0F;
	Tue, 30 Jul 2024 17:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360308;
	bh=mVZM4FU0g0slzbK+0cBwkQ+ntw2uFRBqUAYVPOoB6Zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ha4xp7y2r08V7wnjJAtVhZl+H6O7NRZwhSx6QzpDDhpJ0UKtOPry3DP/bvWDjCZf1
	 vOFu95NS3UYChH3q+N15Hf0VGvKYXLx3brTQoWMt7l/2vHrCsVJ5eAlZUwwUvUyCVq
	 mCxoGzBDyTd26cPsctj3v7cd451Qiwt9rs+heRvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.10 628/809] ALSA: ump: Force 1 Group for MIDI1 FBs
Date: Tue, 30 Jul 2024 17:48:24 +0200
Message-ID: <20240730151749.647812168@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit ac29d8ae05b770ed3f52d7a60908ab9b126f69d7 upstream.

When a Function Block declares it being a legacy MIDI1 device, it has
to be only with a single UMP Group.  Correct the attribute when a
device declares it wrongly.

Fixes: 37e0e14128e0 ("ALSA: ump: Support UMP Endpoint and Function Block parsing")
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240722140610.10845-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/ump.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/sound/core/ump.c
+++ b/sound/core/ump.c
@@ -733,6 +733,12 @@ static void fill_fb_info(struct snd_ump_
 		info->block_id, info->direction, info->active,
 		info->first_group, info->num_groups, info->midi_ci_version,
 		info->sysex8_streams, info->flags);
+
+	if ((info->flags & SNDRV_UMP_BLOCK_IS_MIDI1) && info->num_groups != 1) {
+		info->num_groups = 1;
+		ump_dbg(ump, "FB %d: corrected groups to 1 for MIDI1\n",
+			info->block_id);
+	}
 }
 
 /* check whether the FB info gets updated by the current message */


