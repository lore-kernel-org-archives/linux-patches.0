Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E010429A0;
	Wed,  7 May 2025 19:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644606; cv=none; b=URPiU7dFVkrXfjk0zIdTV3SNFTXDuyJ8ulrNuAPyW618SDw7a/AOiQjUx+6l0eDTTFqYOJS7YExJgMcQOkcO8GB418ULaS7Ln8A/twJIbG75Tw7PEugGFnZVcZziWhRNE0ZAp9y1lZu1R+gNvkoRr62SzUNex34Z+Oe0Dt974BU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644606; c=relaxed/simple;
	bh=XAhJjakkOazYlNPtPLslTW1n6NAXueyAD/s/05eRkEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OOwfSbaXzAi+dfFzxZ+KOUGXut5/isiPWmn473ANQBDKBLvUrThFBlFEm/oP9cS24ARPGKVZ5976n2qSBEM5HAnL5seuFlyS/jzi4Fr0J47Em9HkjQ6aFpKkc9M5DbAMeXrQW7969UE8+ie+lgkWSYUPPzJ6/J2YGkc6SNikecI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NBIHH13M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NBIHH13M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02F55C4CEE2;
	Wed,  7 May 2025 19:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644605;
	bh=XAhJjakkOazYlNPtPLslTW1n6NAXueyAD/s/05eRkEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NBIHH13MnyLHmSgdNkC8aKGRpSEwmCaLoLlAKFj34fmN1kVUDP7odFLZvcL4lxeLF
	 mo5rZ5F6T0gVwCYAtI5khQeF09eRpRIlVzVc76zbFFh9vtbdsFGD6sXg3QSNqHb3cZ
	 Aqj4T3Q/j9mfDMx3EkVIYuKrNVa/+xDr3q0GpwCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Argusee <vr@darknavy.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 098/164] ALSA: ump: Fix buffer overflow at UMP SysEx message conversion
Date: Wed,  7 May 2025 20:39:43 +0200
Message-ID: <20250507183824.943555302@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



