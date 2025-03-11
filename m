Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B1F425DB0B;
	Tue, 11 Mar 2025 15:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705694; cv=none; b=iD37tw7whoxvoVUccg3NaYrA/zENhb7Mu7HRI+poEUomIm4TXIzP3qxawFkcXqARCWcgxQMtoa0pqA0ApgjfrddbDuQc3Kw64zZlHB9ThyqXTNasWGQLRIDZMbN9UHTY8HUmdOglxS17l64cne2n4Q7iToAdVirX4irv+t+Pssw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705694; c=relaxed/simple;
	bh=thDolxC6xc7O0zmMoGlP3FW+nyLihgtMh/pFWQ9vmis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jd3/il2wqEnO3rZKztpGu7ISTYP2ve+EKv8hqrrQO3Pkz5zVbpbHOToUlkw5q2SAb7oPU+ugDg7rihk4Rzxsh185LVTogi1aFfC/i3NpA7agQxtv05cOJu1+B64jNs0YZTWWufseeLUksBbeh8uMx2O+OrYRlS55aqXpf4j+jSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tq6Pwesr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tq6Pwesr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B99FFC4CEE9;
	Tue, 11 Mar 2025 15:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705694;
	bh=thDolxC6xc7O0zmMoGlP3FW+nyLihgtMh/pFWQ9vmis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tq6PwesruRr9d7jJEuA0v58CjWBOhujvkx+8blHlL6UegqdLQ+lQe5vTE0ZgImd3y
	 5d5rBLurAIDH5lA74ScQVGNeD5mOZU2k4U6IJ6RVf3J+wSvLfZj0Iu1ZH3P7V7bCiK
	 ku75ntP9TWsujp4qrHt9Ift0Nf7GLu7fPnkhXeQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.4 103/328] kbuild: userprogs: use correct lld when linking through clang
Date: Tue, 11 Mar 2025 15:57:53 +0100
Message-ID: <20250311145718.988196364@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -956,6 +956,11 @@ ifeq ($(CONFIG_RELR),y)
 LDFLAGS_vmlinux	+= --pack-dyn-relocs=relr --use-android-relr-tags
 endif
 
+# userspace programs are linked via the compiler, use the correct linker
+ifeq ($(CONFIG_CC_IS_CLANG)$(CONFIG_LD_IS_LLD),yy)
+KBUILD_USERLDFLAGS += $(call cc-option, --ld-path=$(LD))
+endif
+
 # make the checker run with the right architecture
 CHECKFLAGS += --arch=$(ARCH)
 


