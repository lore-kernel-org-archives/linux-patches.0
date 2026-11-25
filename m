Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621009;
	b=1GsW3mM7olFdxp6xyXas7TKMzTDsoPMK6+Zq2mnvALFEx3ttP+Ro5un1FnwTHF33aCJq
	 XHBUlNMcGWu7ZPBym0+X6mE53bTJi2dwxThGGfAUKwpeeOHtKkvAqZg0NMx3FbmHxBg9k
	 FqKyZTGyJsSy9w0h4zI1M9iZ+F646FunLkqVggir+bAF+1Zo8axDi9GsCtVcPjSuczUqw
	 50No4L4G0I8I1IsIihG4g1g6TYUBTdVBuQKwJYVG5ptWznVecEss7zSDpP4WiV6KmgM8T
	 L+n+vlWZ3I/TXzJ1YIqP/icUp5OSWZolC/q1EWUj27QShi39LIDlvPK0NOEV9OG0z7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621009;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sBp1dzzhjMDsn6C9tbQdolBv2gTKJmq8Ypa16MKjg3U=;
	b=xb4UVuJ5UFy+SAEVP7TeyDxZnDzzDpWWnTNpKYv8T6YbVhIKEGkVBNIpLv6oWRCdUUWi
	 Cjm269kpO2OSe3+DCNyC/+1tD4yOFaORSqYPo6EFWd0fiNPXKrccTO9LyO8GqsG4kpkMb
	 mT/+aRs7nmX+UT2dyBfOybdFNI6FUiP8AMhO/YTzCzxra2tJVfEuaA6akWEq8zr+4wnlt
	 rrV5R52m5m8WAs9ht8vJPhyai4ZyzTvshpUhPdgjisS8AoQLF9UyD1oRJDb4p7a+PA5Ma
	 akILW/AYu3F0Mcs2WRl+l44EwSnPQJUiufNk52PEb+6GL2sBOgHIEMeGhbHC8RM2F+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FknDH4mQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4966606A683;
	Wed, 25 Nov 2026 15:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FknDH4mQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AB421F0089F;
	Wed, 25 Nov 2026 15:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621009;
	bh=sBp1dzzhjMDsn6C9tbQdolBv2gTKJmq8Ypa16MKjg3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FknDH4mQRe+SmBjidPOAUTlJSCnhVCwpubGSmC6tGaEQlLy3Ii0uM/4JqxvyNuU3y
	 nnmxX7kpOnCiybHACPsFViRQeqn+6ig/FR+c95kvTxRongy7xzO5Ybigq2MKxxeC1K
	 t4B+iR4M3jMU3dpu96aHCHSzzvPJNfysSDgam+v0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>,
	Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>,
	Ao Wang <wangao@seu.edu.cn>,
	Xuewei Feng <fengxw06@126.com>,
	Qi Li <qli01@tsinghua.edu.cn>,
	Ke Xu <xuke@tsinghua.edu.cn>,
	Michael Grzeschik <mgr@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 065/990] net/9p/usbg: Fix use-after-free on usb9pfs_clear_tx
Date: Wed, 25 Nov 2026 15:23:52 +0100
Message-ID: <20261125143823.610964927@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>

[ Upstream commit 5c69297356bf6d04d8222f52717c6c4aa73e5d2c ]

When p9_usbg_close() is called, it invokes usb9pfs_clear_tx() but does
not clear usb9pfs->client nor usb9pfs->in_req->context afterwards.
The 9p client core (p9_client_destroy) calls close() and then
kfree(clnt), so after p9_usbg_close returns the client struct is freed.

If the USB gadget is later disabled (e.g., host disconnect),
usb9pfs_disable calls usb9pfs_clear_tx again, which passes the dangling
usb9pfs->client pointer to p9_client_cb. Inside p9_client_cb,
p9_req_put(c, req) dereferences the freed client to access its reqs IDR,
causing a use-after-free.

Additionally, usb9pfs_clear_tx does not clear usb9pfs->in_req->context
after calling p9_client_cb, so a second invocation finds a stale request
pointer and attempts double-completion, further compounding the UAF risk.

Fix by:
1. Clearing usb9pfs->in_req->context to NULL in usb9pfs_clear_tx()
   before checking usb9pfs->client, so that even if the client is gone
   the stale request pointer is consumed and cannot cause
   double-completion.
2. Adding a NULL check on usb9pfs->client in usb9pfs_clear_tx() to skip
   p9_client_cb() when the client has already been destroyed.
3. Setting usb9pfs->client = NULL in p9_usbg_close() after calling
   usb9pfs_clear_tx(), to prevent any subsequent call from dereferencing
   the freed client pointer.

Fixes: a3be076dc174 ("net/9p/usbg: Add new usb gadget function transport")
Reported-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Reported-by: Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>
Reported-by: Ao Wang <wangao@seu.edu.cn>
Reported-by: Xuewei Feng <fengxw06@126.com>
Reported-by: Qi Li <qli01@tsinghua.edu.cn>
Reported-by: Ke Xu <xuke@tsinghua.edu.cn>
Assisted-by: GLM:GLM-5.1
Signed-off-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Message-ID: <20260529081026.77732-1-zhaoyz24@mails.tsinghua.edu.cn>
Acked-by: Michael Grzeschik <mgr@kernel.org>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_usbg.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/9p/trans_usbg.c b/net/9p/trans_usbg.c
index 1592b99ae00c7..79735bbe739ac 100644
--- a/net/9p/trans_usbg.c
+++ b/net/9p/trans_usbg.c
@@ -460,6 +460,11 @@ static void usb9pfs_clear_tx(struct f_usb9pfs *usb9pfs)
 	if (!req || !client)
 		return;
 
+	usb9pfs->in_req->context = NULL;
+
+	if (!usb9pfs->client)
+		return;
+
 	if (!req->t_err)
 		req->t_err = -ECONNRESET;
 
@@ -483,6 +488,7 @@ static void p9_usbg_close(struct p9_client *client)
 	client->status = Disconnected;
 
 	usb9pfs_clear_tx(usb9pfs);
+	usb9pfs->client = NULL;
 
 	opts = container_of(usb9pfs->function.fi,
 			    struct f_usb9pfs_opts, func_inst);
-- 
2.53.0



