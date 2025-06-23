Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E214C7F;
	Mon, 23 Jun 2025 13:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685126; cv=none; b=Ib9YAqOGKJMhl6O34QcqgR65kXO/ev551aZk3OHlJCLJU5NXMwTNNh3+5g4wTcESQem21uxzM8Z+dhU1ErRg12H5XMiSMQfYQmmziMU7NOEMRbTm+YKsbtJNovU6BG2eFwoK6cEgSNWYoZQtzdB7uM+kq6U1wvZR5Dt+TYomUpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685126; c=relaxed/simple;
	bh=v7UrQeSkpp7WxNx5625/jnurgsPjE7eRPuary8gZ2KA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MV3DEaJPve6NfAZaBdSnLG3VIYk7S8CkmiqeGHVZUYbMz7Nyvplnq7PkCy642FymtAgNnrDJuv1lg0rzszJFbZPM154JWCjhWaVmEcptYmJEKb8tnSuF5e3pbB5LAsT3slDRD5ypGnDwiRWF5kX09AxIl/SmcEZV3eb+vzqJ7Z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ge1p44az; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ge1p44az"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF428C4CEEA;
	Mon, 23 Jun 2025 13:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685126;
	bh=v7UrQeSkpp7WxNx5625/jnurgsPjE7eRPuary8gZ2KA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ge1p44azb51gIHYTkUc6nlDENQMq2BbiZRcS+dmeVLZoPRNOHLmFwP9eFExMapdZh
	 4fSKcOQbVyDXptJjmWLk65MhUM5HpYLIFXULeBP7NV04pf8rRLF3RIWOGAZMTGlpQc
	 4VUOy/3k3KAuSaEVfgyWPuEfJvsK7UD7cQfPpVjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 068/222] Bluetooth: L2CAP: Fix not responding with L2CAP_CR_LE_ENCRYPTION
Date: Mon, 23 Jun 2025 15:06:43 +0200
Message-ID: <20250623130614.149893731@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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
index 874f12d93bfa2..dc9edf8fc336a 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -5578,7 +5578,8 @@ static int l2cap_le_connect_req(struct l2cap_conn *conn,
 
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



