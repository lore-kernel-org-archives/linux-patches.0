Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F43340DAD;
	Mon, 18 Aug 2025 14:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525790; cv=none; b=EkwkJMHHOXHRU/B0ONsrwJh9Cv7x9SdzxSC95KeDIfj6ZDiexC6xWyFodMOfAU7cMXEOkWDkq4NNRTezFLLHhgCAfi3SjksEmOZ+YootStrklVX1QjwjZUy9yVRD+OZ0piuFSpVB5VxpQE7eSaWhI+08W8kX3cA3YVaMZLgQaYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525790; c=relaxed/simple;
	bh=N5JCx3rmLYo7CqZEyf7dK6x2o90aI1M8XE4R4OuAAe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mdNMFbybYmPz6l3PehJ+Muza3KorO+e36uZNz9oUTu0ROE1JbSoKg4mLOcRV9dhqFPN1+OREusS+phzcAHNHbRqM43AHOQNoNzcxt36+ULwGb5dVnSm93wuAnIYx7tlTGihlDfN2aEm7EqqaP9zS5g3DwOrZ5InYXKkIEJ4TpnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0FoxYd+d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0FoxYd+d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E34E1C4CEEB;
	Mon, 18 Aug 2025 14:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525790;
	bh=N5JCx3rmLYo7CqZEyf7dK6x2o90aI1M8XE4R4OuAAe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0FoxYd+dPvub9Eg6A5NX+n5GH1lnt6hezn1e/htQKpny8YGAIs7xMvQ+4yLu2R0sA
	 0IJbBNnjIskJBTZ9jCJSHkXGcm/QtsmEa/1OQbLzcIOKc+sgkhEh3BUqofdGBMZZYk
	 Ttvpjx/jPnlnU9HQwuYydBAHqAyN+QgAjAbaBkV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wens@csie.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 367/570] mfd: axp20x: Set explicit ID for AXP313 regulator
Date: Mon, 18 Aug 2025 14:45:54 +0200
Message-ID: <20250818124519.997666624@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wens@csie.org>

[ Upstream commit 88828c7e940dd45d139ad4a39d702b23840a37c5 ]

On newer boards featuring the A523 SoC, the AXP323 (related to the
AXP313) is paired with the AXP717 and serves as a secondary PMIC
providing additional regulator outputs. However the MFD cells are all
registered with PLATFORM_DEVID_NONE, which causes the regulator cells
to conflict with each other.

Commit e37ec3218870 ("mfd: axp20x: Allow multiple regulators") attempted
to fix this by switching to PLATFORM_DEVID_AUTO so that the device names
would all be different, however that broke IIO channel mapping, which is
also tied to the device names. As a result the change was later reverted.

Instead, here we attempt to make sure the AXP313/AXP323 regulator cell
does not conflict by explicitly giving it an ID number. This was
previously done for the AXP809+AXP806 pair used with the A80 SoC.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Link: https://lore.kernel.org/r/20250619173207.3367126-1-wens@kernel.org
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/axp20x.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/axp20x.c b/drivers/mfd/axp20x.c
index e9914e8a29a3..25c639b348cd 100644
--- a/drivers/mfd/axp20x.c
+++ b/drivers/mfd/axp20x.c
@@ -1053,7 +1053,8 @@ static const struct mfd_cell axp152_cells[] = {
 };
 
 static struct mfd_cell axp313a_cells[] = {
-	MFD_CELL_NAME("axp20x-regulator"),
+	/* AXP323 is sometimes paired with AXP717 as sub-PMIC */
+	MFD_CELL_BASIC("axp20x-regulator", NULL, NULL, 0, 1),
 	MFD_CELL_RES("axp313a-pek", axp313a_pek_resources),
 };
 
-- 
2.39.5



