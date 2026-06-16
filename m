Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B50357D14;
	Tue, 16 Jun 2026 15:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624046; cv=none; b=T2iia+H313CYIV09GoTVeWLArK5zAVmQYpnzgy91oeQDXRGdahAQ6KhZkf+tkf1UofhXLqRUqSIAoaPCkzZxR0UipRSdyJk11lzc0+S2NufFB2V+DW+QqifTMIkXREn1kdNtX5FrpLgzgk48GhPZM763i/QIvisIGg/gMB+9ryY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624046; c=relaxed/simple;
	bh=TL8Mc6lBoAY9ZOZADBWPl+8Y0AJ3ly2OU1NSgptwews=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hjh/tbOFtUBRs6SUejimCVkOy4Gz6ll4sOEwHmk4f049ETSgR3pegVq9oy1i8jFnkY53RlHSJasm7UvMQOOuQd1ShHECdWFpu44bTWWzfZ2tTmMszAZwzBHdfd4PIlSFHZed7qJhSEiPYLq5HudFrnjVCNmhzexGezugf0Q5a8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NT6D/9Vx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NT6D/9Vx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 884F31F000E9;
	Tue, 16 Jun 2026 15:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624045;
	bh=asbK8KrDReSafn65c3e9QEjvUnAg1bCbXjJTyJX2nc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NT6D/9Vxz11KCQpKcXysauI9lnTFw0Z1M3zFnD8rcfqA9z3bXFw0xGBnT9MuZ43bd
	 OY/WKpmz8m8ZHwSymRxUUATVLQEKC4wu8XtT4zEu7LYKHF+xIKAZbxqJUx6LqP/5eR
	 L4sYhjdLxBllBRUJuZhpO9Gg175iWvgmhUSV25gg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 7.0 262/378] accel/ethosu: fix arithmetic issues in dma_length()
Date: Tue, 16 Jun 2026 20:28:13 +0530
Message-ID: <20260616145123.879389195@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Bilal <meatuni001@gmail.com>

commit ee6d9b6e51626f259c6f0e38d94f91be4fd14754 upstream.

dma_length() derives DMA region usage from command stream values and
updates region_size[]:

    len = ((len + stride[0]) * size0 + stride[1]) * size1
    region_size[region] = max(..., len + dma->offset)

Several arithmetic issues can corrupt the derived region size:

- signed stride values may underflow when added to len
- intermediate multiplications may overflow
- len + dma->offset may overflow during region_size updates
- dma_length() error returns were not validated by the caller

region_size[] is later used by ethosu_job.c to validate command stream
accesses against GEM buffer sizes. Arithmetic wraparound can therefore
under-report region usage and bypass the bounds validation.

Fix by validating signed additions, using overflow helpers for
multiplications and offset updates, and propagating dma_length()
failures to the caller.

Fixes: 5a5e9c0228e6 ("accel: Add Arm Ethos-U NPU driver")
Cc: stable@vger.kernel.org
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Link: https://patch.msgid.link/20260524103710.47397-1-meatuni001@gmail.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ethosu/ethosu_gem.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

--- a/drivers/accel/ethosu/ethosu_gem.c
+++ b/drivers/accel/ethosu/ethosu_gem.c
@@ -2,6 +2,7 @@
 /* Copyright 2025 Arm, Ltd. */
 
 #include <linux/err.h>
+#include <linux/overflow.h>
 #include <linux/slab.h>
 
 #include <drm/ethosu_accel.h>
@@ -164,16 +165,26 @@ static u64 dma_length(struct ethosu_vali
 	u64 len = dma->len;
 
 	if (mode >= 1) {
+		if (dma->stride[0] < 0 && (u64)(-dma->stride[0]) > len)
+			return U64_MAX;
 		len += dma->stride[0];
-		len *= dma_st->size0;
+		if (check_mul_overflow(len, (u64)dma_st->size0, &len))
+			return U64_MAX;
 	}
 	if (mode == 2) {
+		if (dma->stride[1] < 0 && (u64)(-dma->stride[1]) > len)
+			return U64_MAX;
 		len += dma->stride[1];
-		len *= dma_st->size1;
+		if (check_mul_overflow(len, (u64)dma_st->size1, &len))
+			return U64_MAX;
+	}
+	if (dma->region >= 0) {
+		u64 end;
+
+		if (check_add_overflow(len, dma->offset, &end))
+			return U64_MAX;
+		info->region_size[dma->region] = max(info->region_size[dma->region], end);
 	}
-	if (dma->region >= 0)
-		info->region_size[dma->region] = max(info->region_size[dma->region],
-						     len + dma->offset);
 
 	return len;
 }
@@ -397,6 +408,8 @@ static int ethosu_gem_cmdstream_copy_and
 		case NPU_OP_DMA_START:
 			srclen = dma_length(info, &st.dma, &st.dma.src);
 			dstlen = dma_length(info, &st.dma, &st.dma.dst);
+			if (srclen == U64_MAX || dstlen == U64_MAX)
+				return -EINVAL;
 
 			if (st.dma.dst.region >= 0)
 				info->output_region[st.dma.dst.region] = true;


