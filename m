Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF3920F07C;
	Mon,  2 Jun 2025 14:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873127; cv=none; b=Ug8Prm6lrw9LNl0kzh6uE/GfKFwsd7zS5njlLEG2lKJPHqsBZ1NWJoe8/17YAaTaFTxU20o01cFYdcsEMyfsuTPfIVsCQAKoddYxSW7Yfu5+UI8GNGOzNF6qFbM4z/2zPKHM0BJyUNJhLwEt68JfZTXAgPgjJYJMrEnJLIlM4Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873127; c=relaxed/simple;
	bh=6+8rqWHnu6fa0cMkIY1NPMVHZH+kF0cGn05bXAtUAw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PbpMdtR9c0XbfwLVZkRrCO7u4HRXj0ABqnOjondQzec58ceJobiEfjlQqPcxK+HTj1oWH9lflBGofL2fhtN3sMT8LnoVlY57R/8CItYvzAO3PAh5pqxWV5Lg1PUoPsKqcGVL/G+VgrGPdZOt7nglx0Umhj8YHSVjcjRvkf8nzGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D/WK9FED; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D/WK9FED"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00832C4CEEB;
	Mon,  2 Jun 2025 14:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873127;
	bh=6+8rqWHnu6fa0cMkIY1NPMVHZH+kF0cGn05bXAtUAw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D/WK9FEDztSi0e4GzmsK00VA0dSshyNrn5dk9aP6cy4jMs6t9iedZj7sGlfqTXGdk
	 aKUZHFD+XXjADv41KIaDlql2dApfLcVrVcfHllHU3pxgjUL0JowolycnyzkpCue9DM
	 9zGlQKute8eArJe1kUC0KNfwYlMT3rScNeXHv1Vw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 016/444] nvmem: core: update raw_len if the bit reading is required
Date: Mon,  2 Jun 2025 15:41:20 +0200
Message-ID: <20250602134341.569484357@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 6786484223d5705bf7f919c1e5055d478ebeec32 ]

If NVMEM cell uses bit offset or specifies bit truncation, update
raw_len manually (following the cell->bytes update), ensuring that the
NVMEM access is still word-aligned.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20250411112251.68002-11-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index 3d69c76f19236..dd00cc09ae5ec 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -456,9 +456,11 @@ static int nvmem_cell_info_to_nvmem_cell_entry_nodup(struct nvmem_device *nvmem,
 	cell->nbits = info->nbits;
 	cell->np = info->np;
 
-	if (cell->nbits)
+	if (cell->nbits) {
 		cell->bytes = DIV_ROUND_UP(cell->nbits + cell->bit_offset,
 					   BITS_PER_BYTE);
+		cell->raw_len = ALIGN(cell->bytes, nvmem->word_size);
+	}
 
 	if (!IS_ALIGNED(cell->offset, nvmem->stride)) {
 		dev_err(&nvmem->dev,
-- 
2.39.5



