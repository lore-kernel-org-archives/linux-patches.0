Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F7093446C8;
	Wed,  3 Dec 2025 15:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777493; cv=none; b=ChBiNl9CvdUvBiRKqaU/HMWx0GQlxjtnw8HGM4wecCuA6RatXyLcujWRq3963HZct4I45i0FqnExZL80Jguu6r6WnRZWBopBZeLsdAqE5MDxnJxU0hkmEF/KG8S1HQROTfelWC0iN+A5V5qX3J5/vB78UNE6PjXRfo0GSpPVssI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777493; c=relaxed/simple;
	bh=tfu2kGEFWeKa0WrFtwPIJkzdQlYzJ7z+oC8o+kcXGKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=StrE1P+WT2cHPs0Kl2pZ+NsByWly0dbx7oxwGYkQy6Vhh15l9PlvMJJZ8l3UJ0KsQ8hq1u96JDQmLj58wKgE2RhtTaDG7o4emhcJ+tJM+djUzOrGsi2CugDwIKJvTX9KnTlQzZfQrkHZQbAxBCxzHYIh9jss8DN7x3wsEupJLFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=12KiV0cH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="12KiV0cH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB336C116B1;
	Wed,  3 Dec 2025 15:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777493;
	bh=tfu2kGEFWeKa0WrFtwPIJkzdQlYzJ7z+oC8o+kcXGKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=12KiV0cHadB0oUUoxz/b7KyUEzMbpiTX90O/x5ujMJDUQWDFs2keYhqPm3rXLbx2G
	 27Oq7wzVHX8fodgqpg9qiomFLWVyj6LYz5qLxBdsMsCmgzkqCOZ2igcRAf4Wb52lC/
	 b0W9v4QOhauhE+7o0FZDRXFW1AHbsopCkl7FT5XQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Reidel <adrian@mainlining.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 054/392] soc: qcom: smem: Fix endian-unaware access of num_entries
Date: Wed,  3 Dec 2025 16:23:24 +0100
Message-ID: <20251203152416.102021368@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Reidel <adrian@mainlining.org>

[ Upstream commit 19e7aa0e9e46d0ad111a4af55b3d681b6ad945e0 ]

Add a missing le32_to_cpu when accessing num_entries, which is always a
little endian integer.

Fixes booting on Xiaomi Mi 9T (xiaomi-davinci) in big endian.

Signed-off-by: Jens Reidel <adrian@mainlining.org>
Link: https://lore.kernel.org/r/20250726235646.254730-1-adrian@mainlining.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/smem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/smem.c b/drivers/soc/qcom/smem.c
index 4fb5aeeb08439..ec01cae7ffc8a 100644
--- a/drivers/soc/qcom/smem.c
+++ b/drivers/soc/qcom/smem.c
@@ -710,7 +710,7 @@ static u32 qcom_smem_get_item_count(struct qcom_smem *smem)
 	if (IS_ERR_OR_NULL(ptable))
 		return SMEM_ITEM_COUNT;
 
-	info = (struct smem_info *)&ptable->entry[ptable->num_entries];
+	info = (struct smem_info *)&ptable->entry[le32_to_cpu(ptable->num_entries)];
 	if (memcmp(info->magic, SMEM_INFO_MAGIC, sizeof(info->magic)))
 		return SMEM_ITEM_COUNT;
 
-- 
2.51.0



