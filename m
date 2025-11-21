Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585BF34F465;
	Fri, 21 Nov 2025 13:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732187; cv=none; b=jZX6XWmn1awntvE+m+k684hTdFLtMfrLbA5V0YxtQ3JIXcyofPQ3kj6Zh8KK3rRtuV9RxTmjBt78/qnDG/7faWqHkrMARrn8O1IhOjlmW6VtWFEkdfV6uvPuiLO5u/Recci2HXbdAFqCQ6zpPDE/4s7VMXVsFFGiYT0UJ3Vtc9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732187; c=relaxed/simple;
	bh=BWw4lTAPtoWFbaUxBX4V1FwgGHAhV1vj9eeoiYNw7as=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DPEr52MS0lOlPoIFpcXZS4dpAdjd+45ycLK/8GH3dm1NUYOmDJX2o2zEZV+5kV6k8nVHy/ENs5xKIqpqZeuRopncBi4K7zSCwv8w8TVv4X4ozT6rCDC29ysCfInuZGIquRLf03UnEcZ+YrXBLbpJK7wbmTREuayce4KN0GodoEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d3JKcTjC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d3JKcTjC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F406C4CEF1;
	Fri, 21 Nov 2025 13:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732186;
	bh=BWw4lTAPtoWFbaUxBX4V1FwgGHAhV1vj9eeoiYNw7as=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d3JKcTjCFfsKjL29EEqu3Sq2dOqBS/7S4h4dMHWiTcCgOPOY0AsinaXdUILHGX92L
	 1LPBAUuTvWXPFy9Bs2IpKOHXKLmRapThIlF1QmYyM6INcFXJy/85CHf9RZaXHrmh64
	 TV4gWMg34gj7OhPoyPyjjNuSPa1V4h04gKHWu9B8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 034/529] Bluetooth: ISO: Fix another instance of dst_type handling
Date: Fri, 21 Nov 2025 14:05:33 +0100
Message-ID: <20251121130232.213360368@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit c403da5e98b04a2aec9cfb25cbeeb28d7ce29975 ]

Socket dst_type cannot be directly assigned to hci_conn->type since
there domain is different which may lead to the wrong address type being
used.

Fixes: 6a5ad251b7cd ("Bluetooth: ISO: Fix possible circular locking dependency")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 69529a3049e74..1469e9b69e631 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -1782,7 +1782,13 @@ static void iso_conn_ready(struct iso_conn *conn)
 		}
 
 		bacpy(&iso_pi(sk)->dst, &hcon->dst);
-		iso_pi(sk)->dst_type = hcon->dst_type;
+
+		/* Convert from HCI to three-value type */
+		if (hcon->dst_type == ADDR_LE_DEV_PUBLIC)
+			iso_pi(sk)->dst_type = BDADDR_LE_PUBLIC;
+		else
+			iso_pi(sk)->dst_type = BDADDR_LE_RANDOM;
+
 		iso_pi(sk)->sync_handle = iso_pi(parent)->sync_handle;
 		memcpy(iso_pi(sk)->base, iso_pi(parent)->base, iso_pi(parent)->base_len);
 		iso_pi(sk)->base_len = iso_pi(parent)->base_len;
-- 
2.51.0



