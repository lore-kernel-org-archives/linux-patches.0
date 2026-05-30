Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E8C26C385;
	Sat, 30 May 2026 16:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159576; cv=none; b=gdJNiy0dRLs4RvyopGwISAmvx7pvdbQzYptXh1wm9pl509fUDUs1KX6uH0Ko4eBZmVsXNf6SXxMxXra22rpghTXRjqs/CJJgxIJrfCvZyiKJOduUPWjh4j2iarz55WRYylrAYmKelvlpZa5McOnWbf//Fre8Yd8u3HBQgniSQCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159576; c=relaxed/simple;
	bh=F7U2kWALLN9gOw65+5uQqrDiE98b03hgR4l8UU4RTuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DlL6UqySNKdzMIDeR6Ni8B8giAUDVEfJUZ2/fbpCTllHMJy1PfKzoYnw7Cf+o7r4IecbAICY8Fv1V+0ZIKgidwSXfXN8HKVe0OO51wRN1MVzG+pODfC9z+q0brzC79jjPy2tQr/C+PzBwiYNpaG4Z2fL29ekOBgXTAYIpu28gWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CP+kQKMO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CP+kQKMO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC8B1F00898;
	Sat, 30 May 2026 16:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780159575;
	bh=dadfFw4O9atwIs/IXqmrmxOTonsEuPgBzH0oFP3ga1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CP+kQKMOVSkmVps/SFJO5LlGmv4l2WTihQMl03fpUlrCNLZSn5GWR7UtAL0lRKZXZ
	 CPveCStKRJ/U/1F31n+PwQVZyGiMewFnFKM3rbiz1Ivm07cvHCX7sGu1icZhv/5t5Q
	 qbVt6hziKobOOgdKIPibj3QcgHTmoZNHf45vEShY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingzhe Zou <mingzhe.zou@easystack.cn>,
	Coly Li <colyli@fnnas.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 104/969] bcache: fix cached_dev.sb_bio use-after-free and crash
Date: Sat, 30 May 2026 17:53:48 +0200
Message-ID: <20260530160303.192985802@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Mingzhe Zou <mingzhe.zou@easystack.cn>

commit fec114a98b8735ee89c75216c45a78e28be0f128 upstream.

In our production environment, we have received multiple crash reports
regarding libceph, which have caught our attention:

```
[6888366.280350] Call Trace:
[6888366.280452]  blk_update_request+0x14e/0x370
[6888366.280561]  blk_mq_end_request+0x1a/0x130
[6888366.280671]  rbd_img_handle_request+0x1a0/0x1b0 [rbd]
[6888366.280792]  rbd_obj_handle_request+0x32/0x40 [rbd]
[6888366.280903]  __complete_request+0x22/0x70 [libceph]
[6888366.281032]  osd_dispatch+0x15e/0xb40 [libceph]
[6888366.281164]  ? inet_recvmsg+0x5b/0xd0
[6888366.281272]  ? ceph_tcp_recvmsg+0x6f/0xa0 [libceph]
[6888366.281405]  ceph_con_process_message+0x79/0x140 [libceph]
[6888366.281534]  ceph_con_v1_try_read+0x5d7/0xf30 [libceph]
[6888366.281661]  ceph_con_workfn+0x329/0x680 [libceph]
```

After analyzing the coredump file, we found that the address of
dc->sb_bio has been freed. We know that cached_dev is only freed when it
is stopped.

Since sb_bio is a part of struct cached_dev, rather than an alloc every
time.  If the device is stopped while writing to the superblock, the
released address will be accessed at endio.

This patch hopes to wait for sb_write to complete in cached_dev_free.

It should be noted that we analyzed the cause of the problem, then tell
all details to the QWEN and adopted the modifications it made.

Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
Fixes: cafe563591446 ("bcache: A block layer cache")
Cc: stable@vger.kernel.org # 3.10+
Signed-off-by: Coly Li <colyli@fnnas.com>
Link: https://patch.msgid.link/20260322134102.480107-1-colyli@fnnas.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/bcache/super.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1368,6 +1368,13 @@ static void cached_dev_free(struct closu
 
 	mutex_unlock(&bch_register_lock);
 
+	/*
+	 * Wait for any pending sb_write to complete before free.
+	 * The sb_bio is embedded in struct cached_dev, so we must
+	 * ensure no I/O is in progress.
+	 */
+	closure_sync(&dc->sb_write);
+
 	if (dc->sb_disk)
 		put_page(virt_to_page(dc->sb_disk));
 


