Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4F9310768;
	Mon, 13 Oct 2025 15:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368081; cv=none; b=n+dHq3XTJaVhgc2ml/xE84teZ9n5YT2TlANEPDq5gVdTjmHXH+TaJBKJwE3GEg6JEtpZeqMdOXzj4d0ZSzgg0vCpkSDtRCLafodElWPq6E3eGFYHNQzGPl7rEHTEiImdP9CWWUWhtaAwdha35qRx+UjI/I7/3B5z0qOnKDJiq6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368081; c=relaxed/simple;
	bh=B4kqeZBAOGz8rLMynEnwNsnmrBfqJYrIpkOLI/C3i9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N8+rkxYJy5PhY/bSKUDPDT/16c/gux8L6Nk5yVyfw9/66hXQs8KYC1bfAcrMpZB0uew3OnOUWMp6aWzhtEDdbZtoTR2chBJMFBWPQ8nWCpcXh9pmFaUHpDP/2gxDx+uI7YgM3WgXWi+fadeU8yots0W9CZlz02B1jGFa6MVeLn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=THmswBU2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="THmswBU2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 435BCC4CEE7;
	Mon, 13 Oct 2025 15:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368081;
	bh=B4kqeZBAOGz8rLMynEnwNsnmrBfqJYrIpkOLI/C3i9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=THmswBU2YJOpQIn7ncHNqB6vQe0O7l1SApu8UbtnPw76Lbc7ZBZGQMQ0Nn7RYbybT
	 8F4W+1Ml24O4DEeMu600lteToVXiCQAyGhpYoW8ysJ8QH0Q9nQ54kM2x5V9So7OeTe
	 Fcb+l12XOKGJritMhuyvRZ87g2bHDR9sOozNAczA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 009/262] coresight: trbe: Prevent overflow in PERF_IDX2OFF()
Date: Mon, 13 Oct 2025 16:42:31 +0200
Message-ID: <20251013144326.461390327@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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
index 96a32b2136699..492b2612f64e0 100644
--- a/drivers/hwtracing/coresight/coresight-trbe.c
+++ b/drivers/hwtracing/coresight/coresight-trbe.c
@@ -22,7 +22,8 @@
 #include "coresight-self-hosted-trace.h"
 #include "coresight-trbe.h"
 
-#define PERF_IDX2OFF(idx, buf) ((idx) % ((buf)->nr_pages << PAGE_SHIFT))
+#define PERF_IDX2OFF(idx, buf) \
+	((idx) % ((unsigned long)(buf)->nr_pages << PAGE_SHIFT))
 
 /*
  * A padding packet that will help the user space tools
-- 
2.51.0



