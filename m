Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683A96313D;
	Tue, 23 Jan 2024 01:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975001; cv=none; b=e4CGofPLJBbzIDbi+Y5Eq773NiyRjHK0rTZrTiQTC/CyJLIKolSQSk8u4xRsa8SZ1OKdJfTXAug/cPxvBHUUcyIoL8ykpwfCnU1ZUHEoQ9LoeshY/jgSGkqqAKzetBjm7gq5TdFmVhokbvjxcMwPKY2MH78uEzamll1qjiYMht8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975001; c=relaxed/simple;
	bh=f0G1mbs0hgNlCA2OidbjAm2fHt7vWuiYaauok2dBo7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=svLNt9p2tacM0t4hAbESA1WzQ7jYkt0c01C37gOtYhRw0Gkv916aELpGnk+n9aF8BX4mFVnLp3O88y45Rdlb5ToMF6Ozmrzi6oCu53ZLEo+ObtBjPcdjJNSj0kRPVGHfnpkK86Z/fOwYmBA/vv0PdfM05xH3aT9WyDZvzucDdec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BCph7Zot; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BCph7Zot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F62BC433A6;
	Tue, 23 Jan 2024 01:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975001;
	bh=f0G1mbs0hgNlCA2OidbjAm2fHt7vWuiYaauok2dBo7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BCph7Zot5a744/ObzVXZs2E7wWhieP7j5vioOaqSb/XeLroG1FKPXLq7gU0YWsN5Y
	 seZj53zid/ko8gi/3bUvDxVu5+gxAkx9JPJZ6e9qcdPMURYtScQIex7dTYZ543I8T4
	 On+glS73I2F3JjFgfY0DaPYKjjluRq4z/e45jrBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 188/583] bpf: Re-enable unit_size checking for global per-cpu allocator
Date: Mon, 22 Jan 2024 15:53:59 -0800
Message-ID: <20240122235817.746666802@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit baa8fdecd87bb8751237b45e3bcb5a179e5a12ca ]

With pcpu_alloc_size() in place, check whether or not the size of
the dynamic per-cpu area is matched with unit_size.

Signed-off-by: Hou Tao <houtao1@huawei.com>
Link: https://lore.kernel.org/r/20231020133202.4043247-4-houtao@huaweicloud.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: 7ac5c53e0073 ("bpf: Use c->unit_size to select target cache during free")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/memalloc.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/kernel/bpf/memalloc.c b/kernel/bpf/memalloc.c
index 956f80ee6f5c..9657d5951d78 100644
--- a/kernel/bpf/memalloc.c
+++ b/kernel/bpf/memalloc.c
@@ -491,21 +491,17 @@ static int check_obj_size(struct bpf_mem_cache *c, unsigned int idx)
 	struct llist_node *first;
 	unsigned int obj_size;
 
-	/* For per-cpu allocator, the size of free objects in free list doesn't
-	 * match with unit_size and now there is no way to get the size of
-	 * per-cpu pointer saved in free object, so just skip the checking.
-	 */
-	if (c->percpu_size)
-		return 0;
-
 	first = c->free_llist.first;
 	if (!first)
 		return 0;
 
-	obj_size = ksize(first);
+	if (c->percpu_size)
+		obj_size = pcpu_alloc_size(((void **)first)[1]);
+	else
+		obj_size = ksize(first);
 	if (obj_size != c->unit_size) {
-		WARN_ONCE(1, "bpf_mem_cache[%u]: unexpected object size %u, expect %u\n",
-			  idx, obj_size, c->unit_size);
+		WARN_ONCE(1, "bpf_mem_cache[%u]: percpu %d, unexpected object size %u, expect %u\n",
+			  idx, c->percpu_size, obj_size, c->unit_size);
 		return -EINVAL;
 	}
 	return 0;
@@ -967,6 +963,12 @@ void notrace *bpf_mem_cache_alloc_flags(struct bpf_mem_alloc *ma, gfp_t flags)
 	return !ret ? NULL : ret + LLIST_NODE_SZ;
 }
 
+/* The alignment of dynamic per-cpu area is 8, so c->unit_size and the
+ * actual size of dynamic per-cpu area will always be matched and there is
+ * no need to adjust size_index for per-cpu allocation. However for the
+ * simplicity of the implementation, use an unified size_index for both
+ * kmalloc and per-cpu allocation.
+ */
 static __init int bpf_mem_cache_adjust_size(void)
 {
 	unsigned int size;
-- 
2.43.0



