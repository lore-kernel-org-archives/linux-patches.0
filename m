Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525AA2BDC0E;
	Sat, 12 Sep 2026 07:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197735; cv=none; b=A18vAU1kZSGrSEDWtAjfwqqGcGYkMADNyBhJx18ymQH29b8hS5Y/V3aHBpg3jiWyPMAZP5lI40z52rOjZC3HHsnav+HYxBCQjE0qlE6dxCGu4MTb1aZIDH2mLP69+OEU6ij7Z42nivdwZxKFYAiKFvo3GRT80u328IZn276cQ3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197735; c=relaxed/simple;
	bh=VK7xWLwy+x9EFN8g4QaG1I2xPc3MI7kIvD036pwqOPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I3C7PNGujdP3Z6kLssMAhDgXpNWgTP4DCl8q4SOcDcsFPDub+8Ga/QfZoGC9KBMb+NYvtWJXe7atwq2KJzjkN8DKVd2aJtQzhsVD2vZZ7hHFVW+4n/u+ciER8uviM8Gs11tBOtGUpedoZI3/ct//5kR6gTq6wll8iyYqKrg76hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SCDwW6Ya; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SCDwW6Ya"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 556021F000FF;
	Sat, 12 Sep 2026 07:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197734;
	bh=WYD8VAqBZ48Q0MqHKHkxLiPkYgRDV5mG/E/y/uEhQRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SCDwW6YaliMHS4xqOr2Z4lArU81jPKboKe5V0dB5kdRueHxeiI3qeJPagMAh9qhwR
	 4L643+S/aarbAjPTgNN1yD3aZz5d4BXXvT0hJLWSulEeFdN5WO1WVQF0XvQerbGkwi
	 3A3JhG56kFgMWcdowSysnnMOsPZIoShLON+X8bY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evgenii Burenchev <evg28bur@yandex.ru>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0237/1815] ALSA: via82xx: Remove unreachable branch in snd_via686_pcm_pointer()
Date: Sat, 12 Sep 2026 08:33:07 +0200
Message-ID: <20260912065654.554341771@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Evgenii Burenchev <evg28bur@yandex.ru>

[ Upstream commit cd3447e1b6425efd1704ed07f1f245c842927eb0 ]

The condition

	if (count && size < count)

can never evaluate to true.

The VIA DMA count register is masked with 0x00ffffff before use, while
the DMA buffer size is limited to 0x00fffffe bytes. As a result, 'count'
can never exceed 'size', making the condition permanently false.

This branch has therefore been unreachable since the driver was
introduced. Remove the unreachable branch without changing runtime
behavior.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Evgenii Burenchev <evg28bur@yandex.ru>
Link: https://patch.msgid.link/20260706131638.15311-1-evg28bur@yandex.ru
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/via82xx_modem.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/sound/pci/via82xx_modem.c b/sound/pci/via82xx_modem.c
index 9b84d3fb9eaf5..b32f84ac17cc1 100644
--- a/sound/pci/via82xx_modem.c
+++ b/sound/pci/via82xx_modem.c
@@ -573,24 +573,18 @@ static inline unsigned int calc_linear_pos(struct via82xx_modem *chip,
 		       viadev->bufsize2, viadev->idx_table[idx].offset,
 		       viadev->idx_table[idx].size, count);
 #endif
-		if (count && size < count) {
+		if (! count)
+			/* bogus count 0 on the DMA boundary? */
+			res = viadev->idx_table[idx].offset;
+		else
+			/* count register returns full size
+			 * when end of buffer is reached
+			 */
+			res = viadev->idx_table[idx].offset + size;
+		if (check_invalid_pos(viadev, res)) {
 			dev_dbg(chip->card->dev,
-				"invalid via82xx_cur_ptr, using last valid pointer\n");
+				"invalid via82xx_cur_ptr (2), using last valid pointer\n");
 			res = viadev->lastpos;
-		} else {
-			if (! count)
-				/* bogus count 0 on the DMA boundary? */
-				res = viadev->idx_table[idx].offset;
-			else
-				/* count register returns full size
-				 * when end of buffer is reached
-				 */
-				res = viadev->idx_table[idx].offset + size;
-			if (check_invalid_pos(viadev, res)) {
-				dev_dbg(chip->card->dev,
-					"invalid via82xx_cur_ptr (2), using last valid pointer\n");
-				res = viadev->lastpos;
-			}
 		}
 	}
 	viadev->lastpos = res; /* remember the last position */
-- 
2.53.0



