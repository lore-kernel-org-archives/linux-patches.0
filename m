Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B5C1DE89C;
	Mon, 10 Mar 2025 17:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628056; cv=none; b=f3xUFKj59XYa1xXJhseOS95clVeY0h34YWaUQcilUJ1WIZFiny4p1QId3rUAeSCpIEQE1ItWjNpC4dHzLsPuUN6LyCl6sfG51e/Qsu0pWFkb92bNANzvRcdU9OIK5Fl8KcA55VSxBUz6ZpAOcQo/PemmbXHk9WeL3kcAIPnKa/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628056; c=relaxed/simple;
	bh=zTCWSVYy1P4omgywWK9I0fGnvXCzE1kRXdP6gFXSaw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iJYSlWxJDq1SI50jvzhrf3OGWVr3Me/nwN1yidL9u3bhsur6V4MC+ouqjBC7lBsqJS9fKD2Hjgys2BGionsNDKstDeHCPckB1AtK3lAgaLzi9Lh1kfWidi1S2UtyqMU+9wcSSmxW8h4hLn/osdwcmTNvingL4hb4LyEXvcBQO1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qBVl/9w3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qBVl/9w3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B20EC4CEE5;
	Mon, 10 Mar 2025 17:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628056;
	bh=zTCWSVYy1P4omgywWK9I0fGnvXCzE1kRXdP6gFXSaw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qBVl/9w3HqYgxcbeeBXNzj9LfgrUkgGNhMOeclCve0//A9f8mf56hc0piROa3Mi8N
	 maSwCStmXBjeMz1vW8kL/loaMieAs984kxpbT5r1D+bHw8kEaEZLSX59FuzjIiNA43
	 Hu5yFKfZcz+Tgl9e52Q87JsBqqYgIuFiPqwymYBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xinghuo Chen <xinghuo.chen@foxmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 073/145] hwmon: fix a NULL vs IS_ERR_OR_NULL() check in xgene_hwmon_probe()
Date: Mon, 10 Mar 2025 18:06:07 +0100
Message-ID: <20250310170437.699239954@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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
index 78d9f52e2a719..207084d55044a 100644
--- a/drivers/hwmon/xgene-hwmon.c
+++ b/drivers/hwmon/xgene-hwmon.c
@@ -712,7 +712,7 @@ static int xgene_hwmon_probe(struct platform_device *pdev)
 			goto out;
 		}
 
-		if (!ctx->pcc_comm_addr) {
+		if (IS_ERR_OR_NULL(ctx->pcc_comm_addr)) {
 			dev_err(&pdev->dev,
 				"Failed to ioremap PCC comm region\n");
 			rc = -ENOMEM;
-- 
2.39.5



