Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C42B471264;
	Tue, 21 Jul 2026 18:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659307; cv=none; b=rJevdk/mLPPmYcHF5vBT7xKrmbeq2sVLAun44cGq9nSQFd3lqo6ptLn+hAQZghhM5M8/mVF7/snYkXgUjrOIYX6BQAq/HKfOp/41WFFEp8/AoIE+BONdBEYNojorV9aBY8Ms+ZKjKRa1Bom9Lx1S2HHm6GGyNFNx2l4j/xlLfZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659307; c=relaxed/simple;
	bh=IAZddm4itb2UME6M0bHXRcETOuaEqdWecr+vV4IWqOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qPJOfQE1d0vEw6bUOUkUqqLC1p4rWGYLQGfvUo/pd/Y/RSSV+MBKKw6hWw8Yxz+7Dp5DYCRX3cXdK9bBSxUdaFlZoSZC2FP+Y2MGH4M6nHQtQyYH0A4KlMwo/4mNXwU6DIKUV6yfhNs7uBoCXXXmhRkEkmXtBHzYdSZzFtJy3DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1pzjyiEX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1pzjyiEX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2F291F000E9;
	Tue, 21 Jul 2026 18:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659306;
	bh=kcgixcB4wlJqz8BI3tHOPtOWy/9qqFXcf+cMOMLFPqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1pzjyiEXOUIkUOr2ads6h/JtajZsJxlNxnwojGzBqWfZXRU2lujSIZwBvzCr/8sxQ
	 jThZ2rZX/w0Sx2jhPtxs8UkfaNbhFPE4Uy49JSGfGJb0mGtfPiN7WT+Uca5zAc9j7a
	 IUtU7/mMQFpTqU1bta4dTAXTCFBtTuUqM4CTnCGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.18 1470/1611] s390/mm: Fix type mismatch in get_align_mask().
Date: Tue, 21 Jul 2026 17:26:26 +0200
Message-ID: <20260721152548.511261924@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gerald Schaefer <gerald.schaefer@linux.ibm.com>

commit ec84aad4c3594307d103af563991b4415ac5c8ab upstream.

Commit 86f48f922ba79 ("s390/mmap: disable mmap alignment when
randomize_va_space = 0") introduced get_align_mask() with return type of
'int', while the target field 'info.align_mask' in struct
vm_unmapped_area_info is 'unsigned long'.

With currently used masks, this should not cause truncation issues, but
fix it and return 'unsigned long' to avoid future problems.

Fixes: 86f48f922ba79 ("s390/mmap: disable mmap alignment when randomize_va_space = 0")
Cc: stable@vger.kernel.org # v6.9+
Signed-off-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Reviewed-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/mm/mmap.c
+++ b/arch/s390/mm/mmap.c
@@ -65,7 +65,7 @@ static inline unsigned long mmap_base(un
 	return PAGE_ALIGN(STACK_TOP - gap - rnd);
 }
 
-static int get_align_mask(struct file *filp, unsigned long flags)
+static unsigned long get_align_mask(struct file *filp, unsigned long flags)
 {
 	if (filp && is_file_hugepages(filp))
 		return huge_page_mask_align(filp);


