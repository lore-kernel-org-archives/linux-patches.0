Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026122;
	b=zpXKOsEe7sZ4/517eFILqnDoC3Usaey0BS8hgWAGQZM5V1RCe8r3puTRlTLWfvkRhVT6
	 8pvAZ9GkcLQ6jpniuBFfvjV4s0CmnyE/m1gK1LpNDckpAn3acmyv1c2CvnX0IThF40uOC
	 FizgjRdRLw3rerPi169FRa7HsRJjDQMfyxAf4RrTJIFVRYZzelG18EkZSxt1G52G+vFPO
	 SOaym74BlKTIpK+VOk3ULIRF/C940RWtLnisAZVNrMB+ulSqIzKLXGBBQBh+rEBbq/KJy
	 Ktetni4boqnShwsdKbo5uj1a4YVcSP065BKIqbKfY9YOhhJw8dFSkDpcheMVt30QQ0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026122;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FQ1EcLWCepM3MJrx/yAspy3DJPlYMyCe1TcV5ai0SCA=;
	b=qIDtzsaDJETv75JA9GadKM//w/yqZZXRuHWY+yEf/ufDXXkZcCP7rcYpjzLAbNSdMSmX
	 xac9V/ij+NPlroNzWdQaUkj+26ufbVINzDcUVqjG4xkImC9op8HngjprSIcdl783T6Vou
	 dvQovklY8f2TsVJEWloI9RP7Nr9V1wGsnHWYrt/BfSWWmUVZomQMx58dZdRucUWnTW9CR
	 2OXP++NjsiFBjsEyW47+/wnSAO7GBf7cWgT3HhHCDCHN0aBNWlUlxyO8qOXaJo359jcA6
	 V8WS11wsUy3OBB4qgJqJZ+Ad1yVY9LWnB1ITAfZ8B4msoxfx+rOCL5Cso7yOurabH9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d+Vg1puw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108CB606A32C;
	Wed, 18 Nov 2026 18:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d+Vg1puw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C2C81F000C4;
	Wed, 18 Nov 2026 18:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026121;
	bh=FQ1EcLWCepM3MJrx/yAspy3DJPlYMyCe1TcV5ai0SCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d+Vg1puwF8IKfAM1DsSOQV/DUPYl9Z2uPaNk4UfEva/M7wDlJQIWdQLJUutS/Qj9r
	 7cEdezOgo1iKRofgp7PKTF+qiRiTckiMEv8Tz7ffLk2wMflwDmjbBV+JDe4gPwEfvj
	 Dki0xbwbMQyzhV6rhfa55qT3RHehkIoUfxYqg8SQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Changyul Lee <lcy8047@gmail.com>,
	Sang-Hoon Choi <csh0052@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1321/2151] xhci: dbc: lock the minor IDR on registration failure
Date: Wed, 18 Nov 2026 15:50:56 +0100
Message-ID: <20261118150210.210039298@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index fda5ccaba27a9..979bfd904dc03 100644
--- a/drivers/usb/host/xhci-dbgtty.c
+++ b/drivers/usb/host/xhci-dbgtty.c
@@ -535,7 +535,9 @@ static int xhci_dbc_tty_register_device(struct xhci_dbc *dbc)
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



