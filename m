Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871B5135A63;
	Mon,  6 Jan 2025 15:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178773; cv=none; b=NOTnJqPTDLLGuI2mQ38ClNDB7GPhir8smOlrigc8V4FaYZeVbLifwbkk5orevmG7Krx0iYz/GIPphmAyg7CBsAQut3BRoTNms+pVKUADpluxtywC1XXfmi6LUYSRRuYKq2Rp2eExFlDrni8+nljV/ZKlfQl2vD5KitRO295DOhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178773; c=relaxed/simple;
	bh=mBdnFvSRqCzquQq0yguWfh27+GA0IooVzV1ASz1UnoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K9T55qPB1F3CcnwsK2VO9pzGtswrjBxz86NNL2SFm7b/cmfYmB1NeOVzR2a1SlnLmCOxLS/PPRY33FVuSLvEFqbN/8jCxt0P16ywbXxNgmvIPSQVA8SWc4AvzGOtP5J795H1G3KIYfGTvu6FWKLLx10/ceqADb6tjLEBjBE8pQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=axcaLRtU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="axcaLRtU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FF88C4CED2;
	Mon,  6 Jan 2025 15:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178773;
	bh=mBdnFvSRqCzquQq0yguWfh27+GA0IooVzV1ASz1UnoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=axcaLRtUQnFgarC2nWCVwS2H9ebQY2DrEMuigbHURnRlo9V38hbKN8bwBXbIkLhvj
	 uPn8/rt21Ml7yqYoiysm4NfKejwimzHD1hJrFP4fFpr/oBspG80KoKyO0xRdu3wmrl
	 O6drtasELwlr4UUtaCDkwGavYSqX1TIvH4Y4bw5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 087/168] bpf: Check validity of link->type in bpf_link_show_fdinfo()
Date: Mon,  6 Jan 2025 16:16:35 +0100
Message-ID: <20250106151141.748646381@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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
index d4b4a47081b5..37aa1e319165 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2522,16 +2522,21 @@ static void bpf_link_show_fdinfo(struct seq_file *m, struct file *filp)
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



