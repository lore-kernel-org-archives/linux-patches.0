Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31983D3015;
	Thu, 15 Jan 2026 17:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499814; cv=none; b=gS7fP46QhCkXYElW1SxZaeOCCY7N0Y9USaVasLr1DZG8rnAuqchvfpiuXjYM0viue3xokaBcpz5naJaF9AzRIQhD/U7eEcANuE4tuJG/RLw8yxHtPrQmBG8eN+P1A7bcLGRxdjJJ/d6MQNq0rHwH56LdRET6XfFv+YtdWkLqQIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499814; c=relaxed/simple;
	bh=0Kr689bsQ3No5pLQKjCsZ6Fef4yooSQVYsNDEaS2oYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M8sy0ZnFJ+yj5uRHl+bgr/RdSp86vQlOJzq4NsYDysAxmP3CTSj3YGO3zKdoT5A2/w3cYTWFpejPDxXbieDr/Gghn4svSTNA323fCIZg7pdZ4q8OkqiHoS47GKFxrI8DJPFkGyj1t2pu9BG/0Cywr5O78bLepb20Jgn3Nlh7Hu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NHNySY/K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NHNySY/K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B9FAC116D0;
	Thu, 15 Jan 2026 17:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499813;
	bh=0Kr689bsQ3No5pLQKjCsZ6Fef4yooSQVYsNDEaS2oYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NHNySY/KVukDCYUikZvcwSKFz0ym4dt+rvEtQg0KUq9mOMuhGNZ6XiyfKGZvPMbFN
	 Q5m3FZ1NPfEZRerYYGAtjWiSph9njwzNNqI2q830UIaPSUnnCP9Idz4FQ3oh8/sZ2k
	 TnEOCZdXzebGP5UUfrixAPgY1/of3Pylqb1PeJfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 358/451] xfs: fix a memory leak in xfs_buf_item_init()
Date: Thu, 15 Jan 2026 17:49:19 +0100
Message-ID: <20260115164243.854271831@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

[ Upstream commit fc40459de82543b565ebc839dca8f7987f16f62e ]

xfs_buf_item_get_format() may allocate memory for bip->bli_formats,
free the memory in the error path.

Fixes: c3d5f0c2fb85 ("xfs: complain if anyone tries to create a too-large buffer log item")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_buf_item.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -744,6 +744,7 @@ xfs_buf_item_init(
 		map_size = DIV_ROUND_UP(chunks, NBWORD);
 
 		if (map_size > XFS_BLF_DATAMAP_SIZE) {
+			xfs_buf_item_free_format(bip);
 			kmem_cache_free(xfs_buf_item_zone, bip);
 			xfs_err(mp,
 	"buffer item dirty bitmap (%u uints) too small to reflect %u bytes!",


