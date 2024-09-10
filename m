Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A1C5381A;
	Tue, 10 Sep 2024 10:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963735; cv=none; b=n3jIDdtlnPqexEtu9OjTD8JyZzMYQLaWnNjbl4X/8SDBqN6nRIjCnbBAWuzDNpj9JtW0FaNhRs1NqgeVWFaKhQ4BXZAFEOpFTPq+ATwfnzE8ZzkSeDs844CNVqhpaUDpDMIR+be6gNNnuJn3q2MZ2BnvHY1QTdFgKDri8PO2ycg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963735; c=relaxed/simple;
	bh=gsFR4DTXDBcBBo5VBqSV5jrc+pGR73Mq0RIWG5IN86s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JSQ7+szwqayEERe1E8fIm0VbmcKS7tUvBsJIw++77Q0mFnRyAwETpIjCABxKc7dzYJFuvh6C6PPTcZzMbvNNm8agwCuZUSYsFfmBxOniRLxbxlUYa1VJnvyQ61LnlmfCuFHFpEbjqezi+7euaA8Rba6uzQDEPpIQE1Kut488Yiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CXtC6emR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CXtC6emR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96E32C4CEC3;
	Tue, 10 Sep 2024 10:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963735;
	bh=gsFR4DTXDBcBBo5VBqSV5jrc+pGR73Mq0RIWG5IN86s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CXtC6emROXt1m3MopaOsHeioiyF+z1RbOfFIGANwljhGlMYjuAC+BVTKeYu/TP6li
	 4txt+YK5N4KeQLEv9lieeym5QWqsfThGa8M5u3P1Y7cYxUYF7tNeo+qx0JEiq4By0l
	 jrTftZagwpkxDb/vO887twwL2D0NTvOiaBysBMPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 159/214] i3c: mipi-i3c-hci: Error out instead on BUG_ON() in IBI DMA setup
Date: Tue, 10 Sep 2024 11:33:01 +0200
Message-ID: <20240910092605.209577906@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jarkko Nikula <jarkko.nikula@linux.intel.com>

[ Upstream commit 8a2be2f1db268ec735419e53ef04ca039fc027dc ]

Definitely condition dma_get_cache_alignment * defined value > 256
during driver initialization is not reason to BUG_ON(). Turn that to
graceful error out with -EINVAL.

Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Link: https://lore.kernel.org/r/20240628131559.502822-3-jarkko.nikula@linux.intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/mipi-i3c-hci/dma.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/i3c/master/mipi-i3c-hci/dma.c b/drivers/i3c/master/mipi-i3c-hci/dma.c
index 5e3f0ee1cfd0..b9b6be186438 100644
--- a/drivers/i3c/master/mipi-i3c-hci/dma.c
+++ b/drivers/i3c/master/mipi-i3c-hci/dma.c
@@ -291,7 +291,10 @@ static int hci_dma_init(struct i3c_hci *hci)
 
 		rh->ibi_chunk_sz = dma_get_cache_alignment();
 		rh->ibi_chunk_sz *= IBI_CHUNK_CACHELINES;
-		BUG_ON(rh->ibi_chunk_sz > 256);
+		if (rh->ibi_chunk_sz > 256) {
+			ret = -EINVAL;
+			goto err_out;
+		}
 
 		ibi_status_ring_sz = rh->ibi_status_sz * rh->ibi_status_entries;
 		ibi_data_ring_sz = rh->ibi_chunk_sz * rh->ibi_chunks_total;
-- 
2.43.0



