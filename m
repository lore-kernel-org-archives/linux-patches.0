Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD5D2222B2;
	Tue, 24 Jun 2025 04:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750738299; cv=none; b=SphcIBgYq10JClW4gDDdd1nbniKsZiIz31h/RcP0jBtppjab+dwAgqgi/CV2HxjeKDOEFuZ5yWE97vn+9z1ItMF/rXyHpoCbfs01HdjpgVVO8AePqUC8E1JbvdMS/bxNcnyJZ9MG82SL2V3sRVK3N3DqWsAZ++zDKImR5XWKCxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750738299; c=relaxed/simple;
	bh=+vmQseMJm0Csnk8ZH7N0eziFnpNk9CZVqw+zqztxKS8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EyGSl0a3rLth/MeGSAtdtcKCCoohEtihfUsa87qqrx/W8jlytKo/Uf/IHnrEluF2JEv8kkIAsSy0mur5mqvyoQuHbuRldeX7fZhLzxk4rk2ZE34/4e2Q9UN57ae2fvGV4ESl+xToYGLWaanayrMkP5y822+S5qMNYdS78I/+DmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Aab9Uu24; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Aab9Uu24"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E428C4CEEF;
	Tue, 24 Jun 2025 04:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750738296;
	bh=+vmQseMJm0Csnk8ZH7N0eziFnpNk9CZVqw+zqztxKS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Aab9Uu24omq59qm+HTdRs4UwupRKEsCBIwRv2NyyGWOKNjKJARqTLg/RuPJrWKk0/
	 fHXl8NWdpT4CMIG4nkA8y/iRIEv/mNLa9P3hORswTebIom3FVIusvkE2+8kTJKpiLx
	 gY1epzM3VyLPkD1X3Q1oRSTFsPwGkg/ZH7jLM7SPZByFjQ/48elRujUPnly1tiBr6y
	 y4byT/VmOR3eW2QB26VS3vtZnnDvvBvfbE/kSnQCiu960b7E4gF7TaPv7lMifMmufS
	 63rx7NC0TtYYi7138ZwZs263S9ZR9Ag8YoyWibMo4mH6KxIJlnKsZ6NxSiV8vrMjoO
	 wFYYXhmqV3iOA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Tulio Magno <tuliom@ascii.art.br>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Justin M . Forbes" <jforbes@fedoraproject.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.15 11/20] powerpc: Fix struct termio related ioctl macros
Date: Tue, 24 Jun 2025 00:11:10 -0400
Message-Id: <20250624041120.83191-11-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250624041120.83191-1-sashal@kernel.org>
References: <20250624041120.83191-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15.3
Content-Transfer-Encoding: 8bit

From: Madhavan Srinivasan <maddy@linux.ibm.com>

[ Upstream commit ab107276607af90b13a5994997e19b7b9731e251 ]

Since termio interface is now obsolete, include/uapi/asm/ioctls.h
has some constant macros referring to "struct termio", this caused
build failure at userspace.

In file included from /usr/include/asm/ioctl.h:12,
                 from /usr/include/asm/ioctls.h:5,
                 from tst-ioctls.c:3:
tst-ioctls.c: In function 'get_TCGETA':
tst-ioctls.c:12:10: error: invalid application of 'sizeof' to incomplete type 'struct termio'
   12 |   return TCGETA;
      |          ^~~~~~

Even though termios.h provides "struct termio", trying to juggle definitions around to
make it compile could introduce regressions. So better to open code it.

Reported-by: Tulio Magno <tuliom@ascii.art.br>
Suggested-by: Nicholas Piggin <npiggin@gmail.com>
Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
Reviewed-by: Michael Ellerman <mpe@ellerman.id.au>
Closes: https://lore.kernel.org/linuxppc-dev/8734dji5wl.fsf@ascii.art.br/
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20250517142237.156665-1-maddy@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Fixes a real build failure**: The commit message clearly documents
   a userspace build failure when `asm/ioctls.h` is included without
   `struct termio` being defined. This breaks userspace programs that
   use these ioctl definitions.

2. **Simple and contained fix**: The change is minimal and low-risk - it
   merely replaces macro calls with their hardcoded equivalents. The
   hardcoded values (0x40147417, 0x80147418, 0x80147419, 0x8014741c) are
   the exact expansion of the original macros for a 20-byte `struct
   termio` on PowerPC.

3. **Follows established patterns**: Other architectures (sh and xtensa)
   already use this same approach of hardcoding the values with comments
   showing the original macro. This indicates it's a known and accepted
   solution.

4. **No functional changes**: The ioctl values remain exactly the same -
   only the way they're defined changes. This ensures binary
   compatibility is maintained.

5. **Prevents future issues**: As noted in the commit message, the
   termio interface is obsolete, and trying to reorganize header files
   to fix this properly could introduce regressions. The hardcoded
   approach is safer.

6. **Clear user impact**: The commit includes a specific example of the
   build failure with line numbers and error messages, demonstrating
   this affects real users (reported by Tulio Magno).

7. **Tested**: The commit indicates it was tested by Justin M. Forbes,
   providing confidence in the fix.

The commit follows the stable tree rules by fixing an important bug
(build failure) with minimal risk of regression, making it an ideal
candidate for backporting.

 arch/powerpc/include/uapi/asm/ioctls.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/include/uapi/asm/ioctls.h b/arch/powerpc/include/uapi/asm/ioctls.h
index 2c145da3b774a..b5211e413829a 100644
--- a/arch/powerpc/include/uapi/asm/ioctls.h
+++ b/arch/powerpc/include/uapi/asm/ioctls.h
@@ -23,10 +23,10 @@
 #define TCSETSW		_IOW('t', 21, struct termios)
 #define TCSETSF		_IOW('t', 22, struct termios)
 
-#define TCGETA		_IOR('t', 23, struct termio)
-#define TCSETA		_IOW('t', 24, struct termio)
-#define TCSETAW		_IOW('t', 25, struct termio)
-#define TCSETAF		_IOW('t', 28, struct termio)
+#define TCGETA		0x40147417 /* _IOR('t', 23, struct termio) */
+#define TCSETA		0x80147418 /* _IOW('t', 24, struct termio) */
+#define TCSETAW		0x80147419 /* _IOW('t', 25, struct termio) */
+#define TCSETAF		0x8014741c /* _IOW('t', 28, struct termio) */
 
 #define TCSBRK		_IO('t', 29)
 #define TCXONC		_IO('t', 30)
-- 
2.39.5

