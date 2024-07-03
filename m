Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21876174EF3;
	Wed,  3 Jul 2024 11:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005872; cv=none; b=dTzWHkVnGTfCyjjN1A0mCnQWfLzKjfNtyCUqJLQDv9OSB/UNy48WeSMS9VkKTuT8OAom0LkvcITOuypH3j0P/3jtBcXlVWPg+q/hHQ89iHuQDpS4qipm+++RDH0iYFxkhJ5TWbxk13hcNikLtcotYpAC1zwvF7hHGPa6YZ4ra8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005872; c=relaxed/simple;
	bh=sMFZstKMMmSmlTvCsgRZXYkQ3JfI56qQbvqHjN6Tp7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OqJrs+hEsdn8Ep8s2NJMrRebldjwe8gt6wwoOelVafGkK46OuTD+xVBKeTPsNIatPSboUCxETTdcSw+V911NS+Sh0znUwr00PvVqL/sAsa5AKZ5G31D2FSTykOxUjeC94/k05a/oSGFnCjljBK4Te+429qpuneznIJMXFACacTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VLuUKdi/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VLuUKdi/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64BE7C2BD10;
	Wed,  3 Jul 2024 11:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005871;
	bh=sMFZstKMMmSmlTvCsgRZXYkQ3JfI56qQbvqHjN6Tp7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VLuUKdi/BUJg6P9Z8kPZTorZ/J+4YR5ggyRLylo6gEzsLRYYXJ2ckopgyOqNnHGLS
	 Yux+GrE8wRf8UdxmWSl8OozjtWidjQManFI/7nWGiX72jz+jq6UjTbUFsKnyGQgypK
	 V6GHt8ICfIE0fiC+HH+cgVOn78aJQznDk5O4D3og=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	Chuck Lever III <chuck.lever@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 225/356] gcov: add support for GCC 14
Date: Wed,  3 Jul 2024 12:39:21 +0200
Message-ID: <20240703102921.628133397@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Oberparleiter <oberpar@linux.ibm.com>

commit c1558bc57b8e5b4da5d821537cd30e2e660861d8 upstream.

Using gcov on kernels compiled with GCC 14 results in truncated 16-byte
long .gcda files with no usable data.  To fix this, update GCOV_COUNTERS
to match the value defined by GCC 14.

Tested with GCC versions 14.1.0 and 13.2.0.

Link: https://lkml.kernel.org/r/20240610092743.1609845-1-oberpar@linux.ibm.com
Signed-off-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Reported-by: Allison Henderson <allison.henderson@oracle.com>
Reported-by: Chuck Lever III <chuck.lever@oracle.com>
Tested-by: Chuck Lever <chuck.lever@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/gcov/gcc_4_7.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/gcov/gcc_4_7.c
+++ b/kernel/gcov/gcc_4_7.c
@@ -18,7 +18,9 @@
 #include <linux/mm.h>
 #include "gcov.h"
 
-#if (__GNUC__ >= 10)
+#if (__GNUC__ >= 14)
+#define GCOV_COUNTERS			9
+#elif (__GNUC__ >= 10)
 #define GCOV_COUNTERS			8
 #elif (__GNUC__ >= 7)
 #define GCOV_COUNTERS			9


