Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A2D46BA0;
	Mon,  4 Mar 2024 21:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588751; cv=none; b=r0+QLyQKAo5q7nOM43KH9oXulv8mNXo9GUo4Y8n09wDYNIdkTjNHw4dclJ//NGYUgLKfsr48yg8MpGC0oZpeQofmr1PP1Nd4Piwu69iwPUafRNNKUW51KtxOYNH2rMt55YhDn3Hy4RnqB5OGRhvXcox5ySaBNSyLw5K6gKG0WlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588751; c=relaxed/simple;
	bh=kuWTSYl4ns7yzT2c7YRnddgDr8SwgUaKFvMp/ONC480=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s2J7v0OxeG/Opk8pmJWl2bI7KtiNdyznzdms+UGKiF2gXxi7HTIZvx/2f2H+SlwPQpQmRJbs8Uafl3ppC2jBa/D59edWkmtHTTLmWgMfn++pNMU7olqfJiCJluN99hkBG0cBTl6dZ2697nEPeB41f9gyRTMM7xRfia8u+Zkzwnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GxRmlFDa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GxRmlFDa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AACEEC433F1;
	Mon,  4 Mar 2024 21:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588751;
	bh=kuWTSYl4ns7yzT2c7YRnddgDr8SwgUaKFvMp/ONC480=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GxRmlFDauFnEHExxshg9ZLURepY6srS5wWSbInjLw5K4bkR4Uz83IZn1stP2udOEj
	 zKfEEOmpQCbcjwgft1TykJK8Ue4oClBr+qskrgqQjm44z0Vj6T882VkZm/PwEnrmlQ
	 aUHlCsFxI46K6ZiwFkn+Uzs0DA98p30PukXDLa14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 6.1 083/215] drm/buddy: fix range bias
Date: Mon,  4 Mar 2024 21:22:26 +0000
Message-ID: <20240304211559.624588947@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Auld <matthew.auld@intel.com>

commit f41900e4a6ef019d64a70394b0e0c3bd048d4ec8 upstream.

There is a corner case here where start/end is after/before the block
range we are currently checking. If so we need to be sure that splitting
the block will eventually give use the block size we need. To do that we
should adjust the block range to account for the start/end, and only
continue with the split if the size/alignment will fit the requested
size. Not doing so can result in leaving split blocks unmerged when it
eventually fails.

Fixes: afea229fe102 ("drm: improve drm_buddy_alloc function")
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: <stable@vger.kernel.org> # v5.18+
Reviewed-by: Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240219121851.25774-4-matthew.auld@intel.com
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_buddy.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/gpu/drm/drm_buddy.c
+++ b/drivers/gpu/drm/drm_buddy.c
@@ -332,6 +332,7 @@ alloc_range_bias(struct drm_buddy *mm,
 		 u64 start, u64 end,
 		 unsigned int order)
 {
+	u64 req_size = mm->chunk_size << order;
 	struct drm_buddy_block *block;
 	struct drm_buddy_block *buddy;
 	LIST_HEAD(dfs);
@@ -367,6 +368,15 @@ alloc_range_bias(struct drm_buddy *mm,
 		if (drm_buddy_block_is_allocated(block))
 			continue;
 
+		if (block_start < start || block_end > end) {
+			u64 adjusted_start = max(block_start, start);
+			u64 adjusted_end = min(block_end, end);
+
+			if (round_down(adjusted_end + 1, req_size) <=
+			    round_up(adjusted_start, req_size))
+				continue;
+		}
+
 		if (contains(start, end, block_start, block_end) &&
 		    order == drm_buddy_block_order(block)) {
 			/*


