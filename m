Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585257;
	b=U4mks5BeZW6ADXQPnj8Q/xaukLqVsT/9t1rZGEJCDRnV0f6xmX/rg+1As9n96TBzg8Ak
	 MgTviO/jf5T6UD9XQF3rKhuVDiRVq846CdBAkduuMXwz137Ctdq3TfCrY7MzMSAf9F+dq
	 IW0slBHVW4uJR+BipeYhYZIDciCkgWz2xqtCdo93o6QpjY4uzl30uiKHcMQoAWTxpSW6E
	 lLJnvaFPbXT7OXbbNmPTIlFdl0/fp2Cg6/MhiKCcv4eRbZPJ/8v0Y1zwrjaxiL3lWGNAT
	 kvZ2l4vshogda6SrdRXejbh/AjGPKfPfKDh2l9K3dBhAYc4MTLmSDGrWV6GFAjnKXUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585257;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eV4CmRS54FtiUQOeoOh9wgLvhW4QDSuO+lHDouHuKRg=;
	b=zb/XdQ4bF8yuBCM6UrDErC5jEo4oQ1XalNDy3rHvRSnj98E3kTjU6qJNtrTnrOCZXcff
	 YFsKXSMUhG4aTlFktJnw/OfSBeJpxZ5jvZXvP0+/8u5acPu6cjPdJCMD2LcNZzej93Hrs
	 dkcG9dLegh5coAC9izh2PtrIVdQ1ecLS5/+lDsrQn3cpcz6fhDOOL055U6fouo7J/W/4H
	 /8yCzhQ1dxxjDK1PXWkrMTyvuqWmpyoZ5z9fiViQBlBdBoQIW8ajIIwlIPrlzMIe3qKzP
	 Nxo2FJxz7vxdT7OU4ME8NoNazsUi63Ijk2Yd6dYDmHI6yraj4juiIf2hP2w/MR1j29A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UP+yabVl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A91E2606A330;
	Fri, 13 Nov 2026 15:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UP+yabVl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5517A1F000C4;
	Fri, 13 Nov 2026 15:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585257;
	bh=eV4CmRS54FtiUQOeoOh9wgLvhW4QDSuO+lHDouHuKRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UP+yabVljZa+iC4AeME0ve1Bkac2IKsCdVYNWSAjo05rJfYjJ3+bS12A3qJtUSVuo
	 c3k1EukVfG+57AZYo3eGZpqjAojkZHblbnG8xZHjIFwl/XYlHP+nthX9FcLEWH2CRh
	 jpoaP+D1CoeQxXLdFSgapWjXFjejR7BxRwYZ06Qc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 004/686] backing-file: always end a queued write
Date: Fri, 13 Nov 2026 10:42:17 -0500
Message-ID: <20261113153821.079418643@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <mason@kernel.org>

commit 627cdcbc2a2eceb0452078a0c14370f9f1f17a91 upstream.

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
index bf526fa2e29df..ed8e793564c36 100644
--- a/fs/backing-file.c
+++ b/fs/backing-file.c
@@ -106,6 +106,7 @@ struct backing_aio {
 	refcount_t ref;
 	struct kiocb *orig_iocb;
 	/* used for aio completion */
+	bool is_write;
 	void (*end_write)(struct kiocb *iocb, ssize_t);
 	struct work_struct work;
 	long res;
@@ -146,7 +147,8 @@ static void backing_aio_rw_complete(struct kiocb *iocb, long res)
 	struct backing_aio *aio = container_of(iocb, struct backing_aio, iocb);
 	struct kiocb *orig_iocb = aio->orig_iocb;
 
-	if (iocb->ki_flags & IOCB_WRITE)
+	/* Pairs with kiocb_start_write() in vfs_iocb_iter_write() */
+	if (aio->is_write)
 		kiocb_end_write(iocb);
 
 	backing_aio_cleanup(aio, res);
@@ -287,6 +289,7 @@ ssize_t backing_file_write_iter(struct file *file, struct iov_iter *iter,
 			goto out;
 
 		aio->orig_iocb = iocb;
+		aio->is_write = true;
 		aio->end_write = ctx->end_write;
 		kiocb_clone(&aio->iocb, iocb, get_file(file));
 		aio->iocb.ki_flags = flags;
-- 
2.53.0



