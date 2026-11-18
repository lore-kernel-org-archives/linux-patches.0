Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031447;
	b=VXw5LjRkLNoIBfZxD7ajdT6UqYF6aAX02MmRS1O3VQHWrpNStCYH56mffzEvOHtks5fr
	 d77Lq/tIv2hObho0nesnuJVjpFC0Ay53yM5u/DE4jUAkBOiazdQ52NWe8iwNtwDn1lBcv
	 c1izYXHTJDs8jFmyktIA9ulWJi/iz9Je2KTIFATgB0TIf7X6tDJ76fUQM3k0YY71nvUhL
	 qb4sxgu8F0dshSOtoAJBuZ2qXuWMGVT8i/jtlMHHiu9yM/BOsCCg0tvV8dSdzIkjaSPfw
	 GMbyKtmwbdl1OYZYgubStltxMhyArJe6f/9Gv0NlbcILpwvut6HBUS9tmXi+VGzmydg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031447;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D9G0X5+zCiE7btdF2dK1nP99FdkRdDerY7tRNKn4rlo=;
	b=z6p30ynNkSmF1ndyUlI/VZU35Zmbi4/sG45v1s32ihT+9Tbh3PbujrB+YlXebpMG/Lr+
	 63e6kv+yGdk7t+++9R7+Wn61IspNIyafgedQU7E0nuDXfR2J7JuWZ2ghe5oBcVxzPgbP3
	 xeSu8sF7eEkaus0pQK4RO4kA1Wdlaii2xgnqlnW6WRI0DobvmhdzZ9BgGWQN7FnXuWgH0
	 yQP9BGcGsafJwgEelxulbAvyt5KvfwsipMC5ohqi5wIUSJqJTC2HDid7EMAA5SPxsv2qT
	 at6TzREc6Y1h9R+A/FVHqtQIUupePc9AupLtarHfiLlqEKIqr77k52J6nrEhIAdgRQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YL91jc0C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAAB6606A320;
	Wed, 18 Nov 2026 19:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YL91jc0C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E93D81F000C4;
	Wed, 18 Nov 2026 19:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031447;
	bh=D9G0X5+zCiE7btdF2dK1nP99FdkRdDerY7tRNKn4rlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YL91jc0Cb42RyJaQnfzGrw5clhRhvuD8Uy+ZOSTO4ukwkd2LywRpYwyKbSnMTytZ+
	 m0S1/FLaNz/bRH4OJKnctS5Jh4N7zMs5bvtVvoE/K47IPnvyisJQqXx+OrqVigTruT
	 +3oCE0guNmBmS0BRD1AqjiWA8BhrAotRXILi+JiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1019/1756] ALSA: line6: Reject too small max packet sizes
Date: Wed, 18 Nov 2026 15:52:26 +0100
Message-ID: <20261118150050.684006895@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit e2ef553dfe923959632e580bcad8583d922868ac ]

Although the LINE6 driver has a sanity check for the given max packet
sizes, it still has an implicit requirement of the minimal size being
bytes-per-frame; e.g. the impulse test signal assuming the fixed size,
and when a too small size is specified by a malformed USB descriptor,
this may lead to an OOB access.

Change the sanity check conditions to reject too small max packet
sizes for avoiding the scenario above.

Fixes: 3450121997ce ("ALSA: line6: Fix write on zero-sized buffer")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://patch.msgid.link/20261008192553.300025-10-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/line6/pcm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/usb/line6/pcm.c b/sound/usb/line6/pcm.c
index 77d5802872b16..586e38e40b930 100644
--- a/sound/usb/line6/pcm.c
+++ b/sound/usb/line6/pcm.c
@@ -561,7 +561,11 @@ int line6_init_pcm(struct usb_line6 *line6,
 	line6pcm->max_packet_size_out =
 		usb_maxpacket(line6->usbdev,
 			usb_sndisocpipe(line6->usbdev, ep_write));
-	if (!line6pcm->max_packet_size_in || !line6pcm->max_packet_size_out) {
+	/* reject max packet sizes smaller than bytes-per-frame;
+	 * (the magic number 6 is taken from the playback case)
+	 */
+	if (line6pcm->max_packet_size_in < 6 ||
+	    line6pcm->max_packet_size_out < 6) {
 		dev_err(line6pcm->line6->ifcdev,
 			"cannot get proper max packet size\n");
 		return -EINVAL;
-- 
2.53.0



