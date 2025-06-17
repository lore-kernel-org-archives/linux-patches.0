Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985892EA14C;
	Tue, 17 Jun 2025 16:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177500; cv=none; b=P65MSr0CqDaDusrSpuAQjM01h96UmDJtxVOOoZ2M3BaNKS7WAACPCu0npP8H1uaQXYYF4nWEzb7wkCb3PpJu1mG4eUp3VaQ3klCQzve3AolMkH4wPs5Xdqw3V5axfy24bNPsryACPCalwj65Z+GeJKG53uP3eWcbGgQomyHmksM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177500; c=relaxed/simple;
	bh=e3XcgKv4oadElgw1ysarcR+/Kthsdn0C/BNM7dZRNEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NQle9u1nboRFbKtvtWVPXft1b2aM+SAfTrdxsMuzF5iWxrBi2EYjzgfeJNKzW2kI9sEyYbm0PMjLZan0aTJpz3RxmlghT88cEg1TJEKgItBsAudGH6N5994BRwGvLWSRRsc5rhrjxXCQoqvCPwJ55PNcpciS2QNnLPEBjwvw+3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hbai3zV+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hbai3zV+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06033C4CEE3;
	Tue, 17 Jun 2025 16:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177500;
	bh=e3XcgKv4oadElgw1ysarcR+/Kthsdn0C/BNM7dZRNEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hbai3zV+zkn6vkTYzOVsREoGJyQfy3uJHdZHQNu/0e4CBo0VNwa5kBA7I7ZA/PMI5
	 znyspuEMmOyDuWiNPu5a73EU1ITsVe/42hmfpihT+T9hoJR8ku1O6UziiZW784UbPC
	 xauIwcFXgcZDf50RSHRcZmnqv5egsR9hgAME9+0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 355/512] Bluetooth: L2CAP: Fix not responding with L2CAP_CR_LE_ENCRYPTION
Date: Tue, 17 Jun 2025 17:25:21 +0200
Message-ID: <20250617152433.962581007@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 66fa5d6fea6ca..a40534bf9084d 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4835,7 +4835,8 @@ static int l2cap_le_connect_req(struct l2cap_conn *conn,
 
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



