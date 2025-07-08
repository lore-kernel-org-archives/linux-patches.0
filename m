Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6132DC32D;
	Tue,  8 Jul 2025 17:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751994118; cv=none; b=rho0izJWqg451rOZtB7PjHS1ZeQd0GkrBWj6VW0vzylhGfE7NdjPtv5zP/Rm9tAhKrtCzwurwRKfO+/3Nk/RzMnqgwEhLQJtiq8GCbeJoZWf/et6ELmWlXIKsglKeItmNGAJ5cOi5z348HJtCNFieAUs8pee/KaH6dqNIEmpPnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751994118; c=relaxed/simple;
	bh=Geq76jeWQBrGrsrd27rwArilar8v5U4IR5c7pBpYO1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ewK1bvZ+KhWt2levUYiKtRIqZ7TcGbstWfICZcgEve09mRtWYUBitOEcPqgV0eP1uGrBBaMWNZXnKyIL64FkZrGBF7ELvy6B2wluqyj6C6cx4BR9sdwWPQ4cKeCAJneR0ObWXcq0xh1xWDVU3Tz/GqSLctfwaA55LwCo1d4Dq28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CMqaP3vP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CMqaP3vP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F2C3C4CEED;
	Tue,  8 Jul 2025 17:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751994118;
	bh=Geq76jeWQBrGrsrd27rwArilar8v5U4IR5c7pBpYO1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CMqaP3vP3j4JrXIt+M9A1/lF/qGa8fuljERf+L4UPFobGiCmST9ZIeCtzWOVPLGsT
	 KC00YzTX9z7WTRvdFPQXMx6EmWyDSGdrYoNB0G9roagnda0XBvLeFW9oWXg+09gJUM
	 g6iYW5rCtM8siY+o8xSTbV8or0sh95jojat+W2D8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tulio Magno <tuliom@ascii.art.br>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Justin M. Forbes" <jforbes@fedoraproject.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 130/160] powerpc: Fix struct termio related ioctl macros
Date: Tue,  8 Jul 2025 18:22:47 +0200
Message-ID: <20250708162235.006734436@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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



