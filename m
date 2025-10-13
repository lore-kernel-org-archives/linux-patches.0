Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D35291C33;
	Mon, 13 Oct 2025 14:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367494; cv=none; b=Wo29IisjAI0qvCGv/qXOLD40rvyGazr0YqVl5vtW/k+dw+3koOnK+7C4EOr562e0GwzEbToXYyZOuhGEOF0g3LWp/EYOAwBs0W9S8M3IfY3gWaDN6fyhOmD0YCdu9NiKwSO1uPE6zZpxM2twawnCods1lVSM4RG5/6c4RTX5b2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367494; c=relaxed/simple;
	bh=09aH5h9Iu9XMh5ZWg+XEBazBKb5I2fa4HRaKHV+aECg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dHdaK07NsqXpIxXo2KmhVHuBwnIPYYB4zVBA7TTRtk/0TDEeOMNSD0SMu1FQozQnjc0bk8pAhvJl5412/rP0eQ1VCjXKl18VzMrkp3zRX9xCkQbRlxFjbHC/jlXvV7ddNTEfyB9smiKqdj1sR1abBP7AD0dMefJOpbMQX9/zF8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0TS3HNyI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0TS3HNyI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7234C4CEE7;
	Mon, 13 Oct 2025 14:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367494;
	bh=09aH5h9Iu9XMh5ZWg+XEBazBKb5I2fa4HRaKHV+aECg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0TS3HNyIwQ/MF0AMvEViQCVkplbYiBM0tgqDKew9IC3tsdDVjMkP6jruJdOrqhg/v
	 Q2kKko/q0DNfBwZm05xmPnZe6WdMYu0MvgW9CBfSFO9YeBxx7yDZ8KiTXKFWLkm95s
	 BzqCbZycbJdzl4z6H/IvW6vMBeXTqaS0yxgw+/ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 006/196] coresight: trbe: Prevent overflow in PERF_IDX2OFF()
Date: Mon, 13 Oct 2025 16:43:17 +0200
Message-ID: <20251013144315.423914179@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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
index e20c1c6acc731..7f91b1ffe66a5 100644
--- a/drivers/hwtracing/coresight/coresight-trbe.c
+++ b/drivers/hwtracing/coresight/coresight-trbe.c
@@ -21,7 +21,8 @@
 #include "coresight-self-hosted-trace.h"
 #include "coresight-trbe.h"
 
-#define PERF_IDX2OFF(idx, buf) ((idx) % ((buf)->nr_pages << PAGE_SHIFT))
+#define PERF_IDX2OFF(idx, buf) \
+	((idx) % ((unsigned long)(buf)->nr_pages << PAGE_SHIFT))
 
 /*
  * A padding packet that will help the user space tools
-- 
2.51.0



