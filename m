Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9378978B69;
	Mon,  4 Mar 2024 21:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587855; cv=none; b=lvmi7pmblLeQl/7S5Gx3bRQa44aY1AcFUpPURyntGsd4jX1SpHSoamV4ykMXaAH8Z7TnX4h/U0ntJmXFmf+3bRqe7f+dQq/N8JaZbhaY6mhqEwcjgl9MbIzughFUtPsOm4RVSe5aGvYtHwkY0OXplhHA/T1hUtBPX6kpx7HkfTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587855; c=relaxed/simple;
	bh=x6p69SxLIrykkDCB/5+/hWulJjz6zgoQnX5W6MDyKt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XsLi95DX52ts+3nRmoxQgVcq8eNb6US0IgAeApPfMgTw+vr7IsK2QYnoXVZMfH1PL0Hq+u7KGkpqTytbkuysYQ1JVNb2lPRMVvwINb982yneldkaOJYLIzwl4vudCXaaZ9TdrPKpnOUWxB71xBtDDhLz0h88REtigJmw5zAuyfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mrIHE9BY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mrIHE9BY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1440C433F1;
	Mon,  4 Mar 2024 21:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587855;
	bh=x6p69SxLIrykkDCB/5+/hWulJjz6zgoQnX5W6MDyKt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mrIHE9BYHEwx9nvN6DTbT9NQFnwBp8ux47Hff4YiidXeDyGcGW6eyMATBxTOoc0yz
	 mbraPFrJYOHoCzjxA5YQngQ/5r0ymvZ01uX9cvkt/vFt33KY6PMyZrsAdUkmMZWzE+
	 G74Z8FWDAGSQPh5PQ1dWajWWMV/OOoYRGkmZMtKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 6.7 091/162] drm/buddy: fix range bias
Date: Mon,  4 Mar 2024 21:22:36 +0000
Message-ID: <20240304211554.754616166@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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


