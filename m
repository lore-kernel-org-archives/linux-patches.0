Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4056E1E98EC;
	Tue, 11 Mar 2025 15:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707610; cv=none; b=LNsqp/KfhQsz3ZtA3kcVRoKigXcW5R7n6oWqg7YI9QVxm8lZ+cY3gH1pyAs18Er/BirxyJkUlxkTMqOo+mgxIDrrY0KNSO2z4VOKCJkCvTpfayKfT8OdD+iFGyJJ8pqNb5QFHxtruKngdr9AricqQVyqt8a+WbzJxAK4J3s1mWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707610; c=relaxed/simple;
	bh=wZw3oYYcgTwqA01Nl+cSCYYZ/PUAeQOg6THhKjr3W94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lBpIm4xdJISkkJCp6jZBIa6Kl1vtdm1LQmVWHmruGyZFr38DzAKwl6sMgYL4FffZHHXD5FBSPtuZZ5Lra0nx/pzwyL4BEeNIFhRphWdBTu9jCrrn/PfdJlEvIwwt2pqM6gQotBLYBazXEAgvt39rSFCXngT4auRWYZsBjDSPAlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zzHvL8ZQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zzHvL8ZQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0274C4CEE9;
	Tue, 11 Mar 2025 15:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707610;
	bh=wZw3oYYcgTwqA01Nl+cSCYYZ/PUAeQOg6THhKjr3W94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zzHvL8ZQeOC5PR2UprtqoYRaqMAhdYT3mwI+X0OGm0GpPBtDr7b84PyedL6I+yFdB
	 R3nKE+OWioLvfkEuz6Nyrudb07pD12y/0/DSwLbuB3o1aZCGBePYyjoTGHnsWkoSta
	 jvpBT8nRzOgQKFNuOW+wBBAfenBCeaHHSXwuxq+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xinghuo Chen <xinghuo.chen@foxmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 416/462] hwmon: fix a NULL vs IS_ERR_OR_NULL() check in xgene_hwmon_probe()
Date: Tue, 11 Mar 2025 16:01:22 +0100
Message-ID: <20250311145814.765231287@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f5d3cf86753f7..559a73bab51e8 100644
--- a/drivers/hwmon/xgene-hwmon.c
+++ b/drivers/hwmon/xgene-hwmon.c
@@ -719,7 +719,7 @@ static int xgene_hwmon_probe(struct platform_device *pdev)
 			goto out;
 		}
 
-		if (!ctx->pcc_comm_addr) {
+		if (IS_ERR_OR_NULL(ctx->pcc_comm_addr)) {
 			dev_err(&pdev->dev,
 				"Failed to ioremap PCC comm region\n");
 			rc = -ENOMEM;
-- 
2.39.5



