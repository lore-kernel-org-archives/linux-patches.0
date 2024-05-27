Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4617126AF2;
	Mon, 27 May 2024 19:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836893; cv=none; b=XrENHvKdMlsyKqgONLmqoUP8Xz9ti7QcBqz9kA6svbGR7TYn9ZN/GPKkJ10sw5TOEuIVCfFdUyzrvvM1fEVYBOKuLTOLI3yIwR4Xs6kWk6YTKUjVOyptooqa9KNY7TwA6hFxs3R9UTXye6QIF7CM7p1aDySWfdYgnJTJ2LS4tAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836893; c=relaxed/simple;
	bh=74/Znb+ZsWb6rLvxWxdVNmKsfE8ykNGziil6VL+GLpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ciBgghMVzl8n0JJjOq3NEfSzcYQkSUXG0pfXOlY+a42ybukH/S2GrlZ99+4K+ir6le9Z9mNeRLweSFZ1PKpzOljv8LJBROI/ah1qqxS1i4vHpR2UaqliyHUzbB4VbN2gM3MCQbmF3acbheQgl70ZREosvFU1tqQbFuNNod4t6fA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ymz/2MWC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ymz/2MWC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB791C2BBFC;
	Mon, 27 May 2024 19:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836893;
	bh=74/Znb+ZsWb6rLvxWxdVNmKsfE8ykNGziil6VL+GLpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ymz/2MWCB07hTEBV84VKpflPMvkQBJoWMC8yoka9y2Rwz4Cj7UyilaoOengiueTz9
	 C4CTrUiTrio2z0vX1g4uLvKJsoAX1vXQbaQepxF1MA63DqWKZtJ9VwDdBjGwPVDoTD
	 AvOuVDWZFylCTc4yfoPkFdApU/vBeqT9DbTmPCwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Finn Thain <fthain@linux-m68k.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 187/427] macintosh/via-macii: Fix "BUG: sleeping function called from invalid context"
Date: Mon, 27 May 2024 20:53:54 +0200
Message-ID: <20240527185619.696782681@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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



