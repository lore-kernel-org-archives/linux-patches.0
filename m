Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57BB02ED16E;
	Tue, 17 Jun 2025 15:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175819; cv=none; b=TXWiE11tsefqiDtCElce9cGqQrExgLpBkFcynaBy2VXZtT3hIYkI9XV37N8AM+FAhfUvZfYXN8eXpVTr6vs5gPAh5agW2vokTXbr1/MK4iOSEf6R6Wq2yvUPwb1cQ7vkYPpjqTIJ74LsBVZGHGN3AoYiSuORMZ6JyRfLrEPtyCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175819; c=relaxed/simple;
	bh=lCG1lWFdpyT8pV+YSnqqYMbYJV7qDXwuKmw/YPfEvU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lVQwKIQTmWDeS9XxPBdNvEoz9HeSw3G0Q6rAwDHOBVMCmjzQQsXmMOGn1/nJtmUgUJAz5MkFvWOB81iyS/clINv3NSufctZ3y/MpsSu2Vtaynh7KmaRTSDweWNPcncV0CWP8KeGKtic60ymosn31eK5nsJQ/HolBYAt/P2x5Mik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i7gL+Bec; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i7gL+Bec"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5826C4CEE3;
	Tue, 17 Jun 2025 15:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175819;
	bh=lCG1lWFdpyT8pV+YSnqqYMbYJV7qDXwuKmw/YPfEvU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i7gL+Bec5aRGtip8OnoojR77wdExt950aW8BFtOe2vo0pvFAXS4m6Ed5vE7pi/v5O
	 DIPd5/46MumiEgiFAnWvcdz4b4YQbh78Zy7lM0uL+AjFPqzB3oKDsu4CtyiWqSDJ+N
	 GogwB/StVmD52cXuU7356PPixUVjZl3LgEMIy3BE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Kornel=20Dul=C4=99ba?= <korneld@google.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 125/780] arm64: Support ARM64_VA_BITS=52 when setting ARCH_MMAP_RND_BITS_MAX
Date: Tue, 17 Jun 2025 17:17:13 +0200
Message-ID: <20250617152456.603191240@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kornel Dulęba <korneld@google.com>

[ Upstream commit f101c56447717c595d803894ba0e215f56c6fba4 ]

When the 52-bit virtual addressing was introduced the select like
ARCH_MMAP_RND_BITS_MAX logic was never updated to account for it.
Because of that the rnd max bits knob is set to the default value of 18
when ARM64_VA_BITS=52.
Fix this by setting ARCH_MMAP_RND_BITS_MAX to the same value that would
be used if 48-bit addressing was used. Higher values can't used here
because 52-bit addressing is used only if the caller provides a hint to
mmap, with a fallback to 48-bit. The knob in question is an upper bound
for what the user can set in /proc/sys/vm/mmap_rnd_bits, which in turn
is used to determine how many random bits can be inserted into the base
address used for mmap allocations. Since 48-bit allocations are legal
with ARM64_VA_BITS=52, we need to make sure that the base address is
small enough to facilitate this.

Fixes: b6d00d47e81a ("arm64: mm: Introduce 52-bit Kernel VAs")
Signed-off-by: Kornel Dulęba <korneld@google.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Link: https://lore.kernel.org/r/20250417114754.3238273-1-korneld@google.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index a182295e6f08b..6527d0d5656a1 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -333,9 +333,9 @@ config ARCH_MMAP_RND_BITS_MAX
 	default 24 if ARM64_VA_BITS=39
 	default 27 if ARM64_VA_BITS=42
 	default 30 if ARM64_VA_BITS=47
-	default 29 if ARM64_VA_BITS=48 && ARM64_64K_PAGES
-	default 31 if ARM64_VA_BITS=48 && ARM64_16K_PAGES
-	default 33 if ARM64_VA_BITS=48
+	default 29 if (ARM64_VA_BITS=48 || ARM64_VA_BITS=52) && ARM64_64K_PAGES
+	default 31 if (ARM64_VA_BITS=48 || ARM64_VA_BITS=52) && ARM64_16K_PAGES
+	default 33 if (ARM64_VA_BITS=48 || ARM64_VA_BITS=52)
 	default 14 if ARM64_64K_PAGES
 	default 16 if ARM64_16K_PAGES
 	default 18
-- 
2.39.5



