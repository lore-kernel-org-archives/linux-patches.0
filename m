Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B93145B07;
	Thu, 11 Apr 2024 10:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829820; cv=none; b=ZIA64QxYaZi+nTKMguRZH5D98qKZ4uuVr+s4EuwPBZjSMKwguJ/H9Ho13K59NuHZrJllMJTOcCeAODALuY/HUEIqxSzcFdTiRu8e2huJ3xL4O/EFr1zejTjw659/aEAPgBLeSUIzHXc0MelTM8tZkiOaN5lZQ/f/KBg+m2T5K5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829820; c=relaxed/simple;
	bh=QcC+AHd2HbR4AooADNYht3BXV0zcEEB8dO4bTt59bAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OeAkJYn4pNPmqycLsDHce7jcoxEf3A1qe2m0+Mmilj8RZjzg5DrjK+WIlR7KTut/4vk1vcw+4nw5dBfUUQtxGdqc+/3R3Df1c7N/9+3IxCm57g8LnuExQ3FXom0xuLkhSKPNHCGtXAWItDqIx09ncb3w5SzwIcjemHA445uzT3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SqgkrdhD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SqgkrdhD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E8D9C43390;
	Thu, 11 Apr 2024 10:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829820;
	bh=QcC+AHd2HbR4AooADNYht3BXV0zcEEB8dO4bTt59bAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SqgkrdhD9IIa3+HUy+rquDLM94xdXLBbPG5qyszq6HiBl1JfwmlbB+6BJCYo6idif
	 fW0xq6twqgwpjEQSbBf73DU0LjsAA4elXDAfIdi6cAUKqIBVtOeteeTCSEeM6Ocz/7
	 VLvgwEKBKrkLu6weheRS0U0U7Ua7hGo6GKnUvtGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 115/175] r8169: fix issue caused by buggy BIOS on certain boards with RTL8168d
Date: Thu, 11 Apr 2024 11:55:38 +0200
Message-ID: <20240411095423.028888660@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

commit 5d872c9f46bd2ea3524af3c2420a364a13667135 upstream.

On some boards with this chip version the BIOS is buggy and misses
to reset the PHY page selector. This results in the PHY ID read
accessing registers on a different page, returning a more or
less random value. Fix this by resetting the page selector first.

Fixes: f1e911d5d0df ("r8169: add basic phylib support")
Cc: stable@vger.kernel.org
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/64f2055e-98b8-45ec-8568-665e3d54d4e6@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/realtek/r8169_main.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -7303,6 +7303,15 @@ static int r8169_mdio_register(struct rt
 	struct mii_bus *new_bus;
 	int ret;
 
+	/* On some boards with this chip version the BIOS is buggy and misses
+	 * to reset the PHY page selector. This results in the PHY ID read
+	 * accessing registers on a different page, returning a more or
+	 * less random value. Fix this by resetting the page selector first.
+	 */
+	if (tp->mac_version == RTL_GIGA_MAC_VER_25 ||
+	    tp->mac_version == RTL_GIGA_MAC_VER_26)
+		r8169_mdio_write(tp, 0x1f, 0);
+
 	new_bus = devm_mdiobus_alloc(&pdev->dev);
 	if (!new_bus)
 		return -ENOMEM;


