Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF8638C2C0;
	Fri,  7 Aug 2026 15:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116892; cv=none; b=taM9lnJFf1vXAyPcn+PVcQFm4Hf0YYbccg+Iv2J1uMBf6k8qBjcXT0Pyh09871sS7AgrD0HMUnt1N8Ts84ohg+CowDbSsS50mDA4aIogV6fkdyCRNxHVj9Lv/0GNgL024TgeRkKhljuYbWUMhC1RJd4+s6DPeOiPaOwg94Ffk/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116892; c=relaxed/simple;
	bh=iehV/it+BeaBd/Z+CTAcOYHbHDo9fOsJOir9c1hMnkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DK2ubXYuZUKBFH/nsjYeC1JabXvAGbDXoWl3Fz+Vvp/D4ROFizHkkk1zwfPLsnzC3PTkO7PNcZj/dWR0VUeBxyq75K+yeWPy85yWNCQSOq6WQWTV4+hO8m5B4M5Tn3vX67wvhrfjQYP4894P3D4Yv5tO/YGwt76NLYq2P/WBqgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BQ5UXIh3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BQ5UXIh3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 431F41F000E9;
	Fri,  7 Aug 2026 15:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116891;
	bh=eC5wBo12U1MSx0aLj3VZEBFSBgUvSzqXfg6EDtuz5/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BQ5UXIh3EoFoUvR+gCvR/DOoYLdTquzBFFXjKAvjX4qIHDe60nUFvVCgGjm0gCY+d
	 ZlSSPqbsrxpgtE0J5CAbB1TxX/Q9rsk55kS2dGggmESfZk84YtpgiswmxTaU6Pg4fh
	 AeaHpR2GNE4lGDiC1jn4CBcNtNatCr/SLs5JyUHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 128/438] Bluetooth: ISO: clear iso_data always when detaching conn from hcon
Date: Fri,  7 Aug 2026 16:35:24 +0200
Message-ID: <20260807143430.723658511@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit d57e506f6a1e3929611340fae87c1e4823f4d85c ]

When setting conn->hcon = NULL, also conn->hcon->iso_data = NULL is
necessary, otherwise later iso_conn_free() will UAF.

Fix clearing of iso_data in iso_sock_disconn()

Fixes KASAN: slab-use-after-free in iso_conn_hold_unless_zero on
iso_sock_release() followed by hci_abort_conn_sync().

Fixes: fbdc4bc47268 ("Bluetooth: ISO: Use defer setup to separate PA sync and BIG sync")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 1d5ce87e6496e..6bbbbce4c5f27 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -836,6 +836,7 @@ static void iso_sock_disconn(struct sock *sk)
 	sk->sk_state = BT_DISCONN;
 	iso_conn_lock(iso_pi(sk)->conn);
 	hci_conn_drop(iso_pi(sk)->conn->hcon);
+	iso_pi(sk)->conn->hcon->iso_data = NULL;
 	iso_pi(sk)->conn->hcon = NULL;
 	iso_conn_unlock(iso_pi(sk)->conn);
 }
-- 
2.53.0



