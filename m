Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D9C262BE;
	Mon, 27 May 2024 19:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838066; cv=none; b=hoYfztgqDFDvIPuLmrbrdenQyF/s4rEAaFf7/GWIY24ofOw+7eS0iotVUN2jcmmBiNTI3vzhLa3Da0tdLQusl+6MWBaMV9VdCX/KXOWaMr2178cTEUONVo0lSdC1k0mfCr5RgMZYg7nMwbSxOa7SyKHIu6vLzv/3PVa8dYZLBW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838066; c=relaxed/simple;
	bh=nQ0tnJJ3kkTibzvq7zmRS8Bomly2dvnKK/Gw83F+nC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PTbBPsmE9vZjnSVPMN1REYm+cNe4+voEvZtzqMx2K2jpIpd3sn6QqCcnUxycroHXLsgFeCoFAmxUeP33XhbNX1JxuPGZUTm+DDkas6dT+57EPpzQTDfA9UI1eCFUWJOmyoq5iy0e0eD5mPyzaQPK87PFSuNNDgphSe127tzJkfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E6SGvhWs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E6SGvhWs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029B9C2BBFC;
	Mon, 27 May 2024 19:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838066;
	bh=nQ0tnJJ3kkTibzvq7zmRS8Bomly2dvnKK/Gw83F+nC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E6SGvhWsgvGGKo+sIXR2wxts7eHxjElvs+sBk1BdkzpyoGs9NEOn/5wbEdV68L+mU
	 o54K1Rqaac4kyBtqFOPkVCPXzAYeIuveb4C1ewJQd7XWAthJKOB1EiQ0rQr19YNChV
	 fNrc8ahOOF8UzcNpLa5cBcGAJV1uIzjRINyCsP8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Finn Thain <fthain@linux-m68k.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 252/493] macintosh/via-macii: Fix "BUG: sleeping function called from invalid context"
Date: Mon, 27 May 2024 20:54:14 +0200
Message-ID: <20240527185638.537476147@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



