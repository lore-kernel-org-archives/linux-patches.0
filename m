Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D14C5304D1;
	Wed, 23 Sep 2026 14:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173550; cv=none; b=FznvGUTlydpeqD1ndos8PehVfG0CLSoZEFFWrvGO6LQH7LVOnBlA+SaXZevdVdyLIqRS0hGl+dveM3pY83S/Qd2PYmGZm2INobQuUK54RkT/3m1+T582l3zThpUTQNEOLlX9Hv+e2oFto9wsyPOHFj6RDuMWS45zlJYNwI9g5d8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173550; c=relaxed/simple;
	bh=eL5+PD8bXeoTqtqCzopZqila1S3P4IgR7LEySpOo9GI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pV8oNWChVVqy17YRapoPh/KAgnYUBii+X+zSJ6UVvGgf3emwzgak4pIZsBj0NDjMm1NKVYFgnT12sgGb14j+Haoqev+URSEBVJFqsmW7GmEj8QX9iGT0EA60g9Ui7dbVJO8i2r2Of2PjMyHM3qNGcw7qPrZleH69z7MHezAkqxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IKUcJwne; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IKUcJwne"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 756591F00898;
	Wed, 23 Sep 2026 14:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173549;
	bh=1lKhuG0IBfx5iGZg4saKHpiIReN9qWtxlRQ4w/1JZuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IKUcJwneMn5Hu2JfHNCP+tkUBGCFWcm19HT7wGn0igvJryGLpkqpZKGmdhHtbTA/k
	 xAHBKK/U8OTjxTL7+7G3fQMjVJ/LgkTJhviaQ7aK4MKaEfE5t0qLmFYXkSb2qNvp8f
	 MqLDPbULqajsODXFp33OYDWJNZxpwamaEYOelRFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radek Podgorny <radek@podgorny.cz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.2 281/438] Bluetooth: keep dst_type with dst when reusing an LE connection
Date: Wed, 23 Sep 2026 16:05:02 +0200
Message-ID: <20260923140652.059056792@linuxfoundation.org>
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

commit 555cd2bd860e7c4bdc3f4e4405b05515b0d9bc87 upstream.

hci_connect_le() swaps the caller's identity address for the peer's
cached RPA when one is known, and stamps the matching
ADDR_LE_DEV_RANDOM on the local dst_type. On the conn-reuse path only
the address is copied into the connection:

  if (conn) {
          bacpy(&conn->dst, dst);

so conn->dst ends up holding an RPA while conn->dst_type still names the
identity it was resolved from, and hci_le_create_conn_sync() puts that
pair on air unchanged. An RPA declared as a public address is not
something any peer can answer.

Measured on a CYW43438 against a peer advertising an RPA the host holds
the IRK for, connecting to the identity address over a raw L2CAP socket.
The first attempt creates the connection, the second takes the reuse
path:

  LE Create Connection  3C:78:95:78:37:C3  type public
  LE Create Connection  5B:75:A2:26:D6:18  type public
  LE Connection Complete: Unknown Connection Identifier (0x02)

The second address is the peer's RPA. btmon annotates it with an OUI
lookup rather than "(Resolvable)" precisely because the command declares
it public; the same bit pattern annotates as resolvable once the type is
right.

The mistyped pair is also why nothing downstream repairs it.
hci_bdaddr_is_rpa() tests the type before the address, so an RPA carrying
a public type is not recognised as one, and hci_find_irk_by_addr() then
searches for an identity address that does not match it either.

Copy the type along with the address.

The assignment used to be unconditional just below this block and covered
both paths; it moved into hci_conn_add_unset(), which the reuse path does
not go through.

Cc: stable@vger.kernel.org
Fixes: 14b06c3a88f7 ("Bluetooth: HCI: Always use the identity address when initializing a connection")
Assisted-by: Claude:claude-opus-5
Signed-off-by: Radek Podgorny <radek@podgorny.cz>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_conn.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1518,7 +1518,15 @@ struct hci_conn *hci_connect_le(struct h
 	}
 
 	if (conn) {
+		/* dst may just have been swapped for the peer's RPA above, and
+		 * dst_type describes dst -- it has to travel with it. Leaving
+		 * the identity type behind makes the pair describe a peer that
+		 * does not exist, and nothing downstream repairs it:
+		 * hci_bdaddr_is_rpa() tests the type before the address, so
+		 * the RPA is never treated as one.
+		 */
 		bacpy(&conn->dst, dst);
+		conn->dst_type = dst_type;
 	} else {
 		conn = hci_conn_add_unset(hdev, LE_LINK, dst, dst_type, role);
 		if (IS_ERR(conn))


