Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8364029A9;
	Fri, 15 Nov 2024 06:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653134; cv=none; b=Ac39CUysZZFlGBZQxmGfD31C2DJaINSqsq5iiCyuFHKyKYeI6z5kkG5MlMYZGJ/fg3v/85yVXSLDUR1eqiwY0dByU01WoLpc5a2ZXoz4lECxeN24MWyd8ZHSQkmuxrIEhifjqDLz2LW5baTMFi/FY4Ar2EWPU+E6TL5pjR7Vjx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653134; c=relaxed/simple;
	bh=ocoQ/HkIcFK/gHhW5DLu9+utAz+ukr3L6wIfXLhW3vI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bvzVEcdRCzVLjYH0HiNXSH8AtO5+WBGYgPaQD+lpUGloP03idkyhk/mfqG0WkMVQiufVx9KCKQHJGEzMnSMV/Q8vtjXUADGTIo6TRA3hvdtLXUZMHv+69s++mAXMZewyF1qXUhlrbrUcW1FNXeU6awotF7PyKDwSlayWi8aZAR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BzC5szOC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BzC5szOC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E172DC4CECF;
	Fri, 15 Nov 2024 06:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653134;
	bh=ocoQ/HkIcFK/gHhW5DLu9+utAz+ukr3L6wIfXLhW3vI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BzC5szOCO6rzKVdeuSCr4U5cpOgjwf+t9j8Lar6uc+AW+P83kzccT7txXFWpuGGjV
	 9el6onoL285x9U6aOe+GUpqlN9UifWX3f0cVbyReuHr5uBvN8DbXP3+TGIKTmuguDj
	 V1SgxZTw1Gf0WvtYTE8dGWMz0uoy/tH6eEuDhEeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Zhang <zhangalex@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Harshvardhan Jha <harshvardhan.j.jha@oracle.com>
Subject: [PATCH 5.4 64/66] mm/memory.c: make remap_pfn_range() reject unaligned addr
Date: Fri, 15 Nov 2024 07:38:13 +0100
Message-ID: <20241115063725.150318486@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.834793938@linuxfoundation.org>
References: <20241115063722.834793938@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Zhang <zhangalex@google.com>

commit 0c4123e3fb82d6014d0a70b52eb38153f658541c upstream.

This function implicitly assumes that the addr passed in is page aligned.
A non page aligned addr could ultimately cause a kernel bug in
remap_pte_range as the exit condition in the logic loop may never be
satisfied.  This patch documents the need for the requirement, as well as
explicitly adds a check for it.

Signed-off-by: Alex Zhang <zhangalex@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20200617233512.177519-1-zhangalex@google.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Harshvardhan Jha <harshvardhan.j.jha@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1920,7 +1920,7 @@ static inline int remap_p4d_range(struct
 /**
  * remap_pfn_range - remap kernel memory to userspace
  * @vma: user vma to map to
- * @addr: target user address to start at
+ * @addr: target page aligned user address to start at
  * @pfn: page frame number of kernel physical memory address
  * @size: size of mapping area
  * @prot: page protection flags for this mapping
@@ -1939,6 +1939,9 @@ int remap_pfn_range(struct vm_area_struc
 	unsigned long remap_pfn = pfn;
 	int err;
 
+	if (WARN_ON_ONCE(!PAGE_ALIGNED(addr)))
+		return -EINVAL;
+
 	/*
 	 * Physically remapped pages are special. Tell the
 	 * rest of the world about it:


