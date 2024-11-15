Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36FB32BB1B;
	Fri, 15 Nov 2024 06:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653587; cv=none; b=H+2yqPyUhjv7MGFf5k/tup8aA5Q1UvhQri+5AQJ5VUc/RFPOydeNKGsXox3kvDq/AvkN2RzlhTee9qDFb9Ngtg9BvCLkFOkDtGoXDVFIcsrGCYGPfPl1Zu/kpDihIctW1qRZJDHOfquAzuUSEQQ7IvZFm8NMcbyUCzWEuFLkl/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653587; c=relaxed/simple;
	bh=OIF9sR0hzMx7ZfPn+9PyJrEPW2dCQ+zk7/73CW9nuXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QH7V+NDY55ncD3xA/ftTL1uWNQ0HDuJQyGDDpOF5DgGKdWTCRRvuP41osk77V1PBI7Cg7OUT6A6t/JisjQO0Ib4qO3FtL8f5z96r7JTdPWaNpGVRtWK1kJOjYeBBExETrZGykn8K+2EmS9tCjcJlFkXxSsNfKQfdPbHZ1vz7Rzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RbE51Av5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RbE51Av5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B8CEC4CECF;
	Fri, 15 Nov 2024 06:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653587;
	bh=OIF9sR0hzMx7ZfPn+9PyJrEPW2dCQ+zk7/73CW9nuXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RbE51Av55x48MEsXFbKvQMz9EhNAZKQr6lxaCYQOaxGY8tymjvOhllcVDNRe2iyWu
	 sJXTQh+xbhxDuLpng/Q2rVFRfaAL/S4I+jgUs55CdEL4W41sJOQIrKrAJJ863JpWuK
	 EYfEASeFrnnbPjKT26lKosTjtxId+2Hebh+TsObc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Mark Rutland <mark.rutland@arm.com>,
	syzbot+908886656a02769af987@syzkaller.appspotmail.com,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 18/39] kasan: Disable Software Tag-Based KASAN with GCC
Date: Fri, 15 Nov 2024 07:38:28 +0100
Message-ID: <20241115063723.266970553@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.599985562@linuxfoundation.org>
References: <20241115063722.599985562@linuxfoundation.org>
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

From: Will Deacon <will@kernel.org>

[ Upstream commit 7aed6a2c51ffc97a126e0ea0c270fab7af97ae18 ]

Syzbot reports a KASAN failure early during boot on arm64 when building
with GCC 12.2.0 and using the Software Tag-Based KASAN mode:

  | BUG: KASAN: invalid-access in smp_build_mpidr_hash arch/arm64/kernel/setup.c:133 [inline]
  | BUG: KASAN: invalid-access in setup_arch+0x984/0xd60 arch/arm64/kernel/setup.c:356
  | Write of size 4 at addr 03ff800086867e00 by task swapper/0
  | Pointer tag: [03], memory tag: [fe]

Initial triage indicates that the report is a false positive and a
thorough investigation of the crash by Mark Rutland revealed the root
cause to be a bug in GCC:

  > When GCC is passed `-fsanitize=hwaddress` or
  > `-fsanitize=kernel-hwaddress` it ignores
  > `__attribute__((no_sanitize_address))`, and instruments functions
  > we require are not instrumented.
  >
  > [...]
  >
  > All versions [of GCC] I tried were broken, from 11.3.0 to 14.2.0
  > inclusive.
  >
  > I think we have to disable KASAN_SW_TAGS with GCC until this is
  > fixed

Disable Software Tag-Based KASAN when building with GCC by making
CC_HAS_KASAN_SW_TAGS depend on !CC_IS_GCC.

Cc: Andrey Konovalov <andreyknvl@gmail.com>
Suggested-by: Mark Rutland <mark.rutland@arm.com>
Reported-by: syzbot+908886656a02769af987@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/000000000000f362e80620e27859@google.com
Link: https://lore.kernel.org/r/ZvFGwKfoC4yVjN_X@J2N7QTR9R3
Link: https://bugzilla.kernel.org/show_bug.cgi?id=218854
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Link: https://lore.kernel.org/r/20241014161100.18034-1-will@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/Kconfig.kasan | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/lib/Kconfig.kasan b/lib/Kconfig.kasan
index ca09b1cf8ee9d..34420eb1cbfe1 100644
--- a/lib/Kconfig.kasan
+++ b/lib/Kconfig.kasan
@@ -22,8 +22,11 @@ config ARCH_DISABLE_KASAN_INLINE
 config CC_HAS_KASAN_GENERIC
 	def_bool $(cc-option, -fsanitize=kernel-address)
 
+# GCC appears to ignore no_sanitize_address when -fsanitize=kernel-hwaddress
+# is passed. See https://bugzilla.kernel.org/show_bug.cgi?id=218854 (and
+# the linked LKML thread) for more details.
 config CC_HAS_KASAN_SW_TAGS
-	def_bool $(cc-option, -fsanitize=kernel-hwaddress)
+	def_bool !CC_IS_GCC && $(cc-option, -fsanitize=kernel-hwaddress)
 
 # This option is only required for software KASAN modes.
 # Old GCC versions do not have proper support for no_sanitize_address.
@@ -91,7 +94,7 @@ config KASAN_SW_TAGS
 	help
 	  Enables Software Tag-Based KASAN.
 
-	  Requires GCC 11+ or Clang.
+	  Requires Clang.
 
 	  Supported only on arm64 CPUs and relies on Top Byte Ignore.
 
-- 
2.43.0



