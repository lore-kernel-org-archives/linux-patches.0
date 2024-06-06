Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16FDC1AB52A;
	Thu,  6 Jun 2024 14:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683265; cv=none; b=UnEnxVGLxWy/OFHMfnYDZPyjzOPxJELa7f8e8aGmegSB87qJw+BcbsQe9VyqyHno2AzViafCUcZ2Egl4dEOTe2t2PZjR/B+aRCFPxNXx+l8Jwy4Oi5VJFwVMKdC+VgaR7RnC7P6TQIiL7YUSYJ7NU5mQKSuWErh2f8pHlaIY46M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683265; c=relaxed/simple;
	bh=ShMj1D6rUmcicjVq2Q31D4Tlu6MsgbSfbrnUZAmxx9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TIA8pwalfQcpSZTkWGWuzn80RaAMCO2NWPuYRHXaNtb0aysYnwI7+lbKGndIuI2Du0tnlp8bzeasN4g4VLA6KP0S7buCuc+vP/R8BcaupfgrOKl8ZNgmqC1UlQZbHVo9BDk5wC0SrgAtx0tk1+lpunV0KbXenIF2xjE6779DTfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NSm1NSQA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NSm1NSQA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F85C32782;
	Thu,  6 Jun 2024 14:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683265;
	bh=ShMj1D6rUmcicjVq2Q31D4Tlu6MsgbSfbrnUZAmxx9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NSm1NSQA3HgK8xj+IVP3QLrRkKptJRvJ17Sl0RGo0GCZfUNA4GyEEc05s3etj83wG
	 b31mNL/rXezHwwHcn6WsJSto5V1o0EY68Y41xLN74+E34K37xXiq1yI5qXbKIS/bXE
	 bss8TySrMZgaitZ0dIiU6P2eNfSAzHjikcPGlsUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Finn Thain <fthain@linux-m68k.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 209/744] macintosh/via-macii: Fix "BUG: sleeping function called from invalid context"
Date: Thu,  6 Jun 2024 15:58:01 +0200
Message-ID: <20240606131739.098654883@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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



