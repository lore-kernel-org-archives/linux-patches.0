Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76060E56A;
	Thu, 15 Jan 2026 17:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497781; cv=none; b=QsaeiObGPXsDAXAaUJ26NnM7fQcRh1YEUU/J3KLYpCvGygC469kE82SG+u0zAjP9paajAodVIZuaKq3o8n+5jKki5exskRjJHkk+0LtIUXceh3uJOV4u+HLO0CwAOecqpxrTtzQ3vcyaGtaTuGMRb1h0dd4M/9S47Sck9JdSFcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497781; c=relaxed/simple;
	bh=03h2MOct8p3o3i56P2ZtDda29+cUVjSmQBeOIg4vtJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iAYvwY+cOR4FktxuJ4+bTmdqOq7Vg3SmLTQqK2V+s++xC6m8UxtjSzddB5+sWOchwkX0+Eu8En/noW/bwWd5Zbir7L5xDOt3iOTGWCE8AZRVCeDLAWAKiJ8btCe2TUgAOVtAZy1DB9hq+UrHbR+7JQqAbZmsriwpzhAQz6gdPPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CeLXTchm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CeLXTchm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02302C116D0;
	Thu, 15 Jan 2026 17:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497781;
	bh=03h2MOct8p3o3i56P2ZtDda29+cUVjSmQBeOIg4vtJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CeLXTchmzK/qDrjQLtwRnbtDu5rFi32FwqJwhO2mhrmGxOCa/CIRT5d+4odwb+KW6
	 F4YQiwjcvcmzafCWuubKzW8K626t0kbLWMoX54WdGUUDVfeMBFs7nvLjMchIiFNtRa
	 FuMpryT7i3XPXgurL85o23CD3dF31PjqOfLrlLS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 200/554] ALSA: dice: fix buffer overflow in detect_stream_formats()
Date: Thu, 15 Jan 2026 17:44:26 +0100
Message-ID: <20260115164253.496149131@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


