Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8468D1CCEF0;
	Wed, 19 Feb 2025 09:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956714; cv=none; b=MO0YQDeTJQpcTUc6/9ozIqCpe1njq4R/m7UvkpeXg5FQhLO86FmXklnLD/gcPNJZ9rFKy35ouEORhkrBs7zZB8jtVkPgGYDot7fAfx1Asfg5EsXbOpjgBM7SR+X1RKbFitLIs2FIKRLp64H03eImRp1nVsMaxfPXNEMCgaX9POY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956714; c=relaxed/simple;
	bh=ixo4MmbYAlvYGL6G65yJKxODUPfbvs/v2+W2Je2FPqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZDixsRvXeygntM2p9ofpnM2VwvXrRTf1K2rbylJWcKmzGzVCdh/kZ/wfpNBO5UaC96EwhpQ107btVLjF53kZg6Kv87lA6dDN6O1ogxoFq0hbWj+8YzsU+bcVzWM5GJxj7JmIv00rwrm+AeRwOfgVgoaDoNkGsxZmGnzGl/mupmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NbLjOKYl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NbLjOKYl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E523C4CED1;
	Wed, 19 Feb 2025 09:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956714;
	bh=ixo4MmbYAlvYGL6G65yJKxODUPfbvs/v2+W2Je2FPqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NbLjOKYlBf6SJqkoNiyJ6rMFWj62aam0xzvecZZs3EVwT9Zo3hQhs8fz1vRDxUA8l
	 WFRykKAmS+TftnveNsLFIyKUOyqu3yD4fyMh7aTSm6XkmQhws9ZMd1VfEEE6ZkUq/k
	 34gRGmunhy0qZj7ojW8SqEmFYCjhTgg3hL/JHb5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 274/578] btrfs: convert BUG_ON in btrfs_reloc_cow_block() to proper error handling
Date: Wed, 19 Feb 2025 09:24:38 +0100
Message-ID: <20250219082703.800348570@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 6a4730b325aaa48f7a5d5ba97aff0a955e2d9cec ]

This BUG_ON is meant to catch backref cache problems, but these can
arise from either bugs in the backref cache or corruption in the extent
tree.  Fix it to be a proper error.

Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/relocation.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 4c6ba97299cd6..d6cda0b2e9256 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4423,8 +4423,18 @@ int btrfs_reloc_cow_block(struct btrfs_trans_handle *trans,
 		WARN_ON(!first_cow && level == 0);
 
 		node = rc->backref_cache.path[level];
-		BUG_ON(node->bytenr != buf->start &&
-		       node->new_bytenr != buf->start);
+
+		/*
+		 * If node->bytenr != buf->start and node->new_bytenr !=
+		 * buf->start then we've got the wrong backref node for what we
+		 * expected to see here and the cache is incorrect.
+		 */
+		if (unlikely(node->bytenr != buf->start && node->new_bytenr != buf->start)) {
+			btrfs_err(fs_info,
+"bytenr %llu was found but our backref cache was expecting %llu or %llu",
+				  buf->start, node->bytenr, node->new_bytenr);
+			return -EUCLEAN;
+		}
 
 		btrfs_backref_drop_node_buffer(node);
 		atomic_inc(&cow->refs);
-- 
2.39.5



