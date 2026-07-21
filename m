Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808B046A5F6;
	Tue, 21 Jul 2026 17:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654850; cv=none; b=ej+wFR6h3idW0P8AGrmC7ffps9568hBKRjx0MjS5XX1xnvrHYAwVHxVlJ+hUqDfAkDNGyPVvEBLq1lcXUjydxEQ/nQqPlS+K4bamJtcvFGsl/pOsOsCc6n26ZpYTUy1DRzRMQB7sUp82lsYCbV8yWXq3HbOy9qyNF24vtxKqCMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654850; c=relaxed/simple;
	bh=vrVpfJCM7WcRGcUc8EQc2NDnwoVTl/QjOEFMgec2ubg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=umFmdhZoMntRe16RcWvtiKGJ2OgoyjHktyDe2DJoti2M4KBGLRDgpO2El7A+ExyMz30AeRYBB02BAQzc+y0t0HgsZS+AtzbxVi2kPZaDfj5aIsn94QGQazmQx2bCh3N908hiUr8Abk5UShR3tJWLzdOzEYGtwwlCNy0zCFHICu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bL3W0zc5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bL3W0zc5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7B491F000E9;
	Tue, 21 Jul 2026 17:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654849;
	bh=g1gUCB8UTmBSEOavVs8R3aRPIWNA8pYPIOcEnlaCjGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bL3W0zc5x/xmLzT77o9ZY3ty1pACmWW+rYL0pxhbx1EPhL7ZZXehqsSeAfZB+JCvl
	 MeMTZrHe9PMt8yXYBf4lCk8aH3UVtG5Ak43oHjryLSeKRmq0l2GkIf0/vum8wYeM54
	 tyyUe22jZqcxIEGDpws02lrT+wCCuAsnXOmJOi3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baineng Shou <shoubaineng@gmail.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 7.1 1862/2077] dma-fence: Make dma_fence_dedup_array() robust against 0-count input
Date: Tue, 21 Jul 2026 17:25:35 +0200
Message-ID: <20260721152636.649908916@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baineng Shou <shoubaineng@gmail.com>

commit 77a9298741f8f9e8b963c977f5582ab21c6d3427 upstream.

dma_fence_dedup_array() returns 1 when called with num_fences == 0:
the for-loop body never executes, j stays at 0, and the final
`return ++j` yields 1. This contradicts both the kernel-doc ("Return:
Number of unique fences remaining in the array") and the natural
expectation that 0 input gives 0 output.

The caller __dma_fence_unwrap_merge() bails out via the
`if (count == 0 || count == 1)` fast path and so is save.

But amdgpu_userq_wait_*() could reach the dedup call with a zero local
count and dereference an uninitialized fence slot in the array.

Make the contract match the documentation by returning 0 early. This
also skips an unnecessary sort() call on an empty array.

Cc: stable@vger.kernel.org
Signed-off-by: Baineng Shou <shoubaineng@gmail.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Fixes: 575ec9b0c2f1 ("dma-fence: Add helper to sort and deduplicate dma_fence arrays")
Signed-off-by: Christian König <christian.koenig@amd.com>
Link: https://lore.kernel.org/r/20260629031346.3875683-1-shoubaineng@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma-buf/dma-fence-unwrap.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/dma-buf/dma-fence-unwrap.c
+++ b/drivers/dma-buf/dma-fence-unwrap.c
@@ -97,6 +97,9 @@ int dma_fence_dedup_array(struct dma_fen
 {
 	int i, j;
 
+	if (!num_fences)
+		return 0;
+
 	sort(fences, num_fences, sizeof(*fences), fence_cmp, NULL);
 
 	/*


