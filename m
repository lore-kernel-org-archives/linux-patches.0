Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199292594B6;
	Mon, 30 Dec 2024 15:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573607; cv=none; b=uSzPo8XU8+ES+zflQU7nheWkTfW7xUXMrdGS9LePR8pmIguKkxrFFlPj/NbFDVVQ5Qy11v/UCkPmx4zmC6gxEMwJhEeT9p0wSqRA+lxwFMqak5ZIuQZXMYMsGAWkJzPjc8JzGmHUUKTy/WmK2Td5a45UZ4r33drgEL903g9aTmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573607; c=relaxed/simple;
	bh=0rnLNZBwVuRIQhn2taVoN5JhETsX1zgu7RQXZRInUxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b0bR4+1VyuDCBt3pQrS7f952H5yuRCP9pC0D57dRoMJ4P2/kNG2E87VIc1cXKMj+AfCbyG+PJrTL1NYLAj83H90TO8CcE2BuW7kPLNfag9OV8eP62vjQ6VC5dcppNwg1Mh/jYM2Hw4hmjI2lWBS2bcQ5wpJxz8SkQISTIqcHn/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YtK7CVH9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YtK7CVH9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80A66C4CED0;
	Mon, 30 Dec 2024 15:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573607;
	bh=0rnLNZBwVuRIQhn2taVoN5JhETsX1zgu7RQXZRInUxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YtK7CVH9r6SQMC01Ax5cqJKv35KGgqhRfWC0g2no1jE4bnwgURUbyNy17ZsROQxD9
	 b7wk7Mu2KME2aG5yQMUOmr5kcGkxU4EPMEsDqIEvL5IuMvgnsJqYjoD43i+1odO4am
	 oRcxbr59jkShgXvfaMrOMDC6DqYE8PihzhdGwwuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 43/60] bpf: Check validity of link->type in bpf_link_show_fdinfo()
Date: Mon, 30 Dec 2024 16:42:53 +0100
Message-ID: <20241230154208.912223776@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154207.276570972@linuxfoundation.org>
References: <20241230154207.276570972@linuxfoundation.org>
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

From: Hou Tao <houtao1@huawei.com>

commit 8421d4c8762bd022cb491f2f0f7019ef51b4f0a7 upstream.

If a newly-added link type doesn't invoke BPF_LINK_TYPE(), accessing
bpf_link_type_strs[link->type] may result in an out-of-bounds access.

To spot such missed invocations early in the future, checking the
validity of link->type in bpf_link_show_fdinfo() and emitting a warning
when such invocations are missed.

Signed-off-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20241024013558.1135167-3-houtao@huaweicloud.com
[ shung-hsi.yu: break up existing seq_printf() call since commit 68b04864ca42
  ("bpf: Create links for BPF struct_ops maps.") is not present ]
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/syscall.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index f9906e5ad2e5..6455f80099cd 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2816,16 +2816,21 @@ static void bpf_link_show_fdinfo(struct seq_file *m, struct file *filp)
 {
 	const struct bpf_link *link = filp->private_data;
 	const struct bpf_prog *prog = link->prog;
+	enum bpf_link_type type = link->type;
 	char prog_tag[sizeof(prog->tag) * 2 + 1] = { };
 
+	if (type < ARRAY_SIZE(bpf_link_type_strs) && bpf_link_type_strs[type]) {
+		seq_printf(m, "link_type:\t%s\n", bpf_link_type_strs[type]);
+	} else {
+		WARN_ONCE(1, "missing BPF_LINK_TYPE(...) for link type %u\n", type);
+		seq_printf(m, "link_type:\t<%u>\n", type);
+	}
+	seq_printf(m, "link_id:\t%u\n", link->id);
+
 	bin2hex(prog_tag, prog->tag, sizeof(prog->tag));
 	seq_printf(m,
-		   "link_type:\t%s\n"
-		   "link_id:\t%u\n"
 		   "prog_tag:\t%s\n"
 		   "prog_id:\t%u\n",
-		   bpf_link_type_strs[link->type],
-		   link->id,
 		   prog_tag,
 		   prog->aux->id);
 	if (link->ops->show_fdinfo)
-- 
2.39.5



