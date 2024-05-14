Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29FD6CDC9;
	Tue, 14 May 2024 10:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683949; cv=none; b=hNTBFpbTRWeDu/D4v4uThG5qeL7/wTLusCyMGXiQDnM7RndWWOF/31qCVBOs/oeDt0XzyQcWjaVZjRZ6oyThYDE5LbYehAIeKd50YcvBYvFd5tXt7fF5oX4GQZkRFGNFXrAtIthgRoIXAb7Sv+r1ayYDAetmaTVyT6F829Pw1oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683949; c=relaxed/simple;
	bh=Vhu9frgZTtzjqKefU4M0DJEKlUADe+xuppHv2RYgawc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YMd5pts1ZiMkKWrC98tZ5dHvlsGkWdipM0CvlhcCZPrx7ElR7DTpNrR0Ype4qt87RIL2dpy4GihaqA7llimBZimj5ZOm6FVK8qinDKZkL8rB7DhNadWNUDHbqOyf+/d6mH4y90frvj2Ke6gNoP2lA7j88Rs5zWcHMMu95fqIP3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uvFMlt8T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uvFMlt8T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E812C2BD10;
	Tue, 14 May 2024 10:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683948;
	bh=Vhu9frgZTtzjqKefU4M0DJEKlUADe+xuppHv2RYgawc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uvFMlt8TqKsETWFtf4zmNj6pBanpDACaFfC9CjbtmihB3Fh5CpStPb4nKJJlUJrKJ
	 GUZRku6pijK2TNN4bioQqciA7If7gj3j+DUu/wIMqnREdMOgu7MXtn+Ns8nGuzngE9
	 QMmzmmLBFSKp5PPcr5nQbnbu956SSA4Fe1wN9Sjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	20240228012313.5934-1-yaolu@kylinos.cn,
	Matt Coster <matt.coster@imgtec.com>,
	Frank Binns <frank.binns@imgtec.com>
Subject: [PATCH 6.8 299/336] drm/imagination: Ensure PVR_MIPS_PT_PAGE_COUNT is never zero
Date: Tue, 14 May 2024 12:18:23 +0200
Message-ID: <20240514101049.906771061@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Coster <matt.coster@imgtec.com>

commit e4236b14fe32a8d92686ec656c870a6bb1d6f50a upstream.

When the host page size was more than 4 times larger than the FW page
size, this macro evaluated to zero resulting in zero-sized arrays.

Use DIV_ROUND_UP() to ensure the correct behavior.

Reported-by: 20240228012313.5934-1-yaolu@kylinos.cn
Closes: https://lore.kernel.org/dri-devel/20240228012313.5934-1-yaolu@kylinos.cn
Link: https://lore.kernel.org/dri-devel/20240228012313.5934-1-yaolu@kylinos.cn
Fixes: 927f3e0253c1 ("drm/imagination: Implement MIPS firmware processor and MMU support")
Cc: stable@vger.kernel.org
Signed-off-by: Matt Coster <matt.coster@imgtec.com>
Reviewed-by: Frank Binns <frank.binns@imgtec.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/imagination/pvr_fw_mips.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/imagination/pvr_fw_mips.h
+++ b/drivers/gpu/drm/imagination/pvr_fw_mips.h
@@ -7,13 +7,14 @@
 #include "pvr_rogue_mips.h"
 
 #include <asm/page.h>
+#include <linux/math.h>
 #include <linux/types.h>
 
 /* Forward declaration from pvr_gem.h. */
 struct pvr_gem_object;
 
-#define PVR_MIPS_PT_PAGE_COUNT ((ROGUE_MIPSFW_MAX_NUM_PAGETABLE_PAGES * ROGUE_MIPSFW_PAGE_SIZE_4K) \
-				>> PAGE_SHIFT)
+#define PVR_MIPS_PT_PAGE_COUNT DIV_ROUND_UP(ROGUE_MIPSFW_MAX_NUM_PAGETABLE_PAGES * ROGUE_MIPSFW_PAGE_SIZE_4K, PAGE_SIZE)
+
 /**
  * struct pvr_fw_mips_data - MIPS-specific data
  */


