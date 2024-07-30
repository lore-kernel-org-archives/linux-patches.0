Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40581E86F;
	Tue, 30 Jul 2024 17:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358999; cv=none; b=PowH0vrg6EXfGCvzOZWt/TvEFCxC+QhiIcyHHCRmPYPIsGU42KhycI/lEKrOKsmRYxsrE0dkGkQqcQxhvAKpaUz6XkncqnFEGEoa93996LWfcSStljaLbNckn/a8S7MLwoEm67fa54kApNQ3k9ty9JCMEEREwOw92tHEOMnHSDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358999; c=relaxed/simple;
	bh=BMJcrvZcLoz5LDjL3ObNBVzCGnDmcbMw89nPI+mEp7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nM+CbS8bvLZFJM6tdPG9OjxxutdLAooU+7kfYhKC2FRKo3XZV7N0nbP/Ilc53aRVeKVZ9gW7ixcabmjdzfpxhm1LXhBZH+0ms0yt5rjh2VED5aCCShCgUIjNomFg0ijWVGJpZB8Ee3YiXgnBjjS8ODRRHcKeSkP0cGV/Yd5l9rA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TDN7Tt+p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TDN7Tt+p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2162BC4AF0C;
	Tue, 30 Jul 2024 17:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358999;
	bh=BMJcrvZcLoz5LDjL3ObNBVzCGnDmcbMw89nPI+mEp7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TDN7Tt+pJX7bvHzISwRvqVU5WdIiyXW0fQkcFMCiGH0ixmw3F3lPurJl51MQB4Q8v
	 GhYi+J9XXBabgHmLlKjQi8OSNncQJ1V0KcBOyuBVv1vnpbeQVR550lyotSTjSJqfpg
	 flCZYn6SsjQwuI5YLrLMw/SfurIQn6aR+Nj7NoJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 418/568] ALSA: ump: Force 1 Group for MIDI1 FBs
Date: Tue, 30 Jul 2024 17:48:45 +0200
Message-ID: <20240730151656.208622815@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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
 sound/core/ump.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/sound/core/ump.c b/sound/core/ump.c
index b325fcfa77d0..0f0d7e895c5a 100644
--- a/sound/core/ump.c
+++ b/sound/core/ump.c
@@ -733,6 +733,12 @@ static void fill_fb_info(struct snd_ump_endpoint *ump,
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
-- 
2.45.2



