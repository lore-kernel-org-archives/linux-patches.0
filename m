Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624000;
	b=0KxPbdgk4csBuYSYtc+nuSuV0Yshqrr1AuKmyumMEZ8FQCskAhqP/9GgrB6l0btLvgK+
	 UXf7OPCC96JwI6wmkbQnFwoeiesHkqWA9xELGy9nGr4npkxAbh0bJWchmcC4qB6tBhEci
	 /oJuQSzDKTJ9N6hLE1eRxY4vwZwPVfEk/dq9o2pZS69/cqIS2CoR2Ae9VRUICB+WXwkLB
	 b7dUe7HT3lpqIWRU5JF2ui0A+VejytJdFgR4VsaquBWpo1S/tS2+9F4NOz9GxcRjbAxPs
	 FgfyHb2NI8ps+dvCmj7OnVvhwF1s2FWfvTG/H7/C2p/i2Uc529lugFTakIJrI7b1CPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624000;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d8elkd3dXkPUGNA0W29cplaqK28520o94AXnZv175Bc=;
	b=GyxYQ7Xs0bIc6hppjFPr/dKcwTOVg6UXBfZ/FHf9DHBXf8GK0hdHhotla2GJdI0arg3Z
	 JXjI0ZY+tlTlbWui/DIGzqup1Cg6RshgveAZLMDR4MZkkIzDv1VMOVYsQtUfU6CNT0e8b
	 Il0qk3c50D1mIZTSuRX+cgAT2PtNyn/I9qlcKqseuqWeitRcHj3YtrToMJUm1Ciq/QTOO
	 7C2G1sCyxe6ETngelmOeZxGs81roiZ8DznFKrREhqM1ek5V9I2qnEYTgNWeOfIseeu5+I
	 9Ny3JcahMsbUsBLMtfLuj8QUruizyLEzrtPyo+aO0aDyip7E8GaU5oW5q4vCyi3oqIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=thIST2w2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458CF606A321;
	Wed, 25 Nov 2026 16:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=thIST2w2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BD181F000C0;
	Wed, 25 Nov 2026 16:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623999;
	bh=d8elkd3dXkPUGNA0W29cplaqK28520o94AXnZv175Bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=thIST2w2HlKxibj/A18sudsU8rI+FZOW26fB0AVHt46dWiyLAYCdESP4j6eQVuNJ+
	 0RYJfd/xw9REGU5IU/U58oLLTBJoeR3StPZD6PK0M41smVU4eueUJUHvSLA2T143fo
	 hcenr7ptJEdWpL8+y87RxHRQLLaBElVyEz46h2g0=
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
Subject: [PATCH 6.12 054/816] net/9p/usbg: Fix use-after-free on usb9pfs_clear_tx
Date: Wed, 25 Nov 2026 15:26:42 +0100
Message-ID: <20261125143850.470313003@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



