Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D81C2798EA;
	Mon, 23 Mar 2026 15:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278129; cv=none; b=eW0xAoVU3MihLNLn+0d6uFvUT9uPeZ+zQHT0++45ny+BcqM1pzabp7ZdkGGdRbw+atRVWv8m6qXxr6UhEN0G1VpAZnRo3uTLZw9dGWFoowRZAJUK83XfzVhxzd73tZZjIzZcGxN0OfDEBFIlKTjuiEuessxWmOHssJ+Cfk0fJEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278129; c=relaxed/simple;
	bh=aCvOi0Ciulf/jkF2ZgDkTwPwLGjL8rcuEPmV+wVqU1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IcN4dnhqBldGYmy0dtQmJZ4ZeWVloCB6M5vtBhroEPyMHekOMC7+4Z/XeoGtK1ShXYiXKisnaKrbUzhOwSRhZuw0EJ//JP88tKOYG2XYWXLusGrgo0nwpjBGGd3wkAxS9aAZhRTXrI2NXSmaHw3RnYJIDAf5CuLytMcmaouRKT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bMDDLTP5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bMDDLTP5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD40FC4CEF7;
	Mon, 23 Mar 2026 15:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278129;
	bh=aCvOi0Ciulf/jkF2ZgDkTwPwLGjL8rcuEPmV+wVqU1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bMDDLTP5urLctRds/MpL0dH1VaieHdJ7fi9u8SoV1NGol4KFV7WJX1gNnCUWw918N
	 RSZJ2/yz67wwUgqO2rl8CTpYySjp0WU+spSUxBugeBspZ40V8ywW2yP20LWbUlBO19
	 P9qNJJA6j37lkhXUt+5q7QD0OqJVheUTSwaszkqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 210/567] ALSA: usb-audio: Check max frame size for implicit feedback mode, too
Date: Mon, 23 Mar 2026 14:42:10 +0100
Message-ID: <20260323134539.029922041@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 7cb2a5422f5bbdf1cf32eae0eda41000485b9346 ]

When the packet sizes are taken from the capture stream in the
implicit feedback mode, the sizes might be larger than the upper
boundary defined by the descriptor.  As already done for other
transfer modes, we have to cap the sizes accordingly at sending,
otherwise this would lead to an error in USB core at submission of
URBs.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221076
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260225085233.316306-3-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/endpoint.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index 806755a65fc05..f6cef6aaca773 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -224,6 +224,7 @@ int snd_usb_endpoint_next_packet_size(struct snd_usb_endpoint *ep,
 
 	packet = ctx->packet_size[idx];
 	if (packet) {
+		packet = min(packet, ep->maxframesize);
 		if (avail && packet >= avail)
 			return -EAGAIN;
 		return packet;
-- 
2.51.0



