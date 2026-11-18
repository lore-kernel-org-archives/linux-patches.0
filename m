Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031405;
	b=wUZtVlvz20QSeixX9mlCMZr1MNEYAgQHgQs9MgcT25NCs9ScEMNa5dpx83Kc29/KCXVY
	 5MdflajFKLd7R60BmHfxFJdhG0Q462zOhZmZTMAVa4ASl4AR/LQTh38oj8oJqeM5m2QmW
	 e+cZmIWeB+i+GGzTtuO4TcAPRvMoNfpP03GI90x1mRub1bz/6+D540fMdub3lxQMaUK3k
	 ExyUZzbaczJ1JH9AZAa0lUI2tA+ZnD3IUNfIOwKInlNK8BqNCqUFnHcskfI95CmRp7yXD
	 tuoeZxGWkhEoEGIWj6w9pREP/UUrdkNutJ8PERtnGtA2FpszL3FPY5E4/fdscJpc19g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031405;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rCikiFCaL5K+QKfyysewiOZOUYUrrA/dz2Z0Wi3/yAc=;
	b=v9aU6SjtCLYALNB9kPsxPFugHn9t/aC+REGYePjhv/wFeN8sLnA7ehuoW2Wt4HJi7dOJ
	 6t7ykiT1fgwdGQyJDGmaTYZAC/3iteRj6viugTfAzj4nWrFwmwrE7PTW+o7t0hU3GXftk
	 THJ7QAiaK6Xgv0RzLUEnofNJNMUjzoKuZnWKyndPeCrxUC/tIRqn6jK3tSpYHVgjkGkt3
	 MEclQOS5JzgYr6C4jZ8R7mVnEhem8SAf86KB1uPf9edef1NIoqkopKYNsIqX5c550DhPJ
	 xaCYsbrT2CDh7HvUqySq1Wqglh0jSxTvVTuDoq1t6cEH5VqdPf1E69ONnb9eqnNS6cA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I25FGfcj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB347606A325;
	Wed, 18 Nov 2026 19:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I25FGfcj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F691F000C4;
	Wed, 18 Nov 2026 19:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031405;
	bh=rCikiFCaL5K+QKfyysewiOZOUYUrrA/dz2Z0Wi3/yAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I25FGfcjb+q6QL96jVngtDByOkroSNjCRddRHVXYMixscaztwnBMKjXG4whwFGAJa
	 bUn0/dlvL/F1LH7nm/FeDiCBh6FS9m6+Ii8yGQZFit7igvmwIGkf5ncxii0TwS6wyH
	 PHLxYvwSXio/rwTNKJfJb17sPNsXzFGBkhjxFVjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Changyul Lee <lcy8047@gmail.com>,
	Sang-Hoon Choi <csh0052@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1046/1756] xhci: dbc: lock the minor IDR on registration failure
Date: Wed, 18 Nov 2026 15:52:53 +0100
Message-ID: <20261118150051.699518622@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Sang-Hoon Choi <csh0052@gmail.com>

[ Upstream commit 47f4e983b5de7616fb11d5f537fc9a605387d136 ]

dbc_tty_minors is protected by dbc_tty_minors_lock when entries are
allocated and during normal device removal. The registration error path
removes an entry without taking that lock. Different DbC instances have
separate event work items, so this removal can race with an IDR update
for another instance.

Take the same mutex around the error-path removal.

Fixes: e1ec140f273e ("xhci: dbgtty: use IDR to support several dbc instances.")
Reported-by: Changyul Lee <lcy8047@gmail.com>
Assisted-by: LLM
Signed-off-by: Sang-Hoon Choi <csh0052@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://patch.msgid.link/20261009151624.618967-6-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-dbgtty.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/host/xhci-dbgtty.c b/drivers/usb/host/xhci-dbgtty.c
index e468cf700af59..b9d6f53eddd85 100644
--- a/drivers/usb/host/xhci-dbgtty.c
+++ b/drivers/usb/host/xhci-dbgtty.c
@@ -503,7 +503,9 @@ static int xhci_dbc_tty_register_device(struct xhci_dbc *dbc)
 err_free_fifo:
 	kfifo_free(&port->port.xmit_fifo);
 err_exit_port:
+	mutex_lock(&dbc_tty_minors_lock);
 	idr_remove(&dbc_tty_minors, port->minor);
+	mutex_unlock(&dbc_tty_minors_lock);
 err_idr:
 	xhci_dbc_tty_exit_port(port);
 
-- 
2.53.0



