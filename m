Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC7C1D0B93;
	Wed,  2 Oct 2024 14:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878520; cv=none; b=UEc7Rpeet+qdFo7IudYreN4AiZMP9W5hDOJybOj16a0yM8LnZU8GO4bZ8ggmf86u8Chb+vrdEz3G4D4qsaUhrzSBXJQ0nvFGxqxq+6a4JIxnF6e2rtmyw9wPy9zE37VZ6fPUJeAIxNjCN+ej9zXhfnxsV1Mr7MdGXmFsU38SPR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878520; c=relaxed/simple;
	bh=JjSqfnKDXxqf/K2MzrUrm2ASpa5xfAj5beNgNc+V3UA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iuz4EK3EjDp9TCWl1liHLoq2jgccY6+xUv2C3Yrv/eMB1swOMNN37FWheYKW0TncNhlBIORZjQbjcu07oXwxAiz5nbRcuK52zB1CuUbhSJDviqMRZnsZSApvCVEqPCpeUjGXez9YMd1soDqmT1UgSyJ5UWadLoJjVqCn4JfxDvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m5aC5wNK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m5aC5wNK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56AA9C4CEC2;
	Wed,  2 Oct 2024 14:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878519;
	bh=JjSqfnKDXxqf/K2MzrUrm2ASpa5xfAj5beNgNc+V3UA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m5aC5wNK22xFF/XlCc9ZTbztWL2nDzjcqxVP8IbO2lZNKurZvOUAN+VEk4/W5yuzc
	 NhFCp+auUBBZek4mHbDsiE4aiT+YGvb3nP+eFSGyEKSFswODPHgGtPr2TMdDa8FbT3
	 d6NnawOuvbNl+f6aSXpiwN9TydD4kDyIMO8Bd3qs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 410/634] spi: spi-fsl-lpspi: Undo runtime PM changes at driver exit time
Date: Wed,  2 Oct 2024 14:58:30 +0200
Message-ID: <20241002125827.290402747@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index d2f603e1014cf..e235df4177f96 100644
--- a/drivers/spi/spi-fsl-lpspi.c
+++ b/drivers/spi/spi-fsl-lpspi.c
@@ -986,6 +986,7 @@ static void fsl_lpspi_remove(struct platform_device *pdev)
 
 	fsl_lpspi_dma_exit(controller);
 
+	pm_runtime_dont_use_autosuspend(fsl_lpspi->dev);
 	pm_runtime_disable(fsl_lpspi->dev);
 }
 
-- 
2.43.0



