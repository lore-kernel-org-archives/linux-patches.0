Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773985;
	b=s4pOd7QkJRYzg5UWjtFumoSzXvTa7QlPBrMR+kI9CamVc9gxFhp0KtlOuzmWhUMAfDM3
	 kNIPUS+ujON5OrVqIri7As6LmX30w54BbTvmbJQEKlLFM3sjVTU8FDHCXwqqDm/5kuTi8
	 ZKzVNi+WzLKYYSYztIU1T3Obv+x/37IHlKh/Ev8du3vqBbSvPxU9eXf0rkhL1+4MnNkw/
	 LG/Obn+2B/9njhn+uhB7co4iUnYOifBaKSA2DfV3CXabfGgQLyrGgEJhthPY+W9BgQuw0
	 AZ1W07HgsBtmC9nP9WofNo0CipsoCJfkcrY2rqI3oZZylA2TRe/MtmhMoYoHor3zxMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773985;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NWmqOswqMZF++VNuODD05e1aIvNjLVxmdzwDlYKMRPM=;
	b=zpZYxLNqmTwtVs19Tqvq2y60AjbhnYJ69gyQJEFuCVN8kRr5ciEG78N2JDAST/JAaFbH
	 jJLAbKd4grrebukHI0hUX/VRU3XR99CEdYRqjh/kGCyjhEcYpckpYNZ0+Z4b7Ww2OsIj5
	 QXg/Jf8OiqzPatv6mUoWcxxJmLVjxSY2k6wlEQ1AbFmp8IG0W6ON8yJF7eaX3DvYkMEYk
	 Q0S2Pw252OThH1cjBE7jWb6FOYBwJnPS3xpqN8EcLcl2DuQOhpleroiG2DtsyFE6XcTBP
	 eG0XJop2bs0wgtkNuTM/HIO5kLo73jAElgO8U1hAmEJtFr/fPj7P/gT+qLiwIrQRu4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mZQwPbYm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B98606A31D;
	Fri, 23 Oct 2026 16:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mZQwPbYm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0CFC1F01825;
	Fri, 23 Oct 2026 16:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773985;
	bh=NWmqOswqMZF++VNuODD05e1aIvNjLVxmdzwDlYKMRPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mZQwPbYmKM72G9ewQKeMjFOLq0CilPhjO1h1pdTZaV4yQb5lr5Six4A/rCw791l0c
	 7AUjBHPdxBHpw0MuAull3M6NQGrdnp3SCgNm4GRTSYXeekRYTirXTZWQ1LTh9sxCMt
	 7ab6gGYvajFDhuA27djbeKAAvwZrBginpEy2uXtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 055/193] pipe: preserve existing fasync readers on writer setup failure
Date: Fri, 23 Oct 2026 18:35:32 +0200
Message-ID: <20261023163715.507313789@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit 40bb03d3ea6f6a915218508819ecc4d7a7fa260d ]

F_SETFL and FIOASYNC decide whether to invoke ->fasync() before
pipe_fasync() takes pipe->mutex. Two enables of one O_RDWR FIFO can
therefore both enter the callback.

fasync_helper() allocates before checking for an existing entry. If the
first enable installs both entries, a second enable can update the
reader entry and then fail the allocation for the writer entry. The
error path removes the pre-existing reader entry, clearing FASYNC while
the writer entry remains registered. __fput() then skips ->fasync(), so a
later pipe notification can dereference the freed file or its f_owner.
An unprivileged memory-pressure reproducer triggers a KASAN
slab-use-after-free in send_sigio() through this path.

Keep the reader helper's result and undo the registration only if this
call added it. The pipe mutex serializes changes to both lists, so a
failed new registration still removes its reader, while a failed
duplicate preserves the existing registrations and FASYNC. Successful
duplicate enables continue to update fa_fd as before.

Fixes: 76398425bb06 ("Move FASYNC bit handling to f_op->fasync()")
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pipe.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index 42fead1efe520..ec1742bad3e79 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -755,9 +755,11 @@ pipe_fasync(int fd, struct file *filp, int on)
 	if (filp->f_mode & FMODE_READ)
 		retval = fasync_helper(fd, filp, on, &pipe->fasync_readers);
 	if ((filp->f_mode & FMODE_WRITE) && retval >= 0) {
+		int read_ret = retval;
+
 		retval = fasync_helper(fd, filp, on, &pipe->fasync_writers);
-		if (retval < 0 && (filp->f_mode & FMODE_READ))
-			/* this can happen only if on == T */
+		/* Undo only a reader entry added by this call. */
+		if (retval < 0 && read_ret > 0)
 			fasync_helper(-1, filp, 0, &pipe->fasync_readers);
 	}
 	mutex_unlock(&pipe->mutex);
-- 
2.53.0



