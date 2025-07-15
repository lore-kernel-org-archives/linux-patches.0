Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC2A2E1757;
	Tue, 15 Jul 2025 13:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586322; cv=none; b=PYO7gTqvAo+gPxFYCbaVLRwPim17lrq+wJgGNQLOk24gaouhR8F6yhyq5uYV6i2X9rbVi8j4NsMkoTtOTjhQ4zW8uwfYjR66QYX5A0rSBak/jhCORi0A+yxtUKL1ULA3kLtHi3PKx0pUFQYcnAZuRl6jL3fGmJvzfFt+XU3jJIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586322; c=relaxed/simple;
	bh=WgMuium4ihTBdz2HmPFECSHZlXIEVoWCm7FSyE/Id6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KbwdyV6MXQfFmLwylDNLrD36/2eMFSbbWuSFriTnW0NCKeO0QHDrL21xv4pI4itj5EeeMzzsbpI4F4o5Pazwnn+3reyWTeVm8mLyLJyGOCdzlEpggynoG06xhaZTejDuWxbxUW7UF0IsZWBeGnrSragd82srSESZoGZlQe9Mnuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O3z8EkRw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O3z8EkRw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 939D8C4CEE3;
	Tue, 15 Jul 2025 13:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586322;
	bh=WgMuium4ihTBdz2HmPFECSHZlXIEVoWCm7FSyE/Id6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O3z8EkRwLxwhCO42VBVLIWZbMX+C5J+HMlD21TsldQ0isgA3VdcsMMTg7FyykjPsx
	 Hiu1eLv3/SYhVqDzkxgMMjqWIuqNnuROOcbM8GY80eDvKpsl3NyExx7CyH0ospan3n
	 EU07pT4zi4ROFJw/Whp+ol2rw8EyJbsxedD+yb2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 021/148] bpfilter: match bit size of bpfilter_umh to that of the kernel
Date: Tue, 15 Jul 2025 15:12:23 +0200
Message-ID: <20250715130801.164566860@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 9371f86ecb60f6f1f120e3d93fe892bbb70d04c0 ]

bpfilter_umh is built for the default machine bit of the compiler,
which may not match to the bit size of the kernel.

This happens in the scenario below:

You can use biarch GCC that defaults to 64-bit for building the 32-bit
kernel. In this case, Kbuild passes -m32 to teach the compiler to
produce 32-bit kernel space objects. However, it is missing when
building bpfilter_umh. It is built as a 64-bit ELF, and then embedded
into the 32-bit kernel.

The 32-bit kernel and 64-bit umh is a bad combination.

In theory, we can have 32-bit umh running on 64-bit kernel, but we do
not have a good reason to support such a usecase.

The best is to match the bit size between them.

Pass -m32 or -m64 to the umh build command if it is found in
$(KBUILD_CFLAGS). Evaluate CC_CAN_LINK against the kernel bit-size.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Stable-dep-of: 02e9a22ceef0 ("kbuild: hdrcheck: fix cross build with clang")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 init/Kconfig          | 4 +++-
 net/bpfilter/Makefile | 5 +++--
 usr/include/Makefile  | 4 ++++
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 41e87e8a5c6c1..50adf085d08b7 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -28,7 +28,9 @@ config CLANG_VERSION
 	default $(shell,$(srctree)/scripts/clang-version.sh $(CC))
 
 config CC_CAN_LINK
-	def_bool $(success,$(srctree)/scripts/cc-can-link.sh $(CC))
+	bool
+	default $(success,$(srctree)/scripts/cc-can-link.sh $(CC) $(m64-flag)) if 64BIT
+	default $(success,$(srctree)/scripts/cc-can-link.sh $(CC) $(m32-flag))
 
 config CC_HAS_ASM_GOTO
 	def_bool $(success,$(srctree)/scripts/gcc-goto.sh $(CC))
diff --git a/net/bpfilter/Makefile b/net/bpfilter/Makefile
index aa945ab5b6558..05930c2fafd52 100644
--- a/net/bpfilter/Makefile
+++ b/net/bpfilter/Makefile
@@ -5,14 +5,15 @@
 
 hostprogs-y := bpfilter_umh
 bpfilter_umh-objs := main.o
-KBUILD_HOSTCFLAGS += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi
+KBUILD_HOSTCFLAGS += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi \
+			$(filter -m32 -m64, $(KBUILD_CFLAGS))
 HOSTCC := $(CC)
 
 ifeq ($(CONFIG_BPFILTER_UMH), y)
 # builtin bpfilter_umh should be compiled with -static
 # since rootfs isn't mounted at the time of __init
 # function is called and do_execv won't find elf interpreter
-KBUILD_HOSTLDFLAGS += -static
+KBUILD_HOSTLDFLAGS += -static $(filter -m32 -m64, $(KBUILD_CFLAGS))
 endif
 
 $(obj)/bpfilter_umh_blob.o: $(obj)/bpfilter_umh
diff --git a/usr/include/Makefile b/usr/include/Makefile
index 6c4b79d4558d6..3d9dc4a5c6fca 100644
--- a/usr/include/Makefile
+++ b/usr/include/Makefile
@@ -8,6 +8,10 @@
 # We cannot go as far as adding -Wpedantic since it emits too many warnings.
 UAPI_CFLAGS := -std=c90 -Wall -Werror=implicit-function-declaration
 
+# In theory, we do not care -m32 or -m64 for header compile tests.
+# It is here just because CONFIG_CC_CAN_LINK is tested with -m32 or -m64.
+UAPI_CFLAGS += $(filter -m32 -m64, $(KBUILD_CFLAGS))
+
 override c_flags = $(UAPI_CFLAGS) -Wp,-MMD,$(depfile) -I$(objtree)/usr/include
 
 # The following are excluded for now because they fail to build.
-- 
2.39.5



