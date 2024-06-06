Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956E1196DA0;
	Thu,  6 Jun 2024 14:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683265; cv=none; b=bcpoN26A/Ri9b+vVPUTauSHuTgfOeGXi7zXqd3UtDyCdkYTUgUJmPhGDUceNOkwDXca0Sfoltdx3xxWXB6L1tJjWWa4nvqXrTeK40sjr1lHyxAEmKfiGwr9MR1FA0hj2vhsjWhdPKmUTXRhKZp3SSDMWC9gA/GqcgKLEBOhU9ZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683265; c=relaxed/simple;
	bh=7M98OYLkhfudewC17PI9j41aSSkhMnvpxn1EnUz8xCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=udZyf4fKzevso/L89ArSTbG6B6OIj3R2QRmG7V/UHt+vhH8FfuSN+HzoOHwg6uTlWMfW9oQJvIFLzg0ApVP4XaZ3Uri+G0FYZbgXu916Zi06JvZ3FNDSaXDrRhuhkolrtUXkf0VGTo4/qZd3FD1mlEo1yQuoV98MwcIFgfxIzYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pIABuE/4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pIABuE/4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73096C32782;
	Thu,  6 Jun 2024 14:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683265;
	bh=7M98OYLkhfudewC17PI9j41aSSkhMnvpxn1EnUz8xCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pIABuE/4qsvRPB9yJzGf2lwyByRb85sfmY3+qVZxfMc+ZXf6CxGnBXxf+ENwPrN+L
	 aLyZZs4ORrgH1f3iEZo8UVKKcr/5L/tsoZDesj5no6o07yIS+1jsDPILAXjxVIPqbx
	 OVJIlm+V1QX59psgQvXr1U7gK8pRPjeIefxNdHvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Finn Thain <fthain@linux-m68k.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 145/473] macintosh/via-macii: Fix "BUG: sleeping function called from invalid context"
Date: Thu,  6 Jun 2024 16:01:14 +0200
Message-ID: <20240606131704.741583097@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit d301a71c76ee4c384b4e03cdc320a55f5cf1df05 ]

The via-macii ADB driver calls request_irq() after disabling hard
interrupts. But disabling interrupts isn't necessary here because the
VIA shift register interrupt was masked during VIA1 initialization.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Link: https://lore.kernel.org/r/419fcc09d0e563b425c419053d02236b044d86b0.1710298421.git.fthain@linux-m68k.org
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/macintosh/via-macii.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/macintosh/via-macii.c b/drivers/macintosh/via-macii.c
index db9270da5b8e9..b6ddf1d47cb4e 100644
--- a/drivers/macintosh/via-macii.c
+++ b/drivers/macintosh/via-macii.c
@@ -140,24 +140,19 @@ static int macii_probe(void)
 /* Initialize the driver */
 static int macii_init(void)
 {
-	unsigned long flags;
 	int err;
 
-	local_irq_save(flags);
-
 	err = macii_init_via();
 	if (err)
-		goto out;
+		return err;
 
 	err = request_irq(IRQ_MAC_ADB, macii_interrupt, 0, "ADB",
 			  macii_interrupt);
 	if (err)
-		goto out;
+		return err;
 
 	macii_state = idle;
-out:
-	local_irq_restore(flags);
-	return err;
+	return 0;
 }
 
 /* initialize the hardware */
-- 
2.43.0



