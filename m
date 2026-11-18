Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027920;
	b=gjBK7s5CyT60x6VYfVI4CSxfxzwDdkKS3Mx2jK0pWFYK7ulKq02JMolD9SY5q4Ftql+Q
	 /lydJkNido+uBptS/98m/Khb+XZ6C0t4yqZWTheBHd/KkCLLGHIuUOUsT7K/5cdJMxlM+
	 pKebRaJ/xefaw/kXCbIEwEzWZMLzDixOMeU/YYMl2HobdXTlY0xpuGGeQ0Y/x462XqEfi
	 JqsJk/NXeBKEy88wFufoTkf5sazza2yuL4qPG3OzOzPEUoKPSaAeiOjghcBNCbZWPX0O/
	 4nGCdeaPXcYEmtwXKJt3x1WOpePiHrbr0TRNrXAayjLKIZKtzkDattQ8WRGD1QMxV8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027920;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i1g/mVzWbi2HywpwJj/FbajJ26PFOF3l29SgFydheoY=;
	b=KsxfqVpCu4Wu2vJsnai21KgGi/TaTEMw2IzXLYRiodQTbm9Sp9xETHmbPaDKslRrEy93
	 yAElp5o1YwctAewV1BsozsRoG1f/VKRFqNiqlH2/CwbU91PpY9Gwml8VkU1957TmJ0pD3
	 R+Es2ev6kwf5h3AshKlzSZb8jldMEnP2T8pAknp4KBZX14x2RtfykKtklHekdNfsUltqJ
	 dBa8Q32AqzECKzTrAJ3NF4VtBrYNL1JYFfQtSGOJoioqC8dlwgqVaxVyWMQcAuSx2XQf1
	 OMyVXIJwWGs33H6Q2sM7WiYwdV8HWCezYpHYBelbk7hVYp1AYvCVp3kfZCjOVdvZeag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TYRxYccg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003B1606A320;
	Wed, 18 Nov 2026 18:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TYRxYccg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5596C1F000C4;
	Wed, 18 Nov 2026 18:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027919;
	bh=i1g/mVzWbi2HywpwJj/FbajJ26PFOF3l29SgFydheoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TYRxYccgNPp7n+uPBBjHjfp862t9Z9IFty5+JU/fLCjO1cB948zqC0lmuaScB5tGw
	 SBMGcyCYivK+Lvuwd27KxYQ4KzolQpDv6i46sVMLydPCMrhkYCemPF9Z3YeKcjVWol
	 IdoV76OqAQYJJ9Nj96azhCjIbYpftdOjIfE36Vv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fuchs <fuchsfl@gmail.com>,
	Adrian McMenamin <adrianmcmenamin@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1918/2151] ALSA: sh: aica: Fix spu_memset() stride
Date: Wed, 18 Nov 2026 16:00:53 +0100
Message-ID: <20261118150231.651553937@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index fa81bfba59c14..2ba5f78f0c9a5 100644
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



