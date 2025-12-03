Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7555430C63C;
	Wed,  3 Dec 2025 15:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764775955; cv=none; b=hGiJyddubhtX3RG3mBRBNFHgaww2RhVd28L26fSq2Qq5JG50mS/UN5G26n0cya9tRkMcsHa+B21JQ0zgwU9bRbf3L0AyAlmMXQpvS2BQJTrfOQZ+MVf5tZjOof4iSZrdSGHexVANJn7S7iTiWwZlIayx+meHctM5TPTixiidCyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764775955; c=relaxed/simple;
	bh=zOzoyTwAQ6VvcCovnwBmvOkmQqbTYd00CnJLE9R5xTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cLYc3V3uLJWP6bnjJdTqYYL2y/FtYRpni3/CN3gUpevZaUAnBH5xjpg+TUBRGB40n1n518cpW7i/zLUUwe0PY9aBO2TClvUFBGmd0MIqLQP+Zi9Pzc43D67zK9CPrFLNlqtckVPZzIqe3M5KAMEJhBGuVx5XBNySWrG0V80rUc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x7XTmgkr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x7XTmgkr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8EA9C116B1;
	Wed,  3 Dec 2025 15:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764775955;
	bh=zOzoyTwAQ6VvcCovnwBmvOkmQqbTYd00CnJLE9R5xTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x7XTmgkrrwKDbqAv41mgR/usE3yWkiB8qkEHM7Y/6uiDV4sffXpSNedmY4nuWggMt
	 5DVRnOLGYzY2kAImZQtdPR14e4iVPeTKXwfjh4wj8rH22A8PAHFYv38aXVGctEM7N+
	 E13upBFPwpyXSgRCVJmYePT5+x8xik6KTmntifXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Reidel <adrian@mainlining.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 038/300] soc: qcom: smem: Fix endian-unaware access of num_entries
Date: Wed,  3 Dec 2025 16:24:02 +0100
Message-ID: <20251203152401.878668198@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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
index 28c19bcb2f205..d2d62d2b378b4 100644
--- a/drivers/soc/qcom/smem.c
+++ b/drivers/soc/qcom/smem.c
@@ -709,7 +709,7 @@ static u32 qcom_smem_get_item_count(struct qcom_smem *smem)
 	if (IS_ERR_OR_NULL(ptable))
 		return SMEM_ITEM_COUNT;
 
-	info = (struct smem_info *)&ptable->entry[ptable->num_entries];
+	info = (struct smem_info *)&ptable->entry[le32_to_cpu(ptable->num_entries)];
 	if (memcmp(info->magic, SMEM_INFO_MAGIC, sizeof(info->magic)))
 		return SMEM_ITEM_COUNT;
 
-- 
2.51.0



