Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C811D284662;
	Tue, 21 Jul 2026 19:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663261; cv=none; b=ALuOmdz2frhgsKYnCn8+Jdb87B1zD84nzAEOIBU3yFBYYFRNU/hY/tzoh+hLZ7Inybnp+OecQbusRNzkb4kQsgx3ouyl6O9Z9LLJDs+SmymZ3EYN3aUx939Xd4nJuaFpBuyKMZN8yAN8WiDuHnYC8y6TWbw4wZ7A3nff0BQYq5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663261; c=relaxed/simple;
	bh=OFQkm6gjMpCKTXE+7VGue57Ual2RdoOx0Ag+6Eoy+6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S7egQhAmdSD8NZXKd6OVdJc/IL7dwzpoLkzbo/nXm4n2YbMmOixLiKoIRYypIkaqdeBnAD4kZS/Ee7p2KFfysVlc5405eTczxeVewRrAD45H+T48Kw04rCap/7YuLQAY8zjPochoi9QnIAtRCfg/Qj18FM2c/JwSSSfaZt3xcm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V/3kcjsr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V/3kcjsr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38CBC1F000E9;
	Tue, 21 Jul 2026 19:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663260;
	bh=shgx1QAPtxFMSJSosZlBhqzukEkwdmwIkh8dmzkKCS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V/3kcjsrbyvc0kDuip7ileTm3Q5uAF6o6TllU9Osyx9ZtLQ2Ly5leI2b2VGaCV0se
	 EIRsiUXRGiUr3qGstARmWXvhHhm8gvTqeWIZzpiFi/xkRtHIu3+l36Grt5G33X1oaf
	 YBtt9orOOGG/DemOACPhRe2Z2ubOcK1puxhE48ZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0756/1276] HID: bpf: Fix hid_bpf_get_data() range check
Date: Tue, 21 Jul 2026 17:19:59 +0200
Message-ID: <20260721152502.994517930@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b711d83dfde1d4..1de6a7e0af7b4c 100644
--- a/drivers/hid/bpf/hid_bpf_dispatch.c
+++ b/drivers/hid/bpf/hid_bpf_dispatch.c
@@ -17,6 +17,7 @@
 #include <linux/kfifo.h>
 #include <linux/minmax.h>
 #include <linux/module.h>
+#include <linux/overflow.h>
 #include "hid_bpf_dispatch.h"
 
 struct hid_ops *hid_ops;
@@ -293,13 +294,15 @@ __bpf_kfunc __u8 *
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



