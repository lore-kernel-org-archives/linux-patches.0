Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406153D4112;
	Thu, 15 Jan 2026 17:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499548; cv=none; b=de/eaTCnmEIIYxa0O0YNH3784/KOZpp5ce/B+SmL6gwCaPzDgeyNXmCjujVSFV3ZEqTI/CdtWFqPJVrErQWwT36jbMVPYzr3GBP0hZWOFFWKvztfPqVZijpEnjJSZrVj3PAkOkwzukNKqzjU4f2ufcWCGoK57dCX9zAW04ffDm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499548; c=relaxed/simple;
	bh=Z8Fg9pT8SBIr9R8BK0SaeAQWGNKDWIBQTz05M/9o9QY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fYik7eoW736fF21vK18kSVNhPD9OEOjoD5G+/pCsjKZzqIGG8rCdQkrJJ1/ZLg6daDDIZj2Gs3lv74ze9igDBNM8ljoswjaTkPrsGIQsMEIqRydN6t2TJWuzxeNgouHQW4PmDwTBhvno2fj0h5f7goYqbEOUVZmN2TuzviFmRI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LpeRKJau; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LpeRKJau"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7E00C116D0;
	Thu, 15 Jan 2026 17:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499548;
	bh=Z8Fg9pT8SBIr9R8BK0SaeAQWGNKDWIBQTz05M/9o9QY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LpeRKJauxXWfxq3eVl0CvHmmA0x7rzG/B5PEB8vxTNk+I2aaVeqPkQu1q/EQKlGNO
	 j+b9TMrPaoWHoNk+ElSVpqQPilThRbeYF1Nh4qNH7uCSJ0gIl+hnBYHD/EjdVG0HSY
	 byw15yuS5apFFWe39JR8ccRD9pOg8ZlY+xpNGi5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH 5.10 264/451] amba: tegra-ahb: Fix device leak on SMMU enable
Date: Thu, 15 Jan 2026 17:47:45 +0100
Message-ID: <20260115164240.435239228@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 500e1368e46928f4b2259612dcabb6999afae2a6 upstream.

Make sure to drop the reference taken to the AHB platform device when
looking up its driver data while enabling the SMMU.

Note that holding a reference to a device does not prevent its driver
data from going away.

Fixes: 89c788bab1f0 ("ARM: tegra: Add SMMU enabler in AHB")
Cc: stable@vger.kernel.org	# 3.5
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/amba/tegra-ahb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/amba/tegra-ahb.c
+++ b/drivers/amba/tegra-ahb.c
@@ -144,6 +144,7 @@ int tegra_ahb_enable_smmu(struct device_
 	if (!dev)
 		return -EPROBE_DEFER;
 	ahb = dev_get_drvdata(dev);
+	put_device(dev);
 	val = gizmo_readl(ahb, AHB_ARBITRATION_XBAR_CTRL);
 	val |= AHB_ARBITRATION_XBAR_CTRL_SMMU_INIT_DONE;
 	gizmo_writel(ahb, val, AHB_ARBITRATION_XBAR_CTRL);


