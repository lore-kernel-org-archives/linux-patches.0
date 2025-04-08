Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCCAD26B080;
	Tue,  8 Apr 2025 12:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114877; cv=none; b=ehlyHXg1WN11rr6rW5WYnTDvTo6vrfsOM7OAEOPaEnGPQ04DrBeYl0AiS8CdymzaKVwgFpps/uYGAd4JRVNQhk87IveCJ8XvjXFK3THe0tzzjnfKveAFf3FPwRxZ5onaVuduEV70N3kOD7GBVDA+fAJAHzTZR+MsriIOKdElUGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114877; c=relaxed/simple;
	bh=rq+G9N6tGKxNSAd2oW78zYRSLBO9kpiAgY8kJQ9t35I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZwT2eBUw47+xRmzX5CM88P//LF5bMlzZICViutRDoFpMbgKP8jnJjxw99gl1ZkGXEEzFc2IdX9OKtQPsmtggiSTh2pFEpYcX5t/HTkWZHVBLkAQABh81rpu0qkMr/6JxvUkZnBNgG66NzB0zjytJf/0/RSCB1sIJ+ThBGihrpT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R+NZYC4J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R+NZYC4J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45366C4CEE7;
	Tue,  8 Apr 2025 12:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114877;
	bh=rq+G9N6tGKxNSAd2oW78zYRSLBO9kpiAgY8kJQ9t35I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R+NZYC4JQeUw3AKORxn4bsJH+JAR63++7LQPgu+mqMPgMxLsBd0PVoevD0+23dhen
	 iRzuBsQD9Xg5c4riB/RCRAFDP5dxxCv73os0k3wzncltjZo81P2KYOfZGvXhlLJ7Bd
	 FaJoPMp3WyX67kEFRD8K4+0QIy1fpQ/NBK0kGvFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Likhitha Korrapati <likhitha@linux.ibm.com>,
	Athira Rajeev <atrajeev@linux.ibm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 269/499] perf tools: Fix is_compat_mode build break in ppc64
Date: Tue,  8 Apr 2025 12:48:01 +0200
Message-ID: <20250408104857.924233766@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Likhitha Korrapati <likhitha@linux.ibm.com>

[ Upstream commit 7e442be7015af524d2b5fb84f0ff04a44501542b ]

Commit 54f9aa1092457 ("tools/perf/powerpc/util: Add support to
handle compatible mode PVR for perf json events") introduced
to select proper JSON events in case of compat mode using
auxiliary vector. But this caused a compilation error in ppc64
Big Endian.

arch/powerpc/util/header.c: In function 'is_compat_mode':
arch/powerpc/util/header.c:20:21: error: cast to pointer from
integer of different size [-Werror=int-to-pointer-cast]
   20 |         if (!strcmp((char *)platform, (char *)base_platform))
      |                     ^
arch/powerpc/util/header.c:20:39: error: cast to pointer from
integer of different size [-Werror=int-to-pointer-cast]
   20 |         if (!strcmp((char *)platform, (char *)base_platform))
      |

Commit saved the getauxval(AT_BASE_PLATFORM) and getauxval(AT_PLATFORM)
return values in u64 which causes the compilation error.

Patch fixes this issue by changing u64 to "unsigned long".

Fixes: 54f9aa1092457 ("tools/perf/powerpc/util: Add support to handle compatible mode PVR for perf json events")
Signed-off-by: Likhitha Korrapati <likhitha@linux.ibm.com>
Reviewed-by: Athira Rajeev <atrajeev@linux.ibm.com>
Link: https://lore.kernel.org/r/20250321100726.699956-1-likhitha@linux.ibm.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/arch/powerpc/util/header.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/arch/powerpc/util/header.c b/tools/perf/arch/powerpc/util/header.c
index c7df534dbf8f8..0be74f048f964 100644
--- a/tools/perf/arch/powerpc/util/header.c
+++ b/tools/perf/arch/powerpc/util/header.c
@@ -14,8 +14,8 @@
 
 static bool is_compat_mode(void)
 {
-	u64 base_platform = getauxval(AT_BASE_PLATFORM);
-	u64 platform = getauxval(AT_PLATFORM);
+	unsigned long base_platform = getauxval(AT_BASE_PLATFORM);
+	unsigned long platform = getauxval(AT_PLATFORM);
 
 	if (!strcmp((char *)platform, (char *)base_platform))
 		return false;
-- 
2.39.5



