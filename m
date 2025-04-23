Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C15D628A415;
	Wed, 23 Apr 2025 15:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422412; cv=none; b=k9YynrQPK8RieQmDXFOpq1jZtO7gVNBPCd9oUvTA8lSh2NNwOIJCXQpsY/NnKerVXUcXDa5YiVeVVvoTa5/0hyphoY3BCPfW/Qfcld41/oMwthPKdEIk7WmKQUJm7uuoSrja93iPUHuRNYOWQDZgI34/WQWZ+Mfi7uM4TOrYquw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422412; c=relaxed/simple;
	bh=dpa8sjdAf7rhQhJHNS3rEPqbTGNhCJU+4nwpsT9MT2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rjEVjvinRQrvOQ/uoRerdhnmwgKBhrjsWFJ8HPa59h0ssE4w0UY23qN60p7/y4mLS6Y5Q/M6TnK728eq1DgSM3IY6jfH+OciIBrdck35/DrKdfQYRxNRgepEwz2BM78834ePg/9PaYhQrOIfyqvIBDeA89YDXIfTdGSAczBKuVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n+wuR9p5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n+wuR9p5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D83E6C4CEEB;
	Wed, 23 Apr 2025 15:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422412;
	bh=dpa8sjdAf7rhQhJHNS3rEPqbTGNhCJU+4nwpsT9MT2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n+wuR9p54IPTkbi7GUhKmzYIM6zbMP7DIMKmB9pUhyjA75DNxpVVK0p3d94kU21Pi
	 cYWBvZJSQ8Y8coVIadRAeeu55Z0DHgzXuoqlgmVD4zcGv59SMBK+t3aRo1iScKMuF3
	 +7ykuNWxJAPWfmGWReHqgyERGbRtIHh2u7vI3T9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Griffin <peter.griffin@linaro.org>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 340/393] scsi: ufs: exynos: Ensure consistent phy reference counts
Date: Wed, 23 Apr 2025 16:43:56 +0200
Message-ID: <20250423142657.374525947@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Griffin <peter.griffin@linaro.org>

commit 7f05fd9a3b6fb3a9abc5a748307d11831c03175f upstream.

ufshcd_link_startup() can call ufshcd_vops_link_startup_notify()
multiple times when retrying. This causes the phy reference count to
keep increasing and the phy to not properly re-initialize.

If the phy has already been previously powered on, first issue a
phy_power_off() and phy_exit(), before re-initializing and powering on
again.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Link: https://lore.kernel.org/r/20250319-exynos-ufs-stability-fixes-v2-4-96722cc2ba1b@linaro.org
Fixes: 3d73b200f989 ("scsi: ufs: ufs-exynos: Change ufs phy control sequence")
Cc: stable@vger.kernel.org
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/host/ufs-exynos.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -901,6 +901,12 @@ static int exynos_ufs_phy_init(struct ex
 	}
 
 	phy_set_bus_width(generic_phy, ufs->avail_ln_rx);
+
+	if (generic_phy->power_count) {
+		phy_power_off(generic_phy);
+		phy_exit(generic_phy);
+	}
+
 	ret = phy_init(generic_phy);
 	if (ret) {
 		dev_err(hba->dev, "%s: phy init failed, ret = %d\n",


