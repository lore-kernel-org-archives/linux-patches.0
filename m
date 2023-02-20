Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6272B63B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:42:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC986C433D2;
	Mon, 20 Feb 2023 13:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676900553;
	bh=MEpeniDZwoSaV2xAjDmu2ZkFj1SCvu4vIGyWhgcp/Y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MlyTeGzhMWFbv0aLJ5ZMCgH6/AVsCxLU0LfOxMlvOnHS8zhlc8I01pwHXBuHFwLYt
	 y18iI/RFhuOmnjk5AvuBhFT9A7twbBMDHyVFvwaJRd7LCGZUgPsgk5nyH8uAS82j0b
	 SMRQVDPa8RjMeI/+zLZNBX+8PsOeqU/jXe828GcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 51/89] ALSA: pci: lx6464es: fix a debug loop
Date: Mon, 20 Feb 2023 14:35:50 +0100
Message-Id: <20230220133554.923679420@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.066768704@linuxfoundation.org>
References: <20230220133553.066768704@linuxfoundation.org>
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
index a80684bdc30d6..46f5362096710 100644
--- a/sound/pci/lx6464es/lx_core.c
+++ b/sound/pci/lx6464es/lx_core.c
@@ -508,12 +508,11 @@ int lx_buffer_ask(struct lx6464es *chip, u32 pipe, int is_capture,
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



