Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347FF46EF7F;
	Tue, 25 Aug 2026 13:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664788; cv=none; b=MDlhqx42uwqbdp8hq8+yXuX/eqaXiVq697Mqj2MlDk9Ta2T5qL2UBAMLjXTAUCdrr6VQruzNpPXJqJLQr7F1rYHm19ZyAbKH1aofJLJJu0xhk+FW8FwilfdYQKxUjs9ZJD4I4JvO1V7q+1JsuhXxg/vuSJMQesrOC74a/xggaf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664788; c=relaxed/simple;
	bh=J1LfRsZQmuIU7faKMxo22NnCfrb3i3J9WHMirjwswOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h//M9BCmNfugjTS/+9y386el3zwB3ekbqTKQO37GIMynB+DhGRQMmZZOW30i+pUjuyvERs8aAWBM+MSCqn2f7mgS7TEnQIs1oeXIVXxTiUV8dOtV33mfs8BjaSdNhCSjTT3vk9FMV44isCd3ycr6p82gkeaOFTZp4FQR42rVFkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wWM3tfPk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wWM3tfPk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8218F1F000E9;
	Tue, 25 Aug 2026 13:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664787;
	bh=xvl15r2gw5+OrA1w6KAgpDoIR37ovHotdfX/uq2z7J0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wWM3tfPkbZylslQUNBCnrHXTJ6kWn5tLZx1KhMT+kGICjNQLyRjOHhra1dqyZiUmz
	 W9EzBu8punmJZHgXlp45Lo9WZzl+NjfTpNozJ5He+JM1xCwpfAazn75kSdHkUwtCVn
	 mFizyJSRA2XnhjU5cKvNdvfkYZHKrRfzEFbxEMGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Ahmet Memis <ali@iusegentoo.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.2 80/82] Bluetooth: ISO: zero the sockaddr before returning it in getname
Date: Tue, 25 Aug 2026 15:26:07 +0200
Message-ID: <20260825132544.613760021@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.560541185@linuxfoundation.org>
References: <20260825132541.560541185@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ali Ahmet Memis <ali@iusegentoo.com>

commit 884cf2cc957da7ac178a0e6c6c69ddfec0481cc8 upstream.

iso_sock_getname() fills a struct sockaddr_iso in place and returns its
size without clearing it first, so bytes it does not write are copied to
user space from the kernel stack. The getsockname(2) and getpeername(2)
paths both run through do_getsockname(), which hands getname() an
uninitialized sockaddr_storage on the stack and copies back up to the
number of bytes getname() returns, so the driver has to initialize every
byte it accounts for.

Two ranges are left uninitialized:

  - struct sockaddr_iso is 10 bytes but only 9 are written (family,
    iso_bdaddr, iso_bdaddr_type), leaking the trailing pad byte on every
    call.

  - for a broadcast peer (BIS_LINK or PA_LINK) the returned length grows
    by sizeof(struct sockaddr_iso_bc), but only bc_sid, bc_num_bis and
    bc_bis are filled; bc_bdaddr and bc_bdaddr_type, the first 7 bytes of
    that structure, are never written.

An unprivileged process can open a BTPROTO_ISO socket and reach the pad
leak with getsockname(); the broadcast leak needs an established BIS/PA
connection. l2cap and rfcomm already memset their sockaddr in getname
for the same reason; do the same here.

Fixes: ccf74f2390d6 ("Bluetooth: Add BTPROTO_ISO socket type")
Fixes: 0a766a0affb5 ("Bluetooth: ISO: Fix getpeername not returning sockaddr_iso_bc fields")
Cc: stable@vger.kernel.org
Signed-off-by: Ali Ahmet Memis <ali@iusegentoo.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/iso.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -1536,6 +1536,7 @@ static int iso_sock_getname(struct socke
 
 	lock_sock(sk);
 
+	memset(sa, 0, sizeof(struct sockaddr_iso));
 	addr->sa_family = AF_BLUETOOTH;
 
 	if (peer) {
@@ -1546,6 +1547,7 @@ static int iso_sock_getname(struct socke
 		sa->iso_bdaddr_type = iso_pi(sk)->dst_type;
 
 		if (hcon && (hcon->type == BIS_LINK || hcon->type == PA_LINK)) {
+			memset(sa->iso_bc, 0, sizeof(struct sockaddr_iso_bc));
 			sa->iso_bc->bc_sid = iso_pi(sk)->bc_sid;
 			sa->iso_bc->bc_num_bis = iso_pi(sk)->bc_num_bis;
 			memcpy(sa->iso_bc->bc_bis, iso_pi(sk)->bc_bis,


