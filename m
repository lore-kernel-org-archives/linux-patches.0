Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90AEB1494D5;
	Tue, 25 Jun 2024 09:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308462; cv=none; b=ImAwGv/ZMp9GK9JryCn6aZ1IBIhWazJgqc/nd28cqudhW89N56njNBEZ7Nc+2g6pJXPZnRunbGJtIxdbtGRQSDYmyA3QhHSYtXJhnKrKUVuN/14PIB3ztZix01L6tPiUuLFZ6+OfhESYGsA1cL7s8isLDOeS1QexCqoXMcXNN2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308462; c=relaxed/simple;
	bh=etdIJdsB9TFg4egI81sq6jOYYYwD5AYsXjzRzbmnbbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MZbLR/k4v/j+XVUpyi4C7kvQxpOfj0zHjk3tMdN1toSUiC7isaty1uIKeaum8/h/qVyxV6S7hOMYhW33DjJZvg5o6dOr1JBPeOB2pVfIEMHsSH0Xra7ll9ib5dEmcRfk5tOdlSjh11k3d96xnUsmTX/oUI70XSn5XhweJWpB3hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RfU7FTMk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RfU7FTMk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13F1AC32781;
	Tue, 25 Jun 2024 09:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308462;
	bh=etdIJdsB9TFg4egI81sq6jOYYYwD5AYsXjzRzbmnbbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RfU7FTMk7wufq/EqNEL735qTSuoZPKzvTHBkncJBZd/M7XaCgjm3Njakc8YhTGWVI
	 HBoWhaC9UWIfAFf4rtUpgQ5IhCxv6eqAZG9YOdh68Hz1OhCjR+bgz6N9QKR79XscPt
	 tIBTWVIlO2gbiJdYn8FJV9iqcDzGAWI1yJLa1AVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 098/250] mips: bmips: BCM6358: make sure CBR is correctly set
Date: Tue, 25 Jun 2024 11:30:56 +0200
Message-ID: <20240625085551.832588050@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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



