Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031894;
	b=tS+0sbYn/NFm4TkmpyHaOTaPxIbqTIzSWj4jt3hmF3G4vZrPfdaWV7rUizDK9CaCqm+R
	 Ylcy9N66GlV6vDDUFBpMpud6fJr8SQmlPflQkHHYWEYZcTEKYOFHR2W4gXX4uKPBSy4uG
	 2LJrEjberV0pp5MDX8flluufplWNgw+P7iVrrYycTq93+hFphj/rfSzlPkO/Xwjo//pqm
	 tlbxLwS4zno4BmthmrlYe7ONJ9QFuO8J/AITAHzyGNsrJHZFMReiEHjqxF53SWpI6nNkR
	 Unto2Eq8sjlID9oh4AfU9s5VTYkjR0FE1Y9NuE2SKq6/Vr7IJkR3I2Uthhj3d5NFgxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031894;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ddlVMXiZ3LjRm3uwING4JfMHdVE9/bykDAvxjKk8jQo=;
	b=vWCCnDw7XuFHwSArEG4/HwKZS0RhgEgg4+WSnB+89xB3Svq4AUBWLVXPqzdljxY1fXN6
	 YIS/ntGr3WsGKX1DKFo7mWP8hXrC3kJ8z/+49Sn26YigXQ5VYMEBZgnlP7tz1Qw91qi0o
	 L+HFPVz9YxfmcOKR2W7+A08kbP+jIeC4nySTDGnGO6a0U4klU27KgxXwm5BBEcxNZ+Y/3
	 6FpOND0rhBsbPSGOFbchjEM/P4excjvXk6TGoAnglLFhJtjiTeun2tfjQLReZR2hxLhbJ
	 6U4accuUJ1beEM5i+ep4rFcHJnX2bYm2rwtXJMlOu/cSt+vUSaFlF5JFRJ1bKbY3U+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NfItfd3o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54770606A320;
	Wed, 18 Nov 2026 19:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NfItfd3o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB6161F000C4;
	Wed, 18 Nov 2026 19:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031894;
	bh=ddlVMXiZ3LjRm3uwING4JfMHdVE9/bykDAvxjKk8jQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NfItfd3oqbaRztzwkXRGH19vBpHZQ3YOklRocBFeTrb0cyZyMfjVEqaps8BpkHJUO
	 +o0yOMizV0wIqXZkg+exJLimTgSerrrnn5hc5I8WT8NwxlWr0xGifDofezd6msEVjc
	 pjmCdJ74Tbd+TXT4ixzN1IqPt3pBy1nc+EnBJ0Qw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1219/1756] Bluetooth: L2CAP: hold l2cap_conn::lock in l2cap_connect_cfm()
Date: Wed, 18 Nov 2026 15:55:46 +0100
Message-ID: <20261118150058.346676207@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 53e784ad51237..053e676fa7863 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -7648,6 +7648,8 @@ static void l2cap_connect_cfm(struct hci_conn *hcon, u8 status)
 	 * we left off, because the list lock would prevent calling the
 	 * potentially sleeping l2cap_chan_lock() function.
 	 */
+	mutex_lock(&conn->lock);
+
 	pchan = l2cap_global_fixed_chan(NULL, hcon);
 	while (pchan) {
 		struct l2cap_chan *chan, *next;
@@ -7672,6 +7674,8 @@ static void l2cap_connect_cfm(struct hci_conn *hcon, u8 status)
 		pchan = next;
 	}
 
+	mutex_unlock(&conn->lock);
+
 	l2cap_conn_ready(conn);
 }
 
-- 
2.53.0



