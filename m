Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15668263C78;
	Tue,  8 Apr 2025 11:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111941; cv=none; b=UTRe3ULNmocUnUyL3v4vRE+j6uzUdUHQVi59F5w1cDfA3gB2YKy4f/sSXpypvjDdugEWYzGrMC9sMPOtMyB5u2yryGZsspQLPOdmh5SA0HWqMUxPjUkXrtB38L2WrVUzYohum/Cfjn4bbhF164jCk5b4zyPkuUFfgrZKZWbgKG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111941; c=relaxed/simple;
	bh=XNTUzK/n3suvwTI2yZE18LYd4Rk9K4j4Zsklff404sI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h7E2Exa2iqpzYWouoNUDffwQ84vBW1nZ0yaxLTaJvMRsMnXcIupna5JOlRDoqorHCs+6o5ysih8JoK2DE8+8okTQyLJ8TSo7DEX7pZUZoXPiPMLrXDWQnHHENxaJv4YbRXODmefwJWLGZQAh6s2wdthKEym5rB0vIFyo5o7bEYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dAeu5Tme; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dAeu5Tme"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AF3AC4CEE5;
	Tue,  8 Apr 2025 11:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111940;
	bh=XNTUzK/n3suvwTI2yZE18LYd4Rk9K4j4Zsklff404sI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dAeu5TmeFXG/FEto5YxtH1DBdqCkxSMN9FmGt0HUJ5ZR0E7/VRf+Yocy4kyPV+ctO
	 Rt777pxfW0SEwz2rE/s5sk8byi0yaKBtZbeNFpzvZ0UxIjO+yqLoVGXRtNX2Kmbjig
	 2iyHkiCA8alaDYpSgaKCbf/cVC0HbL9dDLVFiRhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Piotr Kwapulinski <piotr.kwapulinski@intel.com>,
	Simon Horman <horms@kernel.org>,
	Bharath R <bharath.r@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 616/731] ixgbe: fix media type detection for E610 device
Date: Tue,  8 Apr 2025 12:48:33 +0200
Message-ID: <20250408104928.599651428@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Piotr Kwapulinski <piotr.kwapulinski@intel.com>

[ Upstream commit 40206599beec98cfeb01913ee417f015e3f6190c ]

The commit 23c0e5a16bcc ("ixgbe: Add link management support for E610
device") introduced incorrect media type detection for E610 device. It
reproduces when advertised speed is modified after driver reload. Clear
the previous outdated PHY type high value.

Reproduction steps:
modprobe ixgbe
ethtool -s eth0 advertise 0x1000000000000
modprobe -r ixgbe
modprobe ixgbe
ethtool -s eth0 advertise 0x1000000000000
Result before the fix:
netlink error: link settings update failed
netlink error: Invalid argument
Result after the fix:
No output error

Fixes: 23c0e5a16bcc ("ixgbe: Add link management support for E610 device")
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Piotr Kwapulinski <piotr.kwapulinski@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Bharath R <bharath.r@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_e610.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_e610.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_e610.c
index cb07ecd8937d3..00935747c8c55 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_e610.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_e610.c
@@ -1453,9 +1453,11 @@ enum ixgbe_media_type ixgbe_get_media_type_e610(struct ixgbe_hw *hw)
 			hw->link.link_info.phy_type_low = 0;
 		} else {
 			highest_bit = fls64(le64_to_cpu(pcaps.phy_type_low));
-			if (highest_bit)
+			if (highest_bit) {
 				hw->link.link_info.phy_type_low =
 					BIT_ULL(highest_bit - 1);
+				hw->link.link_info.phy_type_high = 0;
+			}
 		}
 	}
 
-- 
2.39.5



