Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0B8128816;
	Tue, 30 Apr 2024 11:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476695; cv=none; b=UOpmbxgUA3biquBc3gKckthnpXPXWKVfMDuTxDkI5vy5OWSqE9SfEaDnpNsKqW7iLXsmP5bn+zlETcXe1toEHuqSk5ESd2UiKepSKLpaQ/bMMghLysgobHZO3N00dbeVuqVENbYQ+Rw7XFKcj5hncSZAoPOH/dgD0CUxZK44bE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476695; c=relaxed/simple;
	bh=S73grUK3po/myPetf6l7TEpP0imMgP2KnJQlvB4pGxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kMbs5Ycesf56Sx8dLKbHJlmBsCbnVsxuTV8yDQuXjAJKFABEBLo4YA5Q8VDPsQ138LTh/CZhInJw8MKdxcNeX66WdNre01ozr8Qc5AcJVQaUkBhPAePQsdDBdTljm5CLUSYoS4Qj5wNdNJXom+sw04wCgUQBKkNB11yBXihk7jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ybhqs7bD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ybhqs7bD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97A95C2BBFC;
	Tue, 30 Apr 2024 11:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476695;
	bh=S73grUK3po/myPetf6l7TEpP0imMgP2KnJQlvB4pGxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ybhqs7bDhjGtDprXhQG+qRZY7fXqG7uHoLDpBdh8AhOzY6EXBBxgESZlISCWJOzko
	 TLBme0FvnWWDZU5+4LgMCdSnQcfagGNRCdTAxrtyk8HJOviuWdI4MVFdYyjDwZkOmw
	 Y/AoqdNfIy9Io27t5YgClUzzYZtddb2RXz4Dbyiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Kobuk <m.kobuk@ispras.ru>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 095/110] phy: marvell: a3700-comphy: Fix out of bounds read
Date: Tue, 30 Apr 2024 12:41:04 +0200
Message-ID: <20240430103050.377570661@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103047.561802595@linuxfoundation.org>
References: <20240430103047.561802595@linuxfoundation.org>
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

From: Mikhail Kobuk <m.kobuk@ispras.ru>

[ Upstream commit e4308bc22b9d46cf33165c9dfaeebcf29cd56f04 ]

There is an out of bounds read access of 'gbe_phy_init_fix[fix_idx].addr'
every iteration after 'fix_idx' reaches 'ARRAY_SIZE(gbe_phy_init_fix)'.

Make sure 'gbe_phy_init[addr]' is used when all elements of
'gbe_phy_init_fix' array are handled.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 934337080c6c ("phy: marvell: phy-mvebu-a3700-comphy: Add native kernel implementation")
Signed-off-by: Mikhail Kobuk <m.kobuk@ispras.ru>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/r/20240321164734.49273-1-m.kobuk@ispras.ru
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/marvell/phy-mvebu-a3700-comphy.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/phy/marvell/phy-mvebu-a3700-comphy.c b/drivers/phy/marvell/phy-mvebu-a3700-comphy.c
index d641b345afa35..392a8ae1bc667 100644
--- a/drivers/phy/marvell/phy-mvebu-a3700-comphy.c
+++ b/drivers/phy/marvell/phy-mvebu-a3700-comphy.c
@@ -610,11 +610,12 @@ static void comphy_gbe_phy_init(struct mvebu_a3700_comphy_lane *lane,
 		 * comparison to 3.125 Gbps values. These register values are
 		 * stored in "gbe_phy_init_fix" array.
 		 */
-		if (!is_1gbps && gbe_phy_init_fix[fix_idx].addr == addr) {
+		if (!is_1gbps &&
+		    fix_idx < ARRAY_SIZE(gbe_phy_init_fix) &&
+		    gbe_phy_init_fix[fix_idx].addr == addr) {
 			/* Use new value */
 			val = gbe_phy_init_fix[fix_idx].value;
-			if (fix_idx < ARRAY_SIZE(gbe_phy_init_fix))
-				fix_idx++;
+			fix_idx++;
 		} else {
 			val = gbe_phy_init[addr];
 		}
-- 
2.43.0



