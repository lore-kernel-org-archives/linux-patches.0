Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A34305665;
	Fri,  7 Aug 2026 14:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113964; cv=none; b=dZDiyXpzGePr8dcjOCF0FXZ0oSPWmEpG8xgJ7oxAOtTW/cBnIrdd0DfH152f34szH5WNhuDPqnHMdGipx7dMAnKRUKkxzJTzgAiom2PAtY82NtN69nAf/M/NZUFHdiwqEEc/FHhIrV8aGWKAhPaDOpkrO57aoVaSgOgpGJUarYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113964; c=relaxed/simple;
	bh=xq1x5Ni4nsbo6TejmksLZw5VlLhCAJq6ngO2WhIg6ac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MhUK751By+vvsoCOx4YBzJ7jIGkrNR1/M0k2ujb4tZdaRfOsp6mxYzvJIqi3hwTq6wRAyAuBVay2FGTAvwhWIr1N2EX6k0OnU0+3zIkpyA60M9jcPke5HHxXZ1XWWvIO7p0mNpZKbkPXqNJWNckSZVt22G/NGhI2/KZAgHg9Sv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L73qFGxg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L73qFGxg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FA511F000E9;
	Fri,  7 Aug 2026 14:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113962;
	bh=k0vHX7giBVJnRsEffEzK5uFOx8lQhLzZ5YuEy5AzaI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L73qFGxgMxQsBzVTunzt7j9CjexCVhsWmPxt7LuwUowN9tIYrm+Canv9CM/SETA+g
	 41343GIyJ/9a6W2d+5V1IYvLT8bNoRrSn75UKtByR98DW/fjvtJZbINRni6rrGooq5
	 rlOnh8Wyw09CWrEOHIDQdWTe4qB3W+88BYr8Zb/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 096/337] Bluetooth: ISO: clear iso_data always when detaching conn from hcon
Date: Fri,  7 Aug 2026 16:34:59 +0200
Message-ID: <20260807143420.622335414@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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
index 12a01dc6dbde3..1d3e4616ee700 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -811,6 +811,7 @@ static void iso_sock_disconn(struct sock *sk)
 	sk->sk_state = BT_DISCONN;
 	iso_conn_lock(iso_pi(sk)->conn);
 	hci_conn_drop(iso_pi(sk)->conn->hcon);
+	iso_pi(sk)->conn->hcon->iso_data = NULL;
 	iso_pi(sk)->conn->hcon = NULL;
 	iso_conn_unlock(iso_pi(sk)->conn);
 }
-- 
2.53.0



