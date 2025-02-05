Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D7DE347CC;
	Wed,  5 Feb 2025 14:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765960; cv=none; b=ExEU0XXJcSzdEZuHZ+6he8SoM7wjsOuz4rHNWkfjXFiucywFfI7C0n2esWUCMCAagylbqapjWhF+OjFX2WriTiDlF0iYtSHl/Xd7Q5kg8tyeU29wcXv5QLw6/UPMtDiShXmVqcCX/rBSfFlR5SL9f29RE9VgLzwmabA7LkNFYss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765960; c=relaxed/simple;
	bh=7lvHNEABLXscASu+bPpNKzkSHGxs3JQa3+6s5t/MUDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BihuIhMlpNMNnXS+tFCXaLXCq2mRe5dUUk2q36ZcExUAmBk/8tQGP2Z6lGjJ7Qp32nF2FIuD0dmymTewxmDlXth18PdzQA1HpDg3G+KJ9ZPt3phEdH1bHC69sMgM/v6ssFcA7qBb7nxaY+Kn3wSbTzevGNsKAlMSmY9SCj2/BFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=od7OHMbP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="od7OHMbP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 159C0C4CED1;
	Wed,  5 Feb 2025 14:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765959;
	bh=7lvHNEABLXscASu+bPpNKzkSHGxs3JQa3+6s5t/MUDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=od7OHMbP3jbRhJFsHsKNnZlxb5XsRw5qG6wZuzVKFwJGHRI0JL+Doxv/OKUKsXa+l
	 qMtXl14EXZO6PZX+VNQ4PPkqz4tG0hxP5DXDAAExPKY2r1EX9Kqa6KJhwGddTvA0TE
	 7tMfoJH0vk5Q6DQnN4jt7MZ4xY1GFFmqAL1tmEgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 229/623] net: phy: realtek: clear master_slave_state if link is down
Date: Wed,  5 Feb 2025 14:39:31 +0100
Message-ID: <20250205134504.983645780@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit ea8318cb33e593bbfc59d637eae45a69732c5387 ]

rtlgen_decode_physr() which sets master_slave_state isn't called in case
the link is down and other than rtlgen_read_status(),
rtl822x_c45_read_status() doesn't implicitely clear master_slave_state.

Avoid stale master_slave_state by always setting it to
MASTER_SLAVE_STATE_UNKNOWN in rtl822x_c45_read_status() in case the link
is down.

Fixes: 081c9c0265c9 ("net: phy: realtek: read duplex and gbit master from PHYSR register")
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/realtek.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index 26b324ab0f90f..93704abb67878 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -1038,8 +1038,10 @@ static int rtl822x_c45_read_status(struct phy_device *phydev)
 	if (ret < 0)
 		return ret;
 
-	if (!phydev->link)
+	if (!phydev->link) {
+		phydev->master_slave_state = MASTER_SLAVE_STATE_UNKNOWN;
 		return 0;
+	}
 
 	/* Read actual speed from vendor register. */
 	val = phy_read_mmd(phydev, MDIO_MMD_VEND2, RTL_VND2_PHYSR);
-- 
2.39.5



