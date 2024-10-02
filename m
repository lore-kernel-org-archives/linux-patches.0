Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB37C1D095E;
	Wed,  2 Oct 2024 13:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876450; cv=none; b=naECTF2MC79JgVGglP5HUeE4Sjwivn6mR891spOrA1tsSCeAVJ0rMifC/TPAd1p6PDKH7Z5wXMjQ6yhIaLYOYhZe2NxoaYJmkjyt2PyyjdD2Ho4sH+JMxniHJ46Z1/cyjvnwonPX9ibocgLNt28vgUtNnppm3p1sd5WDcvchAWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876450; c=relaxed/simple;
	bh=o9W7NCNKE5BupZv1IpXxi0ErYOT72r7uAPHRAD3ffNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u0yHng3oxMODeM06uMjd+Ib/DOTU4X+u686UzTtX5FzBX9BBRYf38bWHmMOF3KJMXe8+Pk/SZVMG2QxaLADzcuzSZHZgkRVHtD1Ad5+NFqajHGRSGscMzwYyi07acMbF9ZIWez9pXSeky2fTS5JLxc8XbNEulYvehGxjn92SYM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DvxrDP6f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DvxrDP6f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5350DC4CEC5;
	Wed,  2 Oct 2024 13:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876450;
	bh=o9W7NCNKE5BupZv1IpXxi0ErYOT72r7uAPHRAD3ffNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DvxrDP6fIXqLrtzz8M/9dHJtzpjYcokM/FC/kCzHuWMthcvMjgWDVEP7Deo5+qNJB
	 A61UD8KHtN2GynRwSnn1TgF/rKYlWymNMx/iWQwDe+ckg8FwK1IBrTUGx6gSOYSskk
	 AKngszY37Oxg51+sRP7/WFdYYg8aloTSgHjLrnFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 448/695] spi: spi-fsl-lpspi: Undo runtime PM changes at driver exit time
Date: Wed,  2 Oct 2024 14:57:26 +0200
Message-ID: <20241002125840.341062475@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 3b577de206d52dbde9428664b6d823d35a803d75 ]

It's important to undo pm_runtime_use_autosuspend() with
pm_runtime_dont_use_autosuspend() at driver exit time unless driver
initially enabled pm_runtime with devm_pm_runtime_enable()
(which handles it for you).

Hence, call pm_runtime_dont_use_autosuspend() at driver exit time
to fix it.

Fixes: 944c01a889d9 ("spi: lpspi: enable runtime pm for lpspi")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Link: https://patch.msgid.link/20240906021251.610462-1-ruanjinjie@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-lpspi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-fsl-lpspi.c b/drivers/spi/spi-fsl-lpspi.c
index 8ecb426be45c7..977e8b55c82b7 100644
--- a/drivers/spi/spi-fsl-lpspi.c
+++ b/drivers/spi/spi-fsl-lpspi.c
@@ -986,6 +986,7 @@ static void fsl_lpspi_remove(struct platform_device *pdev)
 
 	fsl_lpspi_dma_exit(controller);
 
+	pm_runtime_dont_use_autosuspend(fsl_lpspi->dev);
 	pm_runtime_disable(fsl_lpspi->dev);
 }
 
-- 
2.43.0



