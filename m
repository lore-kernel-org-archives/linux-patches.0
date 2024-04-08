Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0407862148;
	Mon,  8 Apr 2024 13:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582390; cv=none; b=nodLlibH4DfOf0+KpBIHl8U4RhveoTMaOg9KNlxe/TdURCCoj1zCo/hv4tb9MnUPYXjk40Uy7vOlU6lO+aEQtFBc4DJhQjIlpjiSEW9btUpyhY/TMnm1T0kjio3b504lIaLXd25xQevhKMAnxJHNStT5Piom+ovDLN9jY6xpZec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582390; c=relaxed/simple;
	bh=7C5G34ju1RmwHPFcIgQ0ksWe6UvklGp+OAsY8XU9c34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UaqGZpD1w6iTNxUrLowZiCO2KcfyH5Qf6TYjFbq5fN07z+c3otmiLeIsNbihCWR78/pKliBo4OoimdQWQKDyT6dCokU8mSvYUcUU5Fe1G+DV6g8L1qsldkeePv4QXbs1aUJfumWT0EeEeX1Dv98EpuDm0eCytIwEzJFaYg7ZMxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jrg77bZW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jrg77bZW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77881C433C7;
	Mon,  8 Apr 2024 13:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582389;
	bh=7C5G34ju1RmwHPFcIgQ0ksWe6UvklGp+OAsY8XU9c34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jrg77bZWKKjZsxkVgUN+B9LJB2M0O/4QOyC5BJr1B4Xr9sprZag7LZbnLMg/A5pT/
	 7zc+kTy86sPdFmN9WtlbCTQovlQw4Hmx9Y6LHBDdV3s+51+sA/tivRILHuJh+WBCj+
	 fptru38vFFYMY/HdffT0HGR3d6sxicHWxjs7xJwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 073/252] r8169: fix issue caused by buggy BIOS on certain boards with RTL8168d
Date: Mon,  8 Apr 2024 14:56:12 +0200
Message-ID: <20240408125308.897304607@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5055,6 +5055,15 @@ static int r8169_mdio_register(struct rt
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


