Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD307482;
	Mon, 23 Jun 2025 21:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713368; cv=none; b=eVbqkZWMMrCE67282xHaCJ9Q6VR6osQPb596QgZ+SP+iFT2q4pi560EIXLrHZpAbAe40Mzwiqd+R8WnAYfiG5iGwJ/9RR5Ti4CEEDx5/JGE61OyOp8T6I3G0ZzQIAFQph0sRrSPR32ykfe4Bj98VXsLaDA8tLNk+cRBicpZ8yPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713368; c=relaxed/simple;
	bh=ghr7hRWRO76EnU3eccUabx6rV6EnIFmQ4VSgQHu9c80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gubeJZgOsp8BWeeGisagxg8oPPJWqs9WOyS7TEwGjp+ZscpXx8Q0lsrUihZiy7qWtBVBOYuRBV5DF1fbkX8mJx5xN+RD+ykip1IsRi7D9kQ1X++Cxg3w/ICIuiBZrJE5SVpWI31PBlbUnD+QCz//fp9oc6znbhof3KSqV6lnY20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xg/hnxqX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xg/hnxqX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D64A5C4CEEA;
	Mon, 23 Jun 2025 21:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713368;
	bh=ghr7hRWRO76EnU3eccUabx6rV6EnIFmQ4VSgQHu9c80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xg/hnxqXriT77bMR53aOuwcXZMuJ0k73LaJtQUs5LjOcEmot8g+i/jj5PC6lgH3Cg
	 ornJQDnP1AMYl9oXpzQTprkhFNx1mQpXQhS3w78z4Q314MHN6TUvSUQX4+rG4B7nJR
	 hFll1s/3o3JEVy1MU0T3o0Rw/Fmj5ahMP+H/fr6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 119/411] Bluetooth: L2CAP: Fix not responding with L2CAP_CR_LE_ENCRYPTION
Date: Mon, 23 Jun 2025 15:04:23 +0200
Message-ID: <20250623130636.543023582@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 872a0249f53c8..89021b3b8f443 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -5859,7 +5859,8 @@ static int l2cap_le_connect_req(struct l2cap_conn *conn,
 
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



