Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD2E2359701;
	Wed,  3 Dec 2025 16:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778882; cv=none; b=gUefVyh1sdHNqI5byOGsWlzB4L9fhvGEHOm/PzEpGu8ib4NX+mud8oQCaZUqrIIbDsWDdX9P5tInAUhOz4axVsZy6MCOYlFkVhQLSYP4onIAm8VAAQI2FQKcPr7OK3+l4vppS2a0Kdz+/9ijNxPbRSX5YO7qoyr355rw2o/vMFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778882; c=relaxed/simple;
	bh=GD8YwcmNRz36chIwbcMwzZkGIJtjDHwMexNWUTOHYIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=naICVjA/7NRn/yIbjC3ordAf+xu08tziH8U0fiRb+bg9BA7Bfz8Mn0BmVJVFJpA1KNvMZl9wxrIbkoqAySd8+7L3zUyd5ocoM5mrdBp+pfroNW39TsSJpZd0wo2M05p85ioQya6Ea1Q3TbPnaO0bxsparZTxu93hQfJRrFEexkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2S/n2K7G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2S/n2K7G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5066FC4CEF5;
	Wed,  3 Dec 2025 16:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778881;
	bh=GD8YwcmNRz36chIwbcMwzZkGIJtjDHwMexNWUTOHYIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2S/n2K7GZXnLP3thQGzyLYfwOlYBTi6TKkTBMuDKNvSPkknbQGNFS8BySvEvQ45cb
	 zYNTaKpTYSsGv0zdCedwIZn82r2M+VQc1+kO9jSlcW9CQcTn81jRRiNcAbHb+P64rM
	 OJ8OuOoxRUB4qFo4rs2XpgGXp684qM/oH25hSQ0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Reidel <adrian@mainlining.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 088/568] soc: qcom: smem: Fix endian-unaware access of num_entries
Date: Wed,  3 Dec 2025 16:21:30 +0100
Message-ID: <20251203152443.961448585@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index af8d90efd91fa..e4e6c6d69bf55 100644
--- a/drivers/soc/qcom/smem.c
+++ b/drivers/soc/qcom/smem.c
@@ -810,7 +810,7 @@ static u32 qcom_smem_get_item_count(struct qcom_smem *smem)
 	if (IS_ERR_OR_NULL(ptable))
 		return SMEM_ITEM_COUNT;
 
-	info = (struct smem_info *)&ptable->entry[ptable->num_entries];
+	info = (struct smem_info *)&ptable->entry[le32_to_cpu(ptable->num_entries)];
 	if (memcmp(info->magic, SMEM_INFO_MAGIC, sizeof(info->magic)))
 		return SMEM_ITEM_COUNT;
 
-- 
2.51.0



