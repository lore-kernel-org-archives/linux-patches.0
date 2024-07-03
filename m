Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2728461FDF;
	Wed,  3 Jul 2024 11:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004691; cv=none; b=t51xkgv7sTMhgoR0tWqzatUW0R/X66F8tYW9jM/+oYsfCrGtxyRlgwvE2j99ZmQs0wdOkpbHBcNxEOkCQCY1qg8DQne0ndrXnrZ5n69CZzsa/NGizOcfJ3asg146SlUk0mH7jy2Rf63wqcu/PBGSREIRu2D6pZChPI3h0mkJEOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004691; c=relaxed/simple;
	bh=2vhhxmDyK5Xs0PWTWAyXQU2d5ofUo30sCICbn6VpN24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A7EKNRi624KSziL9E6vX//jRj6GKgLv0ODzW0QXzVroSzDOovEiGTOiUC6rOL3jg63Nni/0ilsVIUm3ykl/rlu/KKuuYRPYxMgCq1r4A3eo1tfbtq3FXwzACbe/CMY7MgSWXw0JgUHxak2ObjVjNd8lJhB7YUyx6s5KOeXGqDRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FuGNMCVw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FuGNMCVw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62278C2BD10;
	Wed,  3 Jul 2024 11:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004690;
	bh=2vhhxmDyK5Xs0PWTWAyXQU2d5ofUo30sCICbn6VpN24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FuGNMCVweRTo3P501k9lvypGTT+hHNQDi0Iuzyu+rQoxUuqhgyYSkssCKJqW69/cT
	 PXT6gxD9ZdigjBjCEg3wtqXdn4OPKuYYHr5+e+Jrv7++GcrHPqgSL3m1iVTIzORdK6
	 W/w/5/ogecL1SefGGL5Kjjn5yjyNj1PUDlwRX2xo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Goergens <matthias.goergens@gmail.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Muchun Song <songmuchun@bytedance.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 5.10 095/290] hugetlb_encode.h: fix undefined behaviour (34 << 26)
Date: Wed,  3 Jul 2024 12:37:56 +0200
Message-ID: <20240703102907.778397034@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthias Goergens <matthias.goergens@gmail.com>

commit 710bb68c2e3a24512e2d2bae470960d7488e97b1 upstream.

Left-shifting past the size of your datatype is undefined behaviour in C.
The literal 34 gets the type `int`, and that one is not big enough to be
left shifted by 26 bits.

An `unsigned` is long enough (on any machine that has at least 32 bits for
their ints.)

For uniformity, we mark all the literals as unsigned.  But it's only
really needed for HUGETLB_FLAG_ENCODE_16GB.

Thanks to Randy Dunlap for an initial review and suggestion.

Link: https://lkml.kernel.org/r/20220905031904.150925-1-matthias.goergens@gmail.com
Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[cmllamas: fix trivial conflict due to missing page encondigs]
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/asm-generic/hugetlb_encode.h  |   26 +++++++++++++-------------
 tools/include/asm-generic/hugetlb_encode.h |   20 ++++++++++----------
 2 files changed, 23 insertions(+), 23 deletions(-)

--- a/include/uapi/asm-generic/hugetlb_encode.h
+++ b/include/uapi/asm-generic/hugetlb_encode.h
@@ -20,18 +20,18 @@
 #define HUGETLB_FLAG_ENCODE_SHIFT	26
 #define HUGETLB_FLAG_ENCODE_MASK	0x3f
 
-#define HUGETLB_FLAG_ENCODE_16KB	(14 << HUGETLB_FLAG_ENCODE_SHIFT)
-#define HUGETLB_FLAG_ENCODE_64KB	(16 << HUGETLB_FLAG_ENCODE_SHIFT)
-#define HUGETLB_FLAG_ENCODE_512KB	(19 << HUGETLB_FLAG_ENCODE_SHIFT)
-#define HUGETLB_FLAG_ENCODE_1MB		(20 << HUGETLB_FLAG_ENCODE_SHIFT)
-#define HUGETLB_FLAG_ENCODE_2MB		(21 << HUGETLB_FLAG_ENCODE_SHIFT)
-#define HUGETLB_FLAG_ENCODE_8MB		(23 << HUGETLB_FLAG_ENCODE_SHIFT)
-#define HUGETLB_FLAG_ENCODE_16MB	(24 << HUGETLB_FLAG_ENCODE_SHIFT)
-#define HUGETLB_FLAG_ENCODE_32MB	(25 << HUGETLB_FLAG_ENCODE_SHIFT)
-#define HUGETLB_FLAG_ENCODE_256MB	(28 << HUGETLB_FLAG_ENCODE_SHIFT)
-#define HUGETLB_FLAG_ENCODE_512MB	(29 << HUGETLB_FLAG_ENCODE_SHIFT)
-#define HUGETLB_FLAG_ENCODE_1GB		(30 << HUGETLB_FLAG_ENCODE_SHIFT)
-#define HUGETLB_FLAG_ENCODE_2GB		(31 << HUGETLB_FLAG_ENCODE_SHIFT)
-#define HUGETLB_FLAG_ENCODE_16GB	(34 << HUGETLB_FLAG_ENCODE_SHIFT)
+#define HUGETLB_FLAG_ENCODE_16KB	(14U << HUGETLB_FLAG_ENCODE_SHIFT)
+#define HUGETLB_FLAG_ENCODE_64KB	(16U << HUGETLB_FLAG_ENCODE_SHIFT)
+#define HUGETLB_FLAG_ENCODE_512KB	(19U << HUGETLB_FLAG_ENCODE_SHIFT)
+#define HUGETLB_FLAG_ENCODE_1MB		(20U << HUGETLB_FLAG_ENCODE_SHIFT)
+#define HUGETLB_FLAG_ENCODE_2MB		(21U << HUGETLB_FLAG_ENCODE_SHIFT)
+#define HUGETLB_FLAG_ENCODE_8MB		(23U << HUGETLB_FLAG_ENCODE_SHIFT)
+#define HUGETLB_FLAG_ENCODE_16MB	(24U << HUGETLB_FLAG_ENCODE_SHIFT)
+#define HUGETLB_FLAG_ENCODE_32MB	(25U << HUGETLB_FLAG_ENCODE_SHIFT)
+#define HUGETLB_FLAG_ENCODE_256MB	(28U << HUGETLB_FLAG_ENCODE_SHIFT)
+#define HUGETLB_FLAG_ENCODE_512MB	(29U << HUGETLB_FLAG_ENCODE_SHIFT)
+#define HUGETLB_FLAG_ENCODE_1GB		(30U << HUGETLB_FLAG_ENCODE_SHIFT)
+#define HUGETLB_FLAG_ENCODE_2GB		(31U << HUGETLB_FLAG_ENCODE_SHIFT)
+#define HUGETLB_FLAG_ENCODE_16GB	(34U << HUGETLB_FLAG_ENCODE_SHIFT)
 
 #endif /* _ASM_GENERIC_HUGETLB_ENCODE_H_ */
--- a/tools/include/asm-generic/hugetlb_encode.h
+++ b/tools/include/asm-generic/hugetlb_encode.h
@@ -20,15 +20,15 @@
 #define HUGETLB_FLAG_ENCODE_SHIFT	26
 #define HUGETLB_FLAG_ENCODE_MASK	0x3f
 
-#define HUGETLB_FLAG_ENCODE_64KB	(16 << HUGETLB_FLAG_ENCODE_SHIFT)
-#define HUGETLB_FLAG_ENCODE_512KB	(19 << HUGETLB_FLAG_ENCODE_SHIFT)
-#define HUGETLB_FLAG_ENCODE_1MB		(20 << HUGETLB_FLAG_ENCODE_SHIFT)
-#define HUGETLB_FLAG_ENCODE_2MB		(21 << HUGETLB_FLAG_ENCODE_SHIFT)
-#define HUGETLB_FLAG_ENCODE_8MB		(23 << HUGETLB_FLAG_ENCODE_SHIFT)
-#define HUGETLB_FLAG_ENCODE_16MB	(24 << HUGETLB_FLAG_ENCODE_SHIFT)
-#define HUGETLB_FLAG_ENCODE_256MB	(28 << HUGETLB_FLAG_ENCODE_SHIFT)
-#define HUGETLB_FLAG_ENCODE_1GB		(30 << HUGETLB_FLAG_ENCODE_SHIFT)
-#define HUGETLB_FLAG_ENCODE_2GB		(31 << HUGETLB_FLAG_ENCODE_SHIFT)
-#define HUGETLB_FLAG_ENCODE_16GB	(34 << HUGETLB_FLAG_ENCODE_SHIFT)
+#define HUGETLB_FLAG_ENCODE_64KB	(16U << HUGETLB_FLAG_ENCODE_SHIFT)
+#define HUGETLB_FLAG_ENCODE_512KB	(19U << HUGETLB_FLAG_ENCODE_SHIFT)
+#define HUGETLB_FLAG_ENCODE_1MB		(20U << HUGETLB_FLAG_ENCODE_SHIFT)
+#define HUGETLB_FLAG_ENCODE_2MB		(21U << HUGETLB_FLAG_ENCODE_SHIFT)
+#define HUGETLB_FLAG_ENCODE_8MB		(23U << HUGETLB_FLAG_ENCODE_SHIFT)
+#define HUGETLB_FLAG_ENCODE_16MB	(24U << HUGETLB_FLAG_ENCODE_SHIFT)
+#define HUGETLB_FLAG_ENCODE_256MB	(28U << HUGETLB_FLAG_ENCODE_SHIFT)
+#define HUGETLB_FLAG_ENCODE_1GB		(30U << HUGETLB_FLAG_ENCODE_SHIFT)
+#define HUGETLB_FLAG_ENCODE_2GB		(31U << HUGETLB_FLAG_ENCODE_SHIFT)
+#define HUGETLB_FLAG_ENCODE_16GB	(34U << HUGETLB_FLAG_ENCODE_SHIFT)
 
 #endif /* _ASM_GENERIC_HUGETLB_ENCODE_H_ */


