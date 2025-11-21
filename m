Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01FC4346E72;
	Fri, 21 Nov 2025 13:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732282; cv=none; b=sq5exENzo0eDD7P2W1iTmI32ObcUgxuysrUhpShpJJnJO35ZqeZAT2y21cBAHnQy4g10+wqPPgCBC9f2phNi8nP3wGwU9LqQSQWzucAPzUjkZgUYfR/0BZdYKEH4CSXzgXaAgAlkf6KPfwlV6/3YLFqbpyn7ZxSUXB8uK5W5/CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732282; c=relaxed/simple;
	bh=gW9nrDJ3TnOm5F3Bjq9ox27YkwPWmPbAEzYxGFYdW2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hdaaOr8Njri3jyyBJ7LgB5YI1qQ6nMLjmIVq57egU38E9s978TNffLfmKhSfC2RQVrsxAoXV42VGbVTMIQlxY9jwbbCW8vP8mfsAaIHvyV0cQQUqEivvLzrnKcZ7u90WN4ZH6sm/3+gdkVqF2uKC/EOcDyvOA2/Eqdk3xu7xd98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pmeFDqih; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pmeFDqih"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29122C4CEF1;
	Fri, 21 Nov 2025 13:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732281;
	bh=gW9nrDJ3TnOm5F3Bjq9ox27YkwPWmPbAEzYxGFYdW2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pmeFDqihxm7LRxmLcEaFOy5t61CvOQFdrYzS3g1btKLhFjg/aTepwPLobGrJwM/H1
	 lpZJ2gj///jspBw4fYaM5Ev+EX1NvONe0SJ/mJvaFgXenbvFv3Z9wKYtMbn6NHTcs7
	 pq6ylMAE+Flb+WEhSmsK0psVasVoERCqUIlMt6wY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Reidel <adrian@mainlining.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 059/529] soc: qcom: smem: Fix endian-unaware access of num_entries
Date: Fri, 21 Nov 2025 14:05:58 +0100
Message-ID: <20251121130233.121865358@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2e8568d6cde94..aead7dd482ea3 100644
--- a/drivers/soc/qcom/smem.c
+++ b/drivers/soc/qcom/smem.c
@@ -870,7 +870,7 @@ static u32 qcom_smem_get_item_count(struct qcom_smem *smem)
 	if (IS_ERR_OR_NULL(ptable))
 		return SMEM_ITEM_COUNT;
 
-	info = (struct smem_info *)&ptable->entry[ptable->num_entries];
+	info = (struct smem_info *)&ptable->entry[le32_to_cpu(ptable->num_entries)];
 	if (memcmp(info->magic, SMEM_INFO_MAGIC, sizeof(info->magic)))
 		return SMEM_ITEM_COUNT;
 
-- 
2.51.0



