Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE8D737888;
	Mon, 18 Dec 2023 14:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A1Dd91PE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5088BC433C8;
	Mon, 18 Dec 2023 14:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908574;
	bh=va7HNli8k/oOFrgKty+EEZ40BqXlHHt3xvDsEG5wl+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A1Dd91PEgslvJHfhHQRRgRgeG5qopEo8ZX1v+DHYk3aw0pzu9tttTBEs7Bnoc4g7W
	 r3akW+Eq9fDKRPM/M+f81S6nxGOG3PAU/xcrm+OzS6A/GNU9cow65Mx5LAObIj0ynR
	 oAkkhodC5zZbBxLfxi0DjOOndjI6T1OdgaFc3FLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mazin Al Haddad <mazinalhaddad05@gmail.com>,
	Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>,
	syzbot+e3563f0c94e188366dbb@syzkaller.appspotmail.com
Subject: [PATCH 5.10 60/62] tty: n_gsm: add sanity check for gsm->receive in gsm_receive_buf()
Date: Mon, 18 Dec 2023 14:52:24 +0100
Message-ID: <20231218135048.826699791@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135046.178317233@linuxfoundation.org>
References: <20231218135046.178317233@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mazin Al Haddad <mazinalhaddad05@gmail.com>

commit f16c6d2e58a4c2b972efcf9eb12390ee0ba3befb upstream

A null pointer dereference can happen when attempting to access the
"gsm->receive()" function in gsmld_receive_buf(). Currently, the code
assumes that gsm->receive is only called after MUX activation.
Since the gsmld_receive_buf() function can be accessed without the need to
initialize the MUX, the gsm->receive() function will not be set and a
NULL pointer dereference will occur.

Fix this by avoiding the call to "gsm->receive()" in case the function is
not initialized by adding a sanity check.

Call Trace:
 <TASK>
 gsmld_receive_buf+0x1c2/0x2f0 drivers/tty/n_gsm.c:2861
 tiocsti drivers/tty/tty_io.c:2293 [inline]
 tty_ioctl+0xa75/0x15d0 drivers/tty/tty_io.c:2692
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl fs/ioctl.c:856 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Link: https://syzkaller.appspot.com/bug?id=bdf035c61447f8c6e0e6920315d577cb5cc35ac5
Fixes: 01aecd917114 ("tty: n_gsm: fix tty registration before control channel open")
Reported-and-tested-by: syzbot+e3563f0c94e188366dbb@syzkaller.appspotmail.com
Signed-off-by: Mazin Al Haddad <mazinalhaddad05@gmail.com>
Link: https://lore.kernel.org/r/20220814015211.84180-1-mazinalhaddad05@gmail.com
Signed-off-by: Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/n_gsm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2588,7 +2588,8 @@ static void gsmld_receive_buf(struct tty
 			flags = *fp++;
 		switch (flags) {
 		case TTY_NORMAL:
-			gsm->receive(gsm, *cp);
+			if (gsm->receive)
+				gsm->receive(gsm, *cp);
 			break;
 		case TTY_OVERRUN:
 		case TTY_BREAK:


