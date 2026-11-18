Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021611;
	b=mEQgnI03Ihtzlh1h0Yn7o9hTIgLl+W2fT+LMg2v2OlIJnldj7jSQ6E5u5lNO8rMcK3ML
	 uM35Erm4HDssfd8wm+rWPewKbymwsyw06Pl9poOY7xHOpzmk+SodAaIcgmNhjxQMJLeTf
	 4sO8pjWQ1z/S572CcZVpmKbbii8jQEqCzLCHLP+jSIUr4dnrINE3qmoosaUvJzCqD2J7G
	 zgGbcKMRioye42KXZjUWvxOlDDOuaZO00U3IzDpvDt8/xEPmgTOnE1G/MbOi6Woju67Dc
	 dKOImzEuHC2baf/2i3tDcCmOSlVBdkdwUXU6l+QxeQ71aZW8G96TwdFZ4O4dAeiSdfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021611;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pArj8ulkMgsoaE77keUOreuXUpWzYVhr40k9piQVG8g=;
	b=K0/MCFTwaM9QeFopvOV7F29yiaF0VFPli5zyOr1ETDXu52Pe8Frk0xP9AhTeOa2jaop8
	 UsLowpLJqkBdFyB/OEj2SrMZF2hmkngxbPvHx3CH3epFgSjL6zF1FYoE9wwj/qOVrs/Rn
	 5vepXkR3B1KyV/weRRbzzWzIXDrFEiPCyN6O9c77mwmVbPZ7nFCYnKxjTaJ96rQLiCrmU
	 ik/yDOCViypQ0ReveH0SI+c/wMNNfAOnYQlw16B7aCqilrmAefgHSb9gClp8m2xPjXXxd
	 PwoCxO1I3a6R1YJC1nnYxT8UYHScv1o8nyntUrhk8iGAymGRLOKUvG8PQRhYK4DCXXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BmklFN3c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D09F2606A320;
	Wed, 18 Nov 2026 17:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BmklFN3c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C4A91F000C5;
	Wed, 18 Nov 2026 17:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021611;
	bh=pArj8ulkMgsoaE77keUOreuXUpWzYVhr40k9piQVG8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BmklFN3cHPBLS1T2rGtrwZphoEUkzf2kPidz5Gi2S2UIBPw8N4WrRgBvWp+dNcGu7
	 dnD2PKObBI92CaM3VGKd5IN5L0TR15scZn+7ia5emKMt3n0iRafDE1pCvvLjWjikl5
	 v5YhcmTEqQdu7fB0raIz/tkJLOqAWQfX5LEeWkFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fuchs <fuchsfl@gmail.com>,
	Adrian McMenamin <adrianmcmenamin@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2370/2651] ALSA: sh: aica: Fix spu_memset() stride
Date: Wed, 18 Nov 2026 16:00:10 +0100
Message-ID: <20261118150410.842066728@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 078fc7fc08f9f..04f80c8c89c03 100644
--- a/sound/sh/aica.c
+++ b/sound/sh/aica.c
@@ -94,7 +94,7 @@ static void spu_memset(u32 toi, u32 what, int length)
 		local_irq_save(flags);
 		writel(what, toi + SPU_MEMORY_BASE);
 		local_irq_restore(flags);
-		toi++;
+		toi += sizeof(what);
 	}
 }
 
-- 
2.53.0



