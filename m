Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95ACF9E4;
	Sat,  3 Feb 2024 04:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933317; cv=none; b=B9AptOvQ1aa5TsMxavloh9D1LS+xtd9GKrT9OdQt6fFe/tMvqsVd+Y1Z1vx7uib5D5bhFONH57th7WmeEAsEZD367pV1emWEkarNYEBmK5aCHUkDfBlzWFXS+t+RhMu4Utm7xKgGRZLH7cbuH0qoh4BprEKEQjhMBiEydEVJLZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933317; c=relaxed/simple;
	bh=2OdrLFrTHDB6shOjE1xykvG1Dvgh2YwDrW1dMoqvkAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iBULF9VsEyN1dmJjlyL3OAmPfmX/RnQUFmgiDgYE9rhJ8yjGE4ZehrM0M/sT8UsWPwag9APhIOlxmmvrdvoNp+GVRp9DN/vbgIHFtmtrFZh1Mtw9URYcxTpfxcdtzN3/6eOhJZvZFXY2mAvgjBsLpNrhyvg/KJk8h9SAzs3neDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AGdIhHnL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AGdIhHnL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28BFDC433F1;
	Sat,  3 Feb 2024 04:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933316;
	bh=2OdrLFrTHDB6shOjE1xykvG1Dvgh2YwDrW1dMoqvkAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AGdIhHnL1OFaAtT1Cv/P/VQ+W0p736ymwvH7eRLOOrc6n9BirducVhjUNnT1BCtsK
	 qfbhBhyu9XBabnZVtTzbUa9oO8fvmQ+dEQcNAG3L3OX9RuE9sSp/hds6mdJdpoHAGI
	 GfK6oyi/l/jjM4iA9qnZrkuhBqDlWqMC5LtiyHCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 001/219] asm-generic: make sparse happy with odd-sized put_unaligned_*()
Date: Fri,  2 Feb 2024 20:02:54 -0800
Message-ID: <20240203035317.490481892@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



