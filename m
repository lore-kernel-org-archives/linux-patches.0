Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21312EAD0;
	Fri, 15 Nov 2024 06:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653419; cv=none; b=Wlss6w1YTwLmsr6Xkjo+FiSfrLiKs89hTbOdpt4+Lo2REi3N43/kOCFgw4LZqH7ESY/YmL/9RpB8QejBejKo9L4d7NCs9KPxsxfGyumDGehyVQldh/yMdHSV+rscsxBHhcPM4VD8yvC9BTangqIQRXb3tsC9HbDegGiz2neD5ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653419; c=relaxed/simple;
	bh=JxRvL7DhvQPRKJAd4tU7RRorwiLmAZCEOKu5JRCfJiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U+IMrM9y53tE0T5hoASI9574Bc5/OcRDzea9zc79CrCCEGTjuDHD0+ZCUMJDIALoQMY7nStxnlSVpp0SEGCaNjIa+5AGgmBXvBxLTFHD7yQQJqiVnjZwktQseJHumHm7uWSrGelKm2kI26ZwetzpzYqdMIm68G/eXZxCSuXTbqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AbXC39fP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AbXC39fP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB629C4CECF;
	Fri, 15 Nov 2024 06:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653419;
	bh=JxRvL7DhvQPRKJAd4tU7RRorwiLmAZCEOKu5JRCfJiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AbXC39fPFfJrxrXgItUcE4xzeV3M3OcqHd4cfoJEyv2eqVRWBIpWrav9BAud9Ab+n
	 e5zwBmP2mZ0gr61R9IMBiGvptvLtVDib0mEyKekuwkryfsZ1x1UfZaC3clnx94qLMh
	 kRowZlmbSKiANt5vJiR/yHDy5MFgWaX4dnS3778c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Mark Rutland <mark.rutland@arm.com>,
	syzbot+908886656a02769af987@syzkaller.appspotmail.com,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 17/48] kasan: Disable Software Tag-Based KASAN with GCC
Date: Fri, 15 Nov 2024 07:38:06 +0100
Message-ID: <20241115063723.586046719@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.962047137@linuxfoundation.org>
References: <20241115063722.962047137@linuxfoundation.org>
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
index fdca89c057452..275e6295fcd78 100644
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
@@ -100,7 +103,7 @@ config KASAN_SW_TAGS
 	help
 	  Enables Software Tag-Based KASAN.
 
-	  Requires GCC 11+ or Clang.
+	  Requires Clang.
 
 	  Supported only on arm64 CPUs and relies on Top Byte Ignore.
 
-- 
2.43.0



