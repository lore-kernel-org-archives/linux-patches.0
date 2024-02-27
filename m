Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF33A13B2B3;
	Tue, 27 Feb 2024 13:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040653; cv=none; b=l2AxW/eXl8cU6D5lTdSSnk+osHIHLLPkc5l3LYbrghM3UysA6s3OT4dskF4a/rgimPk2K5HHW+j/IZUZodW39Q+cKKjEBIvpaXuhhGDvzHMUF8x6SU4TErmCPY8nildn5aTvZerge/jLid2Tmg3gQ5vr2CZXnVtrb5chHXlPg+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040653; c=relaxed/simple;
	bh=GK3lYzi7qNSGPVi9shEiroNdQynlA+KqlfHijv4xWrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H2+sanRPEYvJ0tuYoyZBtTycC2RJXmiluHfYts7Ak0MbDNkqEyseFtQrCXTwFHQtLuwcB7HONz8aydX3HGARKU29odIXxfMwByEF9OSUvLuD6/U6w7A67V8Pzt65joiqN+R0ElTRns4VNZJN1D/mqFG42imqJn5iFnMbTRinCCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yLSkr6vf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yLSkr6vf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8013BC433F1;
	Tue, 27 Feb 2024 13:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040652;
	bh=GK3lYzi7qNSGPVi9shEiroNdQynlA+KqlfHijv4xWrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yLSkr6vff6z04hHxVU32pn40+OZfxmpVo4JBBOoM1E2kbCx5lv6ed42zcEdsh/Kqg
	 fg+dGdPjJwW39yjW5dCP1ev0f7lehsksmUETCz0xVifyAknJ09Kxo+IPSRaxnv6/rt
	 XHysqoUBU8thA+1l5mihDqy85IWClnBQqsPUD6Xo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	David Brazdil <dbrazdil@google.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 054/334] misc: open-dice: Fix spurious lockdep warning
Date: Tue, 27 Feb 2024 14:18:32 +0100
Message-ID: <20240227131632.317912454@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 8aea2d070a40c..d279a4f195e2a 100644
--- a/drivers/misc/open-dice.c
+++ b/drivers/misc/open-dice.c
@@ -140,7 +140,6 @@ static int __init open_dice_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	*drvdata = (struct open_dice_drvdata){
-		.lock = __MUTEX_INITIALIZER(drvdata->lock),
 		.rmem = rmem,
 		.misc = (struct miscdevice){
 			.parent	= dev,
@@ -150,6 +149,7 @@ static int __init open_dice_probe(struct platform_device *pdev)
 			.mode	= 0600,
 		},
 	};
+	mutex_init(&drvdata->lock);
 
 	/* Index overflow check not needed, misc_register() will fail. */
 	snprintf(drvdata->name, sizeof(drvdata->name), DRIVER_NAME"%u", dev_idx++);
-- 
2.43.0



