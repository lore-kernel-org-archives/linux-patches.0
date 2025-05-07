Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5914A2116E9;
	Wed,  7 May 2025 18:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644085; cv=none; b=WDxJVxf94MS1emQ37vGbCPb8q35xOy0jyuI7Vsh0VvXUSik0uE0wu9KkQy/10qZmWy1F/ac0W0LorQ60czsoB+x0Tts7n/txv2QlbLZT6PG8KyU4NypbYPKeACe7k8K1wYEq/St6X7P61OhhHmvKXuY7emOH4qwuTK6zu3IzcBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644085; c=relaxed/simple;
	bh=MAkh9KMvDcLoqtxYgotNC4lVhhLdteP8lVSZI+2wcIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B88ll16SvV7MfS50CliGvZfcCqcUIePHejuMh8b9uNxXRfLNAdnrcpbglE3pfU+rTdonSrMT5J6firxLFYVT1kEJw0yo/7L6TYT/gUW/lx6qcyez/qdgiHjVRTDl5Nj7ny+PrCCOv6J4xd/x66WB3a5iJT+aU7v6Pmtd3dbKs8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X650ysmc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X650ysmc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0F2AC4CEE2;
	Wed,  7 May 2025 18:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644085;
	bh=MAkh9KMvDcLoqtxYgotNC4lVhhLdteP8lVSZI+2wcIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X650ysmcEDZXsNDmPSyL24+HGl3vxffPepaaNx+f063EBYUr5Ck8bfEhD4Ugz2MJ4
	 jnNfg4bgrWsn55hTD490l23iH2yj3fhMDppCqIv4R/8lPlZU6EOs/z9BGiGUJS0aT5
	 M82tnJDytuoAqzWHJINqtD0n1GAqCuIwpJGtTekA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 085/183] Bluetooth: L2CAP: copy RX timestamp to new fragments
Date: Wed,  7 May 2025 20:38:50 +0200
Message-ID: <20250507183828.274504823@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit 3908feb1bd7f319a10e18d84369a48163264cc7d ]

Copy timestamp too when allocating new skb for received fragment.
Fixes missing RX timestamps with fragmentation.

Fixes: 4d7ea8ee90e4 ("Bluetooth: L2CAP: Fix handling fragmented length")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index a55388fbf07c8..c219a8c596d3e 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -7380,6 +7380,9 @@ static int l2cap_recv_frag(struct l2cap_conn *conn, struct sk_buff *skb,
 			return -ENOMEM;
 		/* Init rx_len */
 		conn->rx_len = len;
+
+		skb_set_delivery_time(conn->rx_skb, skb->tstamp,
+				      skb->tstamp_type);
 	}
 
 	/* Copy as much as the rx_skb can hold */
-- 
2.39.5



