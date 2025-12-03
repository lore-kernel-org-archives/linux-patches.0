Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E19422DA769;
	Wed,  3 Dec 2025 15:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776631; cv=none; b=Y0MSezLBz7SfTAlAJEYiKVgIIN1jF4YNn2vRBEbtQ7yujKDsAMagvJM33OZ5Wch/ajPcyid5SXzTK2rPenHjl0HKr34a+CRh0HK23eCWE3UdGJQOTyxyOkU3OjLe6qXWZFtVzKh/6Gu25uKTpHJglIGlKVf5vMKY/zkIMhdIm2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776631; c=relaxed/simple;
	bh=+hzTvBGMmRB+f5cNnmxUsJyRYDIjB3UAcbITVgd6OpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R1WJjpsIcUMokyr+ybjPlbdxrJ+Qr/h+Oy8A9eTIXgVfaIiqbFy16058ilw+A+ppDFtkiazOMIRlYHH8zNW+bD7np3QG7tcagXTz3Ui/ON1ksRPk1n5sCCPUV+/gs1mviESr0SaELhc5VvV2s0TrVw2sX+Xl3QVRpbJ8TRQB0gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M9+Z1fEc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M9+Z1fEc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D1A0C4CEF5;
	Wed,  3 Dec 2025 15:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776630;
	bh=+hzTvBGMmRB+f5cNnmxUsJyRYDIjB3UAcbITVgd6OpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M9+Z1fEc7rof15lCtoy23YDzA93VW5kn9IcOOLE3ZpTn52hpucB+59JJP0LRqCeFk
	 xM5DPzu/DNEIx2ea0ysxisYK0uE5/zufClP8JJfnBdejevpTsoSbSee7HqfXC+ocnQ
	 FVEFH/WL0Z9McDhaUH81Ch0H27t+llrkiJazWXPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Matthieu Baerts <matttbe@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10 207/300] gcov: add support for GCC 15
Date: Wed,  3 Dec 2025 16:26:51 +0100
Message-ID: <20251203152408.291453271@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

From: Peter Oberparleiter <oberpar@linux.ibm.com>

commit ec4d11fc4b2dd4a2fa8c9d801ee9753b74623554 upstream.

Using gcov on kernels compiled with GCC 15 results in truncated 16-byte
long .gcda files with no usable data.  To fix this, update GCOV_COUNTERS
to match the value defined by GCC 15.

Tested with GCC 14.3.0 and GCC 15.2.0.

Link: https://lkml.kernel.org/r/20251028115125.1319410-1-oberpar@linux.ibm.com
Signed-off-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Reported-by: Matthieu Baerts <matttbe@kernel.org>
Closes: https://github.com/linux-test-project/lcov/issues/445
Tested-by: Matthieu Baerts <matttbe@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/gcov/gcc_4_7.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/gcov/gcc_4_7.c
+++ b/kernel/gcov/gcc_4_7.c
@@ -19,7 +19,9 @@
 #include <linux/vmalloc.h>
 #include "gcov.h"
 
-#if (__GNUC__ >= 14)
+#if (__GNUC__ >= 15)
+#define GCOV_COUNTERS			10
+#elif (__GNUC__ >= 14)
 #define GCOV_COUNTERS			9
 #elif (__GNUC__ >= 10)
 #define GCOV_COUNTERS			8


