Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2030437F334;
	Fri,  7 Aug 2026 15:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114958; cv=none; b=ALdSR8t61TSCN8Qj4JCgJ3HyML3AusDx0/gjD75s/LKoJxDu6G8hxCqxJZbAJVC6Q/44Pk7dxLkvxYgd0G/kBHydNcbdOqaYOI8f8hkJaEHv4VWZ9/4ngEfFfavbNuQurDq4fnjseEUY9xhPsagakUHnvpIFdLp8g5gg4Yv3yHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114958; c=relaxed/simple;
	bh=oj2u7j6RTklBJMqGSk45ir34hSF5u16KXCDzgLuakPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RCVJU0aWVkTZO9vPc5dE4aKrqGsyFgOaQHOPk5KLInvNTgPj5jtna+Dpy9EjBBIsHYdmibed4DtF45lIJiicsp0IhX+vBF5IW1wI0nK/RzFsGumCFC47d/FIk+BkhJ9dlx7GP2pNj5ChKoKVyLn91QFm/0jNbBXeXTGKH/w2Zy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wuj5wbdn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wuj5wbdn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C0E31F000E9;
	Fri,  7 Aug 2026 15:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114957;
	bh=ErNMScAUR9/xy8Nsaxauk7cr0EIidBefDTPI60VTFkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wuj5wbdndrFj/SxZcijnpxBgX8bGxWtRBYml/dGNy+e41RlVAOajx96hrASqBVNfk
	 PUs3fP7nChqq7lAhoO6HhLGyh+kakn1tXfbiMNYZWDJ5W1CDZqDB6CikO+z8zwXANp
	 LE9EOur5tJp+Anm3359oGy+J5wRtxlOZ0ZUTrrys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 108/396] Bluetooth: ISO: lock sk in iso_sock_getname
Date: Fri,  7 Aug 2026 16:34:28 +0200
Message-ID: <20260807143426.624451655@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit 89cf154d7c18e6e94a3da83051f3cf2bac317ae2 ]

Accessing iso_pi(sk)->conn requires lock_sock, which is not held here.

Fix by adding the lock/release.

Fixes: 2df108c227b2 ("Bluetooth: ISO: Fix using BT_SK_PA_SYNC to detect BIS sockets")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 5868ad1f7128e..4ea41b093ac65 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -1392,6 +1392,8 @@ static int iso_sock_getname(struct socket *sock, struct sockaddr *addr,
 
 	BT_DBG("sock %p, sk %p", sock, sk);
 
+	lock_sock(sk);
+
 	addr->sa_family = AF_BLUETOOTH;
 
 	if (peer) {
@@ -1413,6 +1415,8 @@ static int iso_sock_getname(struct socket *sock, struct sockaddr *addr,
 		sa->iso_bdaddr_type = iso_pi(sk)->src_type;
 	}
 
+	release_sock(sk);
+
 	return len;
 }
 
-- 
2.53.0



