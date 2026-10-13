Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64EF63955EC;
	Tue, 13 Oct 2026 12:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894672; cv=none; b=HYy5gOEX+v692zCrvpmP3lDXKzE4ZU5Ktzy1L9HVhUQBfHXXWLZFFkPc7GeFvxx/EiB9nVIVP09AT21Y3HOocl2c5Wz1aHTOvyyleVKYh734E/9Z4seeHBRAz2IfvR4ZYnhnM+L4BYfpfh/nplbIOTMLSVOBlSG97J9/Sa3mDsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894672; c=relaxed/simple;
	bh=7tkYpPdrTZQyBMA+LMp8uAcWoI9D24WD7jRzasP9+uk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PwYmQRz+m/urAH9+uK8jyLzoWWTLP92pTfQlPnXbl+tn1AoTPwI/olEty/c9b3FhliDswoFsYFQghRB0RPnlN6AHQ5FAIAejaj4FjFk0OiObYpVqx/uGTp+Gof9F8gZGtreKIp9MF4GpBMw/PeKTLea4hIspJQUI+Buie1y8jJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1DX6uerK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1DX6uerK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7E991F000FF;
	Tue, 13 Oct 2026 12:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894671;
	bh=N7VQGkNP44TrVLyTkfHTOMCbjF4YGL3WL7nu9qboqVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1DX6uerKXRPqdmmNZiAie/fLG6aTJV+01magekAvY14eKDCJE/ogvALyIHFF0x1y9
	 XqpXJeOpN/09/yHRYVT0vLKXtx+eYAbO2Go+Gq1uH13SQGENA+rdrI8iHCaBkVZN+F
	 WsK0CoC9kj0SoU3OfwQTIbExqLHEuZOsDW2Oomgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 018/497] Bluetooth: ISO: release unused CIS holds after channel attach
Date: Tue, 13 Oct 2026 13:33:05 +0200
Message-ID: <20261013112908.311588859@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>

[ Upstream commit 0fcd4dad555c96e0bd3a1b8c569f989be85c7341 ]

hci_bind_cis() and hci_connect_cis() return one hci_conn hold for the
ISO layer.  A new channel association consumes that hold, which is
eventually released by iso_conn_free().

There are two cases where iso_chan_add() does not create an association:
it returns success when the socket is already attached to the same
iso_conn, and it returns -EBUSY when another socket is attached.  The
hold returned for the current call is unused in both cases.  This occurs
when deferred setup calls iso_connect_cis() again for its existing
socket, or when another socket attempts to reuse the CIS.

Detect the idempotent case while the connection is locked and release
the unused hold after iso_chan_add().  Also release it on -EBUSY.  Do not
drop it for other errors: a newly allocated iso_conn releases the
transferred hold when its last temporary reference is put.

Fixes: 69997d50ec57 ("Bluetooth: ISO: handle bound CIS cleanup via hci_conn")
Cc: stable@vger.kernel.org
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index b3df3a5137fee..fc9b9c11ab4c5 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -450,6 +450,7 @@ static int iso_connect_cis(struct sock *sk)
 	struct hci_dev  *hdev;
 	bdaddr_t src, dst;
 	u8 src_type;
+	bool already_attached;
 	int err;
 
 	lock_sock(sk);
@@ -511,8 +512,14 @@ static int iso_connect_cis(struct sock *sk)
 		goto unlock;
 	}
 
+	iso_conn_lock(conn);
+	already_attached = iso_pi(sk)->conn == conn && conn->sk == sk;
+	iso_conn_unlock(conn);
+
 	err = iso_chan_add(conn, sk, NULL);
 	iso_conn_put(conn);
+	if (already_attached || err == -EBUSY)
+		hci_conn_drop(hcon);
 	if (err)
 		goto unlock;
 
-- 
2.53.0



