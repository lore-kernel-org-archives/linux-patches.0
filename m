Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 791FD3148DA;
	Sat, 30 May 2026 17:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162183; cv=none; b=SC/6Ss83CTlTdZESlFDcdnJ7Q03QfUVuJtGSEZTxr05SwF0ZslAuc217IHk/wC62vBibffNyKmaF8EgTuhFd6XJo4jSeOkgOna2gXANHPkbtCuTQAH6qID8xug29IGsXpmboGqg/Oos6T/lQAYxYBbO7/yHKPg5XXoqhlDTLT80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162183; c=relaxed/simple;
	bh=2vswnnwhcCd00by9DCPRktfFGx2nYZwmWGQZtrZSogk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EnMskEoQqWnw+yCAufudM2dAt0/2EZ43g1oerHPwK3fDGX58/MA+iMs0ooLj2v2WyEYz+3rUm/CJlQGEFVbu6SHHO5dT4ff4VUtVqiKmrvBaYJAGlw/o6gU7kcDb4paGmKp4lmTZBrgZWIOMF2n3QDKi8cjv0MQPPH/vICAb/gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iaQd+vkC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iaQd+vkC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBCAA1F00893;
	Sat, 30 May 2026 17:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162182;
	bh=nNfVAJWFRKAbKtINZY6hz9pXL+VzYd1u0Jphsp4KIQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iaQd+vkCeWraC4C6oQVr3UBOLDjBC9pdSnTshQeD7X3/oXxq66hZag6GW0yU9lfWV
	 yaO3ry5eT0aQ+8BpfDb6exNG4CStDAs5PTqrA4qZf8eGBwb210z9qLRwWmpRmdUsPX
	 HvLM/LPvIc1i2Cbb5e4GYmCItJyZ5GfK4NRtcfkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 845/969] Bluetooth: ISO: drop ISO_END frames received without prior ISO_START
Date: Sat, 30 May 2026 18:06:09 +0200
Message-ID: <20260530160323.993467130@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1771,6 +1771,11 @@ void iso_recv(struct hci_conn *hcon, str
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


