Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D711EDA0F;
	Mon, 23 Jun 2025 21:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714152; cv=none; b=Q73KmKI/nKH2L9GqHcuOOIenMUWBu76c1Rw2CCkdi6CM+gQNweu5Z2onUKINb2bpfSNFsjr3LSgzCMf0jkeOg7odm9ZVI9cT1gCwCzvsg/c59rGtINot0Hwhowv9qxKDhyanLHtZItq5if4kNe3HS1Q4QS1QGHVo5+oG+gGPE3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714152; c=relaxed/simple;
	bh=0R15opTjPN6S5JBiXrkZ0UMYsEuz0x7tptrPX/6Im/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IElI/UaMkyfJjef3qsnwxwLzGFEJHiEPlbqqF0VydLnuqFOsrTclOgcdeVrvQCl2fOGtH/J/5c1ODa+5s466neUo+HWCPWpasFsfGSO8CcKptbQgzUwn5u3im4yjekBNy6bg3ANUvS88VSf7lOAM8eGx9eZaUKNlF0ObOfQhWwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VSzkp2B1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VSzkp2B1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D8BAC4CEEA;
	Mon, 23 Jun 2025 21:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714152;
	bh=0R15opTjPN6S5JBiXrkZ0UMYsEuz0x7tptrPX/6Im/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VSzkp2B1Aq9zuwM7FtAJBybzxRY0+pdsrY5er7FYH+L/kTRzjTBtC1oNeXY4gdAKo
	 q7fDfZV7WSv556pJK3cpgq5OU61XOwFco7F4mkgjzYiI1xWgukM547K8GPCVL10T0c
	 XJCaiO0r2Bw7xLflnLSqKd50GpgQ2skKeaU/6LpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 175/508] Bluetooth: L2CAP: Fix not responding with L2CAP_CR_LE_ENCRYPTION
Date: Mon, 23 Jun 2025 15:03:40 +0200
Message-ID: <20250623130649.579126607@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index cb9b1edfcea2a..550c3da6f3910 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -5883,7 +5883,8 @@ static int l2cap_le_connect_req(struct l2cap_conn *conn,
 
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



