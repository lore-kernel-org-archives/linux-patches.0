Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420072DEA95;
	Wed, 30 Sep 2026 18:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794445; cv=none; b=OvTr0XnbbDJ6Dy3VHfzkp7C96p7FhRNQfGe1EcXLw6X0tiT39t6QzvWDjRH4j2GqWIVTB/PVFUVKVPSv5ZWtLur9SsYDcgo133lKnZX0ztAePN+NmuuilhRlvj+/YoUrbek/FJlCaY9ma+2VEdXGpRTDb0a+tKUFYHHRlIl0Y/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794445; c=relaxed/simple;
	bh=PTfCX7bVtw3KGQurbSa7ROl//mLwn3mW3benXJba9DI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tKqs/HxRwbL4Q6uBho/8Qcwmdq0EKKlqp5QBFsDxDSlWnV3blBN+ZUvjvcPmVtD/igIadvma7E+adfD520fdWsoSWZlv6rY8xM2ejW0RljZ1o7XHx06GE69TGNC8FuVBe/8ptHinXF4fgMQ55jtpT2QtiW47wM3yZm6n3OaNhuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GF/+9+bS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GF/+9+bS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C62681F000FF;
	Wed, 30 Sep 2026 18:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794444;
	bh=VMybe0PmTByxW+x9jjrcOWqoyyy62KADftFzifJHrpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GF/+9+bSiXCYxEGb50N+QhipmnJlyvlK0VLsuZfcGoL8ep3ObIyDFr6SqVZgftPKK
	 LXQYqhuwk0zoy9TCt2Op+OBfQZMXu0sWKe5hCC2iZ62tgs/o7r+AW8xFiy+Fm7EgH7
	 0QrbrYSb5HbOFUrpioWLn7Fy4fGhZ0WayPZRUHK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Moelius <sam.moelius@trailofbits.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0213/1193] Bluetooth: L2CAP: validate connectionless PSM length
Date: Wed, 30 Sep 2026 17:14:57 +0200
Message-ID: <20260930152438.935629192@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Moelius <sam.moelius@trailofbits.com>

[ Upstream commit a40a5f922546b3bd7c094d882b29177db4f2abe0 ]

Connectionless L2CAP frames carry a two-byte PSM at the start of the
payload.  l2cap_recv_frame() currently reads that PSM unconditionally
after validating only the outer L2CAP length.

A malformed connectionless frame with a zero- or one-byte payload can
therefore make the parser read beyond the advertised skb payload and use
tailroom bytes as part of the PSM.  A VHCI-backed QEMU reproducer
injected a one-byte connectionless payload and reached the unchecked
read.

Reject connectionless frames that cannot contain the PSM before reading
or pulling it.  This preserves all valid connectionless frames while
dropping only structurally incomplete packets.

Assisted-by: Codex:gpt-5.5-cyber-preview
Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 9643a8aacb96b..0f2fe83215cf3 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -7031,6 +7031,11 @@ static void l2cap_recv_frame(struct l2cap_conn *conn, struct sk_buff *skb)
 		break;
 
 	case L2CAP_CID_CONN_LESS:
+		if (skb->len < L2CAP_PSMLEN_SIZE) {
+			kfree_skb(skb);
+			break;
+		}
+
 		psm = get_unaligned((__le16 *) skb->data);
 		skb_pull(skb, L2CAP_PSMLEN_SIZE);
 		l2cap_conless_channel(conn, psm, skb);
-- 
2.53.0



