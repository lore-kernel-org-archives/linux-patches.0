Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4665AD5A;
	Tue, 27 May 2025 16:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364406; cv=none; b=AzITorOiSM+GOjeMIfvV2Ub/X7H5XjxOJANeiAUyZMUxJIJ8vrSrz+LdsHQYUiYguYfNhLmnHmQ0WS257j/yREv5VWT3FjeK8xMbUqEouNsbxumnqQap0qX37fSU9BHQNQjE7Vmt/T6LSVwdcyl5tvu5OBlJ4xb1UNvI/HWzZhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364406; c=relaxed/simple;
	bh=gms+Vjq3srMCDZuapFe5Ud764auXWntTjnqFPmrkBSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BungmhOQp2/YCy6lRArksCfFWrK35EKbJyBMdM8QHN9ShobuMsMVIDK6/BN88MKovZFQyCIML9Zoa87k1BrvCvdtO9cFbhnBP0k9qssoMv2EipJslh58Y87o2x6EiTcJmXDgHp2A9i3rTtYhGxYm27D86aLs+b4KoqEfTwRJIoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lNy6YlTO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lNy6YlTO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5378EC4CEE9;
	Tue, 27 May 2025 16:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364406;
	bh=gms+Vjq3srMCDZuapFe5Ud764auXWntTjnqFPmrkBSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lNy6YlTOpivWXVw2645+Ef/fe02SNZDX8Psd9CTre1XEwyeOaYRlFHhruCgQtf4jr
	 VgTnelE9z517VBN6gQvz1wR0XoXSm6Qlryjvc3nWOUHRaqKHGblE0n5n43gJcIsKTR
	 nwYcGU8fuHOFhk2ZmJbJZa1WR6aTwR9mly252044=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 015/626] nvmem: core: update raw_len if the bit reading is required
Date: Tue, 27 May 2025 18:18:28 +0200
Message-ID: <20250527162445.680453469@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3671d156c7c33..d1869e6de3844 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -581,9 +581,11 @@ static int nvmem_cell_info_to_nvmem_cell_entry_nodup(struct nvmem_device *nvmem,
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



