Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 220C0CA40;
	Tue, 16 Jul 2024 15:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144080; cv=none; b=AN39uSaCAUz/Pr/shdBFTrHZGumxKfoHbuhxY1pyEGJLLIhxSHTBQLY7oypMx0uZhj3zXBLJxgdSb/B1+XRUB16xNmWyUts6jwbS17HboCjd7EY2l+3MxX1jE6/c9bBo8LbDLgnZRRPmAcIqTS8qIY27tefJ4XQy/KRVPX1WF4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144080; c=relaxed/simple;
	bh=3HPWZQ/tIdDSX1k5/v37JYFYEo87uagCqAAmpLTgiMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YO9GOI1VNiEyg8XOs7wj8Wl9haYLmD18oXWBbGVQ+kSs8RutMYMLQeeNNOgjEiwX+q5YJrSBfuSiQFkm7BL4Kzs1B7/zLkR8G/EJjH6MZ+CcYKGBPlr8prj9ZHVOitkJiRYCCaIfpMapcl5lgrhZ3rGdOacFEh3EyE7qjrZ1Q9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h5qevYTb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h5qevYTb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91216C116B1;
	Tue, 16 Jul 2024 15:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144080;
	bh=3HPWZQ/tIdDSX1k5/v37JYFYEo87uagCqAAmpLTgiMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h5qevYTbiIhoDKn+MjkYHSaaJFsUxgfr5jUopKu5Uaa/SHdrbEySSxgBVVAXrfkrw
	 swmX7sgYLYSliDTT2Q8P2QeX0kRojmcjUvMjQVLI/RAFArgsep8JWw+cXp1MCfcC+/
	 dw3vDKzXF+LDu0uc3tC8HkckbghXudU2wZnm6I4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 09/66] net: dsa: mv88e6xxx: Correct check for empty list
Date: Tue, 16 Jul 2024 17:30:44 +0200
Message-ID: <20240716152738.521764527@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152738.161055634@linuxfoundation.org>
References: <20240716152738.161055634@linuxfoundation.org>
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
index c401ee34159ad..e57d7bd6e58d6 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -231,8 +231,8 @@ struct mii_bus *mv88e6xxx_default_mdio_bus(struct mv88e6xxx_chip *chip)
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



