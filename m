Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC4B9269801;
	Tue,  8 Apr 2025 11:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111684; cv=none; b=R59OkBLdSwcC/Ng6oYX3fpHpDFc2dwLoGR62vAyLZGngaTaM0dU986jTodz7MXglU7atb2rq8i4wirmGhY7Fka1TfdY48APgZwxwJFZRJii5YszOjVcEGZq0pDCd7D+P4lZnd9aOsV7W87inxVvpMpJ/uge/6dQ5HzAkcww+zss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111684; c=relaxed/simple;
	bh=a3ggA/NbDwKn8K+O8BfArYRN2enF4P52OhPjlAVS6g4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lj99uCEscmF/FqLRBadURWRJeT9mEOpyVP5P3j4krpGr7JZPW6CigboS/qVBUZNyvRnNATgTzd4kSRzjLNmNJTUX9WcCevGuXwicS0emFcPzK6FWhXdgATLx/TL5DRx54I4VFP59rOWe/BarENaQgTTXuelVL3A2Ybq5g5zhp6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sc5Zexxu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sc5Zexxu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6CB3C4CEE5;
	Tue,  8 Apr 2025 11:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111684;
	bh=a3ggA/NbDwKn8K+O8BfArYRN2enF4P52OhPjlAVS6g4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sc5ZexxuY5E4oykeirSA2/GzcTxEunrTcekpv+FCWD3RsiDkDqv9gmUczUJa9X4Ww
	 xrVTGy5RoQmoHdclYVB/BijDzMIufMTyyAwSkGpNZyd9925mQLaCKSnZlyCQHa1/vr
	 B1hy4WcSKa+Ivhx8yTeNWdLRVQ9VNOw+fNzDjyfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Gow <davidgow@google.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 522/731] um: Pass the correct Rust target and options with gcc
Date: Tue,  8 Apr 2025 12:46:59 +0200
Message-ID: <20250408104926.413735503@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



