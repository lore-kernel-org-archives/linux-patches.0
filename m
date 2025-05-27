Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1261DB34C;
	Tue, 27 May 2025 17:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366267; cv=none; b=LkR6GPBZeOTa9XvFHFuRcz0CM3hGpoykeFj1XfdxgUuzDGJYEsj63n2hwX/sE2+5HbihJPs7oIwr0i2Ye5lr6uKrTeqT90YQqPRbIKZj6KNhx6GK1v1rG8S5PBlACPvP2yEdr/X0FhEXDjkAxKu87YISVQkLL96Sod7ixzwCpEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366267; c=relaxed/simple;
	bh=ujRQuwzpptLoz4WiglZiMKlMphQ0rPIJnGIz7ZBw95M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L81VYulVMLlGr3X/laecUQxtOZ8hnMVf1WckPpZs91ZW3tZ0o/s6xPy7LFE1CbINoW6r37lhBASJPyoqmjMP4fMz/iGuyuC4WaovLBy7Ji/uUV6/+n1phC1JxLtoAV60TVp/tP9MF7F3NMwpVeg4g1Kd98xR8X07+FEM4xB7XhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HzSmso3K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HzSmso3K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF89EC4CEE9;
	Tue, 27 May 2025 17:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366267;
	bh=ujRQuwzpptLoz4WiglZiMKlMphQ0rPIJnGIz7ZBw95M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HzSmso3K2n/l+AQSFmal157GbgqWwMsWUgWhxg4mcM76s/aYNz2fD6YJaW15El/ut
	 hmgtjSJ8CNk5QoAGDyp4cVCyvdHF5SXmJWmXhO20CyibaU5uiQMo9gP9Nweb7Dhccq
	 VGxTYehGZx1dLVt5MvGsI8jvFjQC1whXcDnc7oKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 014/783] nvmem: core: update raw_len if the bit reading is required
Date: Tue, 27 May 2025 18:16:51 +0200
Message-ID: <20250527162513.626694456@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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
index 7b8c85f9e035c..e206efc29a004 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -594,9 +594,11 @@ static int nvmem_cell_info_to_nvmem_cell_entry_nodup(struct nvmem_device *nvmem,
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



