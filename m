Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D609513FD86;
	Tue, 26 Aug 2025 13:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215485; cv=none; b=GzwSYBjl8y2weyD7QVl2BDZ0P9geqO4+xXuuYg5jwKcbO0Qo0G0AhXHAfeFP5JU8W5NyrnROuIvHOAJaCOwE/8WcUTLa+5oCDbmfKDJWv1NKwencHrtJdIQaNbPdEvlvx+Au+DebREpZQN3Q2nHU1QcUSkZCWnUzLprW362Ngww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215485; c=relaxed/simple;
	bh=O2utn1aw8mHrfsxBnyJXSnPb7mwkkHI2EsLgF9RLhrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VheiQYpGJQljErYu5kIX3hf3xmXSeX3vh/ZEcH6ekjCw6Vv2B9EgZsuCKcK+xlnCdVp+S7epK9sYivOC1++0j3V5A4UmdnI9Dl7Y6r5GpmMTOwHfJof5cfB6Mud2kxy3XKWylwbDqVhzn9oqitQYKTL9a2AGM6x3I5NkljR4JIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=elrSzQJu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="elrSzQJu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C1CCC4CEF1;
	Tue, 26 Aug 2025 13:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215485;
	bh=O2utn1aw8mHrfsxBnyJXSnPb7mwkkHI2EsLgF9RLhrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=elrSzQJuUuZIV0k/J8XwXbBtaG4ZYLGmygzKzVgWoahJ02uW9mHBiX6d2kdafM3kA
	 PsVSgFDjoP1lrzEsfdwkkyno4e+Ow9Y4CjxW8e5wZnBK090PBlY5yWINr4hSrB4MdW
	 cDXy1ga8UjPG0zchjAb+zVyl6SmGQe6DCQa7QT70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tariq Toukan <tariqt@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 051/644] lib: bitmap: Introduce node-aware alloc API
Date: Tue, 26 Aug 2025 13:02:22 +0200
Message-ID: <20250826110947.767132949@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

From: Tariq Toukan <tariqt@nvidia.com>

[ Upstream commit 7529cc7fbd9c02eda6851f3260416cbe198a321d ]

Expose new node-aware API for bitmap allocation:
bitmap_alloc_node() / bitmap_zalloc_node().

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Stable-dep-of: 531d0d32de3e ("net/mlx5: Correctly set gso_size when LRO is used")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bitmap.h |  2 ++
 lib/bitmap.c           | 13 +++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index ce03547d69f45..795d57d3ca086 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -123,6 +123,8 @@ struct device;
  */
 unsigned long *bitmap_alloc(unsigned int nbits, gfp_t flags);
 unsigned long *bitmap_zalloc(unsigned int nbits, gfp_t flags);
+unsigned long *bitmap_alloc_node(unsigned int nbits, gfp_t flags, int node);
+unsigned long *bitmap_zalloc_node(unsigned int nbits, gfp_t flags, int node);
 void bitmap_free(const unsigned long *bitmap);
 
 /* Managed variants of the above. */
diff --git a/lib/bitmap.c b/lib/bitmap.c
index 663dd81967d4e..9264088834566 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -1398,6 +1398,19 @@ unsigned long *bitmap_zalloc(unsigned int nbits, gfp_t flags)
 }
 EXPORT_SYMBOL(bitmap_zalloc);
 
+unsigned long *bitmap_alloc_node(unsigned int nbits, gfp_t flags, int node)
+{
+	return kmalloc_array_node(BITS_TO_LONGS(nbits), sizeof(unsigned long),
+				  flags, node);
+}
+EXPORT_SYMBOL(bitmap_alloc_node);
+
+unsigned long *bitmap_zalloc_node(unsigned int nbits, gfp_t flags, int node)
+{
+	return bitmap_alloc_node(nbits, flags | __GFP_ZERO, node);
+}
+EXPORT_SYMBOL(bitmap_zalloc_node);
+
 void bitmap_free(const unsigned long *bitmap)
 {
 	kfree(bitmap);
-- 
2.39.5



