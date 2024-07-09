Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D4B55E4C;
	Tue,  9 Jul 2024 11:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524650; cv=none; b=H3pf7zyVdm9FZEI6+w7FhdD53XKgh54NA+1m9kGG0z/Vq0DaP5/ZaTvi07n6hphcK3laPpDfcgwojXinJv35Xsfw8R8nULViwW88jzWYSs8D7JIrtQBZv5kz3M9X49hbKLAJHBODfDZfewHGw0WO37IlAqn7b090sWEPKxSwWBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524650; c=relaxed/simple;
	bh=N//z5jEvCwjK7TndLZ7FcGAPjChK7ShvwDaRihrS4SY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tg63cq2lMJ1vMqEpudjzdiea0s9EO8ZcC15zDnXOjNoA7c1FfB0Mh64ITbrIRMXOIRzEyFqk6wvLv2peX+Kg5eYujeubXMfy3K1hiIv8p4k+lI+H1eK4HVlovWEvuhBIcHboyLAAW0pVbYlJ0QbANu4070fKoSp7n2/cvGeF8LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dijB4dET; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dijB4dET"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29FD3C3277B;
	Tue,  9 Jul 2024 11:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524650;
	bh=N//z5jEvCwjK7TndLZ7FcGAPjChK7ShvwDaRihrS4SY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dijB4dETldCW7lg8Nydmku1rSfZhboEBnqTMP8GslO2NSindyDSHwZKpuVOwewVGw
	 NXSLlPiwRFrCjBzquZq2wdqmr4TLTbD1AbZGaGCKHOLf8iykcHKs1BW02QUXsd4nHE
	 STBPcm/+PEcdpWrtZTPJkYGPIcK3BxDlpDoMxnjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 023/102] net: dsa: mv88e6xxx: Correct check for empty list
Date: Tue,  9 Jul 2024 13:09:46 +0200
Message-ID: <20240709110652.271794014@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Horman <horms@kernel.org>

[ Upstream commit 4c7f3950a9fd53a62b156c0fe7c3a2c43b0ba19b ]

Since commit a3c53be55c95 ("net: dsa: mv88e6xxx: Support multiple MDIO
busses") mv88e6xxx_default_mdio_bus() has checked that the
return value of list_first_entry() is non-NULL.

This appears to be intended to guard against the list chip->mdios being
empty.  However, it is not the correct check as the implementation of
list_first_entry is not designed to return NULL for empty lists.

Instead, use list_first_entry_or_null() which does return NULL if the
list is empty.

Flagged by Smatch.
Compile tested only.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240430-mv88e6xx-list_empty-v3-1-c35c69d88d2e@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index dc4ff8a6d0bf5..4938550a67c02 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -131,8 +131,8 @@ struct mii_bus *mv88e6xxx_default_mdio_bus(struct mv88e6xxx_chip *chip)
 {
 	struct mv88e6xxx_mdio_bus *mdio_bus;
 
-	mdio_bus = list_first_entry(&chip->mdios, struct mv88e6xxx_mdio_bus,
-				    list);
+	mdio_bus = list_first_entry_or_null(&chip->mdios,
+					    struct mv88e6xxx_mdio_bus, list);
 	if (!mdio_bus)
 		return NULL;
 
-- 
2.43.0



