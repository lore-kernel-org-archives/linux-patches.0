Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB68ABA3E
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:40:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17A35C4339B;
	Tue,  7 Mar 2023 17:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210846;
	bh=DZyIsPkQES0QmFhuErpe1qZmb9SX+Y7DSi0AaVdU0Pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mhiUjD2MPE7tOd1RE9JM9x5kZglnA+OjjOwu8tNElx/wgM+3ZO+hID5PmS3sDMtP3
	 /V/kM+GMqo6nta/jxESpz7Fg6GzoG0R83zgx/K1TeUckS1pIdehzcD2VcCBxsvFvMU
	 4EBnG5Br5l9De4Pgls43ylKnSmLi8i1V6WWsjOTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Arnd Bergmann <arnd@arndb.de>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Alexander Potapenko <glider@google.com>,
	Aleksa Sarai <cyphar@cyphar.com>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0673/1001] uaccess: Add minimum bounds check on kernel buffer size
Date: Tue,  7 Mar 2023 17:57:25 +0100
Message-Id: <20230307170050.810849887@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 04ffde1319a715bd0550ded3580d4ea3bc003776 ]

While there is logic about the difference between ksize and usize,
copy_struct_from_user() didn't check the size of the destination buffer
(when it was known) against ksize. Add this check so there is an upper
bounds check on the possible memset() call, otherwise lower bounds
checks made by callers will trigger bounds warnings under -Warray-bounds.
Seen under GCC 13:

In function 'copy_struct_from_user',
    inlined from 'iommufd_fops_ioctl' at
../drivers/iommu/iommufd/main.c:333:8:
../include/linux/fortify-string.h:59:33: warning: '__builtin_memset' offset [57, 4294967294] is out of the bounds [0, 56] of object 'buf' with type 'union ucmd_buffer' [-Warray-bounds=]
   59 | #define __underlying_memset     __builtin_memset
      |                                 ^
../include/linux/fortify-string.h:453:9: note: in expansion of macro '__underlying_memset'
  453 |         __underlying_memset(p, c, __fortify_size); \
      |         ^~~~~~~~~~~~~~~~~~~
../include/linux/fortify-string.h:461:25: note: in expansion of macro '__fortify_memset_chk'
  461 | #define memset(p, c, s) __fortify_memset_chk(p, c, s, \
      |                         ^~~~~~~~~~~~~~~~~~~~
../include/linux/uaccess.h:334:17: note: in expansion of macro 'memset'
  334 |                 memset(dst + size, 0, rest);
      |                 ^~~~~~
../drivers/iommu/iommufd/main.c: In function 'iommufd_fops_ioctl':
../drivers/iommu/iommufd/main.c:311:27: note: 'buf' declared here
  311 |         union ucmd_buffer buf;
      |                           ^~~

Cc: Christian Brauner <brauner@kernel.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Alexander Potapenko <glider@google.com>
Acked-by: Aleksa Sarai <cyphar@cyphar.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/lkml/20230203193523.never.667-kees@kernel.org/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/uaccess.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index afb18f198843b..ab9728138ad67 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -329,6 +329,10 @@ copy_struct_from_user(void *dst, size_t ksize, const void __user *src,
 	size_t size = min(ksize, usize);
 	size_t rest = max(ksize, usize) - size;
 
+	/* Double check if ksize is larger than a known object size. */
+	if (WARN_ON_ONCE(ksize > __builtin_object_size(dst, 1)))
+		return -E2BIG;
+
 	/* Deal with trailing bytes. */
 	if (usize < ksize) {
 		memset(dst + size, 0, rest);
-- 
2.39.2



