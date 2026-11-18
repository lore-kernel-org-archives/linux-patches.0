Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056018;
	b=4FEpaRE488pk05GeJW1hUYwjtxX/fDu3EzU7+mTTkHmBBuWxg4GqU4E0F5zRle9PTcdn
	 Rs6nJNxR/TzKVHXow/lG9/qhWE+gyOk1Ubt3X9icxNqUUh9K6iDL9t28GrRSGpF1ri/Hu
	 9QhMdLIgGr9tQ+hEHTe/nwGPUPx36IrcIappFCZ1lzFbb1SzzCz/gXtexV0bnBaay71EY
	 GukBKSTvoOpSrCtHePpfPyGVTmhjVqVGufsoJ+ps+nMTkPqqDHVvxdyeWgx9o3NZELXvY
	 JgmmtkgtgNYQfK5jalljznejUACMvOiyQ4k9lP82iiTCgYj80SiJCL3dx5AvmcDVl8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056018;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VfynvZaKWHOCnYy/4oULEEJt2Iq7PZb9AV3TeTq3jYc=;
	b=s0sZTkR+3d9ocMUc4yvRc/2g39MSSel50JprsdXu9R7/aSqDtxvPr8eR/wGl+9hwTTRO
	 vwVepESYmo7GihEhuLm6GF9LVMs6ouhtr69naWsy5/6juAZKGKCSENIwonR2UqqQzW/sq
	 PY+xq7mrvxkubFSzju/ZCsnZj/cW963KdtvYtHm5vtkhPwrLUoFNnQhL/mDC2bzfyDj7r
	 eOLVwZ4DPevf0wV6+iabLElV68VpTmtAXvHeGqjpMAGedwM1IROhH4LhbREY3eCz+pjs5
	 zOqO81XpYIzFTzxMPgyl/5nUDguaj8dhwKS2gVErGcdguAfusdEepgozctUqnU2KSPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=du7qRZo8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52DA3606A31C;
	Thu, 19 Nov 2026 02:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=du7qRZo8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC7271F000C9;
	Thu, 19 Nov 2026 02:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056018;
	bh=VfynvZaKWHOCnYy/4oULEEJt2Iq7PZb9AV3TeTq3jYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=du7qRZo8MMJxFBydUor+PL63cxj+2kRFa/p68ebZHFgFo9TOWv3oV6Isnu7xgUuub
	 EKGH+GrxSvE9kagPpx44hDu6gyEIQH0VZJlD+smTKN76qphxw1Qte4MtMS0hRe4aok
	 kct8DHZ1KN1UMFQHwta8ln0kI89hgdVwYLXPFur8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Changyul Lee <lcy8047@gmail.com>,
	Sang-Hoon Choi <csh0052@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1838/2214] xhci: dbc: lock the minor IDR on registration failure
Date: Wed, 18 Nov 2026 15:58:34 +0100
Message-ID: <20261118150124.958741611@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 740f5df8368eb..2e862ddad63ca 100644
--- a/drivers/usb/host/xhci-dbgtty.c
+++ b/drivers/usb/host/xhci-dbgtty.c
@@ -474,7 +474,9 @@ static int xhci_dbc_tty_register_device(struct xhci_dbc *dbc)
 err_free_fifo:
 	kfifo_free(&port->write_fifo);
 err_exit_port:
+	mutex_lock(&dbc_tty_minors_lock);
 	idr_remove(&dbc_tty_minors, port->minor);
+	mutex_unlock(&dbc_tty_minors_lock);
 err_idr:
 	xhci_dbc_tty_exit_port(port);
 
-- 
2.53.0



