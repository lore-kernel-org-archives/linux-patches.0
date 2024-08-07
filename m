Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4F9823C8;
	Wed,  7 Aug 2024 15:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043471; cv=none; b=SEuWlGGEUKlhHSVQyBeurY7pcZipajVmmNHuCUQ9RhXmf8/rNFhWEQDZpqe5hRndBm0SgIpsLr7NXtKHGz5Ok4o0J3sFnAcF6YeAQWGMcLrEy2vYQs+XMIQvfJWXgPhDpLTNVMuWjXgIOYX8c250QwDq08CAUF86hSsC5vM/J7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043471; c=relaxed/simple;
	bh=G06TGvjCcgZfW9AZUSfvmPfRZRF370kj/LbwOQOakMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gNE/onkcnXrsymylfvqEUuDYcnDRV23XJbgF9jWKmMBkb9Y4LF3Pg6REkLklyXm0J8XUfWCDllpHziD4yMXH5LO02heuHrTodvaOXC1dcNVHVm5y+iFhuAWpzEp1DPnUVhpB6U6QT7st5P9l0s5AayxeRiQdx90RONz2KkpIDM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aRiZG77V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aRiZG77V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 444C6C32781;
	Wed,  7 Aug 2024 15:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043471;
	bh=G06TGvjCcgZfW9AZUSfvmPfRZRF370kj/LbwOQOakMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aRiZG77V3j5ObHp4Hln/kWqTozLkERXE8eFOgwXc2eJCllZjoqzorN+3SFlLSMGH9
	 hUutVIyYUdI/6Lq6vfJ2aOE+inWIs8z7NEz6zBffmI4sIuKdxl6d/IilPhHVtrJ1nw
	 HwNiT4IO/a1IcAuhrAtspCu0HOAYBTTvznGPneWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 103/121] ALSA: seq: ump: Optimize conversions from SysEx to UMP
Date: Wed,  7 Aug 2024 17:00:35 +0200
Message-ID: <20240807150022.769510978@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
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

commit 952b13c215234855d75ef4b5bb0138075e73677c upstream.

The current conversion from the legacy SysEx event to UMP SysEx packet
in the sequencer core has a couple of issues:

* The first packet trims the SysEx start byte (0xf0), hence it
  contains only 5 bytes instead of 6.  This isn't wrong, per
  specification, but it's strange not to fill 6 bytes.

* When the SysEx end marker (0xf7) is placed at the first byte of the
  next packet, it'll end up with an empty data just with the END
  status.  It can be rather folded into the previous packet with the
  END status.

This patch tries to address those issues.  The first packet may have 6
bytes even with the SysEx start, and an empty packet with the SysEx
end marker is omitted.

Fixes: e9e02819a98a ("ALSA: seq: Automatic conversion of UMP events")
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240726143455.3254-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/seq/seq_ump_convert.c | 41 +++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 16 deletions(-)

diff --git a/sound/core/seq/seq_ump_convert.c b/sound/core/seq/seq_ump_convert.c
index e90b27a135e6..d9dacfbe4a9a 100644
--- a/sound/core/seq/seq_ump_convert.c
+++ b/sound/core/seq/seq_ump_convert.c
@@ -1192,44 +1192,53 @@ static int cvt_sysex_to_ump(struct snd_seq_client *dest,
 {
 	struct snd_seq_ump_event ev_cvt;
 	unsigned char status;
-	u8 buf[6], *xbuf;
+	u8 buf[8], *xbuf;
 	int offset = 0;
 	int len, err;
+	bool finished = false;
 
 	if (!snd_seq_ev_is_variable(event))
 		return 0;
 
 	setup_ump_event(&ev_cvt, event);
-	for (;;) {
+	while (!finished) {
 		len = snd_seq_expand_var_event_at(event, sizeof(buf), buf, offset);
 		if (len <= 0)
 			break;
-		if (WARN_ON(len > 6))
+		if (WARN_ON(len > sizeof(buf)))
 			break;
-		offset += len;
+
 		xbuf = buf;
+		status = UMP_SYSEX_STATUS_CONTINUE;
+		/* truncate the sysex start-marker */
 		if (*xbuf == UMP_MIDI1_MSG_SYSEX_START) {
 			status = UMP_SYSEX_STATUS_START;
-			xbuf++;
 			len--;
-			if (len > 0 && xbuf[len - 1] == UMP_MIDI1_MSG_SYSEX_END) {
-				status = UMP_SYSEX_STATUS_SINGLE;
-				len--;
-			}
-		} else {
-			if (xbuf[len - 1] == UMP_MIDI1_MSG_SYSEX_END) {
-				status = UMP_SYSEX_STATUS_END;
-				len--;
-			} else {
-				status = UMP_SYSEX_STATUS_CONTINUE;
-			}
+			offset++;
+			xbuf++;
 		}
+
+		/* if the last of this packet or the 1st byte of the next packet
+		 * is the end-marker, finish the transfer with this packet
+		 */
+		if (len > 0 && len < 8 &&
+		    xbuf[len - 1] == UMP_MIDI1_MSG_SYSEX_END) {
+			if (status == UMP_SYSEX_STATUS_START)
+				status = UMP_SYSEX_STATUS_SINGLE;
+			else
+				status = UMP_SYSEX_STATUS_END;
+			len--;
+			finished = true;
+		}
+
+		len = min(len, 6);
 		fill_sysex7_ump(dest_port, ev_cvt.ump, status, xbuf, len);
 		err = __snd_seq_deliver_single_event(dest, dest_port,
 						     (struct snd_seq_event *)&ev_cvt,
 						     atomic, hop);
 		if (err < 0)
 			return err;
+		offset += len;
 	}
 	return 0;
 }
-- 
2.46.0



