Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA951494AF;
	Tue, 25 Jun 2024 09:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309016; cv=none; b=Dvk1eIYxA3kL/tK1RazTj4E3sdBW6oTDLjLSL9gHQiqeGgLTYLoxyruOS4Qv3b9gKJ74/6fTyP5nlmKJ4vO64Lcv+yKMPNbfJOMzJVke+hsLnoVwj0+9yxv0hE7h3wdJUOl5+0S0cdzI7icnA+GhvMz7W7ZQfLuF5kz2Xu9ZjTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309016; c=relaxed/simple;
	bh=T0on4BsQqh3viIZWeZ4u5BxALn3eMxtdsxh5/Zki9C4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j5Tn4M9H2uPKhDkHMa9nIuAr+W6UmJTkLOVyzvj8hl/B1Q1kV/mdcHEYteFHO8reFiXIfyoRJ+KXhtyRF7IOQwlkPs4H/8JShaWhIZ1ty0y9u5xkhb0+X5g1QIwXkwr06ZDRfw62QO8plXn+RDiD7QRk4CDXE8dqAQ/lTHl8fY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B55JiLlm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B55JiLlm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B362C32781;
	Tue, 25 Jun 2024 09:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309015;
	bh=T0on4BsQqh3viIZWeZ4u5BxALn3eMxtdsxh5/Zki9C4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B55JiLlmXprcdrX2iW4SEdNmi+W3PMBCI6DL4EJvzto0fgY9vBZZXVjp45ob5c4uQ
	 3KdfLBQ5QjChOexdefPlpheO22Zf85rjpgm9a9PDk5b4lolLiu/c5xZiIi09vKkwXO
	 TcVxmITd9X/lemGp+d/3fm8ySbCJ+I82Gdqvm3as=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 066/192] mips: bmips: BCM6358: make sure CBR is correctly set
Date: Tue, 25 Jun 2024 11:32:18 +0200
Message-ID: <20240625085539.706517771@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Marangi <ansuelsmth@gmail.com>

[ Upstream commit ce5cdd3b05216b704a704f466fb4c2dff3778caf ]

It was discovered that some device have CBR address set to 0 causing
kernel panic when arch_sync_dma_for_cpu_all is called.

This was notice in situation where the system is booted from TP1 and
BMIPS_GET_CBR() returns 0 instead of a valid address and
!!(read_c0_brcm_cmt_local() & (1 << 31)); not failing.

The current check whether RAC flush should be disabled or not are not
enough hence lets check if CBR is a valid address or not.

Fixes: ab327f8acdf8 ("mips: bmips: BCM6358: disable RAC flush for TP1")
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Acked-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/bmips/setup.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/mips/bmips/setup.c b/arch/mips/bmips/setup.c
index ec180ab92eaa8..66a8ba19c2872 100644
--- a/arch/mips/bmips/setup.c
+++ b/arch/mips/bmips/setup.c
@@ -110,7 +110,8 @@ static void bcm6358_quirks(void)
 	 * RAC flush causes kernel panics on BCM6358 when booting from TP1
 	 * because the bootloader is not initializing it properly.
 	 */
-	bmips_rac_flush_disable = !!(read_c0_brcm_cmt_local() & (1 << 31));
+	bmips_rac_flush_disable = !!(read_c0_brcm_cmt_local() & (1 << 31)) ||
+				  !!BMIPS_GET_CBR();
 }
 
 static void bcm6368_quirks(void)
-- 
2.43.0



