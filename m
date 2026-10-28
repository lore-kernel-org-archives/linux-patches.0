Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216676;
	b=QrgEW+sEzaYq87TEGTV2Q8Vay1cb6ne0ao4og9x90kf7iPye+dUxemn6lW7GcBLROd9Y
	 8C421erk8MYeGCXu1bxOEIkSD4PZsHVVNSIA981pNK2RW9+H2iv7ZwQmNvknUxByLjS1Q
	 t89fwEEX2LRUQdNxFlCK5gf2jxnOKULa262CH3JSQURXsRgR7eHVc7A6mCMP2PRosezlj
	 NZBmWCj+oonegJC3hlCaJR1CYz5nfaxf9wmAT50SWGPIITnNH8XunlO7gVzL4NgMzGbSX
	 B/k2a5XkEX4KaFqmV/DUSU9ZYQ65+84DCCF0zYAbxk1kU6te8UoPsAIOa4ML8fB/z+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216676;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s2zVHYmbS9OhpnUrvI6xlzdO/klQYiX1hvfAvd3KKKw=;
	b=wvCASrJ0SClRlTtJ/0l+vk3QjMWrncwAvf9nNIOBzJpHD/TOOFVh9uF3x4cOuuaXDb6B
	 jIfrQC2IKWi3sYQouAaklkCjBStvYKRlKM0xRFMNGWsGi5LnYtoAKQ0ri13276nMJy3xO
	 ykuAWbfEgAojMGpe4zR8HhgFNtwtyQe/oMiq80CS/0LBdwAdafg/0MrVw5BTimbXgve7d
	 c8mJykJVE6DOTsjNVhUn8kevqFJxJvuwWjSO+AK9EfbwiILPIEQ7mclgvBqYMckW1lU4V
	 IB9soooMWLbKzZhYkEXJY5DRZFkhOoVeIsVB8a8WxRBEftZM1epSOeDPl0l47xpjQfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0Af0KwI9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73580606A31C;
	Wed, 28 Oct 2026 19:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0Af0KwI9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 837C31F01825;
	Wed, 28 Oct 2026 19:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216671;
	bh=s2zVHYmbS9OhpnUrvI6xlzdO/klQYiX1hvfAvd3KKKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Af0KwI9HrVKPVixI+4cSwcMf2HQWc5LIbyaIJzxKkcKcRDHpAAuPJY0qHgUFICcz
	 JkPb4UHrSxNNf6439M3gcb1k7VZDcmVzDCi+dmLKwR+Gijr9xna+UcFnZS367z/m81
	 WjGKtxow3n5lyKMaeRTFcgChUy6yPVGpfgiD4dk4=
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
Subject: [PATCH 6.1 1601/1887] bpf: Fix potential UAF when reading bpf link info
Date: Wed, 28 Oct 2026 18:01:37 +0100
Message-ID: <20261028170535.902596717@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 kernel/bpf/syscall.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index f629db72bd1c2..df9ce9cc7c112 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2851,9 +2851,10 @@ static const char *bpf_link_type_strs[] = {
 static void bpf_link_show_fdinfo(struct seq_file *m, struct file *filp)
 {
 	const struct bpf_link *link = filp->private_data;
-	const struct bpf_prog *prog = link->prog;
+	const struct bpf_prog *prog;
 	enum bpf_link_type type = link->type;
 	char prog_tag[sizeof(prog->tag) * 2 + 1] = { };
+	u32 prog_id = 0;
 
 	if (type < ARRAY_SIZE(bpf_link_type_strs) && bpf_link_type_strs[type]) {
 		seq_printf(m, "link_type:\t%s\n", bpf_link_type_strs[type]);
@@ -2863,12 +2864,21 @@ static void bpf_link_show_fdinfo(struct seq_file *m, struct file *filp)
 	}
 	seq_printf(m, "link_id:\t%u\n", link->id);
 
-	bin2hex(prog_tag, prog->tag, sizeof(prog->tag));
-	seq_printf(m,
-		   "prog_tag:\t%s\n"
-		   "prog_id:\t%u\n",
-		   prog_tag,
-		   prog->aux->id);
+	rcu_read_lock();
+	prog = READ_ONCE(link->prog);
+	if (prog) {
+		bin2hex(prog_tag, prog->tag, sizeof(prog->tag));
+		prog_id = prog->aux->id;
+	}
+	rcu_read_unlock();
+
+	if (prog) {
+		seq_printf(m,
+			   "prog_tag:\t%s\n"
+			   "prog_id:\t%u\n",
+			   prog_tag,
+			   prog_id);
+	}
 	if (link->ops->show_fdinfo)
 		link->ops->show_fdinfo(link, m);
 }
@@ -4355,6 +4365,7 @@ static int bpf_link_get_info_by_fd(struct file *file,
 {
 	struct bpf_link_info __user *uinfo = u64_to_user_ptr(attr->info.info);
 	struct bpf_link_info info;
+	const struct bpf_prog *prog;
 	u32 info_len = attr->info.info_len;
 	int err;
 
@@ -4369,7 +4380,12 @@ static int bpf_link_get_info_by_fd(struct file *file,
 
 	info.type = link->type;
 	info.id = link->id;
-	info.prog_id = link->prog->aux->id;
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



