Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C395D223328;
	Thu, 28 May 2026 20:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000488; cv=none; b=CcnTEcmwgysqlkuo8bvFFVkhyTdhImEv7ieA0AKIGHmYPGdwLTmKNBiC5GoZ9O8UKf583bZmPbNUsfxES42cx5EK+x5ZutR/jqL5tEpCrFBTHX4J7+m/8uvsRzMOILd0/QQk0BLPDf98LrXnEY2oJGt4mGYPYJfKU+RBl471HxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000488; c=relaxed/simple;
	bh=iPyEJFYZaXDmX8bYoDaE6itN1xSN1SX//t0jLi/Qz6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aGdYjaCkWmNg48foq0lxNoD6pEMQvhoNWVlnd47fNTYB+tcAoIOuUzTNgBZvy02DvJx/vhlAKeR+ysfyI/y+N9bC08ao1vtfXX2mHaWToAK21Mn3Cc819movc2T2nXFn/VRTaKtHI1O2UkbQN3gnCh/hQh92SKTFvL4t9diA6yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V/gD3Hx2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V/gD3Hx2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EFD11F000E9;
	Thu, 28 May 2026 20:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000487;
	bh=9aSkkHmH2/JTBuKi+P96e/9KFTe+6ZDhIjoVoARJwLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V/gD3Hx2+qSksesJhMEB1YwEnHLZfow1ykZcfn1JE/8Mjon19sRqH4vVVIAn26k1Q
	 2UI3NjvLJZ+RqJvl27kDvu/puMwM1hgIbxR4+gthstvw2EHov6oPMi+qPCMY8Toi8m
	 RvrdC0gJTziULOSH07FrbCjqt9F/kK8aMmbKtlEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 063/272] Bluetooth: ISO: drop ISO_END frames received without prior ISO_START
Date: Thu, 28 May 2026 21:47:17 +0200
Message-ID: <20260528194631.142166750@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

From: David Carlier <devnexen@gmail.com>

commit 84c24fb151fc1179355296d7ff29129ac7c42129 upstream.

ISO data PDUs carry a packet-boundary flag indicating START, CONT, END
or SINGLE. The ISO_CONT branch of iso_recv() guards against a missing
ISO_START by checking conn->rx_len before touching conn->rx_skb, but
ISO_END does not.

If a peer sends an ISO_END as the first packet on a fresh ISO
connection, conn->rx_skb is still NULL and conn->rx_len is zero, so
skb_put(conn->rx_skb, ...) dereferences NULL and oopses. For BIS,
where receivers sync to a broadcaster without pairing, any broadcaster
on the air can trigger this.

Mirror the ISO_CONT check at the top of ISO_END so a stray end fragment
is logged and dropped instead of crashing the host.

Fixes: ccf74f2390d6 ("Bluetooth: Add BTPROTO_ISO socket type")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: David Carlier <devnexen@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/iso.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -2319,6 +2319,11 @@ void iso_recv(struct hci_conn *hcon, str
 		break;
 
 	case ISO_END:
+		if (!conn->rx_len) {
+			BT_ERR("Unexpected end frame (len %d)", skb->len);
+			goto drop;
+		}
+
 		skb_copy_from_linear_data(skb, skb_put(conn->rx_skb, skb->len),
 					  skb->len);
 		conn->rx_len -= skb->len;


