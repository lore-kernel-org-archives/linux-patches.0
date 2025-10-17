Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF21330B0D;
	Fri, 17 Oct 2025 15:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715962; cv=none; b=iERjISUxKMk+9WbZcccp8Uk9tdtCqpv+/98Lcp9xPHmxzC9oB20HOdwQD/hdTfVxOvsGaVVTORg6SLuZo+SMrrGiMBpXVjbFik7WuyIaiugp4c9xZDIkjBUnLLPnc31vBvUL5iZ41tEgnx2IFdmLczbUK9a4YFaEI9Fr2fLFeb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715962; c=relaxed/simple;
	bh=uzKTT9ZASGcoxm9n+Y+S55pCC235yl1Z7zc/iEYd2X8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fb4CLzyGXZnJdVyFsyrYk479JemO6P7j0+3px3RNds5fqrJ8WJXtOBOSdseAKKWoZBsPkkqstDj0axe6xuDC42oZQ1TCry7NyEB6KpFictQnjh/XjHu5WiipT/U44OCNCOs+Emj2s4PeBxb7KigbV5asBGUFph9GVB1GGolc0tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kWZOgULf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kWZOgULf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5FBDC4CEE7;
	Fri, 17 Oct 2025 15:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715962;
	bh=uzKTT9ZASGcoxm9n+Y+S55pCC235yl1Z7zc/iEYd2X8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kWZOgULfp3G5++OCGvK1ElkiTwYtpJ4Hv1yroHEe0NWzlFkiDDzrzugjzA0TAQkpS
	 wROjTFbx+NQLfWHgXy7tp9TsCTtQejt1OVtBq9RDA8rx8be17r/Y6yxb2PPkpLXsi5
	 duCFZ1SldU8wPZo+d16NJkT80WSV99svXeiARJZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 025/276] coresight: trbe: Prevent overflow in PERF_IDX2OFF()
Date: Fri, 17 Oct 2025 16:51:58 +0200
Message-ID: <20251017145143.322726616@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit 105f56877f2d5f82d71e20b45eb7be7c24c3d908 ]

Cast nr_pages to unsigned long to avoid overflow when handling large
AUX buffer sizes (>= 2 GiB).

Fixes: 3fbf7f011f24 ("coresight: sink: Add TRBE driver")
Signed-off-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-trbe.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/hwtracing/coresight/coresight-trbe.c b/drivers/hwtracing/coresight/coresight-trbe.c
index fac63d092c7be..732a4bed3f207 100644
--- a/drivers/hwtracing/coresight/coresight-trbe.c
+++ b/drivers/hwtracing/coresight/coresight-trbe.c
@@ -18,7 +18,8 @@
 #include <asm/barrier.h>
 #include "coresight-trbe.h"
 
-#define PERF_IDX2OFF(idx, buf) ((idx) % ((buf)->nr_pages << PAGE_SHIFT))
+#define PERF_IDX2OFF(idx, buf) \
+	((idx) % ((unsigned long)(buf)->nr_pages << PAGE_SHIFT))
 
 /*
  * A padding packet that will help the user space tools
-- 
2.51.0



