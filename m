Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE5F1A704B;
	Sun,  7 Sep 2025 20:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277468; cv=none; b=iT3ubJP2yXPykhbs4SxfayRsFnU5RPCr4xpoaauNErNBhhTnlJ4nU0q8gWcwLfWzHhoAhNlGe5m8IIdftqwGzlQkrlDuxXK1AbpLTfHBkorR5Tsyib3SHkd3q7jichwIBkgqAFMqUWew0+87flisColZbPMLEI+L4IHgmwCHSic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277468; c=relaxed/simple;
	bh=AkAIJB0Mk2213+xXBKJp1TVdBjt62tE76v3LylNl7xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XsqypGcCL9xQB1WBv9ZzKL9tOeQ3EK6EtdzB/CXc7GpmEIs975xpb3Bs1tZCybAr9FE3RJD4hQaFiW+1uEGKnKSVLFtIFIdy/IBgI67YcWVr7Vp0AQLs9nn83QyBVzRt8YSQZAw6/PN94V6hdBpVCbnW7QcqUFVQIIRWKEUDhEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IQKAiajR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IQKAiajR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3977C4CEF0;
	Sun,  7 Sep 2025 20:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277468;
	bh=AkAIJB0Mk2213+xXBKJp1TVdBjt62tE76v3LylNl7xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IQKAiajRCbIkWZbMoWPKPVpyRHB06srZJXoptYRkxIq1IjCcs9XZBxJyw99zj6RUN
	 Q2TSBXxW7YekKeq13NhzxwSgGuP25YxrAK2ocNqK1/olwKEQiHs4dBhdMj0wziiWA7
	 GWphnDN1xTTYmn0P5PUAXkNlzzMOFuuCnyXs7hKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tina Wuest <tina@wuest.me>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 007/183] ALSA: usb-audio: Allow Focusrite devices to use low samplerates
Date: Sun,  7 Sep 2025 21:57:14 +0200
Message-ID: <20250907195615.972586564@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tina Wuest <tina@wuest.me>

[ Upstream commit cc8e91054c0a778074ecffaf12bd0944e884d71c ]

Commit 05f254a6369ac020fc0382a7cbd3ef64ad997c92 ("ALSA: usb-audio:
Improve filtering of sample rates on Focusrite devices") changed the
check for max_rate in a way which was overly restrictive, forcing
devices to use very high samplerates if they support them, despite
support existing for lower rates as well.

This maintains the intended outcome (ensuring samplerates selected are
supported) while allowing devices with higher maximum samplerates to be
opened at all supported samplerates.

This patch was tested with a Clarett+ 8Pre USB

Fixes: 05f254a6369a ("ALSA: usb-audio: Improve filtering of sample rates on Focusrite devices")
Signed-off-by: Tina Wuest <tina@wuest.me>
Link: https://patch.msgid.link/20250901092024.140993-1-tina@wuest.me
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/format.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/sound/usb/format.c b/sound/usb/format.c
index 0ee532acbb603..ec95a063beb10 100644
--- a/sound/usb/format.c
+++ b/sound/usb/format.c
@@ -327,12 +327,16 @@ static bool focusrite_valid_sample_rate(struct snd_usb_audio *chip,
 		max_rate = combine_quad(&fmt[6]);
 
 		switch (max_rate) {
+		case 192000:
+			if (rate == 176400 || rate == 192000)
+				return true;
+			fallthrough;
+		case 96000:
+			if (rate == 88200 || rate == 96000)
+				return true;
+			fallthrough;
 		case 48000:
 			return (rate == 44100 || rate == 48000);
-		case 96000:
-			return (rate == 88200 || rate == 96000);
-		case 192000:
-			return (rate == 176400 || rate == 192000);
 		default:
 			usb_audio_info(chip,
 				"%u:%d : unexpected max rate: %u\n",
-- 
2.50.1



