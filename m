Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF1B82488;
	Wed,  7 Aug 2024 15:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043091; cv=none; b=QX+Fv+2Q5cNBOM89y7/5mEc9WgcZ9XnoYougD56k1xgm1bs9koBOuvLwd+3qxw8xS0WvHucEtnbVEN0GwYSlRB1L8XsC7NtuxTo/HtlN6PvsT0I+3L4tdT6CN1LlprzQbgXCyAjUHGY7zUswB/q2RWvAB5Q7Q/nfWHZ8ZExexfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043091; c=relaxed/simple;
	bh=XzKIQ/LcCO2TChKj+rD4o48+mbY53w4kQ1/i6I3gjmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f4cKgHEwH/wcbyas0NxEnrKuQp4z16wLvV7jL64ICIFOYK118HGWo4x30rM+EUyC99dfQwWDAEjQq94JdogkmioAs1cD1NuNOP3P/ooukQNEsh2Fd8I7dQ+oD8/A+xBlx+XWYZevTZvHZKwU/y8E4EX5ErOanxK+V9sT1eqgeSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=an7oErN4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="an7oErN4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61172C32781;
	Wed,  7 Aug 2024 15:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043091;
	bh=XzKIQ/LcCO2TChKj+rD4o48+mbY53w4kQ1/i6I3gjmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=an7oErN4rx6ig+vZdqeaGexTyiPuilfqQFmOfYVdCSc2MWTDiv5/5KbVFD9taaCBw
	 FwJYkprP64lbfmz+XDKaKr7a+UNZqPNX91HV49sOWnxOdE0Wjm7BkyNVUhiQv57mkp
	 JPRJ7LIjQgd1uSQQPTpqQ0zYKNqI8q9gZFgp5aQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.10 087/123] ALSA: seq: ump: Optimize conversions from SysEx to UMP
Date: Wed,  7 Aug 2024 17:00:06 +0200
Message-ID: <20240807150023.625430184@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
 sound/core/seq/seq_ump_convert.c |   37 +++++++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 14 deletions(-)

--- a/sound/core/seq/seq_ump_convert.c
+++ b/sound/core/seq/seq_ump_convert.c
@@ -1192,44 +1192,53 @@ static int cvt_sysex_to_ump(struct snd_s
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
+			offset++;
+			xbuf++;
+		}
+
+		/* if the last of this packet or the 1st byte of the next packet
+		 * is the end-marker, finish the transfer with this packet
+		 */
+		if (len > 0 && len < 8 &&
+		    xbuf[len - 1] == UMP_MIDI1_MSG_SYSEX_END) {
+			if (status == UMP_SYSEX_STATUS_START)
 				status = UMP_SYSEX_STATUS_SINGLE;
-				len--;
-			}
-		} else {
-			if (xbuf[len - 1] == UMP_MIDI1_MSG_SYSEX_END) {
+			else
 				status = UMP_SYSEX_STATUS_END;
-				len--;
-			} else {
-				status = UMP_SYSEX_STATUS_CONTINUE;
-			}
+			len--;
+			finished = true;
 		}
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


