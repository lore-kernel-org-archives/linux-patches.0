Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF92833B975;
	Mon, 20 Apr 2026 16:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701041; cv=none; b=QZM5md7lerQynrdx9dhPA7G/TiZgecjDME1flqNXk0M+fWlTL9yuxM/whnMNHkvbpm63gKZDap4dKQYxD1+9mp+8kX5WOpKDpee+cNL/XGfogkqxQK8JA4B6/OtsATzpRHoTzk3emBTFfTi+k3AetXoWkNz5AxUufcQrdKHwNEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701041; c=relaxed/simple;
	bh=w7Oeg4IfLrkWa0zkVGCubuorTQ9i6ahAebSHGBnrTB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N7cMtCMdsBaWR/RuEu6ItI7xj/Ny2DLMDCaI6CdqyhA7gO73DdzNmFyHchS/ixLc+bGWweo1DFfP7JHII7BDK1aI2tAFB8uHG1zK80eIFFMc2End2AwPETOwyWgwBBKllypZkvXN6D3de5AXedFd3d+EfQCrmsST0xFk+NBy4oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1mxHvc1A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1mxHvc1A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C447C2BCB4;
	Mon, 20 Apr 2026 16:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701041;
	bh=w7Oeg4IfLrkWa0zkVGCubuorTQ9i6ahAebSHGBnrTB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1mxHvc1AlwzItkK2VVjd6c6Jd69LyqMbzggZrv7rYvF+l3+4fGYKjfa+oFE8QrfSF
	 4LZMmzmGcnza7DcP+8Chx6zIN3Rz6lCFqX/xcqSpBjltczEPTJCpWvbHhykgLjT55k
	 D3Jq5waHP8ld4by+8cYI9GlhZKvhxCcLZSnX77MA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1f5bcc7c919ec578777a@syzkaller.appspotmail.com,
	Ruslan Valiyev <linuxoid@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 159/198] media: vidtv: fix NULL pointer dereference in vidtv_channel_pmt_match_sections
Date: Mon, 20 Apr 2026 17:42:18 +0200
Message-ID: <20260420153941.332157028@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruslan Valiyev <linuxoid@gmail.com>

commit f8e1fc918a9fe67103bcda01d20d745f264d00a7 upstream.

syzbot reported a general protection fault in vidtv_psi_desc_assign [1].

vidtv_psi_pmt_stream_init() can return NULL on memory allocation
failure, but vidtv_channel_pmt_match_sections() does not check for
this. When tail is NULL, the subsequent call to
vidtv_psi_desc_assign(&tail->descriptor, desc) dereferences a NULL
pointer offset, causing a general protection fault.

Add a NULL check after vidtv_psi_pmt_stream_init(). On failure, clean
up the already-allocated stream chain and return.

[1]
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
RIP: 0010:vidtv_psi_desc_assign+0x24/0x90 drivers/media/test-drivers/vidtv/vidtv_psi.c:629
Call Trace:
 <TASK>
 vidtv_channel_pmt_match_sections drivers/media/test-drivers/vidtv/vidtv_channel.c:349 [inline]
 vidtv_channel_si_init+0x1445/0x1a50 drivers/media/test-drivers/vidtv/vidtv_channel.c:479
 vidtv_mux_init+0x526/0xbe0 drivers/media/test-drivers/vidtv/vidtv_mux.c:519
 vidtv_start_streaming drivers/media/test-drivers/vidtv/vidtv_bridge.c:194 [inline]
 vidtv_start_feed+0x33e/0x4d0 drivers/media/test-drivers/vidtv/vidtv_bridge.c:239

Fixes: f90cf6079bf67 ("media: vidtv: add a bridge driver")
Cc: stable@vger.kernel.org
Reported-by: syzbot+1f5bcc7c919ec578777a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1f5bcc7c919ec578777a
Signed-off-by: Ruslan Valiyev <linuxoid@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/test-drivers/vidtv/vidtv_channel.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/media/test-drivers/vidtv/vidtv_channel.c
+++ b/drivers/media/test-drivers/vidtv/vidtv_channel.c
@@ -341,6 +341,10 @@ vidtv_channel_pmt_match_sections(struct
 					tail = vidtv_psi_pmt_stream_init(tail,
 									 s->type,
 									 e_pid);
+					if (!tail) {
+						vidtv_psi_pmt_stream_destroy(head);
+						return;
+					}
 
 					if (!head)
 						head = tail;


