Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391778837;
	Mon, 28 Oct 2024 06:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098292; cv=none; b=NJOSAlC9JjK2poU5X5oQvjZWLHmNyo7hW+oiYLgfck07Is2ud0DcJx8k/PLkWAD2RKrSNJs4ljI2D3bjEIxE6FUzYILdGo78Bfnh2EsQ+M9RsWxtOh7Y2CE9YkLQQ3CFFEVtvd840ybCnUsLCNs66TVT5nPPcWGPtPHhjWawV2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098292; c=relaxed/simple;
	bh=GHReMO6uX46rL/aD4K8jRohsyMJoQmkH4QZiYovfi2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LzfIosK6lUcrIr2JHr0KBDjPIH+zNOxzSLxn4msgic1TbzAISEMxPith2aBlGw/QzOQDUK3hcp5MKJYrumOC5HiokYkLbaYROMxEXzhga9R6nO5AiS7HepeEnqZOm+TIIyCbjnNg9xPbyJ27eYbbwXbFFaCDVHvRkhgKN6mMR8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d8ziw9hv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d8ziw9hv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE005C4CEC3;
	Mon, 28 Oct 2024 06:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098292;
	bh=GHReMO6uX46rL/aD4K8jRohsyMJoQmkH4QZiYovfi2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d8ziw9hvNhtRatnt4svx2sQJHqFxzjGWJAGrqhM6ZdRH9cfru9YL0yrsTuF6KpcHb
	 6niyQWZ6gHW32cZtWmzVClLm7pWzzkvNFoGvouMPCBOqDN5Dv1D70RKeT5FzNX0UIK
	 TF7fIFlnsMYTHoSZIaYiz/t/t+MZe8Glms4mjdYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 162/261] bpf: Preserve param->string when parsing mount options
Date: Mon, 28 Oct 2024 07:25:04 +0100
Message-ID: <20241028062316.064975538@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit 1f97c03f43fadc407de5b5cb01c07755053e1c22 ]

In bpf_parse_param(), keep the value of param->string intact so it can
be freed later. Otherwise, the kmalloc area pointed to by param->string
will be leaked as shown below:

unreferenced object 0xffff888118c46d20 (size 8):
  comm "new_name", pid 12109, jiffies 4295580214
  hex dump (first 8 bytes):
    61 6e 79 00 38 c9 5c 7e                          any.8.\~
  backtrace (crc e1b7f876):
    [<00000000c6848ac7>] kmemleak_alloc+0x4b/0x80
    [<00000000de9f7d00>] __kmalloc_node_track_caller_noprof+0x36e/0x4a0
    [<000000003e29b886>] memdup_user+0x32/0xa0
    [<0000000007248326>] strndup_user+0x46/0x60
    [<0000000035b3dd29>] __x64_sys_fsconfig+0x368/0x3d0
    [<0000000018657927>] x64_sys_call+0xff/0x9f0
    [<00000000c0cabc95>] do_syscall_64+0x3b/0xc0
    [<000000002f331597>] entry_SYSCALL_64_after_hwframe+0x4b/0x53

Fixes: 6c1752e0b6ca ("bpf: Support symbolic BPF FS delegation mount options")
Signed-off-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/bpf/20241022130133.3798232-1-houtao@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/inode.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
index af5d2ffadd70b..00b8dc8ef7385 100644
--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -880,7 +880,7 @@ static int bpf_parse_param(struct fs_context *fc, struct fs_parameter *param)
 		const struct btf_type *enum_t;
 		const char *enum_pfx;
 		u64 *delegate_msk, msk = 0;
-		char *p;
+		char *p, *str;
 		int val;
 
 		/* ignore errors, fallback to hex */
@@ -911,7 +911,8 @@ static int bpf_parse_param(struct fs_context *fc, struct fs_parameter *param)
 			return -EINVAL;
 		}
 
-		while ((p = strsep(&param->string, ":"))) {
+		str = param->string;
+		while ((p = strsep(&str, ":"))) {
 			if (strcmp(p, "any") == 0) {
 				msk |= ~0ULL;
 			} else if (find_btf_enum_const(info.btf, enum_t, enum_pfx, p, &val)) {
-- 
2.43.0



