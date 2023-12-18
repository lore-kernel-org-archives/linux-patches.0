Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F070A129EFB;
	Mon, 18 Dec 2023 14:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A7KwxC5N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 722A1C433C7;
	Mon, 18 Dec 2023 14:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908130;
	bh=99fAomIfgNQj0Gamyjbqsvf3pwwf59rukemDVPZMJYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A7KwxC5NbgDEn6P+dopn0wld10zc7oCVZHgErJD7+Puk4xJiRShV2bJFBGptKNFLB
	 O1l1zOXumeKO8y8MWe4QNGlCYibGr6RfqGbNdawrcCaWyPrDMMDYdel69WRtbE49l5
	 qd7hG/Q+H44U7wAcsejSccv8lsDCF4Pnz7EiDuxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 065/166] io_uring/cmd: fix breakage in SOCKET_URING_OP_SIOC* implementation
Date: Mon, 18 Dec 2023 14:50:31 +0100
Message-ID: <20231218135107.954603070@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

From: Al Viro <viro@zeniv.linux.org.uk>

commit 1ba0e9d69b2000e95267c888cbfa91d823388d47 upstream.

	In 8e9fad0e70b7 "io_uring: Add io_uring command support for sockets"
you've got an include of asm-generic/ioctls.h done in io_uring/uring_cmd.c.
That had been done for the sake of this chunk -
+               ret = prot->ioctl(sk, SIOCINQ, &arg);
+               if (ret)
+                       return ret;
+               return arg;
+       case SOCKET_URING_OP_SIOCOUTQ:
+               ret = prot->ioctl(sk, SIOCOUTQ, &arg);

SIOC{IN,OUT}Q are defined to symbols (FIONREAD and TIOCOUTQ) that come from
ioctls.h, all right, but the values vary by the architecture.

FIONREAD is
	0x467F on mips
	0x4004667F on alpha, powerpc and sparc
	0x8004667F on sh and xtensa
	0x541B everywhere else
TIOCOUTQ is
	0x7472 on mips
	0x40047473 on alpha, powerpc and sparc
	0x80047473 on sh and xtensa
	0x5411 everywhere else

->ioctl() expects the same values it would've gotten from userland; all
places where we compare with SIOC{IN,OUT}Q are using asm/ioctls.h, so
they pick the correct values.  io_uring_cmd_sock(), OTOH, ends up
passing the default ones.

Fixes: 8e9fad0e70b7 ("io_uring: Add io_uring command support for sockets")
Cc:  <stable@vger.kernel.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Link: https://lore.kernel.org/r/20231214213408.GT1674809@ZenIV
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/uring_cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index acbc2924ecd2..7d3ef62e620a 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -7,7 +7,7 @@
 #include <linux/nospec.h>
 
 #include <uapi/linux/io_uring.h>
-#include <uapi/asm-generic/ioctls.h>
+#include <asm/ioctls.h>
 
 #include "io_uring.h"
 #include "rsrc.h"
-- 
2.43.0



