Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A77440244F;
	Tue, 25 Aug 2026 13:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665353; cv=none; b=BzCzgCAuZh855UsFnhS0+24Yi7zhFBJhZ7sVJAQQzdVJy8nu8r6N8twDBofBzzaisYCxjRmJcYicc5UMGsSrvBc4nJlNyR52hjMj0w9neVJ6dVuZpDoiWqjTaXTcyKoDfNExOvtW7B5MIkIoSSa5soL4334UZNTfI09dQCgKT0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665353; c=relaxed/simple;
	bh=a2YSeL6I8V3EaL5jpNuoLJis6PzSHGt8SLAQmzzESYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=InU5iQR+Ba4Jd7WS0toAvn+nDjXTp+DdOolkcPSIkgFSBkw/ilYk+LvaoX5a13HzX1nekyqt83GEwhzT6s+LJ8Ic5Vzutf9lW2hvrBhQ9VjegcVVqgK5+dBgf/VVn8pwsUY/z7pPCd2dWD/kuNP6WtSKHjgxd0iMKrRn+sP5K14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SCQMDCnQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SCQMDCnQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E241C1F000E9;
	Tue, 25 Aug 2026 13:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665352;
	bh=mbdpfdqGX4tkxAg3RaAeM5pHZIbpJiuAdbBp9JiJeDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SCQMDCnQ7IpN6Ni0HyHClxauTq/FXbxX2h+FSGbV5yLSY8FLQ2y0Cb9upHyQosSpY
	 JX2g/OIj5+1nbmw7r8WlJOWu54lpJewsbJk0m97dnhSNPy4Ly9sZ/fkxF4LVo7nZPw
	 vR0IA5MC6LfX/IYLhyhYD7zODtDx0K9QPBnyx3oU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Ahmet Memis <ali@iusegentoo.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 92/94] Bluetooth: ISO: zero the sockaddr before returning it in getname
Date: Tue, 25 Aug 2026 15:26:28 +0200
Message-ID: <20260825132545.332995626@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.887883084@linuxfoundation.org>
References: <20260825132541.887883084@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1415,6 +1415,7 @@ static int iso_sock_getname(struct socke
 
 	lock_sock(sk);
 
+	memset(sa, 0, sizeof(struct sockaddr_iso));
 	addr->sa_family = AF_BLUETOOTH;
 
 	if (peer) {
@@ -1425,6 +1426,7 @@ static int iso_sock_getname(struct socke
 		sa->iso_bdaddr_type = iso_pi(sk)->dst_type;
 
 		if (hcon && (hcon->type == BIS_LINK || hcon->type == PA_LINK)) {
+			memset(sa->iso_bc, 0, sizeof(struct sockaddr_iso_bc));
 			sa->iso_bc->bc_sid = iso_pi(sk)->bc_sid;
 			sa->iso_bc->bc_num_bis = iso_pi(sk)->bc_num_bis;
 			memcpy(sa->iso_bc->bc_bis, iso_pi(sk)->bc_bis,


