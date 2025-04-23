Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D921269B07;
	Wed, 23 Apr 2025 14:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420263; cv=none; b=kMhYXV2BJ9rHUxfzJskEe9naIL9wDQ/grEVibPyU9eEdT8wwC2N6OHcXntAo04PVOpG+IqxrpIRyYez5ZHdhRDjRW2jS3E6yxEt2LpGhrY5L2dDIR6+8eGayhWFymp0cPNWRu4pv0kCUjXkvJEVapjTnySzZRVhT6Vn7dgONPzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420263; c=relaxed/simple;
	bh=axNaMpf0KKZvbhf309aZuAZOSchNI/tzL9GFhN/AAeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jGlKWpvR+XOEeOu5LlvM5NWWdmoc4qxW1svpaWF3YiB7+8+onNhRVJIpH4XYnRu89t9AhNyv6OHfXHFjJjCuakbysWFkHDJHmU7WYBo7Vsf8kIe7VO5dGeUexo3FE33qeGruYLX1l8JJQZDaas2wxsxRgB3cIt9AOQHpVo5UdwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ltoD0c04; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ltoD0c04"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DAE7C4CEE2;
	Wed, 23 Apr 2025 14:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420263;
	bh=axNaMpf0KKZvbhf309aZuAZOSchNI/tzL9GFhN/AAeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ltoD0c04LTJE8yRH3rybXJIE+A4p0KyTdo/Vln16GqMYwFUjNAFOufC2JeKv7aeZP
	 AoCTEJWIvwOcydZ4G/3iP6ogVGT8jyXCPv7+/hK9A+WNN+HgD0aRa/umBikg0TPK9l
	 zuryPU6h32gwgH006xjCKM2IxlWQRRTxznn+KWuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mhklinux@outlook.com>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	https://lore.kernel.org/r/SN6PR02MB415723FBCD79365E8D72CA5FD4D82@SN6PR02MB4157.namprd02.prod.outlook.com
Subject: [PATCH 6.6 046/393] zstd: Increase DYNAMIC_BMI2 GCC version cutoff from 4.8 to 11.0 to work around compiler segfault
Date: Wed, 23 Apr 2025 16:39:02 +0200
Message-ID: <20250423142645.188625951@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ingo Molnar <mingo@kernel.org>

[ Upstream commit 1400c87e6cac47eb243f260352c854474d9a9073 ]

Due to pending percpu improvements in -next, GCC9 and GCC10 are
crashing during the build with:

    lib/zstd/compress/huf_compress.c:1033:1: internal compiler error: Segmentation fault
     1033 | {
          | ^
    Please submit a full bug report,
    with preprocessed source if appropriate.
    See <file:///usr/share/doc/gcc-9/README.Bugs> for instructions.

The DYNAMIC_BMI2 feature is a known-challenging feature of
the ZSTD library, with an existing GCC quirk turning it off
for GCC versions below 4.8.

Increase the DYNAMIC_BMI2 version cutoff to GCC 11.0 - GCC 10.5
is the last version known to crash.

Reported-by: Michael Kelley <mhklinux@outlook.com>
Debugged-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: https://lore.kernel.org/r/SN6PR02MB415723FBCD79365E8D72CA5FD4D82@SN6PR02MB4157.namprd02.prod.outlook.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/zstd/common/portability_macros.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/zstd/common/portability_macros.h b/lib/zstd/common/portability_macros.h
index 0e3b2c0a527db..0dde8bf56595e 100644
--- a/lib/zstd/common/portability_macros.h
+++ b/lib/zstd/common/portability_macros.h
@@ -55,7 +55,7 @@
 #ifndef DYNAMIC_BMI2
   #if ((defined(__clang__) && __has_attribute(__target__)) \
       || (defined(__GNUC__) \
-          && (__GNUC__ >= 5 || (__GNUC__ == 4 && __GNUC_MINOR__ >= 8)))) \
+          && (__GNUC__ >= 11))) \
       && (defined(__x86_64__) || defined(_M_X64)) \
       && !defined(__BMI2__)
   #  define DYNAMIC_BMI2 1
-- 
2.39.5



