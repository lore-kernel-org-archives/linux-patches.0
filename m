Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A619CA43;
	Tue,  5 Dec 2023 03:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ZRBADce"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6824C433C7;
	Tue,  5 Dec 2023 03:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747662;
	bh=e+B5pFBIfIIliSXHoyXOS4rLLZQDvK0LG1SwZ0TgNrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ZRBADceqvkrYxYQi4Ayx+mkUZI3ml648foTiBwurKzf0gffNxinFcIMEKUM7Pb/x
	 REzF6/jxJ5D90tG+ratUwyl5wbb+5BKpQ2ME+m6Epx4kKrCzdyZaQMVTqQdrCBU7SV
	 CJGuH1iMVOs0Der6JVCZOYFMH/068ku4u4qGbw+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	David Sterba <dsterba@suse.com>,
	syzbot+12e098239d20385264d3@syzkaller.appspotmail.com
Subject: [PATCH 5.15 22/67] btrfs: send: ensure send_fd is writable
Date: Tue,  5 Dec 2023 12:17:07 +0900
Message-ID: <20231205031521.061998850@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031519.853779502@linuxfoundation.org>
References: <20231205031519.853779502@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -7576,7 +7576,7 @@ long btrfs_ioctl_send(struct file *mnt_f
 	sctx->flags = arg->flags;
 
 	sctx->send_filp = fget(arg->send_fd);
-	if (!sctx->send_filp) {
+	if (!sctx->send_filp || !(sctx->send_filp->f_mode & FMODE_WRITE)) {
 		ret = -EBADF;
 		goto out;
 	}


