Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E812443E;
	Tue, 23 Jan 2024 00:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969619; cv=none; b=UObq97Jj5ayxqq3aahefXsYmkIKbz8nW8aGQ+FE01ZnLwlqeGHyzdyXbJI6JSYlK/h0ZLpiqS44or9PxWF7+g0t+XFIuC/LLMv00fSsEzgDh7et1o2GI4gsdRtBdlWInsV2Qr7FA/fn7bLbrlEtW4eSA2U0htI4BG55tc32JW0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969619; c=relaxed/simple;
	bh=umJuhacjH/wP7sqlmW+XLK+BIXOvDbEQ1PUK/eUo9Y0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PwkkvMyuFgp9R4ZvEgwQUkoaLLjEjslwowH86cLB2Q6M0mDjwj83IvD/7aXiHNqFw2vzopRNSi107LFHXR5migmlE1G/hbyF90k7CVUnwnYDgXWDvYNv4UKRnDeFmIjJ56tguLt+/F/m8WCRI5VX2UadSz1ho2AEO/Zpsc/SqGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XkLJhTIS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XkLJhTIS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E77BC43390;
	Tue, 23 Jan 2024 00:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969619;
	bh=umJuhacjH/wP7sqlmW+XLK+BIXOvDbEQ1PUK/eUo9Y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XkLJhTISu6IUvWxkfECOPfZOlE+ljb4dzrvcd0AtO2qVA/npv5ybXjRoqJnvu8p0F
	 OwKLxmNBW74HipmhP8VXvEZQls7iSo+7wb8p1bxSbAQr1KWOqTLMcpoyPsX+BUV0FR
	 ue4SHGopyQ0ifbvNtBDK27+ZFf4NpzbdNzBOK5ts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 361/641] ALSA: scarlett2: Add clamp() in scarlett2_mixer_ctl_put()
Date: Mon, 22 Jan 2024 15:54:25 -0800
Message-ID: <20240122235829.228292218@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
 sound/usb/mixer_scarlett2.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/usb/mixer_scarlett2.c b/sound/usb/mixer_scarlett2.c
index f4351900fbbd..cdaf0470e62b 100644
--- a/sound/usb/mixer_scarlett2.c
+++ b/sound/usb/mixer_scarlett2.c
@@ -3663,7 +3663,8 @@ static int scarlett2_mixer_ctl_put(struct snd_kcontrol *kctl,
 	mutex_lock(&private->data_mutex);
 
 	oval = private->mix[index];
-	val = ucontrol->value.integer.value[0];
+	val = clamp(ucontrol->value.integer.value[0],
+		    0L, (long)SCARLETT2_MIXER_MAX_VALUE);
 	num_mixer_in = port_count[SCARLETT2_PORT_TYPE_MIX][SCARLETT2_PORT_OUT];
 	mix_num = index / num_mixer_in;
 
-- 
2.43.0



