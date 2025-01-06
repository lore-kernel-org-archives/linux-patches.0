Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E5F1DDA2E;
	Mon,  6 Jan 2025 15:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178304; cv=none; b=PKPK8vUrvCBScvuy1x7v4vnVSxrF5N/W9gu3HAaYA8Y72YkmVnkS3uY14vTV51YM0JzkTGTRSBot34UfcLLLa5D28GE+aVYEUuy8VK6OT1NoSy6okZwun4fp5WZ2Eilgl7RFJlK+QvEA9GlnaSxRVAwGh8W/wZn89EghxiHWvFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178304; c=relaxed/simple;
	bh=FnCt3aD5DFsQUuGLGdKSLn5LwaDMc9MjWB9hHwzdyc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sV4cgndUz5DUW4Q6Ka2sMdsPmNlyReVize3SGzYmgy6clFZIfVPGGhl+3ldL/vxsu8fYkrTEltPJtjC0V05/hIfbsZJiA7dB9u91rs12GROaWWYcoOR9chCzajwlo8F/qfl9aISNNRJosM8XEUjcV/S+/jMRXO28H5vuPfK5tQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EcIXDNwj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EcIXDNwj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52E15C4CED2;
	Mon,  6 Jan 2025 15:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178303;
	bh=FnCt3aD5DFsQUuGLGdKSLn5LwaDMc9MjWB9hHwzdyc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EcIXDNwj6Qvu+7lTds99pPjKIcw2Scp2vfLZrZEnuS2qth/wcKFWVhhzsjzOmPY7/
	 7GNDZaz9O9kdyj/O9KBYvM1EV2Sy9WCyazNdXb0FOJ2lmqQzXnFz9Ik6ZY96OmI9kU
	 urZlyBLuWD3ySoJ2b0rlQdB3xiCccRCYMrKws0mA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 073/138] bpf: Check validity of link->type in bpf_link_show_fdinfo()
Date: Mon,  6 Jan 2025 16:16:37 +0100
Message-ID: <20250106151135.998158145@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index fbe7f8e2b022..b5d9bba73834 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2427,16 +2427,21 @@ static void bpf_link_show_fdinfo(struct seq_file *m, struct file *filp)
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



