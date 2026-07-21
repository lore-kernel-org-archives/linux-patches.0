Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E39471248;
	Tue, 21 Jul 2026 18:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657559; cv=none; b=BFspxu2M4Sumk8jrFdLBp00kVRX4fs0caV17O9G4stAhUoQqUXkpjApwKMlqiEbRbVTB/wESSAQbG/3M6AMTAnMdBBCSFttCjiwb2C9vEy91SwleN9XO5e0AcT0lihQ9aVe1sX2D3WeMmHF44fX4XNpqR7UT9+hYIK+yemEBQTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657559; c=relaxed/simple;
	bh=W0jkSP8jdy1uuI6++pW4eJfSFRIB5X0Ju6d95GDcx2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jm6xQvkkTOx7+mI9N9jstIKSsyIrEUhmA8StsoCptXQXjJqkCwBAYbg64Dp1sR8mnThsRlpZvrnRDYPymeg/RxV5Gr7A0d0bKQWgaw3vMt1BeVaV6PSXogRpcfpYUykjCkQ63xcC8gg3eZcAz4FB5CBCn0wVOmo+HkoULomp4IA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1GLRWJxB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1GLRWJxB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8901E1F000E9;
	Tue, 21 Jul 2026 18:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657558;
	bh=uelndBhjKzPuB7AYakgeapVPljOff9x0vFn5DSvdp+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1GLRWJxBgz9glo1u2hlf9b8enAILueCszLMXH9vPhu76W+XfAQkQP4FcpEe6GLuq/
	 tq2THv8YIwgr7Xf+tiS1jI0Hf67WGnaWaf1qR/tSWDj9m3Rkavt+i6gwTeBwMnZzkE
	 8Ei9KDDz1HOrT4t0hW8eolBEk/zSz8MJzeqttrgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0810/1611] ALSA: usb-audio: qcom: clear opened when stream enable fails
Date: Tue, 21 Jul 2026 17:15:26 +0200
Message-ID: <20260721152533.607325280@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

[ Upstream commit 3c7af07943b2718087ae791cad450af5cf646d90 ]

On enable, subs->opened is set before the service_interval is validated;
an invalid interval jumps to the response label without clearing it, so
the substream is wedged at -EBUSY until a disable or disconnect.

Clear subs->opened on the enable error path.

Fixes: 326bbc348298a ("ALSA: usb-audio: qcom: Introduce QC USB SND offloading support")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Link: https://patch.msgid.link/20260618025126.1862954-3-michael.bommarito@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/qcom/qc_audio_offload.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/sound/usb/qcom/qc_audio_offload.c b/sound/usb/qcom/qc_audio_offload.c
index 09a699649f8d7a..da2759f2ee8665 100644
--- a/sound/usb/qcom/qc_audio_offload.c
+++ b/sound/usb/qcom/qc_audio_offload.c
@@ -1626,8 +1626,13 @@ static void handle_uaudio_stream_req(struct qmi_handle *handle,
 	if (req_msg->service_interval_valid) {
 		ret = get_data_interval_from_si(subs,
 						req_msg->service_interval);
-		if (ret == -EINVAL)
+		if (ret == -EINVAL) {
+			if (req_msg->enable) {
+				guard(mutex)(&chip->mutex);
+				subs->opened = 0;
+			}
 			goto response;
+		}
 
 		datainterval = ret;
 	}
-- 
2.53.0



