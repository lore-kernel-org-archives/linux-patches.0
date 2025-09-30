Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0802B1FF1C8;
	Tue, 30 Sep 2025 15:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244660; cv=none; b=qIhTm6+UEHscvWdIv6LtSsYod7pI05F1r3jZuI735YLP8QXFE63UpEH+4At70DO6EpHRZ584IJOoLg97jbMx0Ni78Y0Mp0aAF2l0sezWsyvWgxI2lxafDsEHLNMHdZqJETFMBpHLJdD4S8a5HXX4mFgYg+Ra5aFZc/GEctGUeHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244660; c=relaxed/simple;
	bh=+5VoyM91WUPkjMB1cbAPiCJpEHM3OyRHuUHT/p3BSrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DZqW4g3t27uOtVJiLURmsoenkqh3Of02efq+mucmzbOO/4PnaiNH9WbRHlZ9xVw3xrZoZZLgZDInO/6C/HgiCCdAeb3TOo97WRpOQ8SSF5uczuPEPl7WV5bIHncAMbBw3rNZ/e3MoEnWzzW1vc9o2ZLnbU8lAVK70r7xVRCldgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=trj19VOd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="trj19VOd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 229F6C4CEF0;
	Tue, 30 Sep 2025 15:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244656;
	bh=+5VoyM91WUPkjMB1cbAPiCJpEHM3OyRHuUHT/p3BSrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=trj19VOdpIUv6YfgJK+bvBEUJn0Opl6JGnIXhORyZ26Cw/qewTBNZZWxYa0Ekjl7e
	 uqcBqj9Z5kRDjBPKk2chDNS4v8+5vRZmJaas4tBRUFrRcicaelrdMpsNC9jxpz9fOC
	 ksIH2uToPilxZdMeGe+Zp57nAbeU3zJTIfN9p3Vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <jjc@jclark.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Richard Cochran <richardcochran@gmail.com>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 074/143] broadcom: fix support for PTP_EXTTS_REQUEST2 ioctl
Date: Tue, 30 Sep 2025 16:46:38 +0200
Message-ID: <20250930143834.189929882@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit 3200fdd4021de1d182fa3b6db5ad936d519f3848 ]

Commit 7c571ac57d9d ("net: ptp: introduce .supported_extts_flags to
ptp_clock_info") modified the PTP core kernel logic to validate the
supported flags for the PTP_EXTTS_REQUEST ioctls, rather than relying on
each individual driver correctly checking its flags.

The bcm_ptp_enable() function implements support for PTP_CLK_REQ_EXTTS, but
does not check the flags, and does not forward the request structure into
bcm_ptp_extts_locked().

When originally converting the bcm-phy-ptp.c code, it was unclear what
edges the hardware actually timestamped. Thus, no flags were initialized in
the .supported_extts_flags field. This results in the kernel automatically
rejecting all userspace requests for the PTP_EXTTS_REQUEST2 ioctl.

This occurs because the PTP_STRICT_FLAGS is always assumed when operating
under PTP_EXTTS_REQUEST2. This has been the case since the flags
introduction by commit 6138e687c7b6 ("ptp: Introduce strict checking of
external time stamp options.").

The bcm-phy-ptp.c logic never properly supported strict flag validation,
as it previously ignored all flags including both PTP_STRICT_FLAGS and the
PTP_FALLING_EDGE and PTP_RISING_EDGE flags.

Reports from users in the field prove that the hardware timestamps the
rising edge. Encode this in the .supported_extts_flags field. This
re-enables support for the PTP_EXTTS_REQUEST2 ioctl.

Reported-by: James Clark <jjc@jclark.com>
Fixes: 7c571ac57d9d ("net: ptp: introduce .supported_extts_flags to ptp_clock_info")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Reviewed-by: Kory Maincent <kory.maincent@bootlin.com>
Tested-by: James Clark <jjc@jclark.com>
Link: https://patch.msgid.link/20250918-jk-fix-bcm-phy-supported-flags-v1-2-747b60407c9c@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/bcm-phy-ptp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/bcm-phy-ptp.c b/drivers/net/phy/bcm-phy-ptp.c
index 1cf695ac73cc5..d3501f8487d96 100644
--- a/drivers/net/phy/bcm-phy-ptp.c
+++ b/drivers/net/phy/bcm-phy-ptp.c
@@ -738,6 +738,7 @@ static const struct ptp_clock_info bcm_ptp_clock_info = {
 	.n_per_out	= 1,
 	.n_ext_ts	= 1,
 	.supported_perout_flags = PTP_PEROUT_DUTY_CYCLE,
+	.supported_extts_flags = PTP_STRICT_FLAGS | PTP_RISING_EDGE,
 };
 
 static void bcm_ptp_txtstamp(struct mii_timestamper *mii_ts,
-- 
2.51.0



