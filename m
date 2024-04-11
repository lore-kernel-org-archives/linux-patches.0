Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0AF146A90;
	Thu, 11 Apr 2024 10:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832098; cv=none; b=aDjgiA2TUqfMMf+/d3Tc60dvsGz5pQK+ghVBVO78r1Z/N/dlDbal+OI18FRGwQwItFr7uBnyYdoaNbqmWjiNnA09AJ9vVnCUbf/hIOLiHUR+1VmNtMA1+UCtEqah7EBO9UG4NrcS/ZXaJbHNYQnrDEqppQoKULteNN4JGoGCphc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832098; c=relaxed/simple;
	bh=fpS5Want0dFfhhXKGJff2M7XxRLwAcAmK9+KqUngcz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L26qe2MRQ1ueCGownvJWsvzJTa/HLJl2dKMNUIDsVpZItx8yBfJ5I/BJbgU39tArrHpSZi7nF8gn072SyUD+P5q95p92kR77FrqeuSCUmrKWbzp/zlxynk5hnozcnWtUJZ9MDPy5KtC0kUgMpNKUk+PPBtEFlHaX0u67fMZYfkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cKOe2Q01; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cKOe2Q01"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A73BEC433F1;
	Thu, 11 Apr 2024 10:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832098;
	bh=fpS5Want0dFfhhXKGJff2M7XxRLwAcAmK9+KqUngcz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cKOe2Q01G4nAho/Igj4Drmq4qra1EhOqPhemDVPdgMqiwVgf1BFrvWcEsg/BNdsSt
	 S3yB+/I4JKRTFJzqdhw8Q5FDSoEW/uQ86jkH7xz0MIZY+SJiyfDm6nq3PGOGxZVtz6
	 1M+qJiOrWc7g7KXzifdpzhhNmSgCBkDmPZQKs44Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 189/294] r8169: fix issue caused by buggy BIOS on certain boards with RTL8168d
Date: Thu, 11 Apr 2024 11:55:52 +0200
Message-ID: <20240411095441.306190743@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5181,6 +5181,15 @@ static int r8169_mdio_register(struct rt
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


