Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B903D34A9;
	Thu, 15 Jan 2026 17:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499983; cv=none; b=o5wvtnmIbLjjVY6WqteJLIgrTXffTEW9xq7qn3OhxSlRjRCSfdwKsEW/AtXUUQ9/KgMuqg1fBpnI3vY77/bLiyhjh2JBRU0IKtEXg940vXX7gvputQMW7ITc1rsWcToZgaQie9VPzOuYSHNYzKUyaVKdm971fqWFhQRlTVRePmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499983; c=relaxed/simple;
	bh=UbfMr6eKH4uzB+Ix8aALs+8NC4iaOem1sCJPdfH2L98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RwKWrkPKdRTc/c6w8Lf3rvBahyL3s+1anejZPSRG+5xDrgd/KzqB6C3M+hC9cmKKzEJQooKcrbAUkbufnw8zwS917j0kUMjOXvYPrRsCoNcQJXU6/ua3cpBhlK2+h2c2rsWczhwMqaW2SUeJEkf22kI4QOfX7nPIK69T1dYqUQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HyQPPsEV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HyQPPsEV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04319C116D0;
	Thu, 15 Jan 2026 17:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499983;
	bh=UbfMr6eKH4uzB+Ix8aALs+8NC4iaOem1sCJPdfH2L98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HyQPPsEVgzlHFKaVhHq/yT8KJTKWUjXe2L5hou+6N9x9PStQj1BGauQ+xQnl4s8j0
	 OVNwe1PzzUxAk8C2+l/G05euAtnNOnx7FhMjGWkL7Cq10gblSxkphdsaE4a7apydVZ
	 sCZJWoSZn0oplHzC2hs7/5GeTo3KbeRtFs+plyjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 410/451] atm: Fix dma_free_coherent() size
Date: Thu, 15 Jan 2026 17:50:11 +0100
Message-ID: <20260115164245.772333991@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fourier <fourier.thomas@gmail.com>

commit 4d984b0574ff708e66152763fbfdef24ea40933f upstream.

The size of the buffer is not the same when alloc'd with
dma_alloc_coherent() in he_init_tpdrq() and freed.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: <stable@vger.kernel.org>
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Link: https://patch.msgid.link/20260107090141.80900-2-fourier.thomas@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/atm/he.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/atm/he.c
+++ b/drivers/atm/he.c
@@ -1590,7 +1590,8 @@ he_stop(struct he_dev *he_dev)
 				  he_dev->tbrq_base, he_dev->tbrq_phys);
 
 	if (he_dev->tpdrq_base)
-		dma_free_coherent(&he_dev->pci_dev->dev, CONFIG_TBRQ_SIZE * sizeof(struct he_tbrq),
+		dma_free_coherent(&he_dev->pci_dev->dev,
+				  CONFIG_TPDRQ_SIZE * sizeof(struct he_tpdrq),
 				  he_dev->tpdrq_base, he_dev->tpdrq_phys);
 
 	dma_pool_destroy(he_dev->tpd_pool);


