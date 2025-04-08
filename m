Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0818F2686B9;
	Tue,  8 Apr 2025 11:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111599; cv=none; b=HAnFXFcsBk/CnEd8ZgFtED+FzdpNURnh6riagNDkKf35KStGPMzCP5/j9ngmfm+islZ0tNcdZBs8POvx2C25meiO54aALM6IE6RVh0qXweF6A2Cc+/5eC3V6K5aUPLh64+Vu81Et4wYuUHdYSo73Zm/B6ZIjaWNh1mOha1Ah5Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111599; c=relaxed/simple;
	bh=KYSGD5rW554IDLHIqRHsnXkrtJU2i+uFCbwSWwLgGc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XYz+kidXII82rE2qpt3vfKN0exTt3HKr/EQtTc/QLxg80v/yAnw+b8MJnt9J4+3LyWvUWl0aXZdFn+y5T1VR/2BIZiJHDpCY43T4ktgClBsbxCnniH8Sx7q53OPKBxru2oeoiaZbIHJ8Tcd/jHydAfZO5txlY9jyEcBdyc68Ptk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gJgdJP96; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gJgdJP96"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62663C4CEE5;
	Tue,  8 Apr 2025 11:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111598;
	bh=KYSGD5rW554IDLHIqRHsnXkrtJU2i+uFCbwSWwLgGc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gJgdJP96nhBCH7ZvL9a0nb3k3YN7cJy+m9aiJhJde0of4ZVzQ5H3p34ZnIIHQJN/g
	 CM12QkZ5sneKW3rs+lxNe/64SrYz+bixxfbsUnoHvoMhEVwC7xrqIynI2nNDATZNMH
	 xBc0NELmQIw9XOgsCIMeVsH48ZezXwrJS89d4cis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 489/731] dmaengine: ae4dma: Use the MSI count and its corresponding IRQ number
Date: Tue,  8 Apr 2025 12:46:26 +0200
Message-ID: <20250408104925.651261624@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Basavaraj Natikar <Basavaraj.Natikar@amd.com>

[ Upstream commit feba04e6fdf4daccc83fc09d499a3e32c178edb4 ]

Instead of using the defined maximum hardware queue, which can lead to
incorrect values if the counts mismatch, use the exact supported MSI
count and its corresponding IRQ number.

Fixes: 90a30e268d9b ("dmaengine: ae4dma: Add AMD ae4dma controller driver")
Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Link: https://lore.kernel.org/r/20250203162511.911946-3-Basavaraj.Natikar@amd.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/amd/ae4dma/ae4dma-pci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/amd/ae4dma/ae4dma-pci.c b/drivers/dma/amd/ae4dma/ae4dma-pci.c
index aad0dc4294a39..587c5a10c1a8b 100644
--- a/drivers/dma/amd/ae4dma/ae4dma-pci.c
+++ b/drivers/dma/amd/ae4dma/ae4dma-pci.c
@@ -46,8 +46,8 @@ static int ae4_get_irqs(struct ae4_device *ae4)
 
 	} else {
 		ae4_msix->msix_count = ret;
-		for (i = 0; i < MAX_AE4_HW_QUEUES; i++)
-			ae4->ae4_irq[i] = ae4_msix->msix_entry[i].vector;
+		for (i = 0; i < ae4_msix->msix_count; i++)
+			ae4->ae4_irq[i] = pci_irq_vector(pdev, i);
 	}
 
 	return ret;
-- 
2.39.5



