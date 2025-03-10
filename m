Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99591A315A;
	Mon, 10 Mar 2025 17:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626957; cv=none; b=Fb9mtkxOqlhct3wY7BbhlF8GOJ9WKgdLrVV+ICbCPE3yw/tggsKpV8YdXevSMTs6mf0N6WOQkHkpGPO7bBTbc54CCklxSyQzJDugjLaDTJ3+UyV2sM8FGxn9aWt/BziE5AOjx0buHQuaRcA5kjQtQbzKC9vRJnGJt6f3u3A5DPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626957; c=relaxed/simple;
	bh=1Emo0N0++x0HTU8LIhuRvnm6EelF9b3q4d2qXT4eY0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c2K8ubq8p5R8XwTx03vtEcMEFFS+H5EarFIYaydyoTg3MWf4l20TBw+sBG/JuGKU+IPR2grh0swh0ZDEUYkfiD3UBRuVHuODdNnhLXFym5CQqpLT9o2qOyn9d2jizRc2Njxer126XUGYv2GtK8/XqBWOT8eI4uOwZoOw045k1ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a1Q0rCtW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a1Q0rCtW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32127C4CEE5;
	Mon, 10 Mar 2025 17:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626957;
	bh=1Emo0N0++x0HTU8LIhuRvnm6EelF9b3q4d2qXT4eY0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a1Q0rCtWYIdzVMjfJ5P0/lTbNnPr0MS2DJv0gKJc8Tq6XseB7vWOjh7gAvlllQmwl
	 ZSX8Vs2Y8nB976dbK6XCRdl33mgHq49cD8zn9BmVi+DuZLN8fa3OpCEHck7WW2M5Pi
	 Y6UsJpmZE1lgLVO5QIlV5ZIMfkJnZLJUCR+0w340=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 6.13 170/207] kbuild: userprogs: use correct lld when linking through clang
Date: Mon, 10 Mar 2025 18:06:03 +0100
Message-ID: <20250310170454.544487448@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

commit dfc1b168a8c4b376fa222b27b97c2c4ad4b786e1 upstream.

The userprog infrastructure links objects files through $(CC).
Either explicitly by manually calling $(CC) on multiple object files or
implicitly by directly compiling a source file to an executable.
The documentation at Documentation/kbuild/llvm.rst indicates that ld.lld
would be used for linking if LLVM=1 is specified.
However clang instead will use either a globally installed cross linker
from $PATH called ${target}-ld or fall back to the system linker, which
probably does not support crosslinking.
For the normal kernel build this is not an issue because the linker is
always executed directly, without the compiler being involved.

Explicitly pass --ld-path to clang so $(LD) is respected.
As clang 13.0.1 is required to build the kernel, this option is available.

Fixes: 7f3a59db274c ("kbuild: add infrastructure to build userspace programs")
Cc: stable@vger.kernel.org # needs wrapping in $(cc-option) for < 6.9
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile |    5 +++++
 1 file changed, 5 insertions(+)

--- a/Makefile
+++ b/Makefile
@@ -1122,6 +1122,11 @@ endif
 KBUILD_USERCFLAGS  += $(filter -m32 -m64 --target=%, $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS))
 KBUILD_USERLDFLAGS += $(filter -m32 -m64 --target=%, $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS))
 
+# userspace programs are linked via the compiler, use the correct linker
+ifeq ($(CONFIG_CC_IS_CLANG)$(CONFIG_LD_IS_LLD),yy)
+KBUILD_USERLDFLAGS += --ld-path=$(LD)
+endif
+
 # make the checker run with the right architecture
 CHECKFLAGS += --arch=$(ARCH)
 


