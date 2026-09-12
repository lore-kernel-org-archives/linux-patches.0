Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77578235358;
	Sat, 12 Sep 2026 08:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200676; cv=none; b=eDAX3HjLMDbwQVEe04knAHIMoMTUcHMC5GJRnQtbzUICZ3+gUfrPY0wsRQzjIeb+cvwL8pMPoobe4sGJDRaTf0xvhaLAiMfOsO4nhr9SGC3IzWAkQe2KG0sRyI/EDKrgveK5lpgr9I177BUorZAr8AbMwZEjpp2UxL9IWAZXuuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200676; c=relaxed/simple;
	bh=XQTee1ZBH0QRNQzLHFJ00T/6mFC/j7RVre9LZWgQO48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jI69Yzxn489y3mXvSaNHSUSIAiKjA72OQoGHgRIKBRHNBPlHVpQTG/kAqmk6o9WJHg5egQYUWX7caLvP/8jSuTfEW3A4BBOPzShXddjl/XDdcsX7NUOpiU6QdMvOdfiNuGlL/S/y6ie2L8SP7ZSthT/CQuc3Bq+bcOE3cT+7PfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BSOrn42q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BSOrn42q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A7051F000FF;
	Sat, 12 Sep 2026 08:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200671;
	bh=q+wAoSpPDcfJuZgcLWbIlouDjBisXrh7AGJypomUvlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BSOrn42qotyD/e6CM6IH5AiFvzoXVsd2n8/yuqF4jJ+0rR77vBRZ6HkC/if7jkuKR
	 gDGpNU+muJEZx5N+zgX9sxN7/qxWQ7z/1nC2zgrSCOpkfsZN6h+1qHxu/wKCxLAkuj
	 P227u2/o8G6UGQz5mvjR/QHGn8adxiUvWkjGO/4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Pu Lehui <pulehui@huawei.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Amery Hung <ameryhung@gmail.com>,
	Leon Hwang <leon.hwang@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0821/1815] bpf: Fix potential UAF when reading bpf link info
Date: Sat, 12 Sep 2026 08:42:51 +0200
Message-ID: <20260912065708.187567509@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pu Lehui <pulehui@huawei.com>

[ Upstream commit 863f3ddd0b8ac65abfb50d3be0869268ac0e277b ]

In bpf_link_show_fdinfo and bpf_link_get_info_by_fd, link->prog is
accessed without holding any locks. If the prog is concurrently replaced
via bpf_link_update, the old prog can be freed, leading to a potential
UAF issue.

Fix this by accessing link->prog under RCU protection to safely fetch
the pointer and guarantee its lifetime while reading its fields.

Fixes: 0c991ebc8c69 ("bpf: Implement bpf_prog replacement for an active bpf_cgroup_link")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Reviewed-by: Amery Hung <ameryhung@gmail.com>
Acked-by: Leon Hwang <leon.hwang@linux.dev>
Link: https://lore.kernel.org/bpf/f87b53c0-8f00-45a6-82db-8242fa9b143f@huaweicloud.com [0]
Link: https://lore.kernel.org/bpf/20260728025457.2814876-1-pulehui@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/syscall.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 85f7d8a81eb01..fb678b9dcd3e6 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3471,9 +3471,10 @@ static const char *bpf_link_type_strs[] = {
 static void bpf_link_show_fdinfo(struct seq_file *m, struct file *filp)
 {
 	const struct bpf_link *link = filp->private_data;
-	const struct bpf_prog *prog = link->prog;
+	const struct bpf_prog *prog;
 	enum bpf_link_type type = link->type;
 	char prog_tag[sizeof(prog->tag) * 2 + 1] = { };
+	u32 prog_id = 0;
 
 	if (type < ARRAY_SIZE(bpf_link_type_strs) && bpf_link_type_strs[type]) {
 		if (link->type == BPF_LINK_TYPE_KPROBE_MULTI)
@@ -3490,13 +3491,20 @@ static void bpf_link_show_fdinfo(struct seq_file *m, struct file *filp)
 	}
 	seq_printf(m, "link_id:\t%u\n", link->id);
 
+	rcu_read_lock();
+	prog = READ_ONCE(link->prog);
 	if (prog) {
 		bin2hex(prog_tag, prog->tag, sizeof(prog->tag));
+		prog_id = prog->aux->id;
+	}
+	rcu_read_unlock();
+
+	if (prog) {
 		seq_printf(m,
 			   "prog_tag:\t%s\n"
 			   "prog_id:\t%u\n",
 			   prog_tag,
-			   prog->aux->id);
+			   prog_id);
 	}
 	if (link->ops->show_fdinfo)
 		link->ops->show_fdinfo(link, m);
@@ -5535,6 +5543,7 @@ static int bpf_link_get_info_by_fd(struct file *file,
 {
 	struct bpf_link_info __user *uinfo = u64_to_user_ptr(attr->info.info);
 	struct bpf_link_info info;
+	const struct bpf_prog *prog;
 	u32 info_len = attr->info.info_len;
 	int err;
 
@@ -5549,8 +5558,12 @@ static int bpf_link_get_info_by_fd(struct file *file,
 
 	info.type = link->type;
 	info.id = link->id;
-	if (link->prog)
-		info.prog_id = link->prog->aux->id;
+
+	rcu_read_lock();
+	prog = READ_ONCE(link->prog);
+	if (prog)
+		info.prog_id = prog->aux->id;
+	rcu_read_unlock();
 
 	if (link->ops->fill_link_info) {
 		err = link->ops->fill_link_info(link, &info);
-- 
2.53.0



