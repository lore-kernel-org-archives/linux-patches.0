Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50CF41EB5FD;
	Sat, 12 Sep 2026 08:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200286; cv=none; b=bOhn0Q1Kl/dmq2t8I3lnRqFK6G8huEpDPXwvzBtpQb+l55KQrdHI0SGIKErtg+8jK6oimmEBIB2cCAb2qU9Bsf1rtaIzk8zPj7rje5XU4EwAleYkHP+s8Z72LzP35VSYcj6Ljfgcmft2vIXpKPjhbVvsQHxKWm6E6ecK2P5F4nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200286; c=relaxed/simple;
	bh=ICnJJnGfORm8dIomGAEqrcW7E0Ukfeb2TtzmwLffOL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qt3db3bFcd9dJEqH2Z63Pudj0Gh4H7Riz0IMwiIeX34yM5V11/2mHVxKthtjwWdT8snlvf1mmxLtTRyihHCRZiMHGxrjx8JQTuwM8s9xg5kK14LIkEuJdHIxXPeR8qUt/QCc+OdCtkQz1HqVWhM06PhPxmAaaX3FyLlUiAz/ik4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V1muAbJK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V1muAbJK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 552D91F000FF;
	Sat, 12 Sep 2026 08:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200285;
	bh=ycg5FYH95Fbkp0B6OAdH5MRC5I37Ys6MZ6PRGtDIQLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V1muAbJKLJePVtm32IYxWPGNOtFakLP6mERGuKl/pWlhbLhDVM3EaUJDkeXND+4iO
	 aXVu5sdUgDLAMZzp4HgXETUe2bZ0QUkCn0OX8eXiUWb23xRiB1uX/fWySeRIjyWnVV
	 7ph0tUAUHQ0/M1poIm899v6vppmtmBP4qdcLfiHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0758/1815] platform/chrome: cros_ec_debugfs: Unregister panic notifier
Date: Sat, 12 Sep 2026 08:41:48 +0200
Message-ID: <20260912065706.703042162@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongyan Xu <getshell@seu.edu.cn>

[ Upstream commit e5954d3031fb55dd31aa59bae477d63c68e941c0 ]

cros_ec_debugfs_probe() registers notifier_panic with the EC panic
notifier chain. The remove path tears down debugfs and the console log,
but leaves the notifier registered. A later panic notification can call
back into the removed instance and queue work that accesses released
data.

Unregister the panic notifier before tearing down the debugfs and
console log state.

This issue was found by a static analysis tool.

Fixes: d90fa2c64d59 ("platform/chrome: cros_ec: Poll EC log on EC panic")
Signed-off-by: Hongyan Xu <getshell@seu.edu.cn>
Link: https://lore.kernel.org/r/f3ab74ef8034be63bb45a325f3d54656d658817f.1785320940.git.getshell@seu.edu.cn
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/cros_ec_debugfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/platform/chrome/cros_ec_debugfs.c b/drivers/platform/chrome/cros_ec_debugfs.c
index 6d7ff624540ac..c0cb50bd24413 100644
--- a/drivers/platform/chrome/cros_ec_debugfs.c
+++ b/drivers/platform/chrome/cros_ec_debugfs.c
@@ -531,6 +531,8 @@ static void cros_ec_debugfs_remove(struct platform_device *pd)
 {
 	struct cros_ec_dev *ec = dev_get_drvdata(pd->dev.parent);
 
+	blocking_notifier_chain_unregister(&ec->ec_dev->panic_notifier,
+					   &ec->debug_info->notifier_panic);
 	debugfs_remove_recursive(ec->debug_info->dir);
 	cros_ec_cleanup_console_log(ec->debug_info);
 }
-- 
2.53.0



