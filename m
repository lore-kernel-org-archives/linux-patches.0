Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AECA3C1967;
	Thu, 15 Jan 2026 17:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499220; cv=none; b=PO0KRS941P+AGo3o8GHOcHFfuV037TIiZ0BugarAGY6NyoNLpKwVnUbXRXfLmdpAry0tmndJEFJvDNovVj3u8/5JbWzwgW/cWnyDNIkb2q3UWAMvCIZJCK8WFuSHPINPAH4mSmCr3FTwlvNgG7We6XVivAU6ZmMaAEvmgruVrHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499220; c=relaxed/simple;
	bh=uwZXg+biHIpVmNDSF5IZAf46+/BIPg7F7Uaa5cEUU4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TVAPvtEINu+xxSMlYbsln5WbND2a7EZt2VLpBHoiN6Gn1nOceXz0Wp2A7XyzA6qeI7CJm5y+gc9QfDUJdSeNZ9a2ZYFE9vdFxm73ZrHyrCeqQaPQjBqvyWNCg1AFy2yOVd5NKbU0TpR9aPR7x98T2mmxESmL41I9k+hORh4BX0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zj7gTcik; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zj7gTcik"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26DDBC116D0;
	Thu, 15 Jan 2026 17:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499220;
	bh=uwZXg+biHIpVmNDSF5IZAf46+/BIPg7F7Uaa5cEUU4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zj7gTcik2oWWGbtQ3RnpDVDxD3VfV3xSeSn03/kvaOcbwQr91Q12Q+eVuYhggX3Tk
	 ffNJCavOR35YejID1hQIEIgwZtwlqy4qZGuJ9whHxWYMwehPJikFzla2Cz47k9QyKW
	 cGQc5iLAGq2DKvTEC4jAX9hNtwt1zQDfBYuW1G4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 150/451] ALSA: dice: fix buffer overflow in detect_stream_formats()
Date: Thu, 15 Jan 2026 17:45:51 +0100
Message-ID: <20260115164236.341394869@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junrui Luo <moonafterrain@outlook.com>

commit 324f3e03e8a85931ce0880654e3c3eb38b0f0bba upstream.

The function detect_stream_formats() reads the stream_count value directly
from a FireWire device without validating it. This can lead to
out-of-bounds writes when a malicious device provides a stream_count value
greater than MAX_STREAMS.

Fix by applying the same validation to both TX and RX stream counts in
detect_stream_formats().

Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Reported-by: Junrui Luo <moonafterrain@outlook.com>
Fixes: 58579c056c1c ("ALSA: dice: use extended protocol to detect available stream formats")
Cc: stable@vger.kernel.org
Reviewed-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Link: https://patch.msgid.link/SYBPR01MB7881B043FC68B4C0DA40B73DAFDCA@SYBPR01MB7881.ausprd01.prod.outlook.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/firewire/dice/dice-extension.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/firewire/dice/dice-extension.c
+++ b/sound/firewire/dice/dice-extension.c
@@ -116,7 +116,7 @@ static int detect_stream_formats(struct
 			break;
 
 		base_offset += EXT_APP_STREAM_ENTRIES;
-		stream_count = be32_to_cpu(reg[0]);
+		stream_count = min_t(unsigned int, be32_to_cpu(reg[0]), MAX_STREAMS);
 		err = read_stream_entries(dice, section_addr, base_offset,
 					  stream_count, mode,
 					  dice->tx_pcm_chs,
@@ -125,7 +125,7 @@ static int detect_stream_formats(struct
 			break;
 
 		base_offset += stream_count * EXT_APP_STREAM_ENTRY_SIZE;
-		stream_count = be32_to_cpu(reg[1]);
+		stream_count = min_t(unsigned int, be32_to_cpu(reg[1]), MAX_STREAMS);
 		err = read_stream_entries(dice, section_addr, base_offset,
 					  stream_count,
 					  mode, dice->rx_pcm_chs,


