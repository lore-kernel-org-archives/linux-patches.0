Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6A4248BA6;
	Wed, 15 Jan 2025 10:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938041; cv=none; b=OtB2ayQQ3Cmq3NArOThO2THt2I6X1PrBjWG8jQEQ3evqMzueLwSqzqgjZT/Ui53w304rDNBhVJxfvpDrh79y5Z8tJ2AY+PpY3jWv3MIn/tgGyNrxUdvz2f2vWXEWwwI4sZcHQCfwyrVRaXaTcrcNuu3Ne404JNRc1V8sYltxjv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938041; c=relaxed/simple;
	bh=H0mxeEumr8ZAra8RKQDHDYd1LTf5UBwQisrAiHqkk/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o9gsGXneO5FszvoCF8hAhznvOhDQ2NeMDshTJRs5GgiWOIbPWHDCmR9N9nlLixuGp3Tl/AAY68AZs8/jqPE5rFM+k7GP2cw1EcA/dot2WiRV6PY0ziP2k/dJ1BLM+wTNPGg5U16IVHR62b0qTWmRrGVqwcE+iixABqPpDnbKksc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IZYyV5Bk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IZYyV5Bk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C198FC4CEDF;
	Wed, 15 Jan 2025 10:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938041;
	bh=H0mxeEumr8ZAra8RKQDHDYd1LTf5UBwQisrAiHqkk/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IZYyV5BkU4NsRZS2Bi8fUnU8zVuI+R2hbaDCED+pRTgEPaXTzJtJyOu4znuiB+ILy
	 amTC4P4iOG8mIQUwFbopGrjVfD4SeMBpAu/keehBP/3FMUEPaX+DW9vMpoy9ebUHeH
	 vxKA9Tz+tysxrQLOdyl8nM3pU5wGhs99w7NvH9XE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Milena Olech <milena.olech@intel.com>,
	Przemyslaw Korba <przemyslaw.korba@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.12 036/189] ice: fix incorrect PHY settings for 100 GB/s
Date: Wed, 15 Jan 2025 11:35:32 +0100
Message-ID: <20250115103607.803498042@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e6980b94a6c1..3005dd252a10 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp_consts.h
+++ b/drivers/net/ethernet/intel/ice/ice_ptp_consts.h
@@ -761,9 +761,9 @@ const struct ice_vernier_info_e82x e822_vernier[NUM_ICE_PTP_LNK_SPD] = {
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



