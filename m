Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5814132BF5D;
	Thu, 28 May 2026 19:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998170; cv=none; b=VE/4aOuz6ScDZzLFDJBtJKLsRqtf5/SAsRev4rtSFyzMgV+lCqbZ5fHSFHRjHNCf4QQtPIIfElzSM1F+hce3A2Q/NdxFXCk4mluIOt16RLwxDafRz1doSEAYda3JHyeyoO2LUY9lvHabtUVzJ8ZEZ+eWjqgOcz+YH0EP3HWbDyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998170; c=relaxed/simple;
	bh=a4K9obyNSzWIx3pI6N4qSAkTTHQz/zLFyVDb+x3NaWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Or2HE1ltNIuGaRyjJLwGLVL+Q/ltFFQXh2XZZzBkefXooBqVmIJB358owa77H7DGlA4hc3cuRAO9jBS5sRHXc0vA2v1T7X2eBGtoO0AXMm6baFSeV1HDdvKmfp1XErYhA7GH+sdGxC3bLY6/XUkAlzd3ANh6B7/p48CtyWN6P5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NPC10I4P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NPC10I4P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A651F000E9;
	Thu, 28 May 2026 19:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998169;
	bh=RqUFoGx/QSeym2/6i7OI94imQ0cq/J+gftwgK4TYz78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NPC10I4PmMJkKZlOT4NZEiQHZGygTXzyqGE4N6fhUT4iOnoNUYBZ/LnRsxy0ssPMu
	 9Q3iPudbGyuTADTgQ2Y0bItlLFJgjREaSPvNZo3pX/aw79pdYQBOcVjQx3LpxOw9sP
	 6OcGAeVrZLeqMlZbyvnnd+qfCUov2SEwKkcKQOaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.0 042/461] Bluetooth: ISO: drop ISO_END frames received without prior ISO_START
Date: Thu, 28 May 2026 21:42:51 +0200
Message-ID: <20260528194648.118335738@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2594,6 +2594,11 @@ int iso_recv(struct hci_dev *hdev, u16 h
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


