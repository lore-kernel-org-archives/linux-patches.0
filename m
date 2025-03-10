Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B00231A3B;
	Mon, 10 Mar 2025 17:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629175; cv=none; b=BfRPbjGkz/p6//AQ+NonZXtbbJp8NNRJ7d+/n3gSNWPRYSTBKVUICJwrMDtiLmgzpHeTtLhJrB7GVU7CR/64+n+7j4s3Dj6hpOVe2/iOOu1NwxF9e00+9W283/EwPtU8Td8VMlUilHJ1gWomExOHnpjgV/ESJyCRV/whFm2is4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629175; c=relaxed/simple;
	bh=ri0RbkRMka06yF4EwmoUt+yGy37FJwSlNMrHoeRNVPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KE3AlBjubV6nWh8CeukNkl7/4so+FxSqZozq5MsvPH8X3U0mEEUFHMyHWOCPcRNnZ45WTNqjXYvv2Vjv47Rn7cRhWZBHTC080bHfTmZcJZzexi/XccOEWS4JVgMo2xrxhZmgFBMcdI4hN6DQwFsa45Qamsv4OLP5sxWpARWzYcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OngUBpUl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OngUBpUl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA11C4CEE5;
	Mon, 10 Mar 2025 17:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629175;
	bh=ri0RbkRMka06yF4EwmoUt+yGy37FJwSlNMrHoeRNVPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OngUBpUl4OpYw3IEbwhKp7RKLtF2JX4mi3vPrkYuvI1rSsawdgIxmpWCuLNHfp7AW
	 Whb5bUK/ESuJEUBIq4r79SfbSoKNZNBgyjKcPGbAckP6iNHst7n4tBoWl73jz6CRFG
	 jJ43KWF0Jj3sgI3Xdk9Spj16+wguzHA7oUZ5Jetg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 203/620] btrfs: convert BUG_ON in btrfs_reloc_cow_block() to proper error handling
Date: Mon, 10 Mar 2025 18:00:49 +0100
Message-ID: <20250310170553.642230123@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 87f302a413f9a..887ae4a9c50c3 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4414,8 +4414,18 @@ int btrfs_reloc_cow_block(struct btrfs_trans_handle *trans,
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



