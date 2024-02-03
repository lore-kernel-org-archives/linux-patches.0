Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A5A1B95C;
	Sat,  3 Feb 2024 04:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933486; cv=none; b=k+/LrAx+ue4ja838WOCMvhAqNQYgAJlIUElW7OQpimf30XYjgVyfCxpm9P2mFJVKAQgycCVsfw6+qLvTeaQ+MyOX+gO7d5mikX4dl+zXST3oBCY4jLVA2dT3A8zXjabJvOIQkjQ4Cc3bnuXsgu5lHcTXigRIJpUrCwgHI/3WzWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933486; c=relaxed/simple;
	bh=5Getn309I0YvsehLTG5TpNWz18SjKFV6IGZO2em7rsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GCfW2xhG4hHwSigW1yMseA1RLoyN+1STINQWdw4Rer+exK3P3/doRgkKhqIl54xk4i8GD1dw2ojJxJxM/T7F3WjRWp7ydXUN6DrM3URTK8jH+x1jfCJYJL/nl+nvxPN79GvkQoySfVD6h65QyPbN5DyEXm0hiVNr2Im/P1bJHMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZieSxoFU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZieSxoFU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B943AC433F1;
	Sat,  3 Feb 2024 04:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933485;
	bh=5Getn309I0YvsehLTG5TpNWz18SjKFV6IGZO2em7rsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZieSxoFUPp2cPNWktXjLD9wHzp5HbIga8Nx/cT0g2m+4qVZV9WhtPhynnwCgpUjWR
	 7hVEJzNNE7OyGm8N3rZuF0+B6C+zSmv+WJGGumSodFheSFuZFuspfyWK/6qdGg7Bta
	 juygaSOwr/j9S73qgYYxSS8EhlLOMdFJrju1W1Yg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 002/322] asm-generic: make sparse happy with odd-sized put_unaligned_*()
Date: Fri,  2 Feb 2024 20:01:39 -0800
Message-ID: <20240203035359.126342306@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 1ab33c03145d0f6c345823fc2da935d9a1a9e9fc ]

__put_unaligned_be24() and friends use implicit casts to convert
larger-sized data to bytes, which trips sparse truncation warnings when
the argument is a constant:

    CC [M]  drivers/input/touchscreen/hynitron_cstxxx.o
    CHECK   drivers/input/touchscreen/hynitron_cstxxx.c
  drivers/input/touchscreen/hynitron_cstxxx.c: note: in included file (through arch/x86/include/generated/asm/unaligned.h):
  include/asm-generic/unaligned.h:119:16: warning: cast truncates bits from constant value (aa01a0 becomes a0)
  include/asm-generic/unaligned.h:120:20: warning: cast truncates bits from constant value (aa01 becomes 1)
  include/asm-generic/unaligned.h:119:16: warning: cast truncates bits from constant value (ab00d0 becomes d0)
  include/asm-generic/unaligned.h:120:20: warning: cast truncates bits from constant value (ab00 becomes 0)

To avoid this let's mask off upper bits explicitly, the resulting code
should be exactly the same, but it will keep sparse happy.

Reported-by: kernel test robot <lkp@intel.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Closes: https://lore.kernel.org/oe-kbuild-all/202401070147.gqwVulOn-lkp@intel.com/
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/asm-generic/unaligned.h | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/asm-generic/unaligned.h b/include/asm-generic/unaligned.h
index 699650f81970..a84c64e5f11e 100644
--- a/include/asm-generic/unaligned.h
+++ b/include/asm-generic/unaligned.h
@@ -104,9 +104,9 @@ static inline u32 get_unaligned_le24(const void *p)
 
 static inline void __put_unaligned_be24(const u32 val, u8 *p)
 {
-	*p++ = val >> 16;
-	*p++ = val >> 8;
-	*p++ = val;
+	*p++ = (val >> 16) & 0xff;
+	*p++ = (val >> 8) & 0xff;
+	*p++ = val & 0xff;
 }
 
 static inline void put_unaligned_be24(const u32 val, void *p)
@@ -116,9 +116,9 @@ static inline void put_unaligned_be24(const u32 val, void *p)
 
 static inline void __put_unaligned_le24(const u32 val, u8 *p)
 {
-	*p++ = val;
-	*p++ = val >> 8;
-	*p++ = val >> 16;
+	*p++ = val & 0xff;
+	*p++ = (val >> 8) & 0xff;
+	*p++ = (val >> 16) & 0xff;
 }
 
 static inline void put_unaligned_le24(const u32 val, void *p)
@@ -128,12 +128,12 @@ static inline void put_unaligned_le24(const u32 val, void *p)
 
 static inline void __put_unaligned_be48(const u64 val, u8 *p)
 {
-	*p++ = val >> 40;
-	*p++ = val >> 32;
-	*p++ = val >> 24;
-	*p++ = val >> 16;
-	*p++ = val >> 8;
-	*p++ = val;
+	*p++ = (val >> 40) & 0xff;
+	*p++ = (val >> 32) & 0xff;
+	*p++ = (val >> 24) & 0xff;
+	*p++ = (val >> 16) & 0xff;
+	*p++ = (val >> 8) & 0xff;
+	*p++ = val & 0xff;
 }
 
 static inline void put_unaligned_be48(const u64 val, void *p)
-- 
2.43.0



