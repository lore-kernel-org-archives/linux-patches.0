Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6846C1E7C16;
	Wed, 15 Jan 2025 10:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937576; cv=none; b=sHX40NU7HesSsfn0PnpDSHMuRFMgxMz4HLr+5vMYWvRQtCvxsNwo82BN03r6alV+hqzCyPTVpASrqox0riJDIgKfsVU2FL5Iy3jzsCZdvx0uuDHOHiO1V6y+DY1ojcFoy0L0QhXqwlRRi/loBdX+amowD+V09GyQhD6r7Y9ze64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937576; c=relaxed/simple;
	bh=SyrZmfdZ09jdJFIzHAXVqXwI5D2BqiPalJJagx5XOWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i54qPpHm+kqiIYMbDnvUx/CqWGnhkr6gfutdRsXLf4/Yz0vBMQGooEh9vKm/uxYQ8hs9/maeHW8j9WgVLZGf9g+FMrBp1smNX+MqZ5t9g+5Giiw1vEelHN53pz7aQGe0WgGBDbCzPBij47/fMCg/z9w4y16B/IrowSAoLqo9YFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XUNROpb1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XUNROpb1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C44AC4CEDF;
	Wed, 15 Jan 2025 10:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937575;
	bh=SyrZmfdZ09jdJFIzHAXVqXwI5D2BqiPalJJagx5XOWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XUNROpb1LqdA7tVOGW/IJDlDOo9UnOSaaANy4iVr4aV7V+gw9Ky+0vpD5gf1oJcM4
	 fQJE0uktrfuKYxS5dZDtl/YCUrVtT07wo05Ip94xi/PG2fGNfcGcbSSley8/XeYNcv
	 zpWOl5IWrzoqZxga80TbGOyVuxwcKTdcLlt5tlZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Milena Olech <milena.olech@intel.com>,
	Przemyslaw Korba <przemyslaw.korba@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.1 20/92] ice: fix incorrect PHY settings for 100 GB/s
Date: Wed, 15 Jan 2025 11:36:38 +0100
Message-ID: <20250115103548.341043022@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Przemyslaw Korba <przemyslaw.korba@intel.com>

[ Upstream commit 6c5b989116083a98f45aada548ff54e7a83a9c2d ]

ptp4l application reports too high offset when ran on E823 device
with a 100GB/s link. Those values cannot go under 100ns, like in a
working case when using 100 GB/s cable.

This is due to incorrect frequency settings on the PHY clocks for
100 GB/s speed. Changes are introduced to align with the internal
hardware documentation, and correctly initialize frequency in PHY
clocks with the frequency values that are in our HW spec.

To reproduce the issue run ptp4l as a Time Receiver on E823 device,
and observe the offset, which will never approach values seen
in the PTP working case.

Reproduction output:
ptp4l -i enp137s0f3 -m -2 -s -f /etc/ptp4l_8275.conf
ptp4l[5278.775]: master offset      12470 s2 freq  +41288 path delay -3002
ptp4l[5278.837]: master offset      10525 s2 freq  +39202 path delay -3002
ptp4l[5278.900]: master offset     -24840 s2 freq  -20130 path delay -3002
ptp4l[5278.963]: master offset      10597 s2 freq  +37908 path delay -3002
ptp4l[5279.025]: master offset       8883 s2 freq  +36031 path delay -3002
ptp4l[5279.088]: master offset       7267 s2 freq  +34151 path delay -3002
ptp4l[5279.150]: master offset       5771 s2 freq  +32316 path delay -3002
ptp4l[5279.213]: master offset       4388 s2 freq  +30526 path delay -3002
ptp4l[5279.275]: master offset     -30434 s2 freq  -28485 path delay -3002
ptp4l[5279.338]: master offset     -28041 s2 freq  -27412 path delay -3002
ptp4l[5279.400]: master offset       7870 s2 freq  +31118 path delay -3002

Fixes: 3a7496234d17 ("ice: implement basic E822 PTP support")
Reviewed-by: Milena Olech <milena.olech@intel.com>
Signed-off-by: Przemyslaw Korba <przemyslaw.korba@intel.com>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ptp_consts.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp_consts.h b/drivers/net/ethernet/intel/ice/ice_ptp_consts.h
index 4109aa3b2fcd..87ce20540f57 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp_consts.h
+++ b/drivers/net/ethernet/intel/ice/ice_ptp_consts.h
@@ -359,9 +359,9 @@ const struct ice_vernier_info_e822 e822_vernier[NUM_ICE_PTP_LNK_SPD] = {
 		/* rx_desk_rsgb_par */
 		644531250, /* 644.53125 MHz Reed Solomon gearbox */
 		/* tx_desk_rsgb_pcs */
-		644531250, /* 644.53125 MHz Reed Solomon gearbox */
+		390625000, /* 390.625 MHz Reed Solomon gearbox */
 		/* rx_desk_rsgb_pcs */
-		644531250, /* 644.53125 MHz Reed Solomon gearbox */
+		390625000, /* 390.625 MHz Reed Solomon gearbox */
 		/* tx_fixed_delay */
 		1620,
 		/* pmd_adj_divisor */
-- 
2.39.5



