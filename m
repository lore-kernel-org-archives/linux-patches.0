Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5681A3FF1B5;
	Thu, 30 Jul 2026 14:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422300; cv=none; b=j2JYjU5IGAJRuCDzABBJoSNMHowKIcBw6iQWzFO/o6L105dNsRRspjjFhJEFJRqMOjcj+CKYmzczs4uwwrBgoGKwOnU6/+VY2wB4LHgQdHLh95k7wp4F70Dn3ar3Rr/QDrNGZ4L55gewMbVHAvLppOv/E3cPrkIivE4JmaMAVHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422300; c=relaxed/simple;
	bh=oPzNLxxdqYGXLlBR+W0JfrXtWowMLhGj94V14CiS0P8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lh8yyTg7/0LIwvzUpzS8vxpqTiXyoma6Fapon4yOXzdwYR/QbIhbsnITGKL7o3qtLMXk9XYYKQaNJaSgTOu6sdtJ9tHr5QNT08s/i6VBeBwv/ppP4/oFWG+p1bD9jJWF1lcThLHz6mL5DMzy2wuIqJRjMecO3yD/1rkseanZfDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iKVClwqR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iKVClwqR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1D001F000E9;
	Thu, 30 Jul 2026 14:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422299;
	bh=LAV1Am0Mlh1kVhEZ5bedGvDyDgJ4d2ajeD58WYKpCKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iKVClwqRQwm3HxfejfixlbuK4/0CBhLx8lCN6a8Uj8oI30VEprLjE5tKuHruoKkLy
	 3JVVcchU864C9f3/A1xVgA4SwsArAFbjsm/cByuCGl4NSJ8yMd2qjbWi/zXOBcZ1vg
	 o6thJdhJ5sBw9MWLCbgnlQuJoQDj0KdUV6JNeXK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaogang Chen <xiaogang.chen@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Gerhard Schwanzer <geschw@pm.me>
Subject: [PATCH 7.1 391/744] drm/amdkfd: Use exclusive bounds for SVM split alignment checks
Date: Thu, 30 Jul 2026 16:11:04 +0200
Message-ID: <20260730141452.598979576@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gerhard Schwanzer <geschw@pm.me>

commit b89d58b6595d79dc3fe75e213e1f4c5efd0251d4 upstream.

SVM ranges use inclusive page indices: prange->last is the last page in
the range. The split-remap logic introduced by commit 448ee45353ef
("drm/amdkfd: Use huge page size to check split svm range alignment")
uses ALIGN_DOWN(prange->last, 512) to determine whether the original
range can contain a 2MB huge-page mapping.

That aligns the last page itself down. Thus a range ending one page
before the next 2MB boundary is classified as if the final 2MB block did
not exist. When such a range is split inside that final block, the
split head or tail can be left off the remap list even though it was
derived from an original range that may have PMD mappings.

Use prange->last + 1 as the exclusive upper bound when computing the
original range's last 2MB-aligned boundary. Then use the actual split
boundary for the head and tail alignment checks: tail->start for a tail
split, and new_start for a head split. new_start is equivalent to
head->last + 1 and directly names the exclusive end of the split head.

Using head->last for the head-side check can both remap a head that ends
exactly one page before a 2MB boundary and miss a head whose split
boundary is one page after such a boundary. Philip Yang pointed out in
the review of the original change that this condition should use
head->last + 1 or new_start.

Xiaogang Chen identified the inclusive-last cause and posted the
candidate fix in the regression thread. With the culprit change active
and the local revert not applied, the unchanged C/HSA reproducer
completes 10/10 runs with this change on an RX 7600 XT.

Fixes: 448ee45353ef ("drm/amdkfd: Use huge page size to check split svm range alignment")
Closes: https://gitlab.freedesktop.org/drm/amd/-/work_items/4914
Link: https://lore.kernel.org/stable/IA1PR12MB85172F7FE9157C092EDA46A0E3112@IA1PR12MB8517.namprd12.prod.outlook.com/
Link: https://lore.kernel.org/all/32ce2b72-aa16-4202-9f99-92e3cd4408bc@amd.com/
Suggested-by: Xiaogang Chen <xiaogang.chen@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Gerhard Schwanzer <geschw@pm.me>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit a60ea15807126b148a328051636977a33ad0e9bb)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -1144,7 +1144,7 @@ static int
 svm_range_split_tail(struct svm_range *prange, uint64_t new_last,
 		     struct list_head *insert_list, struct list_head *remap_list)
 {
-	unsigned long last_align_down = ALIGN_DOWN(prange->last, 512);
+	unsigned long last_align_down = ALIGN_DOWN(prange->last + 1, 512);
 	unsigned long start_align = ALIGN(prange->start, 512);
 	bool huge_page_mapping = last_align_down > start_align;
 	struct svm_range *tail = NULL;
@@ -1168,7 +1168,7 @@ static int
 svm_range_split_head(struct svm_range *prange, uint64_t new_start,
 		     struct list_head *insert_list, struct list_head *remap_list)
 {
-	unsigned long last_align_down = ALIGN_DOWN(prange->last, 512);
+	unsigned long last_align_down = ALIGN_DOWN(prange->last + 1, 512);
 	unsigned long start_align = ALIGN(prange->start, 512);
 	bool huge_page_mapping = last_align_down > start_align;
 	struct svm_range *head = NULL;
@@ -1181,8 +1181,8 @@ svm_range_split_head(struct svm_range *p
 
 	list_add(&head->list, insert_list);
 
-	if (huge_page_mapping && head->last + 1 > start_align &&
-	    head->last + 1 < last_align_down && (!IS_ALIGNED(head->last, 512)))
+	if (huge_page_mapping && new_start > start_align &&
+	    new_start < last_align_down && !IS_ALIGNED(new_start, 512))
 		list_add(&head->update_list, remap_list);
 
 	return 0;


