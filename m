Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB7711C760D;
	Wed, 19 Feb 2025 09:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955676; cv=none; b=PtxTuUOy+kCrFrkxyfKo5/8pSy1ZOG6pL+D49GByfHb2nw3aizPXLoNsu/r1b/EEbIttYyujmMOkZl6zxO9x6+KTMvXbYL45rXOrIh2HI2fGFt7DIXRmEYfXBcbXUGiyLwNy56vrEhp58xD7d6flfWBHpyk1PMzAjMs3cw+DviU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955676; c=relaxed/simple;
	bh=FFKjC5hbGLQDeF58G0MTd4tjOlfLfQ8qcHRtspST07g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P9YPbxXMYQjJ5bK0xipKfsqjLWwvc62aJKV0mRY9eB54G+gJbV7nvfukfpnXqAZ8fEMjCB8z2xEu9Pyy0Dw6KeQYHoiTQ3fi8nApx+Qoq0OK0HGMxb9xwYHPfQE+ehZg9dZAOrkBhH24meABOxP3QIRSQSeJ9kuQGsidA91A+uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dncSTL7w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dncSTL7w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01F4BC4CEE6;
	Wed, 19 Feb 2025 09:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955676;
	bh=FFKjC5hbGLQDeF58G0MTd4tjOlfLfQ8qcHRtspST07g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dncSTL7w2GzfKWNOn51dpdly8RuKwonjSpLbMD059q1ULHv+88yqweFD8lfX3wSt7
	 p9fW2FqPlXIGe6xlGZ8B7wm5cKvOnazxj7rHsruBqWPlaMjvIwBWKqbGRtzFZ3elMx
	 ZKgB6u/6rLCa3tt7BpzBZsml8SLeSida73+G4DdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 6.6 080/152] kbuild: userprogs: fix bitsize and target detection on clang
Date: Wed, 19 Feb 2025 09:28:13 +0100
Message-ID: <20250219082553.210968486@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
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

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

commit 1b71c2fb04e7a713abc6edde4a412416ff3158f2 upstream.

scripts/Makefile.clang was changed in the linked commit to move --target from
KBUILD_CFLAGS to KBUILD_CPPFLAGS, as that generally has a broader scope.
However that variable is not inspected by the userprogs logic,
breaking cross compilation on clang.

Use both variables to detect bitsize and target arguments for userprogs.

Fixes: feb843a469fb ("kbuild: add $(CLANG_FLAGS) to KBUILD_CPPFLAGS")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Makefile
+++ b/Makefile
@@ -1054,8 +1054,8 @@ LDFLAGS_vmlinux += --orphan-handling=$(C
 endif
 
 # Align the bit size of userspace programs with the kernel
-KBUILD_USERCFLAGS  += $(filter -m32 -m64 --target=%, $(KBUILD_CFLAGS))
-KBUILD_USERLDFLAGS += $(filter -m32 -m64 --target=%, $(KBUILD_CFLAGS))
+KBUILD_USERCFLAGS  += $(filter -m32 -m64 --target=%, $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS))
+KBUILD_USERLDFLAGS += $(filter -m32 -m64 --target=%, $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS))
 
 # make the checker run with the right architecture
 CHECKFLAGS += --arch=$(ARCH)


