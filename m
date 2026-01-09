Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 614CE320CB6;
	Fri,  9 Jan 2026 12:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960689; cv=none; b=bnDDO52KcodzPQ8IbE3TScQ7Ls48rZw3b2Q42iMqsHzhZj9PeUBMVmRycu75HKgXQURLHOvOqI32cDs04JC2hpcr2tRgZSzC/sD4qh9lGj7rXaVjDkM/FJOHOw6iz/V7yQuRjL7gt6vr+p1Fnj1sMbSJa2iOxdfRlONoHjNhmaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960689; c=relaxed/simple;
	bh=0HZyDWBVImTyYIC2pkrktRG3lk97Tr5K8FHn/MnitYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pRQjBH+rPteFsAerxQ6JswsJUVLRCn5a6X4YkBd4mZY9gjDnktrCi1D9W2YtjIRErcqUMI5dIELcyMnc4/J2ZkmZXkoPk4d6aODLAARQ9Lj9I/qezequG8BJHhQiNZryQ1JjikSZtu4mBxNkgm11yP0jJTBjBXcApxdoWYk5STA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XSvccAs5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XSvccAs5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C48C4CEF1;
	Fri,  9 Jan 2026 12:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960688;
	bh=0HZyDWBVImTyYIC2pkrktRG3lk97Tr5K8FHn/MnitYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XSvccAs5So4qZEoroNS40DezewvMO5dkS48uZGg1d6Zkjezfrq20pGOtXx+ILIJFX
	 WtAM3WD2x0/ZV7kPgapSGAA0ZTInKpi/N299Amq0pltd7gPoR7i4VG1rNHKHWzPp+8
	 Y4gPKM4VCChhqyHQRah6EvtLiX5tAUOa6+HrBz/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH 6.6 489/737] amba: tegra-ahb: Fix device leak on SMMU enable
Date: Fri,  9 Jan 2026 12:40:28 +0100
Message-ID: <20260109112152.384488254@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


