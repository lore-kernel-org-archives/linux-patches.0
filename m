Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB6E1CDFAC;
	Sun,  7 Sep 2025 20:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757275822; cv=none; b=R3IctgN+eGhDg6XPi0gJ4FC0NDQsP3no3WeruDyAkW5qRtvFOtRS4TRODJSCLgRBKbFcpouZPQG5o983juo6IQMF4DDVuGdSpWhYMNzQ4BSmcTP1MqXmISII9Ajo1RsuqO3bcXQ8dIYbQFyBg3pUo98/bD/StyMUIAJl5ZD1yvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757275822; c=relaxed/simple;
	bh=sYM0xQuBycfTH+jTcBR24nf/zoAc34d56Ie/a7SLAb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TUteJXNG0k/DECCmqGwLsMiiYUfyVJq96+b5p/kUjmEEuBnj8qRUoPO3S3B7hOuLtR/Ve6hV0qW2byYeCQo/Vq6ITc5JmOJLSulDkd6YoVuNT/NIkile+tSO5WXUZpiQvY6JLrmgfhI9FcSMBHdVbXYY7zJrzlN4r1sYw+96CKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sNZ2wJ1Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sNZ2wJ1Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47E1C4CEF0;
	Sun,  7 Sep 2025 20:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757275822;
	bh=sYM0xQuBycfTH+jTcBR24nf/zoAc34d56Ie/a7SLAb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sNZ2wJ1ZimkzzCzMtiI2joYjfr87zlM1M85gcYVVhh8aiiHhsBx36t2nadGvt1yFl
	 KLJftIOsOXyuQM2K8LDMbsVlXIY5dFlCONC6Cupy3O6z1L8ucZs59A4iXtIXOgNvOR
	 5UCmpcSo9fXu9y5z87LgOgOODN9mBwElEPiI76X8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Fort <disclosure@aisle.com>,
	Stanislav Fort <stanislav.fort@aisle.com>,
	Sven Eckelmann <sven@narfation.org>,
	Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 5.4 22/45] batman-adv: fix OOB read/write in network-coding decode
Date: Sun,  7 Sep 2025 21:58:08 +0200
Message-ID: <20250907195601.602492358@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195600.953058118@linuxfoundation.org>
References: <20250907195600.953058118@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Fort <stanislav.fort@aisle.com>

commit d77b6ff0ce35a6d0b0b7b9581bc3f76d041d4087 upstream.

batadv_nc_skb_decode_packet() trusts coded_len and checks only against
skb->len. XOR starts at sizeof(struct batadv_unicast_packet), reducing
payload headroom, and the source skb length is not verified, allowing an
out-of-bounds read and a small out-of-bounds write.

Validate that coded_len fits within the payload area of both destination
and source sk_buffs before XORing.

Fixes: 2df5278b0267 ("batman-adv: network coding - receive coded packets and decode them")
Cc: stable@vger.kernel.org
Reported-by: Stanislav Fort <disclosure@aisle.com>
Signed-off-by: Stanislav Fort <stanislav.fort@aisle.com>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/network-coding.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/net/batman-adv/network-coding.c
+++ b/net/batman-adv/network-coding.c
@@ -1694,7 +1694,12 @@ batadv_nc_skb_decode_packet(struct batad
 
 	coding_len = ntohs(coded_packet_tmp.coded_len);
 
-	if (coding_len > skb->len)
+	/* ensure dst buffer is large enough (payload only) */
+	if (coding_len + h_size > skb->len)
+		return NULL;
+
+	/* ensure src buffer is large enough (payload only) */
+	if (coding_len + h_size > nc_packet->skb->len)
 		return NULL;
 
 	/* Here the magic is reversed:


