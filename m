Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F19622258C;
	Mon,  2 Jun 2025 14:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873124; cv=none; b=nvQAbbHv7VHXORHESseD2wLM6DxTcY+uJgXhaGvWoB/tvemoB0RIePH1MVj8VN0hDCMnIOKtZQ/ThEd43XSpExMNP07W6Q1jf3y+1VX4zTuwb9xlJqqsGNO8XfvVlHo1fRgohlELaHTiZGN4WYMA8JHDunS6OuTqGx0enxFHwiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873124; c=relaxed/simple;
	bh=s8mxoWpcfgVxP+cTFvFWa6or3AJJL7jZEH72qY3sMec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hPgfrGcACUQtRqbAIydHXBU1H9aaBG7lL139YrnjeD4vMybEE3zLXM7qejtCmr+Xjxb4nfUCmjhSauh/JPHMk2MwCm2zgG3XZUnDeKmby+t8xfcPvxyXwlsi3THNqFsGMGQ2q3EOPTIbtgP3LYwUgSCk6AFaZlqHZqrJLOHuye0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z8xGaYAq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z8xGaYAq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07550C4CEEB;
	Mon,  2 Jun 2025 14:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873124;
	bh=s8mxoWpcfgVxP+cTFvFWa6or3AJJL7jZEH72qY3sMec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z8xGaYAqxIqa1ILY/qEXRCNAJ6F+ZR32WUK6wbWRfC/VXbmUJ98jbhk0P4/2jQEfx
	 a1aTUw7hxD17/7X1DwhHSRCa03iCmqEHdnEpYCheO3pcrPX8ZTvJN/QzpAE2FAonXu
	 uP2ytntv3vq83FNZO5A2GtB5AclEU1ix4U3/XI0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 015/444] nvmem: core: verify cells raw_len
Date: Mon,  2 Jun 2025 15:41:19 +0200
Message-ID: <20250602134341.528550292@linuxfoundation.org>
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

[ Upstream commit 13bcd440f2ff38cd7e42a179c223d4b833158b33 ]

Check that the NVMEM cell's raw_len is a aligned to word_size. Otherwise
Otherwise drivers might face incomplete read while accessing the last
part of the NVMEM cell.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20250411112251.68002-10-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/core.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index 3ea94bc26e800..3d69c76f19236 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -467,6 +467,18 @@ static int nvmem_cell_info_to_nvmem_cell_entry_nodup(struct nvmem_device *nvmem,
 		return -EINVAL;
 	}
 
+	if (!IS_ALIGNED(cell->raw_len, nvmem->word_size)) {
+		dev_err(&nvmem->dev,
+			"cell %s raw len %zd unaligned to nvmem word size %d\n",
+			cell->name ?: "<unknown>", cell->raw_len,
+			nvmem->word_size);
+
+		if (info->raw_len)
+			return -EINVAL;
+
+		cell->raw_len = ALIGN(cell->raw_len, nvmem->word_size);
+	}
+
 	return 0;
 }
 
-- 
2.39.5



