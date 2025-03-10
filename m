Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 553CC2343C1;
	Mon, 10 Mar 2025 17:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627581; cv=none; b=fMBJttVTjWZrJMUi1TrlL43LvFTaKO6/QzIi8TZwDTknF5sulU61dwLggXRroGvqNKA9f4j1KM7Xp8qpjMSprdO0xrIp0zmiboazC4KFCDJdI7Hon1gyPAOyV5JjbUwQrCj9HD0ID+3opphP43W63CI25o46mAhBhYrFzp7OyjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627581; c=relaxed/simple;
	bh=yG5qXD9Gb1X5EZElGO0RNA172FRVVFRWhNiHUiYvMOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n0ka0nDWGkpklwOSjQKWyaISMjYh+J7rBLOY1qnpYSlFd+4L9QN0brcir3jhz00ydbudZMXWaDLxNqMuHPGGnfbygqoNOD5AaR+aZKM8qY5oJmda1ZQ0Ool8t0gv5j/oRaUG2w4OH1KDaf92kN2Hj0oqPr5uZH60LDqXhSI+Lns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RATPqLsK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RATPqLsK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D00B1C4CEE5;
	Mon, 10 Mar 2025 17:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627581;
	bh=yG5qXD9Gb1X5EZElGO0RNA172FRVVFRWhNiHUiYvMOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RATPqLsK/zFLsOQI1pZXX5962kGqXmJBrf+K6cG35+iD0ahOUmm6WqWzAlzjltYqz
	 +ZfaPbvl3Yce3N8qbJGpio7+DGWRXuiYmMa495wpc5E457SDWInhZnWFgDzWFj8yAC
	 I/3hKOiA09fScQQehRoYf8at5/gGwDe+qFm+L240=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xinghuo Chen <xinghuo.chen@foxmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 177/269] hwmon: fix a NULL vs IS_ERR_OR_NULL() check in xgene_hwmon_probe()
Date: Mon, 10 Mar 2025 18:05:30 +0100
Message-ID: <20250310170504.765712577@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xinghuo Chen <xinghuo.chen@foxmail.com>

[ Upstream commit 10fce7ebe888fa8c97eee7e317a47e7603e5e78d ]

The devm_memremap() function returns error pointers on error,
it doesn't return NULL.

Fixes: c7cefce03e69 ("hwmon: (xgene) access mailbox as RAM")
Signed-off-by: Xinghuo Chen <xinghuo.chen@foxmail.com>
Link: https://lore.kernel.org/r/tencent_9AD8E7683EC29CAC97496B44F3F865BA070A@qq.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/xgene-hwmon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/xgene-hwmon.c b/drivers/hwmon/xgene-hwmon.c
index 5e0759a70f6d5..92d82faf237fc 100644
--- a/drivers/hwmon/xgene-hwmon.c
+++ b/drivers/hwmon/xgene-hwmon.c
@@ -706,7 +706,7 @@ static int xgene_hwmon_probe(struct platform_device *pdev)
 			goto out;
 		}
 
-		if (!ctx->pcc_comm_addr) {
+		if (IS_ERR_OR_NULL(ctx->pcc_comm_addr)) {
 			dev_err(&pdev->dev,
 				"Failed to ioremap PCC comm region\n");
 			rc = -ENOMEM;
-- 
2.39.5



