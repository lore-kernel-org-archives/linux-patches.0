Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2C936F90C;
	Sat, 17 Oct 2026 16:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255547; cv=none; b=b0n7j6De8xAZwk2Y9ihO1dviT/9zhbRXwL9RhGhbz8Y45mK5Lva0goY/+wbR54U3LGk8e506RHVx0cALAHT7/40SjbryI6kn7+V7QeWHehkr2+Q7yRlEbZcC6YG3FkurP152Aa9WznbxhSCfuODNKGsUSzw2g4um6b/q0SNSBNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255547; c=relaxed/simple;
	bh=Vf/yez3yT2Efad94ptebvz1eZIgdALFQJ8Bd411tShU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YMoyStsvPFh3AOewRDtjA1aOWzjlv4ogZCrENjZjrCJgFwNQvBdB0Bs6mJ4vGtd/8+LMzSev2XED09MYhcxcoXq5Te/kV8QU1PVz3SoWwzLUZaU9VEwUioKcYSQJHcy4UyP5D+kgewCcMNRn4RPtB6mJvngVCd6qx9v5VCdcLoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x1nuV1Df; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x1nuV1Df"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BBB81F000C4;
	Sat, 17 Oct 2026 16:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255546;
	bh=Vd7FPEcz6jwr6eeK3QSlb6Se5zjQ4NBIKbOTQRNGQ3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x1nuV1DfarfIR9sjDbys89+KMLdknKGaa/ln6jiW7kDRfqc8Fc6PsDiUTmtKfFE7O
	 D6q433GgEjIkw2S7qKRNCTJlUPGoR98hWUcxCQFB7vavkFE1Vm871Im8WvC2YTXXVb
	 OLNjZ9TDsrAZYUxrankSwf041T8ncCXu4r8i90A4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 812/869] bpf: Remove migrate_{disable|enable} in bpf_obj_free_fields()
Date: Sat, 17 Oct 2026 18:00:53 +0200
Message-ID: <20261017160057.712104099@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit 1d2dbe7120e89090ed4f6be03d6fbadfbfff59bf ]

The callers of bpf_obj_free_fields() have already guaranteed that the
migration is disabled, therefore, there is no need to invoke
migrate_{disable,enable} pair in bpf_obj_free_fields()'s underly
implementation.

This patch removes unnecessary migrate_{disable|enable} pairs from
bpf_obj_free_fields() and its callees: bpf_list_head_free() and
bpf_rb_root_free().

Signed-off-by: Hou Tao <houtao1@huawei.com>
Link: https://lore.kernel.org/r/20250108010728.207536-12-houtao@huaweicloud.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: 4a7910ee060d ("bpf: Clear rb node linkage when freeing bpf_rb_root")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/helpers.c | 4 ----
 kernel/bpf/syscall.c | 2 --
 2 files changed, 6 deletions(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 3126ec5097f15..e8417cd67decb 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -2100,9 +2100,7 @@ void bpf_list_head_free(const struct btf_field *field, void *list_head,
 		/* The contained type can also have resources, including a
 		 * bpf_list_head which needs to be freed.
 		 */
-		migrate_disable();
 		__bpf_obj_drop_impl(obj, field->graph_root.value_rec, false);
-		migrate_enable();
 	}
 }
 
@@ -2139,9 +2137,7 @@ void bpf_rb_root_free(const struct btf_field *field, void *rb_root,
 		obj -= field->graph_root.node_offset;
 
 
-		migrate_disable();
 		__bpf_obj_drop_impl(obj, field->graph_root.value_rec, false);
-		migrate_enable();
 	}
 }
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 9b3d067e47420..854cc29b47c8f 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -707,11 +707,9 @@ void bpf_obj_free_fields(const struct btf_record *rec, void *obj)
 			if (!btf_is_kernel(field->kptr.btf)) {
 				pointee_struct_meta = btf_find_struct_meta(field->kptr.btf,
 									   field->kptr.btf_id);
-				migrate_disable();
 				__bpf_obj_drop_impl(xchgd_field, pointee_struct_meta ?
 								 pointee_struct_meta->record : NULL,
 								 fields[i].type == BPF_KPTR_PERCPU);
-				migrate_enable();
 			} else {
 				field->kptr.dtor(xchgd_field);
 			}
-- 
2.53.0



