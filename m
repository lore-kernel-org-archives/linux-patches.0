Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B819412BF15;
	Tue, 23 Jan 2024 00:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971403; cv=none; b=OeO3svv1VV3uTAuO4zzBCq87VDfy/+s2FlOUjRAXicgpppqZ5I/04adSrtKwv/S9xmkVz3EtpASUtdJ5r4LxQkQLLAoYciG4/gn3CdgWjq1eP+d0L5Dqufs8Ps7SWwbcZvzVLvM63t+Fb/wFFjlfX7wj+u+b9XEXioIMMY1pAlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971403; c=relaxed/simple;
	bh=I0RU/jxr+pqtF3PMK/2J1Za9EZegSaRCASwOi4nvtSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lPmBbX3hA0AlILGyInm52N8mx3g9AUUXcSShqjNMewYHfpdrbq9Hx82RomZBaRSNRR+gf+w1E0pbE9mdqa4tHPsR74VZzgCagVVy9C5rbZAC5rDWK+Cmku0d6bvfXmsEFFIpKDxA5Q0zJ0xZdaBjHy2N4P4bkGe6eQihuo+TG7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yH13XUA7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yH13XUA7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28930C433C7;
	Tue, 23 Jan 2024 00:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971403;
	bh=I0RU/jxr+pqtF3PMK/2J1Za9EZegSaRCASwOi4nvtSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yH13XUA7BtV6WXmoskLe62Fk0FTGvHUZ4VeiKeV1fbCoQdUURWh/jrACZ9Zeimq27
	 3txbNdm3S5em5K4Pc23tzsvZNwes7ODGwXLCnX2de6UwAwsriyFZRk8boiNjTD0eUu
	 ASYWtuLhgF3FQMICzY2TnBACnv8D+0+KpPGWUeZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 236/417] ALSA: scarlett2: Add clamp() in scarlett2_mixer_ctl_put()
Date: Mon, 22 Jan 2024 15:56:44 -0800
Message-ID: <20240122235800.067279969@linuxfoundation.org>
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

From: Geoffrey D. Bennett <g@b4.vu>

[ Upstream commit 04f8f053252b86c7583895c962d66747ecdc61b7 ]

Ensure the value passed to scarlett2_mixer_ctl_put() is between 0 and
SCARLETT2_MIXER_MAX_VALUE so we don't attempt to access outside
scarlett2_mixer_values[].

Signed-off-by: Geoffrey D. Bennett <g@b4.vu>
Fixes: 9e4d5c1be21f ("ALSA: usb-audio: Scarlett Gen 2 mixer interface")
Link: https://lore.kernel.org/r/3b19fb3da641b587749b85fe1daa1b4e696c0c1b.1703001053.git.g@b4.vu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_scarlett_gen2.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/usb/mixer_scarlett_gen2.c b/sound/usb/mixer_scarlett_gen2.c
index eedac43eee7d..1bcb05c73e0a 100644
--- a/sound/usb/mixer_scarlett_gen2.c
+++ b/sound/usb/mixer_scarlett_gen2.c
@@ -3361,7 +3361,8 @@ static int scarlett2_mixer_ctl_put(struct snd_kcontrol *kctl,
 	mutex_lock(&private->data_mutex);
 
 	oval = private->mix[index];
-	val = ucontrol->value.integer.value[0];
+	val = clamp(ucontrol->value.integer.value[0],
+		    0L, (long)SCARLETT2_MIXER_MAX_VALUE);
 	num_mixer_in = port_count[SCARLETT2_PORT_TYPE_MIX][SCARLETT2_PORT_OUT];
 	mix_num = index / num_mixer_in;
 
-- 
2.43.0



