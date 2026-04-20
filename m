Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A6342D77E5;
	Mon, 20 Apr 2026 15:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700152; cv=none; b=PKyF+BhQuJKXh0s8P/n8GKcVBBFclxEdwboG122DAD6n3OZ4jyg+OgQAObYymwUltp8/2vcpSZmk1XEs7JidwIdWL2gogIvsjKV0Roa+bj2ejcjSmj/EPDiBtH3m+7x1/hHyoOH7FjWLWXRphwKwIu1KAEZRbbXgOqVjQHnNIJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700152; c=relaxed/simple;
	bh=pysmekRQorfCQfWNb20967DdaOuUOG0w6xqEwklbhoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mO/+klxX0MQVdZicGosHJfNr3yvmUsyA9jx/VI69cA5+HotK7X77hcKGDzci/n7uo5AvdxaNwL1v7hjnJ+gH7TWeLwfAvhSBYcNGkyK3An0pmpc2yeJLWBu8RooznpmyW59Mp5iIGxkWGZzrr0CDcUOD6Vnhe15LzvsIqQllBK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T5RZQd0I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T5RZQd0I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2140FC19425;
	Mon, 20 Apr 2026 15:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700152;
	bh=pysmekRQorfCQfWNb20967DdaOuUOG0w6xqEwklbhoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T5RZQd0IHBIaft572segJ8aBGiC+4hRNf4V+m4aZAtBBgxvl4RO04y5jU89ayn0Y4
	 GY8d3yX4xu+m9pGZH1+FyeZvJ0n1SO/OE7MhYFwttls20/0nM5q3OyPXTL7kgHF93A
	 qvXb4XLA9/1v1O+LU5ShSw/Gi/jzpC6QbkqwQKAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 062/220] soc: microchip: mpfs-control-scb: Fix resource leak on driver unbind
Date: Mon, 20 Apr 2026 17:40:03 +0200
Message-ID: <20260420153936.274352388@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 27459f86a43792d5c29f267a41dbd387601e772b ]

Use devm_mfd_add_devices() instead of mfd_add_devices() to ensure
child devices are properly removed when the driver unbinds.

Fixes: 4aac11c9a6e7 ("soc: microchip: add mfd drivers for two syscon regions on PolarFire SoC")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/microchip/mpfs-control-scb.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/microchip/mpfs-control-scb.c b/drivers/soc/microchip/mpfs-control-scb.c
index f0b84b1f49cbc..8dda5704a389f 100644
--- a/drivers/soc/microchip/mpfs-control-scb.c
+++ b/drivers/soc/microchip/mpfs-control-scb.c
@@ -14,8 +14,10 @@ static int mpfs_control_scb_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 
-	return mfd_add_devices(dev, PLATFORM_DEVID_NONE, mpfs_control_scb_devs,
-			       ARRAY_SIZE(mpfs_control_scb_devs), NULL, 0, NULL);
+	return devm_mfd_add_devices(dev, PLATFORM_DEVID_NONE,
+				    mpfs_control_scb_devs,
+				    ARRAY_SIZE(mpfs_control_scb_devs), NULL, 0,
+				    NULL);
 }
 
 static const struct of_device_id mpfs_control_scb_of_match[] = {
-- 
2.53.0



