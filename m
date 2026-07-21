Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C4E46EF63;
	Tue, 21 Jul 2026 18:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658141; cv=none; b=E/FzEuNWf49kfomiuNbJPl1MvknJenRI/j5dSqo02oHKIvQUKcVvLzKeCMR85HkN4dgIqXLrmbbu6+DlGB7AndVjAIDM4+o+auDixCO9a2Bc46SDxLLCuXts5G+DAvpF0yhckxgYlj3g2Lel1CPi1MYxjfsiZ26DsrkZE+n+YwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658141; c=relaxed/simple;
	bh=ubVVsMrTMAIy05U8yBUspJWJR1+idYz/UCKdWfyk5mI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bf4jasEvelfzJIH8DxLvegMrMI5pQbXRin23XUDGhdoKNFtmgyTAO96ZPp3c3BZCIzxJ+YoFaR7/EJDzm/JBAMeEiJLIaDH8cPWwHGoTm1wp7MZoa6Kgdg5GIzbMfp76MLkKJluOhRwlHXhAZazUP5aVcQx7UQr7D1EpYb72NAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=00SFi+wf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="00SFi+wf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7DD21F00A3D;
	Tue, 21 Jul 2026 18:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658140;
	bh=ErFCSSagJyYP6rOLj2BJXnPanztQSg/TAm2l1sfltrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=00SFi+wf8FwUq0L9pHaKmtsJoMg8mQ2MfIQDIAA1UhqBRPFo6XZw421iXX0VA7wuQ
	 cJi8Rwr2zs4AXv6mH5nhZvw9i7Bk9i+0Ei3oWuyvx7QN7oThDCsXD8QBHA6mCIbxSR
	 hLChAaNgH/fP0Fe8E2cvg8BjkZ9ft0wjMudyn1Xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1032/1611] HID: bpf: Fix hid_bpf_get_data() range check
Date: Tue, 21 Jul 2026 17:19:08 +0200
Message-ID: <20260721152538.613277370@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index eb9f40c988d02b..e6cf551b41e8e7 100644
--- a/drivers/hid/bpf/hid_bpf_dispatch.c
+++ b/drivers/hid/bpf/hid_bpf_dispatch.c
@@ -17,6 +17,7 @@
 #include <linux/kfifo.h>
 #include <linux/minmax.h>
 #include <linux/module.h>
+#include <linux/overflow.h>
 #include "hid_bpf_dispatch.h"
 
 const struct hid_ops *hid_ops;
@@ -296,13 +297,15 @@ __bpf_kfunc __u8 *
 hid_bpf_get_data(struct hid_bpf_ctx *ctx, unsigned int offset, const size_t rdwr_buf_size)
 {
 	struct hid_bpf_ctx_kern *ctx_kern;
+	size_t end;
 
 	if (!ctx)
 		return NULL;
 
 	ctx_kern = container_of(ctx, struct hid_bpf_ctx_kern, ctx);
 
-	if (rdwr_buf_size + offset > ctx->allocated_size)
+	if (check_add_overflow(rdwr_buf_size, offset, &end) ||
+	    end > ctx->allocated_size)
 		return NULL;
 
 	return ctx_kern->data + offset;
-- 
2.53.0



