Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE06D226D04;
	Tue, 24 Jun 2025 04:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750738412; cv=none; b=VTa/rtnX6eswPQE3Ccvsh3Yk+sOJjl1uL8l2k6UjrBKy6WxHDJL0Cb1KVZGcKNYZAwar+8nnxoEI3fMkl7QwPQWQQ9qyYqTwrrVH0jfZBq6SIEiR10R7LE2UF+mr0LgUT1ye73BCp6BHB7ca42h9dAIJDGD1QAOG5cGlWu42shg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750738412; c=relaxed/simple;
	bh=+vmQseMJm0Csnk8ZH7N0eziFnpNk9CZVqw+zqztxKS8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VglJWJ0BdpXhjuRIb5fqUOuZR9g7tMTfGUfZw2dq/mfKW8H4xeIKkbzXEcszB3d8oDQHOPoHFSkYTCxMgRpNYe46DbnEPd14XEEwqDrK9slsA8rWOSUxZ0IixpSNCM5ZOXjIq+jz4nArjXaoPFVfdwKAWt/h0Z5YRPsksJ16wFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ot5/SH91; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ot5/SH91"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06B19C4CEE3;
	Tue, 24 Jun 2025 04:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750738412;
	bh=+vmQseMJm0Csnk8ZH7N0eziFnpNk9CZVqw+zqztxKS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ot5/SH911bknVTpgxli53ys3LRTFHfLNdbuUWkJNcCHRoU155f6iWmYNYswa4qrnW
	 SLJumu/REaojtfg584IPROVMmCgJt5kFpUcImWJLWLpgKS/AtckdbDQasCDUGN1qW/
	 SQJV6QAmUwd2HE18/7dlZfg5X2e9RKSTDhvyR5FODhuq6BZqls5mRzyrCXE4QspdU4
	 9/rFy+iAYNXpoLqnoXaaCHm0Ook9VKDGTBXChQFdA6d8GYJPQ6L3pNbCPk5PkEISnY
	 uM47FHyWnlY9aBARWqDmdg+PdwwjJNI39ADuy0W8ANumWlV6UlLoVcSVmKqaexcofN
	 N3snPnpcBwRkA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Tulio Magno <tuliom@ascii.art.br>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Justin M . Forbes" <jforbes@fedoraproject.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 3/7] powerpc: Fix struct termio related ioctl macros
Date: Tue, 24 Jun 2025 00:13:22 -0400
Message-Id: <20250624041327.85407-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250624041327.85407-1-sashal@kernel.org>
References: <20250624041327.85407-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.4.294
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

