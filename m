Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B434C79E3;
	Tue,  5 Dec 2023 03:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BJOLi8TU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BF4FC433C7;
	Tue,  5 Dec 2023 03:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747067;
	bh=NGQB15MsnfF4bHitRYXsPWMYh8+Gvtb5rLt7jIuUSlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BJOLi8TUqRGxBcdLlzSGk5FoCgC5Hog5sMvJrwk5vMrQnGdRBCOET5Ta23w5JLX62
	 ZymZmRnXvgxgyUIpMIMIf4n7dhR5KOVZvaRtE8tCul/ON73/3MY3X5jyUZXf3jTOFD
	 dWJVY0z4y81WQi3D6m5gcRMd6nonT/C59I2rqzrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	David Sterba <dsterba@suse.com>,
	syzbot+12e098239d20385264d3@syzkaller.appspotmail.com
Subject: [PATCH 6.1 047/107] btrfs: send: ensure send_fd is writable
Date: Tue,  5 Dec 2023 12:16:22 +0900
Message-ID: <20231205031534.268872468@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031531.426872356@linuxfoundation.org>
References: <20231205031531.426872356@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

commit 0ac1d13a55eb37d398b63e6ff6db4a09a2c9128c upstream.

kernel_write() requires the caller to ensure that the file is writable.
Let's do that directly after looking up the ->send_fd.

We don't need a separate bailout path because the "out" path already
does fput() if ->send_filp is non-NULL.

This has no security impact for two reasons:

 - the ioctl requires CAP_SYS_ADMIN
 - __kernel_write() bails out on read-only files - but only since 5.8,
   see commit a01ac27be472 ("fs: check FMODE_WRITE in __kernel_write")

Reported-and-tested-by: syzbot+12e098239d20385264d3@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=12e098239d20385264d3
Fixes: 31db9f7c23fb ("Btrfs: introduce BTRFS_IOC_SEND for btrfs send/receive")
CC: stable@vger.kernel.org # 4.14+
Signed-off-by: Jann Horn <jannh@google.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/send.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -7885,7 +7885,7 @@ long btrfs_ioctl_send(struct inode *inod
 	}
 
 	sctx->send_filp = fget(arg->send_fd);
-	if (!sctx->send_filp) {
+	if (!sctx->send_filp || !(sctx->send_filp->f_mode & FMODE_WRITE)) {
 		ret = -EBADF;
 		goto out;
 	}


