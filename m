Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A01325CC40;
	Tue, 11 Nov 2025 01:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823998; cv=none; b=nenDy1K7kyzKNhk1aZn+jmrUtMoHbQDeY8O22GroTM1IUqSZPbix9y/FpR+xnuf8BnYcsT0TqGgpH+Eiznjcgxo9YZWdNLE8bcjjf7in3bo2H5hADswQde6lK/SHEftJd9KwbgnYqFWahRw8L+nTWyP3aom6G6WqqEKy6Ozkqms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823998; c=relaxed/simple;
	bh=swntWXiu6ejr6eXuazvBlD3C2wohGf5KqfHhbvfbWlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jl8m4G8cEonyN+GBAp6Sd+gMAAJKFiSLOc3ABpd+1uqQdxOcbg9IlrttEEtHTpWGnvEPBkbA5BBHPQ2xCKKMHaWdDf/JSXFJy15Km8GTuNVP8sXoyak0zlOhCZGJx/q1Ok8uVfrVCpOa30CS0hdYB31HFz4LOTPAAcFSsdfDakE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nBscdZD3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nBscdZD3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C3EAC113D0;
	Tue, 11 Nov 2025 01:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823998;
	bh=swntWXiu6ejr6eXuazvBlD3C2wohGf5KqfHhbvfbWlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nBscdZD3o1No+wtxyGpFDNj+Bs6z4kD6jnibBCPjsyNi+Ajivi9g+m4tOZlcZ2TRu
	 SR6Rkzgtn7YVrL5AQK4srATsHaadz1UPm6klOGz4qj+sdqxsxoHSmKl0d/JV37MvwJ
	 PaVXL0Z9OTWEp09vrjeTQhMrda4hM96LReFOcUcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 368/565] ethernet: Extend device_get_mac_address() to use NVMEM
Date: Tue, 11 Nov 2025 09:43:44 +0900
Message-ID: <20251111004535.148496214@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4e3651101b866..43e211e611b16 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -613,7 +613,10 @@ EXPORT_SYMBOL(fwnode_get_mac_address);
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



