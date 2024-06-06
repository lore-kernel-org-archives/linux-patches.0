Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A3A196C8D;
	Thu,  6 Jun 2024 14:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682950; cv=none; b=dqqZmEgJ9DaOKjPnp7yXMgbUXchD9KsF0MOBSQ5udFQ6KtmwYAILhPO7tvLcFOeOotSRlmpkGJWMyf0vMrbcYQoGTQH3VJup9KN7MPEJHcrJY1QgUUus5jSE9Ucd8Q5ErlvdChnl2zqqW71KyxP2sfK4IrccG2HWkNtoYDV55GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682950; c=relaxed/simple;
	bh=zFPWwVjlS7jWIcYTpbo6tod+ebIUaaW74tZ+5Q3Huus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CdTfrLrB52uh7l3BCSTVHE1LDqZKwqMIfuV11Ic1aaEL56aEwkD6lHcjlL+nuGKBTz9iUlbTW2WxzjAk8Gok3AQXW9/LW7071HcyZ5PhMbTLZVdfZe5Cu+Yv/3BuuFrk/4L78QufdSTkA9N+V95iAbnym0tSFY8vCSdoXVFrSkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PPLqnIn4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PPLqnIn4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0984DC2BD10;
	Thu,  6 Jun 2024 14:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682950;
	bh=zFPWwVjlS7jWIcYTpbo6tod+ebIUaaW74tZ+5Q3Huus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PPLqnIn4Fpx7/5Wp1FMKFYanWV2RV+7TbnjuzocwW/sdzPpG82730qS+V+cZ0IVDW
	 k6mO12nnoDIXJupt16+JuxTUz5BdmeaS/h0jw9TR++61hdN/vRrtQa+cRnL/O4cOzz
	 UUsnuzSbqjB2KYY2neTe4btQ1iduNuqa0nQX/Bh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miklos Szeredi <mszeredi@redhat.com>,
	xingwei lee <xrivendell7@gmail.com>,
	yue sun <samsun1006219@gmail.com>,
	Hou Tao <houtao1@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 113/374] fuse: clear FR_SENT when re-adding requests into pending list
Date: Thu,  6 Jun 2024 16:01:32 +0200
Message-ID: <20240606131655.717047985@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit 246014876d782bbf2e652267482cd2e799fb5fcd ]

The following warning was reported by lee bruce:

  ------------[ cut here ]------------
  WARNING: CPU: 0 PID: 8264 at fs/fuse/dev.c:300
  fuse_request_end+0x685/0x7e0 fs/fuse/dev.c:300
  Modules linked in:
  CPU: 0 PID: 8264 Comm: ab2 Not tainted 6.9.0-rc7
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)
  RIP: 0010:fuse_request_end+0x685/0x7e0 fs/fuse/dev.c:300
  ......
  Call Trace:
  <TASK>
  fuse_dev_do_read.constprop.0+0xd36/0x1dd0 fs/fuse/dev.c:1334
  fuse_dev_read+0x166/0x200 fs/fuse/dev.c:1367
  call_read_iter include/linux/fs.h:2104 [inline]
  new_sync_read fs/read_write.c:395 [inline]
  vfs_read+0x85b/0xba0 fs/read_write.c:476
  ksys_read+0x12f/0x260 fs/read_write.c:619
  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
  do_syscall_64+0xce/0x260 arch/x86/entry/common.c:83
  entry_SYSCALL_64_after_hwframe+0x77/0x7f
  ......
  </TASK>

The warning is due to the FUSE_NOTIFY_RESEND notify sent by the write()
syscall in the reproducer program and it happens as follows:

(1) calls fuse_dev_read() to read the INIT request
The read succeeds. During the read, bit FR_SENT will be set on the
request.
(2) calls fuse_dev_write() to send an USE_NOTIFY_RESEND notify
The resend notify will resend all processing requests, so the INIT
request is moved from processing list to pending list again.
(3) calls fuse_dev_read() with an invalid output address
fuse_dev_read() will try to copy the same INIT request to the output
address, but it will fail due to the invalid address, so the INIT
request is ended and triggers the warning in fuse_request_end().

Fix it by clearing FR_SENT when re-adding requests into pending list.

Acked-by: Miklos Szeredi <mszeredi@redhat.com>
Reported-by: xingwei lee <xrivendell7@gmail.com>
Reported-by: yue sun <samsun1006219@gmail.com>
Closes: https://lore.kernel.org/linux-fsdevel/58f13e47-4765-fce4-daf4-dffcc5ae2330@huaweicloud.com/T/#m091614e5ea2af403b259e7cea6a49e51b9ee07a7
Fixes: 760eac73f9f6 ("fuse: Introduce a new notification type for resend pending requests")
Signed-off-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 8eb2ce7c0b012..9eb191b5c4de1 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1814,6 +1814,7 @@ static void fuse_resend(struct fuse_conn *fc)
 
 	list_for_each_entry_safe(req, next, &to_queue, list) {
 		set_bit(FR_PENDING, &req->flags);
+		clear_bit(FR_SENT, &req->flags);
 		/* mark the request as resend request */
 		req->in.h.unique |= FUSE_UNIQUE_RESEND;
 	}
-- 
2.43.0



