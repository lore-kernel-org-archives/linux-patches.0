Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBCA41DE89C;
	Mon, 10 Mar 2025 17:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628265; cv=none; b=HD1L6VmeQobHvwx3JuIPRs+UiyCZ0ZiI2kvIZEZMrywvBSBOBxoQAtpu2WWEFGYkHpeF7coGR1BoulUqvKJqQJ/JZ5U9G7vtLIfojzZMLIP8Ot4Z/HzcjFTc/Iw5gSqiwirAt8Q8oWKQk8m8U4QzogsYkk+RPJTzHEAYYkIROL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628265; c=relaxed/simple;
	bh=D/kpPhGf+khtGv402LEZ8pgegc+eWBPMPdceUChZoFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fe1s7xHsbT3AAY4R1sberSVu/NrfaB5ltEI9E6/a9H2Vr9WII5W/4TvHmCZzmjAe/qew7/RiqzMHL7D+xGHGxXyjbn4eeYTx6EanQgbb2yQdjCvoXUi8a/TDcu4lWKG/XjJpuDvKx3ms+Z9LkoihjABhLMdUYqDBi7Bf8Pzv3VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZRmyXplj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZRmyXplj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB520C4CEE5;
	Mon, 10 Mar 2025 17:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628265;
	bh=D/kpPhGf+khtGv402LEZ8pgegc+eWBPMPdceUChZoFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZRmyXpljPFW0C7Y4RsFzKdqqqqlrfH5cD59VR0FcFH9PO5jcyxVig5grj6YRxrCuX
	 nKb5TLFviriuZeHKqe9+iXLhyObj5ruInzhd2II/oprqlIJcStTieu0nE6Y8qF0SB9
	 n77tJGrgQrA+Cv+dR7EUEG8XB6W3eaHJduDVTX5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 6.6 145/145] kbuild: userprogs: use correct lld when linking through clang
Date: Mon, 10 Mar 2025 18:07:19 +0100
Message-ID: <20250310170440.608619703@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Thomas Weiﬂschuh" <thomas.weissschuh@linutronix.de>

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
Signed-off-by: Thomas Wei√üschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
[nathan: use cc-option for 6.6 and older, as those trees support back to
         clang-11]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile |    5 +++++
 1 file changed, 5 insertions(+)

--- a/Makefile
+++ b/Makefile
@@ -1057,6 +1057,11 @@ endif
 KBUILD_USERCFLAGS  += $(filter -m32 -m64 --target=%, $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS))
 KBUILD_USERLDFLAGS += $(filter -m32 -m64 --target=%, $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS))
 
+# userspace programs are linked via the compiler, use the correct linker
+ifeq ($(CONFIG_CC_IS_CLANG)$(CONFIG_LD_IS_LLD),yy)
+KBUILD_USERLDFLAGS += $(call cc-option, --ld-path=$(LD))
+endif
+
 # make the checker run with the right architecture
 CHECKFLAGS += --arch=$(ARCH)
 


