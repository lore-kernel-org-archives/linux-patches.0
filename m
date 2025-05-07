Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 708F62144C1;
	Wed,  7 May 2025 19:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746645039; cv=none; b=VlvbOpdfV8bJOhC1yKxYqVdOvL9pp19Q+8AyEP48C2Z1xWOULdGXu8nL89Dx7jRpyIMd7kL3K0pZxdkd/Q3aDFgU0hqDPmFPfwjG+wL8YQo3wDOz15yqrJ6Hm580CM+uOf+mEDHKHB1a9ymDqm494aHIjSwBr9ZkMOsR+TA+D2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746645039; c=relaxed/simple;
	bh=A6fc5Uv5Ctv3dCj7SxNESX+w0cbbVJlX1qdK209XW/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cum454npexcHeG5VNKJsHQ4WsUKdtds4dHV8VNUBTCFg8iT/mkhRnVEpLUn6s91XuZPmOBVKcvaggJ/S6MwjydpEzHInR44NMtqB67B5J4NHlLGS2cpW0SlW+1hrRuV+jdgegJYn5zPoysnZ5JLLwWnPIg8Bj2iN2arocrrf45Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zYf2Hlq+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zYf2Hlq+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF578C4CEE2;
	Wed,  7 May 2025 19:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746645039;
	bh=A6fc5Uv5Ctv3dCj7SxNESX+w0cbbVJlX1qdK209XW/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zYf2Hlq+zglX9JsODqhA8SeOg56uxt3Qc0Z6z34HWecI9RrrOS2RIH6JlvS8ssZgC
	 Ff8N6o13OL8QOU9ubsSKSab9HwO+hYXl6N9/g7MXQNST/g4OF8PkmGY8CMQ0GlcJBl
	 1kVrQRPpDpuLhADDmi090NPtu8FL0o3TQCqGbJ7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Argusee <vr@darknavy.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 073/129] ALSA: ump: Fix buffer overflow at UMP SysEx message conversion
Date: Wed,  7 May 2025 20:40:09 +0200
Message-ID: <20250507183816.477602108@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 56f1f30e6795b890463d9b20b11e576adf5a2f77 ]

The conversion function from MIDI 1.0 to UMP packet contains an
internal buffer to keep the incoming MIDI bytes, and its size is 4, as
it was supposed to be the max size for a MIDI1 UMP packet data.
However, the implementation overlooked that SysEx is handled in a
different format, and it can be up to 6 bytes, as found in
do_convert_to_ump().  It leads eventually to a buffer overflow, and
may corrupt the memory when a longer SysEx message is received.

The fix is simply to extend the buffer size to 6 to fit with the SysEx
UMP message.

Fixes: 0b5288f5fe63 ("ALSA: ump: Add legacy raw MIDI support")
Reported-by: Argusee <vr@darknavy.com>
Link: https://patch.msgid.link/20250429124845.25128-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/ump_convert.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/sound/ump_convert.h b/include/sound/ump_convert.h
index d099ae27f8491..682499b871eac 100644
--- a/include/sound/ump_convert.h
+++ b/include/sound/ump_convert.h
@@ -19,7 +19,7 @@ struct ump_cvt_to_ump_bank {
 /* context for converting from MIDI1 byte stream to UMP packet */
 struct ump_cvt_to_ump {
 	/* MIDI1 intermediate buffer */
-	unsigned char buf[4];
+	unsigned char buf[6]; /* up to 6 bytes for SysEx */
 	int len;
 	int cmd_bytes;
 
-- 
2.39.5



