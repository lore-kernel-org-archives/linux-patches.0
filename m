Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE1D0216E12;
	Thu, 12 Dec 2024 15:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017744; cv=none; b=VLEzxMPP2PExVWO9cZ8AMLRCCNivrzF1pB/33oTrdyLR+Oi7VUQUw50Rv9vaCxwb2owhG+SOOMSN7v6nTJ9Ebc1HTHMdl9wyGCjc/JdHOLR+Kk1b9ES4m3/h1ODbFzYShx0fyGqODSG/OwWFCSAhQlIGShFxmnYewA+uNhfR/2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017744; c=relaxed/simple;
	bh=8gawyf8NwzEl2m0DEF71EdaMHQKQvVRw8O/82zwQg8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mtSKNr/UPnkdb30XjWf2WEnopvBZoKlsdUPahJmxlyCtV37tlvKxc/YY0jFeeCuigLNZMXlFMWnGdBM0H8G5kQ/SIv/FluN6i0lg6NwAfXhWgmuURynqBU7WrCZtCHhGpUGoGkIfGO65H0i2GU1NlXhiTaIiVWPujFBhJNnm6vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ny1+SGRC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ny1+SGRC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC577C4CED0;
	Thu, 12 Dec 2024 15:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017744;
	bh=8gawyf8NwzEl2m0DEF71EdaMHQKQvVRw8O/82zwQg8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ny1+SGRC3TVsZJBKCGBvF7bcN+IGOplZ/Hxpzz4LfHtYabOzWblaw8zukpQJ83hL1
	 gN5eNhmLQDiQrL0QxnWziDi3HaDwSHyaaa3BDN1/YyNcXYydrqLllTnMps90pipnSK
	 3vZ5BNFFHY+bol1Pbn6nG0qAUYNHDoaprIIabUAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 092/356] powerpc/vdso: Drop -mstack-protector-guard flags in 32-bit files with clang
Date: Thu, 12 Dec 2024 15:56:51 +0100
Message-ID: <20241212144248.249219846@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit d677ce521334d8f1f327cafc8b1b7854b0833158 ]

Under certain conditions, the 64-bit '-mstack-protector-guard' flags may
end up in the 32-bit vDSO flags, resulting in build failures due to the
structure of clang's argument parsing of the stack protector options,
which validates the arguments of the stack protector guard flags
unconditionally in the frontend, choking on the 64-bit values when
targeting 32-bit:

  clang: error: invalid value 'r13' in 'mstack-protector-guard-reg=', expected one of: r2
  clang: error: invalid value 'r13' in 'mstack-protector-guard-reg=', expected one of: r2
  make[3]: *** [arch/powerpc/kernel/vdso/Makefile:85: arch/powerpc/kernel/vdso/vgettimeofday-32.o] Error 1
  make[3]: *** [arch/powerpc/kernel/vdso/Makefile:87: arch/powerpc/kernel/vdso/vgetrandom-32.o] Error 1

Remove these flags by adding them to the CC32FLAGSREMOVE variable, which
already handles situations similar to this. Additionally, reformat and
align a comment better for the expanding CONFIG_CC_IS_CLANG block.

Cc: stable@vger.kernel.org # v6.1+
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://patch.msgid.link/20241030-powerpc-vdso-drop-stackp-flags-clang-v1-1-d95e7376d29c@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/vdso/Makefile | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/vdso/Makefile b/arch/powerpc/kernel/vdso/Makefile
index 5c7af93018865..d5defff8472da 100644
--- a/arch/powerpc/kernel/vdso/Makefile
+++ b/arch/powerpc/kernel/vdso/Makefile
@@ -51,10 +51,14 @@ ldflags-y += $(filter-out $(CC_AUTO_VAR_INIT_ZERO_ENABLER) $(CC_FLAGS_FTRACE) -W
 
 CC32FLAGS := -m32
 CC32FLAGSREMOVE := -mcmodel=medium -mabi=elfv1 -mabi=elfv2 -mcall-aixdesc
-  # This flag is supported by clang for 64-bit but not 32-bit so it will cause
-  # an unused command line flag warning for this file.
 ifdef CONFIG_CC_IS_CLANG
+# This flag is supported by clang for 64-bit but not 32-bit so it will cause
+# an unused command line flag warning for this file.
 CC32FLAGSREMOVE += -fno-stack-clash-protection
+# -mstack-protector-guard values from the 64-bit build are not valid for the
+# 32-bit one. clang validates the values passed to these arguments during
+# parsing, even when -fno-stack-protector is passed afterwards.
+CC32FLAGSREMOVE += -mstack-protector-guard%
 endif
 LD32FLAGS := -Wl,-soname=linux-vdso32.so.1
 AS32FLAGS := -D__VDSO32__
-- 
2.43.0



