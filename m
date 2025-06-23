Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825CA1EDA0F;
	Mon, 23 Jun 2025 21:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713820; cv=none; b=XEKMOWloFH3ODD5JZ6kCzdlg7Ws3kA6j+PaBbdEnKXgcNE6/atWe/XNU7d00I2cHgniAMOXnhdWzHEs7O+QE4T6SYYWD9LFM8FuZ1lAQMFlqOv7ucW1+P/gJB5NVobc0zgPl1uop3K9tMnt0cDwDCzehopKveBP8XZpDrtIuvrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713820; c=relaxed/simple;
	bh=u2I54/01iM1pA+7C5OSSdFrZQwDn4FhfD0H/8optDE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OtXakO9ZWrNVdKcVjkVN14U2U8wOKs3KG0IYfreG6wPgPFidHyZUa1TtT7QHPk4nm64nCZaTj0/QsVYb9ErTQ794Ul8Bv+cjBGBGkjsEe2xbxjE+9/cXH2YsGjuK/X+2i/l8TNammWhl3eLHAeHlmFmoZu86kUU2DkulRG2YP6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m1FAZGym; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m1FAZGym"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B491C4CEEA;
	Mon, 23 Jun 2025 21:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713820;
	bh=u2I54/01iM1pA+7C5OSSdFrZQwDn4FhfD0H/8optDE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m1FAZGymZ55PyUmfe4ZQiS44lgVfuXzFO5p5Gj0NtICg2qY5HsV6EwTiR+z0uLt62
	 0marTvbdKfwWYLGuHSt1xVAUoupXRoMBRs44zX9u2oPUpOm7u/UrqCYv8ZYlxfYOJj
	 iz5qY1EE15v+LIFQzFZs4Dp49dCEhDhCDS6D2sI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 5.15 169/411] MIPS: Move -Wa,-msoft-float check from as-option to cc-option
Date: Mon, 23 Jun 2025 15:05:13 +0200
Message-ID: <20250623130637.949923111@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

This patch is for linux-6.1.y and earlier, it has no direct mainline
equivalent.

In order to backport commit d5c8d6e0fa61 ("kbuild: Update assembler
calls to use proper flags and language target") to resolve a separate
issue regarding PowerPC, the problem noticed and fixed by
commit 80a20d2f8288 ("MIPS: Always use -Wa,-msoft-float and eliminate
GAS_HAS_SET_HARDFLOAT") needs to be addressed. Unfortunately, 6.1 and
earlier do not contain commit e4412739472b ("Documentation: raise
minimum supported version of binutils to 2.25"), so it cannot be assumed
that all supported versions of GNU as have support for -msoft-float.

In order to switch from KBUILD_CFLAGS to KBUILD_AFLAGS in as-option
without consequence, move the '-Wa,-msoft-float' check to cc-option,
including '$(cflags-y)' directly to avoid the issue mentioned in
commit 80a20d2f8288 ("MIPS: Always use -Wa,-msoft-float and eliminate
GAS_HAS_SET_HARDFLOAT").

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -110,7 +110,7 @@ endif
 # (specifically newer than 2.24.51.20140728) we then also need to explicitly
 # set ".set hardfloat" in all files which manipulate floating point registers.
 #
-ifneq ($(call as-option,-Wa$(comma)-msoft-float,),)
+ifneq ($(call cc-option,$(cflags-y) -Wa$(comma)-msoft-float,),)
 	cflags-y		+= -DGAS_HAS_SET_HARDFLOAT -Wa,-msoft-float
 endif
 


