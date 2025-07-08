Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B262045B5;
	Tue,  8 Jul 2025 16:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993604; cv=none; b=GqYRI2h0kftOlkb1Xn96lIEvBiZaCTRvmeV279q2tAm4F9b5fWzZitV1lBvZi7H+JkL3RiwaNExBtYnkW72XqbN5uzJGIbQd9NbxoVpdQBTl8HJxvJgs2CckdIMcQ6qyg4aLKSofKUMhyYZy/4oMZlQKtDyKoJ0T6U3QjSLNwlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993604; c=relaxed/simple;
	bh=rktD87SNJVsiVzyLWLDmwod8mxHZ6R8OnO9NHcS69C0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=azFjaSWmXK6RIpiiE46UudVtevQ1fyzp2IC9xTCUYvOIVXIrSHcejejWDmB1/8DyUaSrM6pLUK8Jt6xtNgQqXwKZDTw1YrsbF1wlhBU7d4OBB2bjrur24b1/robBkY06uiCVjOrD/Lu+k+wdQ93+QMWBTWOj2OFSHX32sw8h90A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EwKD5Rcy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EwKD5Rcy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DF74C4CEF0;
	Tue,  8 Jul 2025 16:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993604;
	bh=rktD87SNJVsiVzyLWLDmwod8mxHZ6R8OnO9NHcS69C0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EwKD5Rcy9+yMJ++l/OSDYi8ZPn2mC2XwYwiMwM+6gIfIX7uAgwrmGPwCNa4wo7TGP
	 p6lhqyIWhRjCY3S2rsWrYsDj352PLs+FIbqAwx08WyVpfm9Vr3onVVV9qSU/++beqi
	 z049M9ktXR6U9TqyybcI0D3+6W+biLQ0dIjCtEiE=
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
Subject: [PATCH 6.15 131/178] powerpc: Fix struct termio related ioctl macros
Date: Tue,  8 Jul 2025 18:22:48 +0200
Message-ID: <20250708162239.989095952@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



