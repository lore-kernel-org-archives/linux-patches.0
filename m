Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E963AC0EF;
	Wed, 23 Sep 2026 14:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173199; cv=none; b=Vf19PYLfWfiUYHiImM4BqUBWBvWRicd+0nk9Qb4aCgp2pQDYBqLq9Fz4sYrFMqqHuj0U3RxWiA6o7OxTSkdlb7getIDD4mE1i+Bi5Gk20Y6iv1OsDzpnaL4RaEW7zemR3EKPABOe9R3Fw4D7Oq/fZ822SqEH+0/9AMMMe8XwdNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173199; c=relaxed/simple;
	bh=o0A3S3DIUgMylRww/C6M18EavRHDiTiWoCoEGxZZhJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t4WtCQzEdZgP4vLsGg/gg8fg4ysQgv5Yw1B27P2ke1DRz/Q/lkuc00m1AwSxIkvqcubSh25xk0ObLgAU+7+pT2tiIMFa/KRSjxkNrcKe+2GtGtKubzCzw16XDdnM8qyKkmeE7s2guficNfWKcHra1Eml3mS78t1rUCE1sO2qXVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MfHiAEJC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MfHiAEJC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8621F1F000FF;
	Wed, 23 Sep 2026 14:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173198;
	bh=+bDTOUiOL3+sQT2+CcHRPSauMQBfCJBeEceLfBuEi5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MfHiAEJCUX3XsKT3MaD8uuOIdPqGwzYOe4YFDAXyAp29PRSC1EVRLDWxIO403ncj+
	 VmleV9kKI+n5t5REU+4FMZYD6toZEHQY0cDG47nhhq0Xp9URhCgGFswszEEMe/rn3j
	 Gk8TiRge0tEQh3Y3Wh041pBNZFoTEp+hhgkJxQXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radek Podgorny <radek@podgorny.cz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 171/438] Bluetooth: put the peers on-air address on air when we cannot resolve
Date: Wed, 23 Sep 2026 16:03:12 +0200
Message-ID: <20260923140649.202015502@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Radek Podgorny <radek@podgorny.cz>

[ Upstream commit 4914c499896121ae8b9d5b90f0abc5c8287ff396 ]

An identity address only reaches a peer that is advertising an RPA if the
controller resolves it on our behalf. Where it cannot, the host has to put
the peer's on-air address on air itself.

hci_connect_le() still swaps the caller's identity address for the peer's
cached RPA before creating the connection, but __hci_conn_add() resolves
the RPA back to the identity address when it stores it, so the identity is
what goes out. Storing the identity is right when the controller
translates it on the way to the radio; without LL Privacy, or with this
peer absent from the resolving list, nothing does.

A peer advertising an RPA cannot answer its identity address, so the
attempt burns a full create-connection timeout. That is not merely a slow
connect: a controller without extended scanning cannot scan while it is
initiating, so every dead attempt also takes the scanner off the air for
the whole timeout.

Measured on a CYW43438, which reports neither LL Privacy nor extended
advertising (LE features 3f 00 00 08 00 00 00 00), against a peer
advertising a resolvable private address the host holds the IRK for, with
the connection requested on the peer's identity address:

  before: LE Create Connection to the identity address, public type
          1.61s -> 22.07s, then LE Create Connection Cancel
          LE Connection Complete: Unknown Connection Identifier (0x02)
  after:  LE Create Connection to the peer's RPA, random type
          LE Connection Complete: Success

Advertising reports reaching the host per second, same window, same five
unrelated devices on the adapter:

  before   1s:2   [nothing from 2s through 21s]   22s:5  23s:3
  after    0s:11 1s:5 2s:2 3s:5 4s:3 5s:4 ... 21s:2 22s:1 23s:2

One dead connect costs twenty seconds of scanning for every device on the
adapter, not just the one being dialled.

Keep the RPA in conn->dst unless the controller will translate the
identity address: address resolution enabled and the peer's identity
actually programmed into the resolving list. Testing ll_privacy_capable()
alone would not be enough: it reports the feature bit, not whether
resolution is switched on and not whether this peer is in the list.
Resolution is cleared with the other volatile flags on power-off and
switched off again while suspend pauses scanning, and a peer's IRK is only
programmed along the accept list path, so a direct-connect target, a peer
without HCI_CONN_FLAG_ADDRESS_RESOLUTION, and one that did not fit in a
full list are all absent from it.

With the peer programmed, the identity address stays in conn->dst and the
controller translates it: measured on an Intel controller, the host dials
the identity and LE Enhanced Connection Complete reports Resolved Public
with the peer's RPA in the separate peer resolvable private address field.
With the peer absent from the list the same setup dials the RPA itself.

Everything downstream already copes with an RPA in conn->dst: it is what
every outgoing LE connection stored before 14b06c3a88f7, the connection
complete event names the address that was dialled, and
le_conn_complete_evt() resolves it back to the identity once the link is
up. ISO links keep the unconditional conversion: they are created from an
existing ACL or a periodic sync and never dial this address themselves.

Keeping the RPA is only right while the peer is still using it, which is
why the preceding patch drops the cached RPA as soon as the peer is seen
advertising its identity address. Without that, a peer that turns privacy
off would be dialled on the address it abandoned rather than the one it
is answering on.

Fixes: 14b06c3a88f7 ("Bluetooth: HCI: Always use the identity address when initializing a connection")
Assisted-by: Claude:claude-opus-5
Assisted-by: Claude:claude-fable-5
Signed-off-by: Radek Podgorny <radek@podgorny.cz>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_conn.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 8de98af2fb581..c9466cb2c7c00 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1023,6 +1023,19 @@ static struct hci_conn *__hci_conn_add(struct hci_dev *hdev, int type,
 		if (!hdev->le_mtu && hdev->acl_mtu < HCI_MIN_LE_MTU)
 			return ERR_PTR(-ECONNREFUSED);
 		irk = hci_get_irk(hdev, dst, dst_type);
+		/* An identity address only reaches a peer advertising an RPA
+		 * if the controller translates it. Unless address resolution
+		 * is enabled and this peer is programmed into the resolving
+		 * list, keep the RPA the peer is on air with;
+		 * le_conn_complete_evt() resolves it back once the link is
+		 * up.
+		 */
+		if (irk &&
+		    (!hci_dev_test_flag(hdev, HCI_LL_RPA_RESOLUTION) ||
+		     !hci_bdaddr_list_lookup_with_irk(&hdev->le_resolv_list,
+						      &irk->bdaddr,
+						      irk->addr_type)))
+			irk = NULL;
 		break;
 	case SCO_LINK:
 	case ESCO_LINK:
-- 
2.53.0



