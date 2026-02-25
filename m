Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED02251795;
	Wed, 25 Feb 2026 01:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983034; cv=none; b=pUZUgL7Hzk5x+upp2ROXU9dApn6W9IEGk9UTiS6TBASIHnuCFAABj3PSNNa93vF6WCNK18B9WkPaY1m6CXbZMbhN6BO5JLIzIo/YG7T+HBqPshm17elPF0h+6v912wRAarOrOsVSPETUDuMMBionsNcMccT8NybMhw/Knx6bhgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983034; c=relaxed/simple;
	bh=O/+ZdIhiRS7xQWwnbgXHWR7kVRkb5RDiQPvIu85hbao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IuFAV1rhOCySPT9leLUc32fOGmSr2aPV4NIUjTYUjCXe25NspbBnrxWSXXxdZ3mrCgZxBMFhJa16qxhhdueQKlYlOiUmGQpkaBYlRgGxtFYOfK7hOlFjuTLYZO+rMa6IZAvLLMYmc+aZtzfHE394th/gTHC+MxPXQ0oMFmO/hgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LGboz+po; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LGboz+po"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A323C116D0;
	Wed, 25 Feb 2026 01:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983034;
	bh=O/+ZdIhiRS7xQWwnbgXHWR7kVRkb5RDiQPvIu85hbao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LGboz+popD7T7kqNiioi+zpkVgYuZsMJ1GfWbXKBSBkSjuKmLZQUDSqHKdP5FdwiI
	 7YkYNZUVmhAqIQcBGtY8CF4U/n2xOlkjO4tENfQJRykYwpwMmG0fze7ohD+AOzygjb
	 HxiJYIdEk/U5KTj7wnKYFxLwjCuRLyuGk4HlK1qI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 163/781] soc: qcom: cmd-db: Use devm_memremap() to fix memory leak in cmd_db_dev_probe
Date: Tue, 24 Feb 2026 17:14:32 -0800
Message-ID: <20260225012403.650009322@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 0da7824734d8d83e6a844dd0207f071cb0c50cf4 ]

If cmd_db_magic_matches() fails after memremap() succeeds, the function
returns -EINVAL without unmapping the memory region, causing a
potential resource leak.

Switch to devm_memremap to automatically manage the map resource.

Fixes: 312416d9171a ("drivers: qcom: add command DB driver")
Suggested-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Link: https://lore.kernel.org/r/20251216013933.773-1-vulab@iscas.ac.cn
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/cmd-db.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/soc/qcom/cmd-db.c b/drivers/soc/qcom/cmd-db.c
index ae66c2623d250..84a75d8c4b702 100644
--- a/drivers/soc/qcom/cmd-db.c
+++ b/drivers/soc/qcom/cmd-db.c
@@ -349,15 +349,16 @@ static int cmd_db_dev_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	cmd_db_header = memremap(rmem->base, rmem->size, MEMREMAP_WC);
-	if (!cmd_db_header) {
-		ret = -ENOMEM;
+	cmd_db_header = devm_memremap(&pdev->dev, rmem->base, rmem->size, MEMREMAP_WC);
+	if (IS_ERR(cmd_db_header)) {
+		ret = PTR_ERR(cmd_db_header);
 		cmd_db_header = NULL;
 		return ret;
 	}
 
 	if (!cmd_db_magic_matches(cmd_db_header)) {
 		dev_err(&pdev->dev, "Invalid Command DB Magic\n");
+		cmd_db_header = NULL;
 		return -EINVAL;
 	}
 
-- 
2.51.0



