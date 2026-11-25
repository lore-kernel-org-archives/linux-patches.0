Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617641;
	b=30fbIunaGZx6YbZ8qmzmCREiNdmicP0CF+GBnJJkykIWX/XKFmIb7FTlGuPUkagLhfRr
	 nVo44w/Anjk0YQwCcIfOYYfuPQaHRmiEEJG72ITtKyi78wHmaxJmNFyJtEm/NsI2S292O
	 liwyRL5H7RaZDT2h/mkaGll4PwKm6Ju1uvHBTHMN0VGePP1UXQ0CyOfR1F2pOXSSlsVj0
	 WnVImem8c05YUFsnPaQMcdXwDOnFe8TXNutRiu6iQ0hxlIKJQJ6/eWbpNMXgI8W2Lwi/H
	 JE3ZWvF8DjETgEe3Rai3b43QiZ4XD/YMHr5msNEUXZBQycC00pOqKVsaUDa18EI4VYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617641;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WNUouV2YVoRk/56KWHctfUD6xRCg1b7VTSc1Cl+n2M8=;
	b=j75mNIsmEO6hB/5ZmOQLjAdoR9ggJFdheN7xAiKpA6TReeWMDH3J8GVg6VsCcAEbvqLo
	 gdStl8N7XiCzsSP8vWsC6tAlhi834akz+WoWHwv6Srsqg33js1x3SUqzgYwgVxOATl9ln
	 7by6Q0KGVsL6vuupc62WLEp3hZByCI+qAocPKgFzesc9JS/firoPNjHSblW4u7JKFljG4
	 ASUzWQuU8QSE9IUICNZ+NjCw0rSfSCnJwr4cS1/iHSyeX6nU3zkUhmiem97F4b2PrnJEn
	 iuCSv+3Rg85R0pw/DVUQ2o9ToimRXw44lybjtnLmLEK1DuJ4U8taspW28iuRJ6YDqgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2nyV8Rr4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737ED606A680;
	Wed, 25 Nov 2026 14:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2nyV8Rr4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C31E11F000EE;
	Wed, 25 Nov 2026 14:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617641;
	bh=WNUouV2YVoRk/56KWHctfUD6xRCg1b7VTSc1Cl+n2M8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2nyV8Rr4xxd+hBrjpXXlm+v3xsOp/OegII2+LkExOqcoOAJpckvw9LevB90e8G9uS
	 10pnBLbZs1u/uNZr4NJghfeq/MUDOUIGvarZOihLAEvyX76RYXRQdJLxFu3+WXKbwS
	 g8NnYKy5nLNdHIExAn64LqvMv0XP628f977yXYrA=
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
Subject: [PATCH 7.3 0030/1005] net/9p/usbg: Fix use-after-free on usb9pfs_clear_tx
Date: Wed, 25 Nov 2026 15:22:48 +0100
Message-ID: <20261125143822.443112307@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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
index 6bc7de04bd514..45b0ea594211c 100644
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



