Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116B45349D5;
	Thu, 17 Sep 2026 17:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664518; cv=none; b=uBgL3Lphgw5Nyp5IR38W/dJkFKNNq3wv7n5TYmjw+O2c+lhmd54VEhfFsL4rbrRCBVSf9VcCWsTWoC7O9g+iHlGKkCDG0Ed33fdk6Eemr/BQRn5xY5mVO0SnqyBMY5o9C7kyFI4/A+lHbd1BGUTgsep35JZQd6l3ImvpOMjsmBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664518; c=relaxed/simple;
	bh=3P4NSbc4tzjTzuVdwPz7tWa7kM33o7hB+EOfl9KMz20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LLRq4hhQtHcExNsZ7zJ0s+/IZ5yRy4wS5x3uVQLZKNFCeJjiV+gZxorvG/tsjrCCQO9FWXBvMNdi0BQI7KXYQktXQHzj5BiR1rY5H7njdSCiM8thJeDqH8p+o+BGfQHrq3dTI1QYRweXdZep6oHmini37PZP2H4bHCZJ3navxyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BdpX8LGA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BdpX8LGA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21E091F000FF;
	Thu, 17 Sep 2026 17:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664516;
	bh=LjHGkOnQs0OiCd0G6q6pvK5hCNcr+Kf2FttZ7z7vIvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BdpX8LGAghmgIN9W1RoRA8XjUlMW0Obfo7ytDssNrgHxJStazYuJ78iMVQ0IzHolA
	 q3NZilEmooX5ezh+30AllIBMt/71a8MoIynmXiCUWlRSnKEIn8jrjwCg0mgcqG8flq
	 U6L3ZNz789+2gK+eUH0AI0tLpK8FXrymjyMX8t5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Moelius <sam.moelius@trailofbits.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0399/1250] Bluetooth: L2CAP: validate connectionless PSM length
Date: Thu, 17 Sep 2026 16:03:14 +0100
Message-ID: <20260917151602.844342293@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 6133c65b20172..1a38a667ef0b0 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -7117,6 +7117,11 @@ static void l2cap_recv_frame(struct l2cap_conn *conn, struct sk_buff *skb)
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



