Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B31522E00A;
	Mon, 10 Mar 2025 17:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626819; cv=none; b=bwbG3q/N7oJoPd0UfwouoHjbwbiGISKE/UbfY4BMZWJ0GS50Qzs/Dc1QOMAkxz7AH2nvQyxy3YUpmDsjMAZG0yiWdN3essOw7ICE5NmMVlYV/lhUw1lgqDFoZ66dsnzNADHDAs43oZS1+s8SBeFJedfKOqe9bumf1qzmx+xiym8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626819; c=relaxed/simple;
	bh=3pZ5Y4tMmMYTYOLRAK6aQ870PJqhb5Z9OG7Xtik7KN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t1ej3HQKGA3c9T+t4fEZe+XAwtYFqMQQRpEAWUiqITClGl9obhrOqR/oPqnO/xEpMsHQ7MgVfFfOmfgd9v7kKQMMxpwWzqweqjw3DuyMJHsmFH5krK+tz9ovgfAEXGMV6D3INeD88HtFzyfPBDZ8a5T8gBhRznPGANS3I719BME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uQ/7CgXg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uQ/7CgXg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7F02C4CEE5;
	Mon, 10 Mar 2025 17:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626819;
	bh=3pZ5Y4tMmMYTYOLRAK6aQ870PJqhb5Z9OG7Xtik7KN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uQ/7CgXgVFYJXGsS4RJ4E6fiClB/cOWj3RfurW6e8ZERUE9JY+EDPUwMT3uYT5Cgu
	 BfHF5XoXKiL8bH/B33w6fNGk/WVV9DMyEjKcHoT2cTHAQclmwTN7LSkzV7s1SSovra
	 XgWXcgs439HAkq4EN1ApBl7rElxBms5DSKcOF0cg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xinghuo Chen <xinghuo.chen@foxmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 123/207] hwmon: fix a NULL vs IS_ERR_OR_NULL() check in xgene_hwmon_probe()
Date: Mon, 10 Mar 2025 18:05:16 +0100
Message-ID: <20250310170452.693360089@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 1e3bd129a922d..7087197383c96 100644
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



