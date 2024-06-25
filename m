Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDDE8149E0A;
	Tue, 25 Jun 2024 09:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309526; cv=none; b=NkUaDB/iYNmEmGN+0kkwPIxoCue4QYm6KD6BIW56fsS5DTnbnK4s3i/FvQJv4UC8S0oK1R3hVgkCWH1MR2yRh+AVLhnCxU3h61VOvOTvRr94n2C5hQihOQ6g1wJvLeTozUVKrwnfRUk7QDB4QmscCku5EEIzu+PkL6crBTH7VMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309526; c=relaxed/simple;
	bh=LYLBv37Qw3VS/g3CaiRCPkN2UpjcJp8eDZBC7YSpDrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QCSu9CaBkpXDpTk/bVZXMBYO2jBbKoMX0vw4I6EArX5mStfK/unjb+M5pgm7Lw7u6oOjaKKwgSC75DaBKuvlu+ZHIV1Exp0nmCGZ0At/S1jtmq7iHT82g/UfX3+hJJTxt2QniNS+q/aeQkwYwoAYGjTIdNuXRJkRUaCvQ1r9Pj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2UYxcOO8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2UYxcOO8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32387C32781;
	Tue, 25 Jun 2024 09:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309526;
	bh=LYLBv37Qw3VS/g3CaiRCPkN2UpjcJp8eDZBC7YSpDrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2UYxcOO8d6MrcEtr59++xqHNhpuJMazwyH/M8Q/4VzdYuK3LDx4EaetRPiOtAq97G
	 Z82Ei1IWggbRxMDW8cv3RSUKfaoOQl3s8/UOavlMxrbcb32wu/qRAffIIjsm3VR3yg
	 51Tz+L/b40AbIQI4AH5D5R9g3Di0zkZfE5gRA37o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 046/131] mips: bmips: BCM6358: make sure CBR is correctly set
Date: Tue, 25 Jun 2024 11:33:21 +0200
Message-ID: <20240625085527.701850146@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 549a6392a3d2d..7615f0e30e9de 100644
--- a/arch/mips/bmips/setup.c
+++ b/arch/mips/bmips/setup.c
@@ -111,7 +111,8 @@ static void bcm6358_quirks(void)
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



