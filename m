Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056305;
	b=KzPXduF30VGWdFHrDxBPf2+iH0Ney0YfZCQ+vUjmixivi2FfdYJyuzRsvpsPYgAHHI+B
	 s3H9mxYscP94/IlFNE9PGZKgE2Yr10bd8/Whhjvv/ANL9L2P5aZNi9+zygD1JiLe/j55C
	 CRvAWgqOhGqGYSYuNajujjKvAfoPzkMaDU+RLLMU47tchamcIlVWc8VgRRVJTiUNnJLks
	 DLS2jjmkRz1TgbcKgi//q46NoBMCr8oax3581LwMKeEiaj++CdI0ZMG7MxCnqhYk0LLLz
	 ncqE98J0UIWs1QUJoijUZIINzNmNBIxT9gVH76egdX/A7Gb1q07DAW4mZA2eMPw0e+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056305;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=uBsXMBTiTv2Ajq1DzPgXielH1bf336XaelPHLxHFNWc=;
	b=AB2rSwgoVoLJiEnerUdNM3BcqR/Cl1TtUVe33hphFpbeEp1mY9B3KXmtdUS9TDmzy7HR
	 mnlL6k1GU0nlclPwrzvYborK1xpdIFdAz8+nmmRi8pYvFl/pvStWuqlc10dX5Jrb6/j28
	 gqJlQmwo2Mum/d5Y6IY58bz9bTb16cY2NRJShIA+0I6TcUsURbksQRdfIOrvZdlCYN4Xi
	 3KHZSeT8TiZoSoHYu0HRarWJvw002kSyHwUJwurrG3oiVJJrz+fb001tAow/HXZlG81qM
	 60PtpvJTMRbG0WOrjzmAZisH5NhZbtw3Tr85VIN2+mceuZlcT2zi92J1Bejh7OsCL6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TNeYsVpI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78FBC606A320;
	Thu, 19 Nov 2026 02:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TNeYsVpI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D005E1F000C4;
	Thu, 19 Nov 2026 02:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056305;
	bh=uBsXMBTiTv2Ajq1DzPgXielH1bf336XaelPHLxHFNWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TNeYsVpIprMTdeoe0dngjmUib0i1NMwbaOiCrJ56FSGYRoO/F3HSXXgQAecEgErRG
	 2qFAkOSSYMUPHCY51jb8gq5GTR9uxUvg8bZ3hd8ixmsx3scwfTM8T9gmmD7gnxNTHA
	 1W+0ODun3heC/z9vnPEA5SvsP06//+XVr2uQtLew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1903/2214] ALSA: pcm: Fix driver_tstamp value reporting
Date: Wed, 18 Nov 2026 15:59:39 +0100
Message-ID: <20261118150127.269148674@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amadeusz Sławiński <amade@asmblr.net>

[ Upstream commit 8ff1161ac5aa02f3261e00f07d6212be2b12384b ]

In some cases (system32 and compat64) due to incorrect assignment wrong
value is being reported. Fix it.

Fixes: 3ddee7f88aaf ("ALSA: Avoid using timespec for struct snd_pcm_status")
Signed-off-by: Amadeusz Sławiński <amade@asmblr.net>
Link: https://patch.msgid.link/20261013164256.4949-1-amade@asmblr.net
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/pcm_compat.c | 4 ++--
 sound/core/pcm_native.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/core/pcm_compat.c b/sound/core/pcm_compat.c
index 21c6fbb4f8c90..8b74307c68655 100644
--- a/sound/core/pcm_compat.c
+++ b/sound/core/pcm_compat.c
@@ -219,8 +219,8 @@ static int snd_pcm_status_user_compat64(struct snd_pcm_substream *substream,
 		.audio_tstamp_data = status.audio_tstamp_data,
 		.audio_tstamp_sec = status.audio_tstamp_sec,
 		.audio_tstamp_nsec = status.audio_tstamp_nsec,
-		.driver_tstamp_sec = status.audio_tstamp_sec,
-		.driver_tstamp_nsec = status.audio_tstamp_nsec,
+		.driver_tstamp_sec = status.driver_tstamp_sec,
+		.driver_tstamp_nsec = status.driver_tstamp_nsec,
 		.audio_tstamp_accuracy = status.audio_tstamp_accuracy,
 	};
 
diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index c6ae68f35f2f8..fc0ac80e8a7a4 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -1154,8 +1154,8 @@ static int snd_pcm_status_user32(struct snd_pcm_substream *substream,
 		.audio_tstamp_data = status64.audio_tstamp_data,
 		.audio_tstamp_sec = status64.audio_tstamp_sec,
 		.audio_tstamp_nsec = status64.audio_tstamp_nsec,
-		.driver_tstamp_sec = status64.audio_tstamp_sec,
-		.driver_tstamp_nsec = status64.audio_tstamp_nsec,
+		.driver_tstamp_sec = status64.driver_tstamp_sec,
+		.driver_tstamp_nsec = status64.driver_tstamp_nsec,
 		.audio_tstamp_accuracy = status64.audio_tstamp_accuracy,
 	};
 
-- 
2.53.0



