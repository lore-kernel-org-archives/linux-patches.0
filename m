Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B147B3B19BA;
	Sat, 17 Oct 2026 17:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259195; cv=none; b=D8iai4A+nYAXfffbGjWQ4w239t7Eh3/vmdXMU/2zvIgH6+uwsif0BwTK6elVh6mFjuuhXWlGdaQzQL6NLbxUHFrBCGDfzBHE9CFmnpxJQY71PbKoWTPlbBh8fsRHpkNzeTyxJQt/+6DLzToLA3Ofw9Gn0Zh/pdnQprOe8bSbmi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259195; c=relaxed/simple;
	bh=z80H0XY73IT2rccZ/1Y0hS/a11oR/Du6PyxGayj8xhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pk9kz+25B/VVa2NhW6FIfJtLkTIENdqPL4Xk8HN17xyGwWHhy0JqzHbRn36HJR9q5FF+kpY8zEe5/6HiI3ViGf5W/7bTaetKGIsZQD7be+38J75Bn7oI0JyypCJ6VJXXrrs3YVatCWT2V4lLQbwvsbR4lJDqeOXDdzTRELcrbeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O2S9OEn9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O2S9OEn9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 127ED1F000C5;
	Sat, 17 Oct 2026 17:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259194;
	bh=DZQcURYrv6/RTQReo7QMYR9hbqTHd9W8kNgkPMT1i/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O2S9OEn9QGUzuQ/pn/uYbQNg3hH1FbjYwZLUszQyhb/Q1igYU6lQfOkKu6jK+I66D
	 2kYYsQ1WxBy6KeVcMnVfqGJ0yPOk2gm/S2lIv8StM0ePBZ1p5th3IJx0YPjmO+PTOQ
	 kuTpE8PCploKV/SHPcNUaA5Nep/m9gq5KD9AOLMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1132/1674] HID: bpf: Fix hid_bpf_get_data() range check
Date: Sat, 17 Oct 2026 17:56:44 +0200
Message-ID: <20261017160500.215369720@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e0c03942ff7c4..9948ada290f03 100644
--- a/drivers/hid/bpf/hid_bpf_dispatch.c
+++ b/drivers/hid/bpf/hid_bpf_dispatch.c
@@ -18,6 +18,7 @@
 #include <linux/minmax.h>
 #include <linux/module.h>
 #include <linux/workqueue.h>
+#include <linux/overflow.h>
 #include "hid_bpf_dispatch.h"
 #include "entrypoints/entrypoints.lskel.h"
 
@@ -157,13 +158,15 @@ noinline __u8 *
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



