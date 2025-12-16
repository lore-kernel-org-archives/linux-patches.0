Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8BF341AC3;
	Tue, 16 Dec 2025 11:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884895; cv=none; b=mK6UFlWJlTLEhQkz4NPF5zWaX3IBacMFdBTfbteZtQgldqyeszPkByvflkkcXjBapuQ+qjE4kvLuY4Ug7/Lzgum3JkMm1Nxv6MYJP1v/vVIfXK9BR4HSgpuu/OTgEIjMHKWO8FQ2mjlI6R3jkPmg4J3am097afeyKcincBjAvzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884895; c=relaxed/simple;
	bh=M2PmgGJQ+dYzYbxOasY8hgPDliYqJRU7LK4KaE+zXSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JR1Mv26OPYdQQXBUXn6STACz2ND19/qMZJoBAYD4zN7vfF0jLY+cwfC5QZ/rw65WKvTk/gL2pCnO3t0BujGsuvEZ1zkANp/sScuXwNkGvBx3b5UHPMNn/+A+wOd3OZXutJ09/p5S8rBpqkTrVvGDo/kzSKQBm7lyzi69y7j7mws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GiM7cuJJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GiM7cuJJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13086C4CEF1;
	Tue, 16 Dec 2025 11:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884895;
	bh=M2PmgGJQ+dYzYbxOasY8hgPDliYqJRU7LK4KaE+zXSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GiM7cuJJLM0dryAf+tUY9cl+XqU53r1bbRRX7SqK06qCWwFekLZMK+G3qMxJzo4md
	 eCwzxeVxKOGAblgJCTjkq1zigRQ/b4C8akQecOwOOebPIVKD79NZ422Vpn4Li4NbeE
	 mEq/NAVoxUnis+Nt/QVJkYEYq4qoyxakvzJKeIDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaogang Chen <xiaogang.chen@amd.com>,
	Philip Yang <Philip.Yang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 332/354] drm/amdkfd: Use huge page size to check split svm range alignment
Date: Tue, 16 Dec 2025 12:14:59 +0100
Message-ID: <20251216111332.937548922@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiaogang Chen <xiaogang.chen@amd.com>

[ Upstream commit bf2084a7b1d75d093b6a79df4c10142d49fbaa0e ]

When split svm ranges that have been mapped using huge page should use huge
page size(2MB) to check split range alignment, not prange->granularity that
means migration granularity.

Fixes: 7ef6b2d4b7e5 ("drm/amdkfd: remap unaligned svm ranges that have split")
Signed-off-by: Xiaogang Chen <xiaogang.chen@amd.com>
Reviewed-by: Philip Yang <Philip.Yang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 448ee45353ef9fb1a34f5f26eb3f48923c6f0898)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c | 46 +++++++++++++++++++---------
 1 file changed, 32 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
index 99ce4fe5eb170..d65b0b23ec7b8 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -1143,30 +1143,48 @@ static int
 svm_range_split_tail(struct svm_range *prange, uint64_t new_last,
 		     struct list_head *insert_list, struct list_head *remap_list)
 {
+	unsigned long last_align_down = ALIGN_DOWN(prange->last, 512);
+	unsigned long start_align = ALIGN(prange->start, 512);
+	bool huge_page_mapping = last_align_down > start_align;
 	struct svm_range *tail = NULL;
-	int r = svm_range_split(prange, prange->start, new_last, &tail);
+	int r;
 
-	if (!r) {
-		list_add(&tail->list, insert_list);
-		if (!IS_ALIGNED(new_last + 1, 1UL << prange->granularity))
-			list_add(&tail->update_list, remap_list);
-	}
-	return r;
+	r = svm_range_split(prange, prange->start, new_last, &tail);
+
+	if (r)
+		return r;
+
+	list_add(&tail->list, insert_list);
+
+	if (huge_page_mapping && tail->start > start_align &&
+	    tail->start < last_align_down && (!IS_ALIGNED(tail->start, 512)))
+		list_add(&tail->update_list, remap_list);
+
+	return 0;
 }
 
 static int
 svm_range_split_head(struct svm_range *prange, uint64_t new_start,
 		     struct list_head *insert_list, struct list_head *remap_list)
 {
+	unsigned long last_align_down = ALIGN_DOWN(prange->last, 512);
+	unsigned long start_align = ALIGN(prange->start, 512);
+	bool huge_page_mapping = last_align_down > start_align;
 	struct svm_range *head = NULL;
-	int r = svm_range_split(prange, new_start, prange->last, &head);
+	int r;
 
-	if (!r) {
-		list_add(&head->list, insert_list);
-		if (!IS_ALIGNED(new_start, 1UL << prange->granularity))
-			list_add(&head->update_list, remap_list);
-	}
-	return r;
+	r = svm_range_split(prange, new_start, prange->last, &head);
+
+	if (r)
+		return r;
+
+	list_add(&head->list, insert_list);
+
+	if (huge_page_mapping && head->last + 1 > start_align &&
+	    head->last + 1 < last_align_down && (!IS_ALIGNED(head->last, 512)))
+		list_add(&head->update_list, remap_list);
+
+	return 0;
 }
 
 static void
-- 
2.51.0



