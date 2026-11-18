Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062030;
	b=yAAOwJaxF0zGTHutqOH40bANFwZ3/wpbmqehVd4MW7+P382bpnPmVF7lWiOO4ptypbJq
	 ooCCyDNOXF55bTCVq0a1zblcbiillIlklpB/s1C+pkogrlY6ploQx/anGWD9CGOe7jSMx
	 GYNxNCUMCz60xCqzG3pfzC6o5zrzHEpuLj2AE+k2wlWgFXRX7FAg81rrj1tNqA5XuayXS
	 u1uPgXQx13LyWi6hrmvk4nOGALbpjjykjCTTj4ISx8V2up39hbrdvjKJptdV8PJEk4pdN
	 OnSnEUEN8/LFA54n5HfiBQO5HUMm6Qylz2qyDjyzFtBO0BDzV9WR6tTRihdj2qWaFmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062030;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XBxOqFJR20iuZmSguZj9eBHGx46ljTT3eTVbbCHAhsU=;
	b=A6Nu/HjzlaQnnNEW1s5/DM8wv6f6ddYJwAI2OrW98epYiyHe2QI08FkllM7UBjnDtrhG
	 00xna7ykSeZ3AQYTWE4SxZQmhRMVatmqczXFAl703lmgEjJr3KRDrcW3Y/j1jPJtw95hy
	 LzVYIiDd1TVFltyiAxEji/NNoUu8gmDlsBdBlBckPlHPI/SoDvAuody1BGIUv5Y5Imwpa
	 iYU6FMgTemFmJ94JYFpTB3qnFSMB//shbDFeSd+TogGYTgfx1jVI829aR7KwQ9+5CGc1j
	 kF62GhygXhlUuI1SgwF8eyJCbsgU2mfl1cSLtQCygxXCwsASxz8EXojqjfNibyEJ6Pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ok0KADcz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F9F0606A325;
	Thu, 19 Nov 2026 04:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ok0KADcz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73CAA1F000C5;
	Thu, 19 Nov 2026 04:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062030;
	bh=XBxOqFJR20iuZmSguZj9eBHGx46ljTT3eTVbbCHAhsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ok0KADcz17WI98xFwT+876axGH8sYf2rqZzgT5pSI6F+q2McPYeUGRsoXxUKOYLwc
	 KvY8DYnLTVw2YogvY7MvKFEd2QcTNOCEXJvgNK8Rp3QW91ASL0tGr4fPIPB/zdEFKn
	 53fP26innIVSDJs6wRmR3Ut5vgw1Cua8q8kDQKBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fuchs <fuchsfl@gmail.com>,
	Adrian McMenamin <adrianmcmenamin@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1763/1848] ALSA: sh: aica: Fix spu_memset() stride
Date: Wed, 18 Nov 2026 16:03:21 +0100
Message-ID: <20261118150033.235250190@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 2d59e3907fcfb..02df305e8664a 100644
--- a/sound/sh/aica.c
+++ b/sound/sh/aica.c
@@ -96,7 +96,7 @@ static void spu_memset(u32 toi, u32 what, int length)
 		local_irq_save(flags);
 		writel(what, toi + SPU_MEMORY_BASE);
 		local_irq_restore(flags);
-		toi++;
+		toi += sizeof(what);
 	}
 }
 
-- 
2.53.0



