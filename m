Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 671902566;
	Tue, 27 May 2025 17:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368325; cv=none; b=arL+7CUaBQKMqlUsYjsyNeCNKmlmM/uCQzYAsHhWyAHT2K5vVYMZqjq4+JO+qD+4KFH/5GJggcohSel8WMgInpmdu0ihfnCBEfiyOKo4/zLKKPAFy5SqdYry0xMG05LHDUlDREsXrEFD6sJuSh0xiTtO1QzVtFCyfcUwzgt88ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368325; c=relaxed/simple;
	bh=jWPqnpi9O0FFITb1RZDbZrhEB6Ut6/c2+CFhmU7yIho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fo1Mv2MQjd5MrouvLU5hkbp0o4e8GN0N27t7y0xYKxm7MuObRGvxh+c4L0yoDY57STH486koeMeti8aNPbrkzFgNc38uIj0MQl+Wso/WF/lvUX8C4/X/KeZJJCsjat3UfxxU9B1Lg7XYuOSJ+CCJv9rKh47EZB6N/OEio+/vVK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0EIuDJB2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0EIuDJB2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBF88C4CEE9;
	Tue, 27 May 2025 17:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368325;
	bh=jWPqnpi9O0FFITb1RZDbZrhEB6Ut6/c2+CFhmU7yIho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0EIuDJB2FBkYbRPxh8MrQ3pvPMo3T8gMiKLTFHMZa/6lcp/nlF/QOAYq6nA4QPPFQ
	 COH0upf7YiSTn3GdrGnYfD2GZMoxBzrY8yTh/PKg8IbTXZqGzt1tF7B5bGToynu6r0
	 L2TMwaXVEQkNV+/PbALQYv5481qU6gfJyoTfEeaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Kees Cook <kees@kernel.org>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 670/783] btrfs: compression: adjust cb->compressed_folios allocation type
Date: Tue, 27 May 2025 18:27:47 +0200
Message-ID: <20250527162540.406719180@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <kees@kernel.org>

[ Upstream commit 6f9a8ab796c6528d22de3c504c81fce7dde63d8a ]

In preparation for making the kmalloc() family of allocators type aware,
we need to make sure that the returned type from the allocation matches
the type of the variable being assigned. (Before, the allocator would
always return "void *", which can be implicitly cast to any pointer type.)

The assigned type is "struct folio **" but the returned type will be
"struct page **". These are the same allocation size (pointer size), but
the types don't match. Adjust the allocation type to match the assignment.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Kees Cook <kees@kernel.org>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/compression.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 0c4d486c3048d..18d2210dc7249 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -606,7 +606,7 @@ void btrfs_submit_compressed_read(struct btrfs_bio *bbio)
 	free_extent_map(em);
 
 	cb->nr_folios = DIV_ROUND_UP(compressed_len, PAGE_SIZE);
-	cb->compressed_folios = kcalloc(cb->nr_folios, sizeof(struct page *), GFP_NOFS);
+	cb->compressed_folios = kcalloc(cb->nr_folios, sizeof(struct folio *), GFP_NOFS);
 	if (!cb->compressed_folios) {
 		ret = BLK_STS_RESOURCE;
 		goto out_free_bio;
-- 
2.39.5



