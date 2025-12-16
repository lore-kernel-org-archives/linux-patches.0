Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF9B239656B;
	Tue, 16 Dec 2025 12:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888586; cv=none; b=cuX+ZPkTjfRSjBqCqabm3NJS1yjqNXeS3+Y4wZ4rsVyuo6goqvwr3mcNKdXAxN6LvPt7oT5GAU8ulnMJlTOMLPN+QhjATr/z24p4NPbdBXswYU8kMMzP0JBvOPWf3rEbQUvDQrC2oDggXGfySYVJLz7IfmlzEdc9UjNC5ExkaJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888586; c=relaxed/simple;
	bh=gKRU8H+V7A0sTZDHI0b8RneITalQvAFrxvnhcnJ2wDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xt9DOJbsSrxPp1UYDF/Blwjj9U2zIa05Z1BHQKg6rrTt9LV+EZqDpn6eAi1arGMXE2AHGwnuVSWE2VFHet2sAsylcU0xRTMYRgTA1/VOhmDKO2vs9eB4Avr5jNMVhanKQSBLx1Uus/AwDkUNqU3DPkzhWV0OnYOZi83jvYWJV8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iULC6hWN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iULC6hWN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A75F4C4CEF1;
	Tue, 16 Dec 2025 12:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888586;
	bh=gKRU8H+V7A0sTZDHI0b8RneITalQvAFrxvnhcnJ2wDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iULC6hWNhIsv0Gp59GESTCmNYjCPAch+mNkGLR6pVer/PSOpcLs5vGtVW2glVyvOD
	 oT1UEFj/RsvA5NPe4GpBrwD1Qv+XkESLZQUNRLCWpT3OYFtTa/RAzInpmHZb1oJ4Sd
	 9MJGpf2IgB3GrAP/Er4jLPLlJR09HL4wnqvkaUvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaogang Chen <xiaogang.chen@amd.com>,
	Philip Yang <Philip.Yang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 579/614] drm/amdkfd: Use huge page size to check split svm range alignment
Date: Tue, 16 Dec 2025 12:15:46 +0100
Message-ID: <20251216111422.362834367@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 74a1d3e1d52be..49dd0a81114e4 100644
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



