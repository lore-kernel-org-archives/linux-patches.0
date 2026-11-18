Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026692;
	b=rTY9t7ISYFec1NsfhTyapyQ2maC1Q9SwtHQkrU4ehZu6K41b32Tq19TRcIC8SfzKyObX
	 O+wVEtntxu+2/wzrCyCz5BQQLZggvazRJZQ1YJckyKbBkfUxWJQnfpKaUaZVr/bVdifIa
	 iol2MsiPEsRtkkFqgQOZgyhQ9oGnwKh7e9CIwnuxmCfeFucnY36uPoHk7D7wnivn52LYl
	 8+r0wtrGw47iCl862mp0TVZaLHwkKhpO6KSESsKPC0oJ4axqw41gTUz8NQw8bbL70XB+A
	 gHXtM/r6/7JpXn4TRwTomvBbzKO6tys8pDNlC1fNEDPZxFFH8sHDcQTwHLpjXLnmHJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026692;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K0RFV6BeMD5mLSQE1ueyJ7XP5CyEMphMZOTWh1L0ouU=;
	b=U7ZgasuwCD6h0fxB3crZsie7AlfgCerqnvt7S66/+h/FNpRpzgNNsSV8Sv/QhPVr8kvc
	 32+LwLNLFqhHMvvVPMbB+fCvTS60+iVeoF17CZJCxgxYqq8Ktvsaby6YKEDJDmleZhkpZ
	 o5zNDh2HR56KZkRtoFfvzM5evAHaTErKIGhyAPh+obhDHhv50J/48jd4/1/6hB1uH9Gn3
	 d8E7Vsw5TzQuXsAVxh/sNlaso0R8IS6nNLeI6SgA67A4sxPytSUiZrlJVOVMhrFRkMgOK
	 8eQAE9CMFkEHBQd2Z6rrkH4zhEZzh5qLHxg79zO5AFwarIPoTqm+yq93eFVgjcM4bXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e7xUNp7U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D30606A320;
	Wed, 18 Nov 2026 18:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e7xUNp7U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91EE51F000C4;
	Wed, 18 Nov 2026 18:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026692;
	bh=K0RFV6BeMD5mLSQE1ueyJ7XP5CyEMphMZOTWh1L0ouU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e7xUNp7UH3UjzUTLyM8jWPsal1v4WZw2GfgRlf86fVXYgiI7GrJdy7SMFWG6X6Qtd
	 QIx4mh9g/8BGe0aU/Cg3vyYA2WcKIFxlZhutEC2xehaQRLLAdnkkCwJWpb4mWWYohL
	 8d4KyLwZnr3dpQxLTQg8ucdzELH7biIY4N6YhD5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1526/2151] Bluetooth: L2CAP: hold l2cap_conn::lock in l2cap_connect_cfm()
Date: Wed, 18 Nov 2026 15:54:21 +0100
Message-ID: <20261118150217.418725665@linuxfoundation.org>
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
index 3655d5e1d03c3..67d4b6430ba74 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -7670,6 +7670,8 @@ static void l2cap_connect_cfm(struct hci_conn *hcon, u8 status)
 	 * we left off, because the list lock would prevent calling the
 	 * potentially sleeping l2cap_chan_lock() function.
 	 */
+	mutex_lock(&conn->lock);
+
 	pchan = l2cap_global_fixed_chan(NULL, hcon);
 	while (pchan) {
 		struct l2cap_chan *chan, *next;
@@ -7694,6 +7696,8 @@ static void l2cap_connect_cfm(struct hci_conn *hcon, u8 status)
 		pchan = next;
 	}
 
+	mutex_unlock(&conn->lock);
+
 	l2cap_conn_ready(conn);
 }
 
-- 
2.53.0



