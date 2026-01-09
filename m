Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40EED33032C;
	Fri,  9 Jan 2026 12:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962807; cv=none; b=G1mJUtRhzBW5H8xJBj3FTLspxD8jOARgMhvy8eGe3OnOQYkkIET6FMCE+/dMIYPGVMU7577vqJUvuYlP2kL8zRW8aO1b0l+tT5tAYip9VpnP6kae2c/tJdJ1Uy0V2VmWlzxJjzmNFykYRjkffcCfvWrQ3/iBEzvc78SE45IOWAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962807; c=relaxed/simple;
	bh=k112OGGGXYzRV7opfFucio6E4xPBMUGvKp1dTE3kr1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=od82/3llRQxRNALrYbGAF5/XxHeY0EAMvFWXSjA9hZIl0tNeNlYJ1AqPysk/YgDLryzPugW+EZ7GqENhX2fHy+QmcEqH24cs0HKJ0csuK6d0II+ZFn+IY1VJz33nHHNrI2LYkrJKWonNJzZ47Mh9c3vDtVFrmakvSR46jJKf3e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=omF31A/X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="omF31A/X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54501C4CEF1;
	Fri,  9 Jan 2026 12:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962806;
	bh=k112OGGGXYzRV7opfFucio6E4xPBMUGvKp1dTE3kr1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=omF31A/XFOAHwatw/bV6S/0Qur84cC4QeuyCN6TcjkEF2UShO/mSSINkehgRkyz51
	 u4KNi7pmOzlzvYvkK+pw7Hyz2HuNG7YUFJ4GSMMlb+vT48km2dt8NIh0k0mqhXAcwU
	 ZrdXoulYpYNjcQU6Dx09QpCpIedA+wadacf9zLeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Magnus Damm <damm+renesas@opensource.se>,
	Robin Murphy <robin.murphy@arm.com>,
	Johan Hovold <johan@kernel.org>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.1 452/634] iommu/ipmmu-vmsa: fix device leak on of_xlate()
Date: Fri,  9 Jan 2026 12:42:10 +0100
Message-ID: <20260109112134.551476002@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 80aa518452c4aceb9459f9a8e3184db657d1b441 upstream.

Make sure to drop the reference taken to the iommu platform device when
looking up its driver data during of_xlate().

Fixes: 7b2d59611fef ("iommu/ipmmu-vmsa: Replace local utlb code with fwspec ids")
Cc: stable@vger.kernel.org	# 4.14
Cc: Magnus Damm <damm+renesas@opensource.se>
Acked-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/ipmmu-vmsa.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iommu/ipmmu-vmsa.c
+++ b/drivers/iommu/ipmmu-vmsa.c
@@ -714,6 +714,8 @@ static int ipmmu_init_platform_device(st
 
 	dev_iommu_priv_set(dev, platform_get_drvdata(ipmmu_pdev));
 
+	put_device(&ipmmu_pdev->dev);
+
 	return 0;
 }
 


