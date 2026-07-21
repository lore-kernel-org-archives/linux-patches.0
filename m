Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64E546D2B3;
	Tue, 21 Jul 2026 17:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653686; cv=none; b=Tn83U2xTlS+gmRUcfbr5Qig9JTyjzLtprU86jODdm9GrzoGCxOvRl9hsCk/jRXxPVitT/qEfdal5J4C16P0D9qpPh+rPPPqL2/Ja13sCmACoG+5TR5I/0D0fndk+E0WSrgvgYisNM4GbKUAjzIhXkSPUYww+yUFkWxW7wTunUhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653686; c=relaxed/simple;
	bh=PHI/o7RAGEX23GoiBbOBKHmrEbYpLbopXeahsu49GRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jIe3Bc8NSSRHLLNvat1O9ChKC5KiLxKXhqdwgTFo+hT59eI8mUEh2nNIaqtv+P9MA8bDAQgd7r9QgLtRYBOz41pBmeWs+4MT7/BrOBChvVJP5RiKo4ysr73H/jyRhC6lUtIxH6SwH/MhYauINDZlZ5RG5BI6KIltsGnyChTIbbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eL1BteGo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eL1BteGo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEA451F000E9;
	Tue, 21 Jul 2026 17:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653684;
	bh=Vv9jZ3T8ozNiN8ctJj6FiEjPXbEJCFQelf2tCmFCw4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eL1BteGoL8wxeAQko/fKhnQFeWq6yHpZSPH/C4NyvZjJvVZiN3Q7iseq/dJfGvYwG
	 svYcRHrGOvjiVBaP9KEAB9yUsh0JSKifd1UXBWLVdnmfHKLPlgA24SuvqS/HrIcYkQ
	 8Scx8CFWjA5SRkLaqcvgE1SRKYI+ii12Y2NLsy8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1419/2077] HID: bpf: Fix hid_bpf_get_data() range check
Date: Tue, 21 Jul 2026 17:18:12 +0200
Message-ID: <20260721152626.271556372@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>

[ Upstream commit 2d044049421dd48212b28646a850749d4a2d57fa ]

hid_bpf_get_data() returns a pointer into the HID-BPF context data when
the caller-provided offset and size fit inside ctx->allocated_size.

The current check adds rdwr_buf_size and offset before comparing the
result against ctx->allocated_size. Since both values are unsigned, a
very large size can wrap the sum below ctx->allocated_size and make the
helper return a pointer even though the requested range is not contained
in the backing buffer.

Use check_add_overflow() to reject wrapped range ends before comparing
the requested range end against ctx->allocated_size.

Fixes: 658ee5a64fcf ("HID: bpf: allocate data memory for device_event BPF programs")
Signed-off-by: Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/bpf/hid_bpf_dispatch.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/bpf/hid_bpf_dispatch.c b/drivers/hid/bpf/hid_bpf_dispatch.c
index d0130658091b02..536f6d01fd14c6 100644
--- a/drivers/hid/bpf/hid_bpf_dispatch.c
+++ b/drivers/hid/bpf/hid_bpf_dispatch.c
@@ -17,6 +17,7 @@
 #include <linux/kfifo.h>
 #include <linux/minmax.h>
 #include <linux/module.h>
+#include <linux/overflow.h>
 #include "hid_bpf_dispatch.h"
 
 const struct hid_ops *hid_ops;
@@ -296,10 +297,12 @@ __bpf_kfunc __u8 *
 hid_bpf_get_data(struct hid_bpf_ctx *ctx, unsigned int offset, const size_t rdwr_buf_size)
 {
 	struct hid_bpf_ctx_kern *ctx_kern;
+	size_t end;
 
 	ctx_kern = container_of(ctx, struct hid_bpf_ctx_kern, ctx);
 
-	if (rdwr_buf_size + offset > ctx->allocated_size)
+	if (check_add_overflow(rdwr_buf_size, offset, &end) ||
+	    end > ctx->allocated_size)
 		return NULL;
 
 	return ctx_kern->data + offset;
-- 
2.53.0



