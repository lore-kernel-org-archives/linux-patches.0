Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D07226B742;
	Mon, 13 Oct 2025 14:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367001; cv=none; b=eUsosa9UPe2o9E6SdzEUVouHqpczaqEBuMPkMF4dsicABjf78b9NLDaJp/OXvWnHeyLomNViV+Ybl/e/4T6R6konWqoE7RcsVTZOEh9tVTGvjOi0dAsaAzyeMBRsz7J4A1GjvtjOaZ8nmhIExEqti81fLEI5yVjdow9V+5DO6B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367001; c=relaxed/simple;
	bh=NovrTsFIN0u24jhXaH3iWAl7+xDAlFdRiB6/qQqTcQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sc4qCceFOzXGgHw9WuUjErys2WtB45kFBHoos0aL2qr2IXfbL1z5uo3k9h46oiy0hfN8/bFs+WzhvTUYdqDB6N6ranTOxy/jgs9zd/WyaUXCmMq1YivokNj7+I8Wi7HZYOYtSS/HaEXGBIRg2VrTCub+kf9Ky6Mi8PJkYGbA/Tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A2MCL8wb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A2MCL8wb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 514D5C4CEFE;
	Mon, 13 Oct 2025 14:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367000;
	bh=NovrTsFIN0u24jhXaH3iWAl7+xDAlFdRiB6/qQqTcQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A2MCL8wb91MPEQnx5dn2UHIspazvtqSN09a609JjkHA109sOEGTr21kf5yMz/12rJ
	 8gcHD86XB7lkiMW+X/R7diFQGd3ogixofTa8mbC2rJ7QbyTV65xOCkTXLZ+vWWo32z
	 ziHvZZVjy24rF8Y5Hoyny/craF/9qWnCkhZO3Fxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 050/196] coresight: trbe: Prevent overflow in PERF_IDX2OFF()
Date: Mon, 13 Oct 2025 16:43:43 +0200
Message-ID: <20251013144316.395891582@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 925f6c9cecff4..bc6e247443e80 100644
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



