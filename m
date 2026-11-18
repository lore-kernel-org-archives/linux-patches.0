Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035049;
	b=XGzBOUquBdhlR/iga2ngdv0gJfbJIor6wqiqlz4BlErHZ18zSEGqhl7YZjI6fuWWx6la
	 GUkwjbLPCg8tUAqiF9TlAnsOJtrMMtUBKbU9pkfSNLWLIThf3XL7tYpewZ9J3AO9DI0gJ
	 kaPonJ+mjCWPQoZgYd6eQHnzBCyceKySIG+PWGZjzs6xr7jGhyqWnRoY5EWSBOa/Xfcly
	 s6p6ovfC+pqbfFdGD6a72ZVij4d+onj/F1xx3ApQ2fKrng02NTbqE4GZjIyIyk+nh4DNn
	 7+fbcu9zfV9YuB0kr7OqthhaVg/6Qmgz5eBbVEM3UByp/IiY1mP5Y4s4Zxk9rgHcwFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035049;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ctdx+gesRepzJD27IQqv1tZI3fVd7tud7pBItQWfxvs=;
	b=zgzrnleaBSG/8NWkvgZbw4ldodTU9WXN9mQB7xOxf9cHWCb3yrjGavtKLYjwozZ/rMRE
	 q7QtrM2ssF5dK15utOX28pDA5TnMHI3MtmVO7IJDy95L/qBy5VkxOtEXw1T4uqsu00c/v
	 5FNtjcmMHM4hgPmDrDqAMqUEzcRiRsZ6Yab67x0tBsza3xWgG6HLV//9eghCmqoNjYejB
	 5Bvng//3hW1B1tzH3sdqwYKzrt9tUsUBKyC+ERPlCWUsa1N0fJ/qvl9HC0sKJ/YInCiRn
	 7irhIrB87pzRherVfq/pJFNkKlcKLoD8oY3Ze+ixnztJKIoDdGfcFEPIuts9m5wk31Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H0k3wXfZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243EB606A31C;
	Wed, 18 Nov 2026 20:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H0k3wXfZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72D601F000C4;
	Wed, 18 Nov 2026 20:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035049;
	bh=ctdx+gesRepzJD27IQqv1tZI3fVd7tud7pBItQWfxvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H0k3wXfZjel8RLi2XFTLfMnr3y+MWQqkPFcyFLshT44UsmfN+RTtwildCAlBqlTMo
	 apRUooiuXiuJegxPHYC+25QW2Gn7HSDcbJTqNwmcsBgE7K4AVdMd/7tKRC0BPZMP0c
	 jXJxNBf4hpR8bDmlhVZx0jhD3ZdO7Lfn3RL482Ws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.6 0585/3318] smb: client: fix use-after-free in cifs_ses_add_channel()
Date: Wed, 18 Nov 2026 15:20:07 +0100
Message-ID: <20261118150335.103418843@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henry Martin <bsdhenrymartin@gmail.com>

commit 031278577380e7875d95aed81a2b2bcac39be923 upstream.

The error path of cifs_ses_add_channel() calls cifs_put_tcp_session()
before cifs_chan_clear_need_reconnect().  The latter reaches
cifs_ses_get_chan_index(), which dereferences server->terminate; if
the put was the final reference, TCP_Server_Info is already freed and
this is a use-after-free.  Same put-then-use pattern as the recently
fixed sibling in commit 717e0a25036b ("cifs: Fix server use-after-free
in cifs_chan_skip_or_disable()").

Move the put last, but do not read chan->server after dropping
chan_lock: chan points into ses->chans[], and once chan_count is
decremented a concurrent add_channel can reuse the slot and overwrite
the pointer, so the put would act on the new channel's server.  Cache
the pointer under chan_lock, clear the reconnect bit and decrement
chan_count while still holding the reference, and release it after
the unlock.

This issue was discovered by Tencent CodeBuddy Security.

Fixes: ee1d21794e55a ("cifs: handle when server stops supporting multichannel")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
Cc: stable@vger.kernel.org
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/sess.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -673,12 +673,13 @@ cifs_ses_add_channel(struct cifs_ses *se
 
 out:
 	if (rc && chan->server) {
-		cifs_put_tcp_session(chan->server, 0);
+		struct TCP_Server_Info *pserver;
 
 		spin_lock(&ses->chan_lock);
+		pserver = chan->server;
 
 		/* we rely on all bits beyond chan_count to be clear */
-		cifs_chan_clear_need_reconnect(ses, chan->server);
+		cifs_chan_clear_need_reconnect(ses, pserver);
 		ses->chan_count--;
 		/*
 		 * chan_count should never reach 0 as at least the primary
@@ -686,6 +687,7 @@ out:
 		 */
 		WARN_ON(ses->chan_count < 1);
 		spin_unlock(&ses->chan_lock);
+		cifs_put_tcp_session(pserver, 0);
 	}
 
 	kfree(ctx->UNC);


