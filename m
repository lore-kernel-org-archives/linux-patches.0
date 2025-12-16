Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B55483570B0;
	Tue, 16 Dec 2025 12:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886565; cv=none; b=R9v0thWZg1yo8AQJiGJuJIqALtpgivIBLm6OWfM6n4CbbNW6tiufhflQOk8DMkahhaMgd+jM2ygfeTUEgDBd1FB4Zuvgypa7w9JkHUGQ6YN8hAEf9RrxAVMlTSfSQQdGcNLH7szs0H6hbOCCYDC9oknkVSOrOMcqoKmC+58utEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886565; c=relaxed/simple;
	bh=F0wRWCHv301nBoHLl02cfe8Luh0w86uHt0Qqjri88Kg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aBsVg2bF/kALWt1qq8Xy3oSxbVZuQbYp6eNekDE5xuyyPP69IAbepkQH8nkk+4w9V1np18xrJA6N7CvVVgEi8XL35bsLB5ddPAp1yxUdZ9gUM5wbhSbTUizP5bKQeKHAIBMkdDxEgX+p5eQ3WDtxQnUJzf8loPV5CxiSXdpqDFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=grZ7rLrV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="grZ7rLrV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D92BC4CEF1;
	Tue, 16 Dec 2025 12:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886565;
	bh=F0wRWCHv301nBoHLl02cfe8Luh0w86uHt0Qqjri88Kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=grZ7rLrVtYAT8MiXn/RMSM/3DLvsdLJdiKDgpDi0NYO6eEq56AoNIvHWJTnLpTA6N
	 TQhUItFlnxHRSVFmaZOVTQpKkYDgmqd4kploSg6YRLPw0Zku9UPhnvZl66aLrGaUUh
	 THN+UAfS44DTUmyj/t1EnAYpzFCSHEqmFbkfsqXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaogang Chen <xiaogang.chen@amd.com>,
	Philip Yang <Philip.Yang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 475/507] drm/amdkfd: Use huge page size to check split svm range alignment
Date: Tue, 16 Dec 2025 12:15:16 +0100
Message-ID: <20251216111402.651664785@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index fab6e7721c803..2850356b018db 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -1144,30 +1144,48 @@ static int
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



