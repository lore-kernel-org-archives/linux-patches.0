Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D898F70
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 19:59:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AC7AC433C8;
	Sun, 16 Jul 2023 19:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537574;
	bh=znMCHaVmtZ+T9MYF6KsrB2BszaTI2N/WrfL3EXTa/gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NCw9zeIEdTCjco7EjPrgz1WUHleE4AnmJicI8jUwZI3wRmpkE2vIgJXJSJ90otPK0
	 qgDL5YvSFkgX1VlIdl3ecegu7lp5CwUPjqIxf2/Pwq8zKzdRGom8RAbiMBdYkTeaVK
	 GJ28zk3Fqv/U8R/7UMFqPQCPZaDsZIVnoF0W3d6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Marchevsky <davemarchevsky@fb.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 143/800] bpf: Fix __bpf_{list,rbtree}_adds beginning-of-node calculation
Date: Sun, 16 Jul 2023 21:39:56 +0200
Message-ID: <20230716194952.416913425@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dave Marchevsky <davemarchevsky@fb.com>

[ Upstream commit cc0d76cafebbd3e1ffab9c4252d48ecc9e0737f6 ]

Given the pointer to struct bpf_{rb,list}_node within a local kptr and
the byte offset of that field within the kptr struct, the calculation changed
by this patch is meant to find the beginning of the kptr so that it can
be passed to bpf_obj_drop.

Unfortunately instead of doing

  ptr_to_kptr = ptr_to_node_field - offset_bytes

the calculation is erroneously doing

  ptr_to_ktpr = ptr_to_node_field - (offset_bytes * sizeof(struct bpf_rb_node))

or the bpf_list_node equivalent.

This patch fixes the calculation.

Fixes: d2dcc67df910 ("bpf: Migrate bpf_rbtree_add and bpf_list_push_{front,back} to possibly fail")
Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
Link: https://lore.kernel.org/r/20230602022647.1571784-4-davemarchevsky@fb.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/helpers.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 8d368fa353f99..27b9f78195b2c 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -1943,7 +1943,7 @@ static int __bpf_list_add(struct bpf_list_node *node, struct bpf_list_head *head
 		INIT_LIST_HEAD(h);
 	if (!list_empty(n)) {
 		/* Only called from BPF prog, no need to migrate_disable */
-		__bpf_obj_drop_impl(n - off, rec);
+		__bpf_obj_drop_impl((void *)n - off, rec);
 		return -EINVAL;
 	}
 
@@ -2025,7 +2025,7 @@ static int __bpf_rbtree_add(struct bpf_rb_root *root, struct bpf_rb_node *node,
 
 	if (!RB_EMPTY_NODE(n)) {
 		/* Only called from BPF prog, no need to migrate_disable */
-		__bpf_obj_drop_impl(n - off, rec);
+		__bpf_obj_drop_impl((void *)n - off, rec);
 		return -EINVAL;
 	}
 
-- 
2.39.2



