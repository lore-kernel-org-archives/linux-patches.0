Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F18B31A3178;
	Thu, 17 Apr 2025 18:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913953; cv=none; b=BUG0L75CTDXgMc8GsIig7jrb+IXoh+2Rat+jKM1Y7S8NOHCIuOFPoh0B2wfYWt8euY77wHRUIZS4RDbdK/+sdZtQP3r3CJO+B9Ua3P4izQ743/eJialKO2uk5m8pZf3vRLkLtMZJbkLz/e08yxYTRyL2iXXsFDtjAJ+8P9LxFM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913953; c=relaxed/simple;
	bh=RfkqtJiWihlJED/o/DmLAta0t8cS/vuBPT5Z7FI+8GE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tuj9pWijPrOZ3VQ9G6UEYMndJopagjj44/AACvRv6D7pQnbxYqg8JE/rtx56egq4HIww/ZDhO4U95I1svDw8c1wW2RMjAcHm9T7CmULvK22qoxCSfjA45031BYccs6/yikGaEMyjifxmMEU9jsKQYYEKv1G4JpfP2eZXgobuWO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=twGv/Ow1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="twGv/Ow1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8087CC4CEE4;
	Thu, 17 Apr 2025 18:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913952;
	bh=RfkqtJiWihlJED/o/DmLAta0t8cS/vuBPT5Z7FI+8GE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=twGv/Ow1L1f5YbrkFXyiDRdY6cNMwvLQu0GN4S8Tvc6NPaSMfIO9uV25QR6lTfBcr
	 y0zWCob9mFOI+pplF4/bhkSLF+sEBjhBflgNwkmZDakWVselpEvGKUYsyr3RysxkVP
	 H1mRLPr5bCHsRxxeXxlmrFoaCxOeymKIB5en/fQw=
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
Subject: [PATCH 6.13 057/414] zstd: Increase DYNAMIC_BMI2 GCC version cutoff from 4.8 to 11.0 to work around compiler segfault
Date: Thu, 17 Apr 2025 19:46:55 +0200
Message-ID: <20250417175113.708060227@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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



