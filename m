Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DC8148167D;
	Tue, 25 Aug 2026 13:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665068; cv=none; b=IdR5cifHLl1M6yeHBrFGhEFa37PhaNdIQGcNG/3v/K5N3JagZqlXwMlC4zRlEJ5kOUkJvoyuthD94E1S5W5rYVFDvR8Y/U0Z3fS7C4NI/DjeYEfwq/jg8vwI1dt1uGZUCOvXYrG/Cq57b2c0w1JYj7bF9ZDAErRvVkWEDjRj54k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665068; c=relaxed/simple;
	bh=/ZDo6aD9pK6eWG/gPO5YhhKRN673qeSK1SQxLwikAz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h9pxpb4jo3UIE15k7BOPcozd3s7hyJAK9tehv2AzVal6a2oBhdo/WTVjdghAYg+NsbAUzeNEXRuRrzoZkVYZ6ngl8lIYdwyOXqNFuIWbyp6L6bGvhyHZ/7TQ9+kD2cGLewe7NGBkL4nJPfMNATweTIoa1qYlnu8VFG35olurzAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=khjsAjWz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="khjsAjWz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFC881F000E9;
	Tue, 25 Aug 2026 13:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665067;
	bh=aVhcviLSX+buDU02kc9/cyQ8swxP/0aEf19H9D5FrM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=khjsAjWzLM7sPGVV1l28ocPgsqq+NGq7C75rWCJMWUZcZ5eqUYUaXwiMrFsa5NAU4
	 4dxPTxhqea+lMuS8fzbrd0dvaZbNrYtnf0bJppN8WOGipMGrUdGDp2TIjBuiK/25K/
	 7/8SqkVnrL3rgZa1wbbPJKyr02aWmsbai/S9TeYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Ahmet Memis <ali@iusegentoo.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.1 099/101] Bluetooth: ISO: zero the sockaddr before returning it in getname
Date: Tue, 25 Aug 2026 15:26:17 +0200
Message-ID: <20260825132545.641819968@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.986300899@linuxfoundation.org>
References: <20260825132541.986300899@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1535,6 +1535,7 @@ static int iso_sock_getname(struct socke
 
 	lock_sock(sk);
 
+	memset(sa, 0, sizeof(struct sockaddr_iso));
 	addr->sa_family = AF_BLUETOOTH;
 
 	if (peer) {
@@ -1545,6 +1546,7 @@ static int iso_sock_getname(struct socke
 		sa->iso_bdaddr_type = iso_pi(sk)->dst_type;
 
 		if (hcon && (hcon->type == BIS_LINK || hcon->type == PA_LINK)) {
+			memset(sa->iso_bc, 0, sizeof(struct sockaddr_iso_bc));
 			sa->iso_bc->bc_sid = iso_pi(sk)->bc_sid;
 			sa->iso_bc->bc_num_bis = iso_pi(sk)->bc_num_bis;
 			memcpy(sa->iso_bc->bc_bis, iso_pi(sk)->bc_bis,


