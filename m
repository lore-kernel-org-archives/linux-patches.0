Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AFBC216E1B;
	Tue, 26 Aug 2025 12:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213195; cv=none; b=DASwwdyUtCc4fyI6WTixpqG0UET3bz6z8jOjRVqW8kSwEeBUqPgSNMNfv2til8DPEygcaz/Mg89EAWiM4lnULdlTcNPS/DPJS4qozNKDthmo25IJGQ6Z35/GhgzUgV2vUU3Hu4Dk3tlwa6NrjD70Fz2+MgbOvV3CzcDfC4cXHMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213195; c=relaxed/simple;
	bh=wSlwFxX0TDAMIonkgj2XYgGaMzISJ99Xq2VqXl+z/hw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bOIpTje5cLEO1Zkqzbrcx57yuCrRVZ7wGoE7SVw7s9nadIKzOYL0myBNk4Vo6khnyaX7ffYlYhC6uhDWuz34Fa/PIGRRtfUGBJjWsIG2I0mwdZw6R5XjLCLJZa+ABh1qMxuvFbKS1s0cGhWSdA+v4AImzNa4kau0qXNoyeXf1Y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tJRFFCCv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tJRFFCCv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D554C4CEF4;
	Tue, 26 Aug 2025 12:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213195;
	bh=wSlwFxX0TDAMIonkgj2XYgGaMzISJ99Xq2VqXl+z/hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tJRFFCCvIHmee9CGSIQvEY5ZSmvgEwNuVprY7WMb0Tl7XUu0s1KcBCkhoMf7oM6eE
	 glMDOPf1yY0ORT8SD2j/oWJOYPd68E/8mZIYUZviZkSRR559I5n4m6YkUnhHhGQfzg
	 7kJz20ypNWfaE+yMmitmyjkrc7dTnm65PeDn3WXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wens@csie.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 225/587] mfd: axp20x: Set explicit ID for AXP313 regulator
Date: Tue, 26 Aug 2025 13:06:14 +0200
Message-ID: <20250826110958.659723222@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 87603eeaa277..2b85da0fcf27 100644
--- a/drivers/mfd/axp20x.c
+++ b/drivers/mfd/axp20x.c
@@ -936,7 +936,8 @@ static const struct mfd_cell axp152_cells[] = {
 };
 
 static struct mfd_cell axp313a_cells[] = {
-	MFD_CELL_NAME("axp20x-regulator"),
+	/* AXP323 is sometimes paired with AXP717 as sub-PMIC */
+	MFD_CELL_BASIC("axp20x-regulator", NULL, NULL, 0, 1),
 	MFD_CELL_RES("axp313a-pek", axp313a_pek_resources),
 };
 
-- 
2.39.5



