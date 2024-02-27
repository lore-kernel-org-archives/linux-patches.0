Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A8CA13B2B4;
	Tue, 27 Feb 2024 14:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043293; cv=none; b=WbmaibsDXrYNu/IoN5a2idPWbbLJBSX8IwmZsfe8ybCMZthMcxFT3A2HR162ODthXUdQJ3S6ANB6FKj0dZWt9NTshcahHuSt+PQErEyTdEDC2LdMZsUm+7RDw5Vr0bB6f6xtpG1SicPaohevDyjY8StCCnn+uZe/Rqj+ONt4FfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043293; c=relaxed/simple;
	bh=WkPszWlTKcmKJifXW2VqSE72TMVSj2cxkukiTAS+4Oc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HSSz20mIQtoW6SJ/hwe9CgE1ewX/xldb0J0z17Jh7tP/dkVH1sDBsJ/sYXzf3PjsqY5M/l9tJEXijEQgd/M9TKayd3B9h+23eAFmWf4zv3n8axs7FSJT9bMKDD/JrT9191dw3x2VeD3caTd89YMp9beoQllNBdXTgdzYOA+BYRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rhyIMQJW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rhyIMQJW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8D32C433C7;
	Tue, 27 Feb 2024 14:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043293;
	bh=WkPszWlTKcmKJifXW2VqSE72TMVSj2cxkukiTAS+4Oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rhyIMQJW0kYFmeeO4hy2qIlaR1TIIgnk3ujEWoSqz0lfJMbY6Pq6cKmM6ywePXr2O
	 RZzR5lmIpEqirHbkqK99o4k5RjQCmcmoD0e3nRiCIAYVEpPY74k7h/GCA75cIBk8BU
	 Kx2zoNfztHQ8Xhckc/U7ULvtN8EpoM1TQ7ubEpi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	David Brazdil <dbrazdil@google.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 038/195] misc: open-dice: Fix spurious lockdep warning
Date: Tue, 27 Feb 2024 14:24:59 +0100
Message-ID: <20240227131611.649722260@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

From: Will Deacon <will@kernel.org>

[ Upstream commit ac9762a74c7ca7cbfcb4c65f5871373653a046ac ]

When probing the open-dice driver with PROVE_LOCKING=y, lockdep
complains that the mutex in 'drvdata->lock' has a non-static key:

 | INFO: trying to register non-static key.
 | The code is fine but needs lockdep annotation, or maybe
 | you didn't initialize this object before use?
 | turning off the locking correctness validator.

Fix the problem by initialising the mutex memory with mutex_init()
instead of __MUTEX_INITIALIZER().

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: David Brazdil <dbrazdil@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20240126152410.10148-1-will@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/open-dice.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/open-dice.c b/drivers/misc/open-dice.c
index c61be3404c6f2..504b836a7abf8 100644
--- a/drivers/misc/open-dice.c
+++ b/drivers/misc/open-dice.c
@@ -142,7 +142,6 @@ static int __init open_dice_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	*drvdata = (struct open_dice_drvdata){
-		.lock = __MUTEX_INITIALIZER(drvdata->lock),
 		.rmem = rmem,
 		.misc = (struct miscdevice){
 			.parent	= dev,
@@ -152,6 +151,7 @@ static int __init open_dice_probe(struct platform_device *pdev)
 			.mode	= 0600,
 		},
 	};
+	mutex_init(&drvdata->lock);
 
 	/* Index overflow check not needed, misc_register() will fail. */
 	snprintf(drvdata->name, sizeof(drvdata->name), DRIVER_NAME"%u", dev_idx++);
-- 
2.43.0



