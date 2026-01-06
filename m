Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB30F3559C0;
	Tue,  6 Jan 2026 17:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720564; cv=none; b=jquCFhhdI6MAqDA6mpcU2+mnpn7ABJI2X6i3FdDdIW/aXXZc6Piu3VkbVqI+u0jGcbVqc5gEHtrebzKsqW2iJe1KqpRi2bmDRsPgcLbfUuXB6kKsrbdZK/Yk50XhHS9NQKqRfvOl+S4Ils8uUAi67rSuLFl5DeL7DwHuwOaoA34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720564; c=relaxed/simple;
	bh=F7VdJXcNIbIl1mfo/wYoUtwF6krQOhTn7Crifgbl+i4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QmlkMAzBtSDYxT61sX/A/3QO4fCR6+UXeFUqyWFnO1E8CFaGKL+wWu9nU5UyWKP8NjDDQONOcMXMBnYWxnxmqDzOfZzt96IHkrrxT0PMhCjzi1zwDLjaTAnk/EK9dZPaOEeXadQBTEGMjGx4LxmGBsX//ET+aECOZd6K767ye30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BYh93WnT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BYh93WnT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AEEDC116C6;
	Tue,  6 Jan 2026 17:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720564;
	bh=F7VdJXcNIbIl1mfo/wYoUtwF6krQOhTn7Crifgbl+i4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BYh93WnTYRyCVFGGjMZN5XvFbROXgBQioYLAaVSeUTxMuqDq0HuY+KKIpeyvRfvn2
	 yRe2CwukUOX2hgORWfajEL/VOt/2yeNXLHDQ9ghIPUuauIrJc6YHZ6P/WPhK5Ttgov
	 G7+bXWcaDS1p6Jw84fWOK9GnRM6gYalVvo6ivbXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH 6.12 274/567] amba: tegra-ahb: Fix device leak on SMMU enable
Date: Tue,  6 Jan 2026 18:00:56 +0100
Message-ID: <20260106170501.462205895@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


