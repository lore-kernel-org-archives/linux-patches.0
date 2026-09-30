Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22EE369990;
	Wed, 30 Sep 2026 15:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783200; cv=none; b=PPuLgO6UFHZKJ3fdcSO4cxC9TO2OHOP9xV+cjP+qhysV8iACY0MdJ27G5uGLI3dCTgu0RX/N3YTC23tQUlJ9vBTJeCRwngWNCAP/U4NSix0UmiELffCbnoPxm3PcZhu99iqhnzqBk72c38GrSn4TCJSb4czDyzvvex5A0oLP+Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783200; c=relaxed/simple;
	bh=OvY2fSbyjKP8MmGO9IWO6qm/KUe/GNMzNK2U75CiU0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dkg7MffhOO3zMetw9+1T2zCGdHxqmi7PK5QvUSz5s5bkqn1DbSL3A4ZOrP60cx4aJl05GTBYsrKwxsnP0d1R8RxqUPviHyhGhuOo5pSpCq+lFzQPR7RhESY9GFst4tfjVWg1BhIakhqCP30MJGveX1qFCJWczfOeZ9Z7/3Ja7Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1k8/VlwY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1k8/VlwY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A331F00893;
	Wed, 30 Sep 2026 15:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783197;
	bh=LM+CiCHATuRCmkMxoLNGXd4dY/w9mZRwJEUtrcZItJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1k8/VlwY/LCWPF01UfdOO2OME/HFS5SDGm/cg2zfpNRPxx9fHAoz2H7ojONndgXYH
	 BLvjczWBm2387O+sRCpzCu4eGRMOAw9WqIAfsSshssxUEXyFP2nNMp3fO3dQetMAof
	 3V9I95RKoO8W/IY56H6+uAIMAhkjiJZVqyi9zN4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.10 315/595] media: hevc: add bounded tile-count helpers
Date: Wed, 30 Sep 2026 17:23:28 +0200
Message-ID: <20260930152354.464113914@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 592dd4f8442a13bed6e946d73d3164ba38b33bbd upstream.

The stateless HEVC decoders compute the number of tile columns and rows
from num_tile_columns_minus1 / num_tile_rows_minus1 and clamp it to the
column_width_minus1[] / row_height_minus1[] capacity before using it as a
loop bound. Add shared helpers in a new <media/v4l2-hevc.h> so the rkvdec
and hantro drivers do not each open-code the min_t() clamp.

Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Assisted-by: Claude:claude-opus-4-8
Fixes: 256fa3920874 ("media: v4l: Add definitions for HEVC stateless decoding")
Cc: stable@vger.kernel.org
Reviewed-by: Benjamin Gaignard <benjamin.gaignard@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/media/v4l2-hevc.h |   41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)
 create mode 100644 include/media/v4l2-hevc.h

--- /dev/null
+++ b/include/media/v4l2-hevc.h
@@ -0,0 +1,41 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Helper functions for HEVC stateless codecs.
+ */
+
+#ifndef _MEDIA_V4L2_HEVC_H
+#define _MEDIA_V4L2_HEVC_H
+
+#include <linux/minmax.h>
+#include <media/v4l2-ctrls.h>
+
+/**
+ * v4l2_hevc_pps_num_tile_columns - number of HEVC tile columns, bounded
+ * @pps: the V4L2 HEVC PPS control
+ *
+ * Return the number of tile columns (num_tile_columns_minus1 + 1) clamped to
+ * the capacity of column_width_minus1[]. The control validation already
+ * rejects out-of-range counts; this keeps the consuming drivers bounded too.
+ */
+static inline unsigned int
+v4l2_hevc_pps_num_tile_columns(const struct v4l2_ctrl_hevc_pps *pps)
+{
+	return min_t(unsigned int, pps->num_tile_columns_minus1 + 1,
+		     ARRAY_SIZE(pps->column_width_minus1));
+}
+
+/**
+ * v4l2_hevc_pps_num_tile_rows - number of HEVC tile rows, bounded
+ * @pps: the V4L2 HEVC PPS control
+ *
+ * Return the number of tile rows (num_tile_rows_minus1 + 1) clamped to the
+ * capacity of row_height_minus1[].
+ */
+static inline unsigned int
+v4l2_hevc_pps_num_tile_rows(const struct v4l2_ctrl_hevc_pps *pps)
+{
+	return min_t(unsigned int, pps->num_tile_rows_minus1 + 1,
+		     ARRAY_SIZE(pps->row_height_minus1));
+}
+
+#endif /* _MEDIA_V4L2_HEVC_H */


