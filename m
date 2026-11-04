Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827081;
	b=xeRpCGPx/tm5Rr/G6yXgV8BYm91axrwsU/dtxTHeUhD5kEZQ1iLA5Hm3G21Z0bk+HGcT
	 saYDPtllKNCN1X8BCjj5BX42+4r+f8LZxodA1XO8N0qABFOY+G04cAmI75YP9iY5PDrnc
	 nbcJ06zW87BIjQ9XrxUArftQzm7k1FdFd/eG1FLolufaj4IMImRggcF5VC6fSiUEJnynP
	 6GMmLMoXDe4sjLNIpsiHrpx8B9Dpo88bQ9W2q93nXsW/RuK8AXvsaSK/62by/jfixE8Dn
	 opjrQXy1oUbuAuUwYnxoV1ZS8a66S+5yl+fc567c2hby2wqL4SGbYWGZNn9nJH0lwxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827081;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I5j6hg7s7myEwYqWJX1YWzKO4nWmCVCJ9UjqiKcTpnA=;
	b=z2JDt/sXRtetSd1+KwJOJjIpX90nFEk0Bk6Xo5t6zobNKdU3g2GDMC4O4fzf34MTk4Qw
	 /IMxWEH7P/3fkVXQYDcJMiq/0/lt+3rapaePgtPRbWIqYTQtOkBQik0reyan5DnOUOhIA
	 QOMpKFfqhisxiBF+ssz1ZauSXl9fWTvFrnwt42rSXM030yvT+Kr0EAkbBc68SqSA6bwqZ
	 dhnK6WUoowZ4ZNALCO0rzLULBvXqQa64S9We7rCKAGCl2qxOEL5Pk7RCXDUp3D3wzah2p
	 SmXufogsVp8QcNwEkeA/8dnggHLWc4zHlwzvMIZP3uHO4v2tMdgaMgxQMIfqjkM/NqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YXpodCTC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221A6606A86D;
	Wed,  4 Nov 2026 21:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YXpodCTC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B13C11F000C1;
	Wed,  4 Nov 2026 21:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827081;
	bh=I5j6hg7s7myEwYqWJX1YWzKO4nWmCVCJ9UjqiKcTpnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YXpodCTC91AVcA2BZgDq+Tv0r7IYC6yoJUD+3tfK+thwL2GQOUH01Jm2XEAvSHlwi
	 MXNJzWsOaV2GkJeKv4Be+MnniSywqd194P4+K2H2MpatEL4kAg03VTOc66KP9Q2q5L
	 RGR+FoaWraWViKrvs3VT6X3b1jmTAArS1CXeAciw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 7.3 144/547] smb: client: fix use-after-free in cifs_ses_add_channel()
Date: Wed,  4 Nov 2026 16:05:28 -0500
Message-ID: <20261104211042.262030152@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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
@@ -626,12 +626,13 @@ cifs_ses_add_channel(struct cifs_ses *se
 
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
@@ -639,6 +640,7 @@ out:
 		 */
 		WARN_ON(ses->chan_count < 1);
 		spin_unlock(&ses->chan_lock);
+		cifs_put_tcp_session(pserver, 0);
 	}
 
 	kfree(ctx->UNC);


