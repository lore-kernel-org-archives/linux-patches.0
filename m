Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050439;
	b=RISHrvgwL7H27bfoO/S8Yd3DX+ShBFGCZASjYuafvrz5HZX0dTWqe1QwJw4U9k/FWQ+4
	 H1XU1LAkCefLnW0uqZsO8Svlgzb3E4TXXm1kHb1O39qIteSSOedO572GqRgQ+uCgSGEj7
	 nacjRSiJtKmq9IHr43tLvOKYLQMOrteQKQTUM5L7Cw2AHXVQP56pzPsdrPb2Jui6bbyp/
	 FIidSN9An55TCGW9FWLpfWhmW+topkjHst82BkMJFEL2SVC+SqjOga6C5RHv4TslJkpC0
	 munMW75D81W41Y4dZC15DY6SSlO4RNABgEBF67X937YfHsWFiekvjKVnM/SttjfpUWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050439;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BN/uw40KJqao8v/1jhDCKWJ2DhZi0+4SxSPHBplmGNU=;
	b=qMmWy86cR8TslQVAnCXHNPKhRn9sBu/MfMFZ6aTzjtgBkIc1GfexG+z/Kd3BLhaaTZgT
	 QEhGGLEtUNEd4GfrHlLEw+gFOFxboILHMH6cGSPBtTKEkdh5CRPkiZuF9mKhpe6JEkGhW
	 yKqaPY6ltAi5voIDPAgwxzEIGajf96KuNCWP1gi2YWSbDg2JOe2tD/MnnwwPHdmcT9G41
	 bFpGBZQDqgiOxCpq1PBcRUKNCsNtM96KlPt9na4w9liFjY7XY+xeRrsoozpjmB6c0ewPY
	 2BtMUe3IzMVg5GtmMnUbMxlXBH4cp1fOu04iz1Zkcfq1E573aMhjR256LRZTzkHp1Ug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=axyprkIA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E292606A31C;
	Thu, 19 Nov 2026 01:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=axyprkIA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E09771F000C4;
	Thu, 19 Nov 2026 01:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050439;
	bh=BN/uw40KJqao8v/1jhDCKWJ2DhZi0+4SxSPHBplmGNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=axyprkIAsVweqPLU8UYs7fdXJoj5ES6bHGR3lvSsA6Isnu36kBDmOOj82DqvwMSDZ
	 /QYBJjHdxCCniyXtd0BBclGdAjYRMJN1AFKVt0dx6TmUgzV/6/hMFJ1mI0jEt6FvNd
	 4lKadCkq9odxVRu/V5YJwQzlqdu7xjMn6rWfblM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fuchs <fuchsfl@gmail.com>,
	Adrian McMenamin <adrianmcmenamin@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2706/2857] ALSA: sh: aica: Fix spu_memset() stride
Date: Wed, 18 Nov 2026 16:02:20 +0100
Message-ID: <20261118150339.015127540@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fuchs <fuchsfl@gmail.com>

[ Upstream commit 0d01f90b07e877ef31f9959e9b0bc6bcca9b99df ]

spu_memset() writes one 32-bit word per iteration, but advances the
destination offset by only one byte. spu_reset() calls it with
0x200000 / 4 words to clear the 2 MiB of sound RAM, so:

 - three out of four writel() calls target an unaligned address. The
   SH4 can't do that. Each one traps and is emulated by the unaligned
   access fixup. This call to spu_memset() causes 393216 unaligned
   accesses, visible in /proc/cpu/alignment.
 - the clear covered only about 512 KiB of sound RAM, not 2 MiB.

Advance the offset by the size of the written word, to clear the full
sound RAM using aligned writes.

Fixes: 198de43d758c ("[ALSA] Add ALSA support for the SEGA Dreamcast PCM device")
Signed-off-by: Florian Fuchs <fuchsfl@gmail.com>
Acked-by: Adrian McMenamin <adrianmcmenamin@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20261022163241.2504922-1-fuchsfl@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/sh/aica.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/sh/aica.c b/sound/sh/aica.c
index 8b47bfcd90318..2ed2f5cc84447 100644
--- a/sound/sh/aica.c
+++ b/sound/sh/aica.c
@@ -95,7 +95,7 @@ static void spu_memset(u32 toi, u32 what, int length)
 		local_irq_save(flags);
 		writel(what, toi + SPU_MEMORY_BASE);
 		local_irq_restore(flags);
-		toi++;
+		toi += sizeof(what);
 	}
 }
 
-- 
2.53.0



