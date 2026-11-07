Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065606;
	b=uIXXQCZYyVmvJr0+ZZNU1meLeyi4QfY5e7cc5cRKN/jnVV/chy0BkxTLTaX1ar/gcO6Y
	 YR0wHAL7ueG4dGZ4KGUepo2/YM+XzBceDKBJ/kyoYuZAtVRMJqBogtnQ4vBqNWflLtH5b
	 yS4qrthoI2BSawtn7ulQG5CqvolKwTD+Izp4c3sqD1AJl1vTm1IPuXXLlJvyDb0OJFLFl
	 WS50LE5R2Pudn4Jogm4plcb1BLtGKnZCI1PMSGLTWVsWDuQw3Tat59mKQso1BeZYVhvTF
	 urmuBbXa4RjET8cpy8JKZE91Ug5UBctDxqMNK40P7Bfa7MOmMNvqMXwimHdkt0mP4mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065606;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nkLV0j2/2ibUcVqdZZlZnTUEtwJkeR+9+dMi4dtImaE=;
	b=HL/IWAUyVieuTRghIwA3fKKDWJYZLevPuto0XSjsovP5wgyYEwIfuKmVaJTlT8/1vy/z
	 sSHeE/Hd/Ba4W3fVfsw7o5CluCM3qBRR3Oy0deAwqxtkfuVvqEpGxH/rBeUAK3L9i1beC
	 DuyXLb8TKgOZ3qQuLQ2eNb/BPzUfWbO88IcDUS2yV+310suWugzl3P1B/akrJjneFNGqr
	 GSYpQEI+t+AQSDigJ3Uco4QNYdg/1CIP565vfjReiITAXH5eZMWsADWULcePEQ4iVYlM4
	 n4pRV4EzEudatun5/+ahKxeDDS7cWN/PZTq8jbO98nx7FKtyw3hh1rsSLwm0b6MyjxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S77FNTH8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32761606A32C;
	Sat,  7 Nov 2026 15:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S77FNTH8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D68D61F0089F;
	Sat,  7 Nov 2026 15:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065606;
	bh=nkLV0j2/2ibUcVqdZZlZnTUEtwJkeR+9+dMi4dtImaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S77FNTH8dC+SG2YspyKmAK6fmX0vVzF+nG0tS+F6TtdHYAVd9X3rXnHaQkvnjoUsI
	 KGX3jE1P7MNBJ4+FETI62Euh1rz2NUiaWbUVEs4EZy9/rOnl42uJ6YAn47y20WjcqN
	 XHoJQRypsygT8VCTBppVJRGFBRv+dVM5cTjkCcwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1248/1257] backing-file: always end a queued write
Date: Sat,  7 Nov 2026 08:59:04 -0500
Message-ID: <20261107135013.791601989@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <mason@kernel.org>

[ Upstream commit 627cdcbc2a2eceb0452078a0c14370f9f1f17a91 ]

Writes to a loop device with direct I/O on an overlay file make the
next freeze of the upper filesystem hang for ever.

Every kiocb_start_write() needs a kiocb_end_write(). For a write that
is queued, vfs_iocb_iter_write() leaves the end to the completion, and
backing_aio_rw_complete() only calls kiocb_end_write() when IOCB_WRITE
is set in the flags copied from the submitter. In-kernel submitters
such as loop do not set that flag, so each queued write keeps the
freeze protection of the backing filesystem.

Direct writes to a loop device with direct I/O backed by an overlay
file left fsfreeze of the ext4 upper filesystem, and a later touch
there, blocked in D state. It takes write access to the node of the
loop device, which root has by default, to attach the file and to write.

The fix used here is to mark a write in struct backing_aio and to call
kiocb_end_write() on completion of every marked write.

Reproduced under qemu without KVM, on v7.3-rc6-21-g602042bf29f6 with
earlier fixes of this series applied, with and without this change,
once each. The kernel was not changed for the run. With this change
fsfreeze finished in about a second. Not run: the nvmet and LIO file
backends, which do not set IOCB_WRITE either, FUSE passthrough, and an
xfs upper filesystem.

Fixes: 2406a307ac7d ("ovl: implement async IO routines")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
[amir: use aio->is_write to explicitly mark a write aio]
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Link: https://patch.msgid.link/20261029180319.2852090-1-amir73il@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/backing-file.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/backing-file.c b/fs/backing-file.c
index 37253f2e3084f..83f0ba241fb0b 100644
--- a/fs/backing-file.c
+++ b/fs/backing-file.c
@@ -96,6 +96,7 @@ struct backing_aio {
 	refcount_t ref;
 	struct kiocb *orig_iocb;
 	/* used for aio completion */
+	bool is_write;
 	void (*end_write)(struct kiocb *iocb, ssize_t);
 	struct work_struct work;
 	long res;
@@ -136,7 +137,8 @@ static void backing_aio_rw_complete(struct kiocb *iocb, long res)
 	struct backing_aio *aio = container_of(iocb, struct backing_aio, iocb);
 	struct kiocb *orig_iocb = aio->orig_iocb;
 
-	if (iocb->ki_flags & IOCB_WRITE)
+	/* Pairs with kiocb_start_write() in vfs_iocb_iter_write() */
+	if (aio->is_write)
 		kiocb_end_write(iocb);
 
 	backing_aio_cleanup(aio, res);
@@ -251,6 +253,7 @@ static int do_backing_file_write_iter(struct file *file, struct iov_iter *iter,
 		return -ENOMEM;
 
 	aio->orig_iocb = iocb;
+	aio->is_write = true;
 	aio->end_write = end_write;
 	kiocb_clone(&aio->iocb, iocb, get_file(file));
 	aio->iocb.ki_flags = flags;
-- 
2.53.0



