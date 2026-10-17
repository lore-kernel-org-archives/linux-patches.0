Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E8337DEBE;
	Sat, 17 Oct 2026 16:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254765; cv=none; b=gMfbeR0dp1w+vLsGtpEurZHx9C/OaYrmKVt8VouteSVHdhchQhIAwpsowv03AqtbXECoues61WUMjagGoVRLjn40ddF0E8Taa7DRzVBj4lpmxAMkfAKgKQgg0/m4VvqgZn5dZpV9IBmVIPGvxYsc1jkE0IAMaBvxnNd9icZyL4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254765; c=relaxed/simple;
	bh=gNaqXsM2r49UTC0fTF2OpXVbvyMJi4Two81Fad4wHqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DT801BffA27FEPZNX5p82VcGTI0MohxqIZ2zkoB4il37Bbil2qJAy1vznTCrQEgBlpebJKO9zhfIl/THKMfdbSkas/8hAYvkV+aZFSYNPpTXcgE5sMrUS0nQqZ1uXEhdp/HjDsEmlVteSAPaWulI6HnhqMTB7ZqSZ0AzKr0YIkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zXq0Ea1A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zXq0Ea1A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A8921F000C4;
	Sat, 17 Oct 2026 16:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254764;
	bh=WsAhID+si5wqAIpMgVRe3uIvvTsQWBHqzNy/DczNFcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zXq0Ea1AXERfqgmyKtlET8fi9CEjSAs7NSsOp5fC3BceGSPbLmP66soC9sy9bWP3z
	 3+L08G2g6wDv1vldJNl7od5D1Lp6KoYLVcMHONZ55skxfaMH5vOGXQEmAGc6k6SooD
	 WW/yPcQunk0MkrKjlgX02bASUg9w3MYOipRjsrds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Ahmet Memis <ali@iusegentoo.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 552/869] Bluetooth: ISO: zero the sockaddr before returning it in getname
Date: Sat, 17 Oct 2026 17:56:33 +0200
Message-ID: <20261017160051.238605142@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ali Ahmet Memis <ali@iusegentoo.com>

[ Upstream commit 884cf2cc957da7ac178a0e6c6c69ddfec0481cc8 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index eafa22468e5f0..98261072aa050 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -1397,6 +1397,7 @@ static int iso_sock_getname(struct socket *sock, struct sockaddr *addr,
 
 	BT_DBG("sock %p, sk %p", sock, sk);
 
+	memset(sa, 0, sizeof(struct sockaddr_iso));
 	addr->sa_family = AF_BLUETOOTH;
 
 	if (peer) {
-- 
2.53.0



