Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7873E2CCC5;
	Tue, 17 Jun 2025 16:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178851; cv=none; b=YSeKDmhakJkd8VWH0S/va22yttNqz54kvvKIBaHFY9uh+tXDni8b+iyeMnmu1vgHTZkSKAkGfmf4YgWA08UcOsNR1k+zZCam+KSa3TwWYgXrBuc0CX9CUuiE24N5x/KQSQLd9Hr3EETKkT1wQBMILNhhZNwjBBbet+KjySQhErA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178851; c=relaxed/simple;
	bh=CFND/5s+5pJuKgF9/RjZ8tvisOZ3fxqIYmndePlhk7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PAkYoU1pcZFxwB/I0NFVIjl6HBZSccfaEsDk0DZd2pnit1ngvXES9vYLezRfuj6fpnBVLri9VwIxA70mVUi3FSZ3t68HSzgcl5T/UulSrifXUCrnbDH92QlHTZNWK2wwMjWo/kC+p1d+AIjm3iQTNfxa++goh90/S+hZVhvNfLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1FcDjDpA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1FcDjDpA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCB7EC4CEF0;
	Tue, 17 Jun 2025 16:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178851;
	bh=CFND/5s+5pJuKgF9/RjZ8tvisOZ3fxqIYmndePlhk7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1FcDjDpAWLU8PjIQcenGVp6KNBu+IjWhuJso3bfeZVCY7V93doPXwlbUd3qou8qtn
	 KLBi9+/LIBHgKz6lk7xcEaCFbL8OP8Bm5dmPcz66Pl7pnv3wSLe1DZ1dGDac2hWoOh
	 70cVZxJVQMiZeC1Vhtfg08ZbtPSAhdC3jSjWeK3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 570/780] Bluetooth: L2CAP: Fix not responding with L2CAP_CR_LE_ENCRYPTION
Date: Tue, 17 Jun 2025 17:24:38 +0200
Message-ID: <20250617152514.688924226@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 03dba9cea72f977e873e4e60e220fa596959dd8f ]

Depending on the security set the response to L2CAP_LE_CONN_REQ shall be
just L2CAP_CR_LE_ENCRYPTION if only encryption when BT_SECURITY_MEDIUM
is selected since that means security mode 2 which doesn't require
authentication which is something that is covered in the qualification
test L2CAP/LE/CFC/BV-25-C.

Link: https://github.com/bluez/bluez/issues/1270
Fixes: 27e2d4c8d28b ("Bluetooth: Add basic LE L2CAP connect request receiving support")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 042d3ac3b4a38..a5bde5db58efc 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4870,7 +4870,8 @@ static int l2cap_le_connect_req(struct l2cap_conn *conn,
 
 	if (!smp_sufficient_security(conn->hcon, pchan->sec_level,
 				     SMP_ALLOW_STK)) {
-		result = L2CAP_CR_LE_AUTHENTICATION;
+		result = pchan->sec_level == BT_SECURITY_MEDIUM ?
+			L2CAP_CR_LE_ENCRYPTION : L2CAP_CR_LE_AUTHENTICATION;
 		chan = NULL;
 		goto response_unlock;
 	}
-- 
2.39.5



