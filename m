Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DF48F58
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 15:05:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11FE0C433EF;
	Mon, 13 Feb 2023 15:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300723;
	bh=zAydcrZKWG64h1wx0RKWbtLiME/t1tx+JzBHRr4t8FM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i0hDx4L8qf5+lEvLn3VOIj33pWvakQSR8sWkkHFEi5p5avtmHPrs6XAc+ch1oe22i
	 h3aMmzFWTXihFFl0IbP+MKTBZ1i9lWj2clcF5MhhkkvV60r3CL74nKiwSU0g/SeuK7
	 Mdg3fKNoKPSB0PuxpJT/TIwUJq/SNnqP9yVsRJCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 123/139] ALSA: pci: lx6464es: fix a debug loop
Date: Mon, 13 Feb 2023 15:51:08 +0100
Message-Id: <20230213144752.416216181@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144745.696901179@linuxfoundation.org>
References: <20230213144745.696901179@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit 5dac9f8dc25fefd9d928b98f6477ff3daefd73e3 ]

This loop accidentally reuses the "i" iterator for both the inside and
the outside loop.  The value of MAX_STREAM_BUFFER is 5.  I believe that
chip->rmh.stat_len is in the 2-12 range.  If the value of .stat_len is
4 or more then it will loop exactly one time, but if it's less then it
is a forever loop.

It looks like it was supposed to combined into one loop where
conditions are checked.

Fixes: 8e6320064c33 ("ALSA: lx_core: Remove useless #if 0 .. #endif")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Link: https://lore.kernel.org/r/Y9jnJTis/mRFJAQp@kili
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/lx6464es/lx_core.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/sound/pci/lx6464es/lx_core.c b/sound/pci/lx6464es/lx_core.c
index f884f5a6a61c2..a49a3254f9677 100644
--- a/sound/pci/lx6464es/lx_core.c
+++ b/sound/pci/lx6464es/lx_core.c
@@ -493,12 +493,11 @@ int lx_buffer_ask(struct lx6464es *chip, u32 pipe, int is_capture,
 		dev_dbg(chip->card->dev,
 			"CMD_08_ASK_BUFFERS: needed %d, freed %d\n",
 			    *r_needed, *r_freed);
-		for (i = 0; i < MAX_STREAM_BUFFER; ++i) {
-			for (i = 0; i != chip->rmh.stat_len; ++i)
-				dev_dbg(chip->card->dev,
-					"  stat[%d]: %x, %x\n", i,
-					    chip->rmh.stat[i],
-					    chip->rmh.stat[i] & MASK_DATA_SIZE);
+		for (i = 0; i < MAX_STREAM_BUFFER && i < chip->rmh.stat_len;
+		     ++i) {
+			dev_dbg(chip->card->dev, "  stat[%d]: %x, %x\n", i,
+				chip->rmh.stat[i],
+				chip->rmh.stat[i] & MASK_DATA_SIZE);
 		}
 	}
 
-- 
2.39.0



