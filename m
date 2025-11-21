Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB72D341ADF;
	Fri, 21 Nov 2025 13:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732776; cv=none; b=Vt0uKfJerXOK+79H32odaqTAkOao/ksTZlRR+nMAutv32b3TS4JpgIiJjpAVtDaRQeZtSTTT1qt6EqqEVzPpnJN01CFm6DHrqe3mR/p73lT+FPjzn7GUwGqojd50MEplvJumNF9+9dutHuftU08T6TFbP82ymGXuhH2gXHLfKRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732776; c=relaxed/simple;
	bh=wMk3WpWS6Hz57VXqi6I+TG4Hw3MLMc6QMuwTJGwXlbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bC4ySDwm2K01Pl+LbJIj6bY0kH/hqR1JzoZbjtkOpWFsobAdQmtltFSVEWDIk5WosXudIZDwiltFFE8xD7TRgOqIB7zMk+NozO0W5nnEaowuQZ/+ajMpj4s6vYHmEHol8Kmdym6o4905K/ZltrlCugcBOsRsnKfF/KFjv43NpUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GekpKoJj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GekpKoJj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EF35C116C6;
	Fri, 21 Nov 2025 13:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732776;
	bh=wMk3WpWS6Hz57VXqi6I+TG4Hw3MLMc6QMuwTJGwXlbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GekpKoJjejcgov4kif1RpibzFhfaR4LzNBVdMsadRFUIyFPCbmMHYvsCP8swVpL8q
	 7/q9NVxkNV/Y5H0rgplWiIlkPc4SVVSu7sp0WTFrPHdQjnddpYQC0lnapWF6YvxWlU
	 Lz6/hBDwU44Y8Fp9kkxj/FTouxSLDfIt264HN3Sk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 238/529] ethernet: Extend device_get_mac_address() to use NVMEM
Date: Fri, 21 Nov 2025 14:08:57 +0100
Message-ID: <20251121130239.486898216@linuxfoundation.org>
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

From: Stefan Wahren <wahrenst@gmx.net>

[ Upstream commit d2d3f529e7b6ff2aa432b16a2317126621c28058 ]

A lot of modern SoC have the ability to store MAC addresses in their
NVMEM. So extend the generic function device_get_mac_address() to
obtain the MAC address from an nvmem cell named 'mac-address' in
case there is no firmware node which contains the MAC address directly.

Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250912140332.35395-3-wahrenst@gmx.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethernet/eth.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index 049c3adeb8504..b4a6e26ec2871 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -615,7 +615,10 @@ EXPORT_SYMBOL(fwnode_get_mac_address);
  */
 int device_get_mac_address(struct device *dev, char *addr)
 {
-	return fwnode_get_mac_address(dev_fwnode(dev), addr);
+	if (!fwnode_get_mac_address(dev_fwnode(dev), addr))
+		return 0;
+
+	return nvmem_get_mac_address(dev, addr);
 }
 EXPORT_SYMBOL(device_get_mac_address);
 
-- 
2.51.0



