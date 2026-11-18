Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041619;
	b=PXVvxi3COYe4GovlbbY84L0QKumAha6CsvmzPZ66M4qBq/th/YkntU7m04z/Sm52hvBS
	 F5MISfaR3sMNPRYzZlyyKOqHREaxUyCgkcSytrCbCJwJhX5GMCRmFKGt0lghjpPzcq8PO
	 PkRYFuLE2OMFVgtHD5b2GE6hkeSqF2rlWe/wBZi6kM9sZ9Hnjm73YS+XGOyHzbLixJul7
	 2MXh0DhysI2XiaLdOq7kLvUm6Eu6B7p9yHIsTFGwqjUT8/ZE/UCEQWYtF3UVz3mf4VGx7
	 4AxLDDpbutDEa12vGPqQoS3zXfSW0ZXQSwHBu9mtaCYIuXkxalYNGqztOD/Ns7PmiVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041619;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N0905kW2sYr2exQ4XeVY4xfTshe0QXS3zDbFGUU7wRg=;
	b=stIbDAjwlWIzPhond144OgGSpxRqXoxHJL8GcjxCKb7FWSNwiXC6sPwa7m4kNToHDST/
	 jOR8JUqDxOnqHzzrioCgNdOC+QUu78f0EVAnzrz3K5yJmZxve+jnloEUIo4GCx6XlyEio
	 kYcyeHBpG/jRA0/9zTjQ61RqaEjF6aj+tj4DjNM71cjzG4xjFejjJ6MB/JHRxVV8sgTix
	 q76AZ7sE7UAJ0d5ZlbhdTmM1HQ3lK8TeVcM0MhquDPbrDb79UOOUysgJ3/D6y9pijcaIl
	 cQMeszPl3xjaO6YEGukb+HzlCSE7Ez62/rJeuHKHcWKjH23M15Eni70yHDcVF6MeJXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hm4rieY2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7EE5606A32F;
	Wed, 18 Nov 2026 22:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hm4rieY2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BF191F000C4;
	Wed, 18 Nov 2026 22:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041618;
	bh=N0905kW2sYr2exQ4XeVY4xfTshe0QXS3zDbFGUU7wRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hm4rieY2LrXGyeZ6aZWfboStPDfFr3Cvyse1cjUAtZDU1wTOwtl5Gvv2eJgtnt4zi
	 c3P2QDwb80dUl/4MoA9JfciR/Jx8EbFdEzWUUkpLq5KrD/Dhm/emzCI9/HVkFhjTFx
	 GNlZxzXDHawNNz8tZ2T89C0mF+aKuNW1c8SOzPsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2877/3318] Bluetooth: L2CAP: hold l2cap_conn::lock in l2cap_connect_cfm()
Date: Wed, 18 Nov 2026 15:58:19 +0100
Message-ID: <20261118150446.854307597@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 036c880cc4e53..3c3a377673936 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -7595,6 +7595,8 @@ static void l2cap_connect_cfm(struct hci_conn *hcon, u8 status)
 	 * we left off, because the list lock would prevent calling the
 	 * potentially sleeping l2cap_chan_lock() function.
 	 */
+	mutex_lock(&conn->lock);
+
 	pchan = l2cap_global_fixed_chan(NULL, hcon);
 	while (pchan) {
 		struct l2cap_chan *chan, *next;
@@ -7619,6 +7621,8 @@ static void l2cap_connect_cfm(struct hci_conn *hcon, u8 status)
 		pchan = next;
 	}
 
+	mutex_unlock(&conn->lock);
+
 	l2cap_conn_ready(conn);
 }
 
-- 
2.53.0



