Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4092FB622;
	Tue, 30 Sep 2025 14:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759243877; cv=none; b=AM//kwjsZ0IPfKOE0jOT4E1Gpzq2cSbipfh863YgrtmXp3bB5XfnOG/c0WfmVsvC9V/Z/DqCYkU7WYPxOeuy3k35zUot9h3Wo6p/Fpk2tdFESsKx1R4hLbZkqQHun06JXE1CtgLDJJ8xIP/MZKPLOorVfcUMTiIigGM2G5JIFPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759243877; c=relaxed/simple;
	bh=Rg8Txy1CXOSQmutHcfecL3NvYG7WUlskLwSKZQZp4E8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=duuunhSR7PPx4o1yXQVeE/zPXJZBk2UhdgAic//5S+4S94S6vel2in2cZnBlp+a9As6RDOrfGyfCiwPwzma6p7cGlv4TKAWSQGaf/5gxuY1s35N29n5VvRF6Uoo7FHEw3xuyBwukwAtkQ+lBB+VRmUVTSf5aHmqirsLfRU1zBJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sOIi3hWZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sOIi3hWZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC6E9C116B1;
	Tue, 30 Sep 2025 14:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759243877;
	bh=Rg8Txy1CXOSQmutHcfecL3NvYG7WUlskLwSKZQZp4E8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sOIi3hWZZqztoFfoz06chA7U7M34OBB8xU4fH9+AcSSMxYiYWHch6QpRd/WbQjcQW
	 GD1faOmujgDxqTCDE6VQgCAJB7jissMM+nG0fbumP+w7fNtnOcI4pxbjfs7RlE4oWa
	 mPt37tsTObFZT4HOV0lvf3FHXL4GO/zp+jF5zbGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 44/81] mmc: mvsdio: Fix dma_unmap_sg() nents value
Date: Tue, 30 Sep 2025 16:46:46 +0200
Message-ID: <20250930143821.520968959@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143819.654157320@linuxfoundation.org>
References: <20250930143819.654157320@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fourier <fourier.thomas@gmail.com>

commit 8ab2f1c35669bff7d7ed1bb16bf5cc989b3e2e17 upstream.

The dma_unmap_sg() functions should be called with the same nents as the
dma_map_sg(), not the value the map function returned.

Fixes: 236caa7cc351 ("mmc: SDIO driver for Marvell SoCs")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/mvsdio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/mvsdio.c
+++ b/drivers/mmc/host/mvsdio.c
@@ -292,7 +292,7 @@ static u32 mvsd_finish_data(struct mvsd_
 		host->pio_ptr = NULL;
 		host->pio_size = 0;
 	} else {
-		dma_unmap_sg(mmc_dev(host->mmc), data->sg, host->sg_frags,
+		dma_unmap_sg(mmc_dev(host->mmc), data->sg, data->sg_len,
 			     mmc_get_dma_dir(data));
 	}
 


