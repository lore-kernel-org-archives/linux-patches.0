Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63085147C75;
	Thu, 16 May 2024 14:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715868227; cv=none; b=KyTz2V+ZvKkVjwT/0N/v90iLw+yXs77HG08R4UvXGTg+o8qtDKHosgmUO5srbm38Ng/T/JVrmWuhyGliegC6oAn07zi7rXA5hB41pOCwvqAG6Nqc4WhpjGPFzXzCIEJFhptzBGXnITU8wK+6g65HczgtKSOc70hYeyU1bV6ZHyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715868227; c=relaxed/simple;
	bh=btau07SULIoJqAYVzbVYOn4odv7J5jQdnBX5OjVK4G4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=U1GIqgwE4Y02uBfsjeDm0ekVvfUnZtMGzRpJVLNl8By7ASkK96khoOMh3MELsdw2AazFkrVn2NY6Po9OuaqPVksoRQUyAVeu0hE1ck6VpJc3BpSQDkWc9QtRId127WJmX1f0ialfvuqIcSWZe1APaKX+rq1KOPabIA6QZXo2qDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Drw8Zuny; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Drw8Zuny"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98387C113CC;
	Thu, 16 May 2024 14:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715868227;
	bh=btau07SULIoJqAYVzbVYOn4odv7J5jQdnBX5OjVK4G4=;
	h=From:Date:Subject:To:Cc:From;
	b=Drw8ZunyLWTr0nM0rJ68C/Qs17bPqqTgPav4i1mGgj2/L27YwXmx4oZjSv7CNjyCi
	 3ObhB/MpoSlxm0DigGTMGuE+plKFoNl91gH2B+GxdKDTGW8BwepQOCwBioUVFmvR6r
	 VERV9RbO0dTwfKKr3htsi1Iblz3WALW6tUsRpmnyIjK03hmJbAPqSNYYVuN8RjdR5P
	 dliR0k/KQ20XL1ccOSlhdwSWyUFhSE4umJB819p4TTpRcn7qavEJz0eCTRIOvREhwc
	 NjGkrSaGwzOB0c8LknuaND4gAkoNrCqqthBLNN/vIivn3O7ADidW4SzXkDlJZivOm4
	 7qhhsK0PS/1GA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 16 May 2024 07:03:41 -0700
Subject: [PATCH] x86/boot: Address clang -Wimplicit-fallthrough in
 vsprintf()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240516-x86-boot-fix-clang-implicit-fallthrough-v1-1-04dc320ca07c@kernel.org>
X-B4-Tracking: v=1; b=H4sIADwSRmYC/x2NwQqDMBBEf0X27IKRJmp/RTyY7WoWUiOJLYL47
 116fMO8mQsKZ+ECz+qCzF8pkjYFU1dAYd5WRnkpQ9u0j8Yah2fv0Kd04CInUtQKynuPQqLRHOM
 RcvqsAReyNHhvhs5Z0LU9sxr/p3G67x8/+nHAeQAAAA==
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org
Cc: Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev, 
 kernel test robot <lkp@intel.com>, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.14-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1475; i=nathan@kernel.org;
 h=from:subject:message-id; bh=btau07SULIoJqAYVzbVYOn4odv7J5jQdnBX5OjVK4G4=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDGluQk73OprDal7ErGtaPL/fzVM1ew6D8kGH9DdR834W/
 HZbf2NqRykLgxgXg6yYIkv1Y9XjhoZzzjLeODUJZg4rE8gQBi5OAZiIHBfDP71rcTKm7x0Y2SX0
 I0s4zSc45au+t1qy/qCzwtG3pQteODIy/NsZvI1Z6vjeiqfiWrXB2x2l+cR1DM7/SDilMyVTit+
 WBQA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

After enabling -Wimplicit-fallthrough for the x86 boot code, clang
warns:

  arch/x86/boot/printf.c:257:3: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
    257 |                 case 'u':
        |                 ^

Clang is a little more pedantic than GCC, which does not warn when
falling through to a case that is just break or return. Clang's version
is more in line with the kernel's own stance in deprecated.rst, which
states that all switch/case blocks must end in either break,
fallthrough, continue, goto, or return. Add the missing break to silence
the warning.

Fixes: dd0716c2b877 ("x86/boot: Add a fallthrough annotation")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202405162054.ryP73vy1-lkp@intel.com/
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/x86/boot/printf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/boot/printf.c b/arch/x86/boot/printf.c
index c0ec1dc355ab..51dc14b714f6 100644
--- a/arch/x86/boot/printf.c
+++ b/arch/x86/boot/printf.c
@@ -254,6 +254,8 @@ int vsprintf(char *buf, const char *fmt, va_list args)
 		case 'd':
 		case 'i':
 			flags |= SIGN;
+			break;
+
 		case 'u':
 			break;
 

---
base-commit: dd0716c2b87792ebea30864e7ad1df461d4c1525
change-id: 20240516-x86-boot-fix-clang-implicit-fallthrough-fc5c9bb19765

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

