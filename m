Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E24C8248BCB;
	Wed, 15 Jan 2025 10:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938073; cv=none; b=tLU7pvjf5jLqIQGPWM0Pg9VEeqS12qAFMsh3+qZI3wzNh8jWjARFDDIA9Ca0d2wnqH9lXmy+wFTKPURk3zGosIYC44upfewPtJcFdzAYk1EU0WCRvzyn/Ppska+Zl+qlRFayEhjyGYPqqZ9FAvDlAG5GeP3YC1p1Id0c99/ip5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938073; c=relaxed/simple;
	bh=NrlDQZ8iTcSrsfxPYMPm1911cWxGIfHnuFxdnP7oaeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tdVTUck72EHU3Gj+HPDCaPLThTKRnyqIoBpo5HAascDJjOnAGlwu8VTxjCJ/oj3wevw9czx6rbhq807RfVkPOgG1iRybeolDQD+UYnsN8QjeemsYxXT6ZTxLFKcbqP98JlY2KpDWa99txeMYLorbd9dNQsWyH0IIF6qvSDuJ4XI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s46eBjDk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s46eBjDk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5520BC4CEE9;
	Wed, 15 Jan 2025 10:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938072;
	bh=NrlDQZ8iTcSrsfxPYMPm1911cWxGIfHnuFxdnP7oaeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s46eBjDk6tOx0HNxVIdxcVT87D+aCCDigQ2ruZopxZzZFjx2X5HmPXzRk0Or3CnGL
	 3pHeEqOrQSQxKOM1uZz/Ydo+uvfK6kLJkF9fu7Sy3qtdR4/b1+imwIPj45JiA0NXlM
	 3tCO6cgw43RVbuN4gUnKlbCqd4ukxGeGTsvP5dBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai Zhang <zhangkai@iscas.ac.cn>,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 075/189] riscv: module: remove relocation_head rel_entry member allocation
Date: Wed, 15 Jan 2025 11:36:11 +0100
Message-ID: <20250115103609.343238123@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clément Léger <cleger@rivosinc.com>

[ Upstream commit 03f0b548537f758830bdb2dc3f2aba713069cef2 ]

relocation_head's list_head member, rel_entry, doesn't need to be
allocated, its storage can just be part of the allocated relocation_head.
Remove the pointer which allows to get rid of the allocation as well as
an existing memory leak found by Kai Zhang using kmemleak.

Fixes: 8fd6c5142395 ("riscv: Add remaining module relocations")
Reported-by: Kai Zhang <zhangkai@iscas.ac.cn>
Signed-off-by: Clément Léger <cleger@rivosinc.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Reviewed-by: Charlie Jenkins <charlie@rivosinc.com>
Tested-by: Charlie Jenkins <charlie@rivosinc.com>
Link: https://lore.kernel.org/r/20241128081636.3620468-1-cleger@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/module.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/arch/riscv/kernel/module.c b/arch/riscv/kernel/module.c
index 1cd461f3d872..47d0ebeec93c 100644
--- a/arch/riscv/kernel/module.c
+++ b/arch/riscv/kernel/module.c
@@ -23,7 +23,7 @@ struct used_bucket {
 
 struct relocation_head {
 	struct hlist_node node;
-	struct list_head *rel_entry;
+	struct list_head rel_entry;
 	void *location;
 };
 
@@ -634,7 +634,7 @@ process_accumulated_relocations(struct module *me,
 			location = rel_head_iter->location;
 			list_for_each_entry_safe(rel_entry_iter,
 						 rel_entry_iter_tmp,
-						 rel_head_iter->rel_entry,
+						 &rel_head_iter->rel_entry,
 						 head) {
 				curr_type = rel_entry_iter->type;
 				reloc_handlers[curr_type].reloc_handler(
@@ -704,16 +704,7 @@ static int add_relocation_to_accumulate(struct module *me, int type,
 			return -ENOMEM;
 		}
 
-		rel_head->rel_entry =
-			kmalloc(sizeof(struct list_head), GFP_KERNEL);
-
-		if (!rel_head->rel_entry) {
-			kfree(entry);
-			kfree(rel_head);
-			return -ENOMEM;
-		}
-
-		INIT_LIST_HEAD(rel_head->rel_entry);
+		INIT_LIST_HEAD(&rel_head->rel_entry);
 		rel_head->location = location;
 		INIT_HLIST_NODE(&rel_head->node);
 		if (!current_head->first) {
@@ -722,7 +713,6 @@ static int add_relocation_to_accumulate(struct module *me, int type,
 
 			if (!bucket) {
 				kfree(entry);
-				kfree(rel_head->rel_entry);
 				kfree(rel_head);
 				return -ENOMEM;
 			}
@@ -735,7 +725,7 @@ static int add_relocation_to_accumulate(struct module *me, int type,
 	}
 
 	/* Add relocation to head of discovered rel_head */
-	list_add_tail(&entry->head, rel_head->rel_entry);
+	list_add_tail(&entry->head, &rel_head->rel_entry);
 
 	return 0;
 }
-- 
2.39.5



