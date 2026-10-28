Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213041;
	b=halpqY/Qa7qyuOMoniYysSNwsj+rdMGVxDindiLxFp9KZs69mIgesdSLF6CKp9Vhceaz
	 alakZljm/V01Fid0H6tw98HkZWMSpDK/c+35FHIgWRvG3cd7rP/nyvslkNQPJhNMm67RC
	 yqIw+GTdRS77BJqnI6VEvusJSs0UtXZ8/hv5ahnfTItpbnRBhMlyfR3NQdc5DNA/Sefv2
	 MmY3vPes1cCuZIecue2m01ksQwCErVIfeEN+K8gM//oYxKC3NjB4tc65hf5aYOhMJ6nJA
	 XL6hJ8D8YfYqS/1+P/nXqJ3ftELPOURxQf9fzEbz+oLUiL25IqO0SM3GIrUcoEkDmSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213041;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N5+xSZmTmj3rc4nZloWKIvOqLcrD90kRI3yEloZ7KaA=;
	b=VZT/vGQjKDgzxwxB2xpUujW5/mEnnVKDYEue4fKrWhGOPh6Iu0XTrbslM1aVXe7PTheU
	 pVCnR46bx+yTIS9bCgYKLv4cXLBx57o12ipZYmw17ccPlBCTQuY1eaovYfyiSYKo7Y6O9
	 WcTUD4jxf5EbjmMSIp0/XkvmT51ECWv2WPg25NqHP1AWqg+LyIaQYauRHTWvmkSxahF1m
	 e+kyDgMX+cOmreD3sNa1OzmWxitecxHFpDeghc1VaYmVYJmvEZb1mmb4IV0Swgwgwo2Wv
	 EImNFoFoIgnlXYHKMVq8cZxyPSSGf0NlZR29EccvkL599l4g2HiMB4dKFuvNjo2pzjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=roRfcg5s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B17D606A31A;
	Wed, 28 Oct 2026 18:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=roRfcg5s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD7E31F01825;
	Wed, 28 Oct 2026 18:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213041;
	bh=N5+xSZmTmj3rc4nZloWKIvOqLcrD90kRI3yEloZ7KaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=roRfcg5s+wnzuqP12aiwqka0iWqUoiA2O7PnfV1BKD/bgrbPFmYmYAMTek+Uywn2E
	 pBpYy6yh7fDmvfDihZf5YCWHSuV05Y6PQvETIZMQBD8d7iBxaV3L6QoQWooZHcxBcE
	 K2V74lUZB2rsF6MNko3MlFAyMhj30TzP3CuJkvi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingyu Jin <xingyuj@google.com>,
	Neill Kapron <nkapron@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0366/1887] usb: gadget: f_fs: Fix Use-After-Free in AIO error path
Date: Wed, 28 Oct 2026 17:41:02 +0100
Message-ID: <20261028170507.563285843@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neill Kapron <nkapron@google.com>

[ Upstream commit e78dcb1f7ec271449c54984dc90c62a5ba272de7 ]

In ffs_epfile_write_iter() and ffs_epfile_read_iter(), when ffs_epfile_io()
fails with an error other than -EIOCBQUEUED, the io_data structure (`p`) is
freed. However, for AIO operations, the kiocb cancel function was already
armed and kiocb->private was set to `p`.

If a concurrent cancel operation (such as sys_io_cancel()) executes after
ffs_epfile_io() fails but before the function frees `p`, a Use-After-Free
can occur when the cancellation handler accesses the freed pointer.

To securely fix this race condition, we must properly un-arm the
cancellation. Invoking `kiocb->ki_complete()` does exactly this by
acquiring `ctx->ctx_lock` and safely removing the kiocb from the active
sequence. In doing so, it ensures that a parallel io_cancel can no longer
discover the kiocb, effectively closing the race window.

We then return -EIOCBQUEUED to notify the VFS layer that the kiocb has been
consumed and it should avoid attempting to complete the request again or
triggering subsequent completion handlers.

Fixes: de2080d41b5d ("gadget/function/f_fs.c: close leaks")
Cc: stable@vger.kernel.org
Reported-by: Xingyu Jin <xingyuj@google.com>
Assisted-by: Antigravity:gemini-3.1-pro
Signed-off-by: Neill Kapron <nkapron@google.com>
Link: https://patch.msgid.link/20260724235100.106011-1-nkapron@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_fs.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1244,8 +1244,10 @@ static ssize_t ffs_epfile_write_iter(str
 	if (res == -EIOCBQUEUED)
 		return res;
 	if (p->aio) {
+		kiocb->ki_complete(kiocb, res);
 		mmdrop(p->mm);
 		kfree(p);
+		return -EIOCBQUEUED;
 	} else {
 		*from = p->data;
 	}
@@ -1295,9 +1297,11 @@ static ssize_t ffs_epfile_read_iter(stru
 		return res;
 
 	if (p->aio) {
+		kiocb->ki_complete(kiocb, res);
 		mmdrop(p->mm);
 		kfree(p->to_free);
 		kfree(p);
+		return -EIOCBQUEUED;
 	} else {
 		*to = p->data;
 	}


