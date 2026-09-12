Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 806AF2D5C68;
	Sat, 12 Sep 2026 16:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229220; cv=none; b=ptP0fK898bjrjusuChv80tvmLY8R+tiVxP+TlsXP+RDbcs5rpw5yQK1OuJHI6dJn2Lm4yQfyAAJcLXBvcGDs07AtimvkhjUxz6xjF3vWiyAAOVEkQUKTs4PlR9cx4Go9jQ/0QJR5aOigD9NqvpZqyhHJ5h2N4FhguOIkbfBJXc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229220; c=relaxed/simple;
	bh=Ara5xjDvusgEqEJoATPP7RK1xR8H1or4EcBucfKd5O0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dly6v3uYMA9PdlbaIakV29v+cgBiWqiu4mYONUctzKAmPATbXyhxGloz+nf8iTMA1Fpevvy2inPg70Z5u9iQQmwbDs6rGJT98jwaxhbzezA822KEmPYE7fe/lAKRwSU3I2D6UpImve5NcSwGGRyU83cYVnjIsMWfwBmgx0Quk+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=krh0sI/2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="krh0sI/2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14A0D1F000FF;
	Sat, 12 Sep 2026 16:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229216;
	bh=LzkUBxBye87N0AuF9EietG01eJgb3EEzuOzyi4kHyX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=krh0sI/2+7sWv6l5Ls8Zn2Ch/VnN5tdLwTlx9e6LX/CKD9jWVAUX09LTBKsYPFjrn
	 ey3I/IuAuQdQ7F+EAGts3VADBxFFQFBJPp72By40A7po7btzBwWBVkKhudYHu7Lr3y
	 z0CccmZCequWcjn0GCguhW43rSx+KHdrFWlv+8K4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evgenii Burenchev <evg28bur@yandex.ru>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0544/1191] ALSA: via82xx: Remove unreachable branch in snd_via686_pcm_pointer()
Date: Sat, 12 Sep 2026 08:54:32 +0200
Message-ID: <20260912065600.465247603@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ca7f024bf8ec6..473024e7d8ff5 100644
--- a/sound/pci/via82xx_modem.c
+++ b/sound/pci/via82xx_modem.c
@@ -576,24 +576,18 @@ static inline unsigned int calc_linear_pos(struct via82xx_modem *chip,
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



