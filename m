Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B83C8330B34;
	Fri, 17 Oct 2025 15:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715798; cv=none; b=sssZ7cOmfEnKkZ/oHuoEGMytpRPzw7ouccOJAMH0KJppPCrQ8gjTq12a6ObVcoMFdrUapXQ7LjfiLwuojytVQh0VO+nLQY4XaJSBdLtkA8BVFLy9V/66oQav6sU6bY+hjHLLXAjCKQbwc4VGQp1HwMrs9Et/WnEteSUhyZNLJEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715798; c=relaxed/simple;
	bh=O4i+gv6X0q8UYoNwT9v+7ShjMhYTs+NA6RzI7jQGXc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SzkT38jeeCE+xPAdU0kJJQgYTu5tiz/saeybYE/yq8F18c8JqEiz7AFZvUyyzFD0YqlSPy7AH6gk5wfzsEvNIjItd8pl5ITCuSW7bo2DwrCUCQyzhRtqNIHMR6p3L1/Nmg1wbVEmFwE+86V4alRXTbBfrBr9DnIWPFL3rUW9Kjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tgmRXZRR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tgmRXZRR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9A6CC4CEE7;
	Fri, 17 Oct 2025 15:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715797;
	bh=O4i+gv6X0q8UYoNwT9v+7ShjMhYTs+NA6RzI7jQGXc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tgmRXZRRrmdkBPOIp0z8UedL1ANmI4LZ2hr8UTfRu0EIK+zx+C4jK0bhTNCwPuTgl
	 /ZeE4nCSjc3Ce5puGooKWQd7u/6SiVXwAA5MgRe1nMQR5fKW73wVqtI/buoPlCewhN
	 I7FdvcoRw5BAbMBdaaBNEmqiTJ0eMw/tFb0mz/vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 6.17 307/371] s390: Add -Wno-pointer-sign to KBUILD_CFLAGS_DECOMPRESSOR
Date: Fri, 17 Oct 2025 16:54:42 +0200
Message-ID: <20251017145213.184435797@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

commit fa7a0a53eeb7e16402f82c3d5a9ef4bf5efe9357 upstream.

If the decompressor is compiled with clang this can lead to the following
warning:

In file included from arch/s390/boot/startup.c:4:
...
In file included from ./include/linux/pgtable.h:6:
./arch/s390/include/asm/pgtable.h:2065:48: warning: passing 'unsigned long *' to parameter of type
      'long *' converts between pointers to integer types with different sign [-Wpointer-sign]
 2065 |                 value = __atomic64_or_barrier(PGSTE_PCL_BIT, ptr);

Add -Wno-pointer-sign to the decompressor compile flags, like it is also
done for the kernel. This is similar to what was done for x86 to address
the same problem [1].

[1] commit dca5203e3fe2 ("x86/boot: Add -Wno-pointer-sign to KBUILD_CFLAGS")

Cc: stable@vger.kernel.org
Reported-by: Gerd Bayer <gbayer@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/s390/Makefile
+++ b/arch/s390/Makefile
@@ -25,6 +25,7 @@ endif
 KBUILD_CFLAGS_DECOMPRESSOR := $(CLANG_FLAGS) -m64 -O2 -mpacked-stack -std=gnu11
 KBUILD_CFLAGS_DECOMPRESSOR += -DDISABLE_BRANCH_PROFILING -D__NO_FORTIFY
 KBUILD_CFLAGS_DECOMPRESSOR += -D__DECOMPRESSOR
+KBUILD_CFLAGS_DECOMPRESSOR += -Wno-pointer-sign
 KBUILD_CFLAGS_DECOMPRESSOR += -fno-delete-null-pointer-checks -msoft-float -mbackchain
 KBUILD_CFLAGS_DECOMPRESSOR += -fno-asynchronous-unwind-tables
 KBUILD_CFLAGS_DECOMPRESSOR += -ffreestanding


