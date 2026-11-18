Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020233;
	b=lNlYqREvavp66ApxDOlYan6sP0oAfELRH7vyqy6a8xkPOFO5qQlbF2FVZhJcBxkBAOHv
	 wxUq1fUnP4cRyIsY6Ptv6kUWGz9MHq7+vH7HNj2/2oD36fE7fBu1ZfnRlM+e2XeQ7SS22
	 5CFZUMDKlC2J3RVvjZWYt8KmrzyofyGpfMciAMjDcgXJamsOhj7JG0miafAVMpcgk2g7a
	 Sd5dBAYWQu6DaeGu6FVfF5ieE32CUj8HersPmLugpEBcUk6AHnzHPkXRnkA1FRdxPTW1K
	 sHKnx+Os2OxGmaBjbKRenZFVhojRMJdIbQVah29caDMgyXD90oD0zcpgUDzdgQFsbwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020233;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=spR57m8X/P4FCvI+7sYalGNdahHFPo4caelDzhXmSqg=;
	b=EQ4FOGNJ9LPSlcq4Ien5xD+JjcCIicxOyX5m65vLmB8O9Mmgy/Kes+O/otzj9Dza7tKy
	 4kHfWaMIKLikt4yU2IkCQBXCjdRX2xFCjKvMYVP9xzR7R4TybAfB87JeOD+U18TCjtso4
	 cZjg/tgmMJS3A0KK39UGfKr7zy0KHV1IhBJOvNuONhg37kt8M4dwOAuR+eh5MHMnl+LI9
	 jSWAwPesh4zg82bgHoyX7k5dkYG1hdJVY5MVgvDzicp8J1/92lr5ML8tAymhwiJP94Hf7
	 PtYTiwE2GyCDkCFUTs3flKTTQIErQ1a/PggeVOPf4v0SENfLsqEPXbNoUlsVWxc8Juw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TF4pDJC1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D98E606A325;
	Wed, 18 Nov 2026 16:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TF4pDJC1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 615AC1F000C4;
	Wed, 18 Nov 2026 16:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020232;
	bh=spR57m8X/P4FCvI+7sYalGNdahHFPo4caelDzhXmSqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TF4pDJC1PjfLLZ6lecxudGrd4pb/gfmRQJztEhZYhDs69qwrRTM3/uayhwXJ7CGvF
	 qhSacHU4mEEEMdE1n5ST3K8GX1Ypw1z0AMdEtvhzLEBoF04QW+BUQZJPQz9vnOKivu
	 nDF/Dlkp1lMVrPrgk0mGaSZTaSrQwcs+iIH+p630=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1876/2651] Bluetooth: L2CAP: hold l2cap_conn::lock in l2cap_connect_cfm()
Date: Wed, 18 Nov 2026 15:51:56 +0100
Message-ID: <20261118150354.481087516@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit 115e6a21c88a5f708b2b025f7567ab78a782a74f ]

l2cap_new_connection() -> __l2cap_chan_add() modifies
l2cap_conn::chan_l, which is guarded by l2cap_conn::lock. The lock is
not held in l2cap_connect_cfm().

Fix by holding conn->lock in l2cap_connect_cfm() to make the locking
systematic.

Fixes: ab4eedb790ca ("Bluetooth: L2CAP: Fix corrupted list in hci_chan_del")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index de7397e53c2a3..8fc38a9e02bf7 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -7728,6 +7728,8 @@ static void l2cap_connect_cfm(struct hci_conn *hcon, u8 status)
 	 * we left off, because the list lock would prevent calling the
 	 * potentially sleeping l2cap_chan_lock() function.
 	 */
+	mutex_lock(&conn->lock);
+
 	pchan = l2cap_global_fixed_chan(NULL, hcon);
 	while (pchan) {
 		struct l2cap_chan *chan, *next;
@@ -7752,6 +7754,8 @@ static void l2cap_connect_cfm(struct hci_conn *hcon, u8 status)
 		pchan = next;
 	}
 
+	mutex_unlock(&conn->lock);
+
 	l2cap_conn_ready(conn);
 }
 
-- 
2.53.0



