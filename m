Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E941F5439;
	Tue, 21 Jan 2025 17:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482155; cv=none; b=GhiJrLE7KUamHECpHQBsC+m6F4YQTT31TIxuxiHAmCEx1SPO77jfieDnDP+e/u9pPL4UeQ3+ezLa8jblGbXHjIOSjM6Oh2OT0uxYrMLpNrXAVv+Q3RT7w4IW4vYer74dUAzhlkCwLAtUg2YT+q/TRDwQxslhRbaK7rnmPMivyHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482155; c=relaxed/simple;
	bh=OUh21iAEyfSTLofXVmRpg/KmkFsIAPrWc+snX2aaHow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GMFgLhHysKjRF3PtmsdM7mnv9pe8y/Eh30k9yV9ucdScThWJkRXTYy9tJzR4a8nRiQFLqZ06KsEQIcJpdZrG6lSKtE4H/PiKxkrxALkOv//Haz2JP25rBkQrzGVfziz0Zk0IaSqRbBdqamM3tpauK1J9VPZMGfUqy9evpSoogDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TXO6rkpK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TXO6rkpK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A81C4CEE3;
	Tue, 21 Jan 2025 17:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482155;
	bh=OUh21iAEyfSTLofXVmRpg/KmkFsIAPrWc+snX2aaHow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TXO6rkpKcu318SyaIA/kACLXG3cLw22VekYhbzgFMYFoylJpvyl1bJwa3UC6hXqRE
	 NY9EBcN+5043X/HWq1/FrCCLWQrXxWp+CgvhQ+y2XA9Sc9/YBPeC2kSAe9KX5rpxZb
	 6fVZinuftgf8KadDEXmgpHDIiGOv5iL9kTIKyG1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 22/72] i2c: mux: demux-pinctrl: check initial mux selection, too
Date: Tue, 21 Jan 2025 18:51:48 +0100
Message-ID: <20250121174524.281218105@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174523.429119852@linuxfoundation.org>
References: <20250121174523.429119852@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit ca89f73394daf92779ddaa37b42956f4953f3941 ]

When misconfigured, the initial setup of the current mux channel can
fail, too. It must be checked as well.

Fixes: 50a5ba876908 ("i2c: mux: demux-pinctrl: add driver")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/muxes/i2c-demux-pinctrl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/muxes/i2c-demux-pinctrl.c b/drivers/i2c/muxes/i2c-demux-pinctrl.c
index 9f2e4aa281593..299abb6dd9423 100644
--- a/drivers/i2c/muxes/i2c-demux-pinctrl.c
+++ b/drivers/i2c/muxes/i2c-demux-pinctrl.c
@@ -261,7 +261,9 @@ static int i2c_demux_pinctrl_probe(struct platform_device *pdev)
 	pm_runtime_no_callbacks(&pdev->dev);
 
 	/* switch to first parent as active master */
-	i2c_demux_activate_master(priv, 0);
+	err = i2c_demux_activate_master(priv, 0);
+	if (err)
+		goto err_rollback;
 
 	err = device_create_file(&pdev->dev, &dev_attr_available_masters);
 	if (err)
-- 
2.39.5



