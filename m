Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E24E4267B10;
	Tue,  8 Apr 2025 12:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116624; cv=none; b=uYTISc5aObdUU8+oTPVswYrCzUQi2yfCsGrnPjNQlxL6lolZURb9jYqRYt0VxFOuF/ppM2N5wGHYikh9rhitwfk+0QV9tz9sOrsMrujrpPnQ+tJFbkYBTqlA8tX0vyQ1sJCltdTHGHZAiqRMPRYEDR5C5jQh9Iuy2/ZbAy5v1M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116624; c=relaxed/simple;
	bh=FgRMGBwYgzAwnerlM8JGZzV9fvUsqfm6hBLkvrpVntM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rvAtnKN/H6aAjc+fIg12w+LcKeoHQU9DVmPHnh5oHxBvByO6vIu71sFKb122cBtq5BH5BNxlKBt/gzdPLPUUbJe3iKkZa1BGfVJErtbffByjqdZT7O9by7tEimFTTdbkyV1biV1IhTJ2YfVt2Vo3MMagqVXtWPaM+EOFHMkzct8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YzTkG4u7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YzTkG4u7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DC5EC4CEE5;
	Tue,  8 Apr 2025 12:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116623;
	bh=FgRMGBwYgzAwnerlM8JGZzV9fvUsqfm6hBLkvrpVntM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YzTkG4u7p2G8OUS/gapG5lof6qtPQz8WQFSNbWypTMsAwXa5ryNuR8457vVxHiaBc
	 qgoWR6Uw2sz1dLBCmskxShcFGcH1rWiYxwrzPYa8hxJrbdqCK55ghNhpc7ufQWedGy
	 hItyp5RQZd6BPkL5qJO/CytJcYeEE/K9OEJyXzHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Gow <davidgow@google.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 207/423] um: Pass the correct Rust target and options with gcc
Date: Tue,  8 Apr 2025 12:48:53 +0200
Message-ID: <20250408104850.556158770@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Gow <davidgow@google.com>

[ Upstream commit 5550187c4c21740942c32a9ae56f9f472a104cb4 ]

In order to work around some issues with disabling SSE on older versions
of gcc (compilation would fail upon seeing a function declaration
containing a float, even if it was never called or defined), the
corresponding CFLAGS and RUSTFLAGS were only set when using clang.

However, this led to two problems:
- Newer gcc versions also wouldn't get the correct flags, despite not
  having the bug.
- The RUSTFLAGS for setting the rust target definition were not set,
  despite being unrelated. This works by chance for x86_64, as the
  built-in default target is close enough, but not for 32-bit x86.

Move the target definition outside the conditional block, and update the
condition to take into account the gcc version.

Fixes: a3046a618a28 ("um: Only disable SSE on clang to work around old GCC bugs")
Signed-off-by: David Gow <davidgow@google.com>
Link: https://patch.msgid.link/20250210105353.2238769-2-davidgow@google.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/Makefile.um | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/Makefile.um b/arch/x86/Makefile.um
index a46b1397ad01c..c86cbd9cbba38 100644
--- a/arch/x86/Makefile.um
+++ b/arch/x86/Makefile.um
@@ -7,12 +7,13 @@ core-y += arch/x86/crypto/
 # GCC versions < 11. See:
 # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=99652
 #
-ifeq ($(CONFIG_CC_IS_CLANG),y)
-KBUILD_CFLAGS += -mno-sse -mno-mmx -mno-sse2 -mno-3dnow -mno-avx
-KBUILD_RUSTFLAGS += --target=$(objtree)/scripts/target.json
+ifeq ($(call gcc-min-version, 110000)$(CONFIG_CC_IS_CLANG),y)
+KBUILD_CFLAGS +=  -mno-sse -mno-mmx -mno-sse2 -mno-3dnow -mno-avx
 KBUILD_RUSTFLAGS += -Ctarget-feature=-sse,-sse2,-sse3,-ssse3,-sse4.1,-sse4.2,-avx,-avx2
 endif
 
+KBUILD_RUSTFLAGS += --target=$(objtree)/scripts/target.json
+
 ifeq ($(CONFIG_X86_32),y)
 START := 0x8048000
 
-- 
2.39.5



