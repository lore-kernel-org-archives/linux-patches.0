Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F35D3DABFC;
	Tue, 30 Jul 2024 16:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355310; cv=none; b=Yl1wgcpdDAmoAvlpRu05rOnMux9I6GHCLLDgXa1ppSHP1i7hsNl7oN+FD3DzS1lxcuboEWo0A1Ir6c8+jd5wfGlZ5krYUJ5JmvDHACpZ8j3Vc33t6MLGiKLeeFM2EqCQpe2zD9WhBaD/zaEQBMKSLGBTHyEenpY0uJK+try2WBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355310; c=relaxed/simple;
	bh=Wt33U5aWzpWLkBS0+7dIA8vnZGuLuoYLJPSBZxExBsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A6x3ZD+ufzo/FEWTaM+Q6PuQo8VlnfT4CGGLXw/Kditak80o83n1jhDBF+l0+38r7M8H9LJquxWdJrN2sN0pNGzPqzynnHK/Mlx2Uy6xnDQ4UuyAdAMRMKIZbSA8NxC2Bl7tbBCV4bVIVcNOhSis+RoRJ0MlJkhi3TRNWHS3veQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MhfxnGm0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MhfxnGm0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4E75C32782;
	Tue, 30 Jul 2024 16:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355310;
	bh=Wt33U5aWzpWLkBS0+7dIA8vnZGuLuoYLJPSBZxExBsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MhfxnGm0GN8gyT2ZNWHpP2Eqq24pl5IwD1ghdu7YdcKMsQwfdufrGXKCdmq278LYA
	 oDYhB2Y6f7InIRPTHoWitwgpRI3H3M8oVQQOSbozwIuZWUgegoRQnhMv4/W08Z+zBN
	 XfaEWFK6g/e5XvaTsOFWmrwk9fnvJtgJHngPrUlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nicolas=20Pomar=C3=A8de?= <npomarede@corp.free.fr>,
	Christian Zietz <czietz@gmx.net>,
	Eero Tamminen <oak@helsinkinet.fi>,
	Michael Schmitz <schmitzmic@gmail.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 072/440] m68k: atari: Fix TT bootup freeze / unexpected (SCU) interrupt messages
Date: Tue, 30 Jul 2024 17:45:05 +0200
Message-ID: <20240730151618.577262263@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eero Tamminen <oak@helsinkinet.fi>

[ Upstream commit f70065a9fd988983b2c693631b801f25a615fc04 ]

Avoid freeze on Atari TT / MegaSTe boot with continuous messages of:

	unexpected interrupt from 112

Which was due to VBL interrupt being enabled in SCU sys mask, but there
being no handler for that any more.

(Bug and fix were first verified on real Atari TT HW by Christian,
 this patch later on in Hatari emulator.)

Fixes: 1fa0b29f3a43f9dd ("fbdev: Kill Atari vblank cursor blinking")
Reported-by: Nicolas Pomarède <npomarede@corp.free.fr>
Closes: https://listengine.tuxfamily.org/lists.tuxfamily.org/hatari-devel/2024/06/msg00016.html
Closes: https://lore.kernel.org/all/9aa793d7-82ed-4fbd-bce5-60810d8a9119@helsinkinet.fi
Tested-by: Christian Zietz <czietz@gmx.net>
Signed-off-by: Eero Tamminen <oak@helsinkinet.fi>
Reviewed-by: Michael Schmitz <schmitzmic@gmail.com>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Link: https://lore.kernel.org/20240624144901.5236-1-oak@helsinkinet.fi
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/atari/ataints.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/m68k/atari/ataints.c b/arch/m68k/atari/ataints.c
index 56f02ea2c248d..715d1e0d973e6 100644
--- a/arch/m68k/atari/ataints.c
+++ b/arch/m68k/atari/ataints.c
@@ -302,11 +302,7 @@ void __init atari_init_IRQ(void)
 
 	if (ATARIHW_PRESENT(SCU)) {
 		/* init the SCU if present */
-		tt_scu.sys_mask = 0x10;		/* enable VBL (for the cursor) and
-									 * disable HSYNC interrupts (who
-									 * needs them?)  MFP and SCC are
-									 * enabled in VME mask
-									 */
+		tt_scu.sys_mask = 0x0;		/* disable all interrupts */
 		tt_scu.vme_mask = 0x60;		/* enable MFP and SCC ints */
 	} else {
 		/* If no SCU and no Hades, the HSYNC interrupt needs to be
-- 
2.43.0



