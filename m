Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B8128DEEA;
	Wed, 23 Apr 2025 15:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422055; cv=none; b=XUBmXLSt3OUvgkjNYWe9lCpxrZyZv42LyhY3fdEJv7TxAhdPRTJP8kqQUltKsBB0vPa9xUPFwxYM7/dI+Tq+TQTl4zC/Oc6rxq/HllZbmlXYkXsxuJZ5GAiJLCPUWKI3+pao25/llJ6xql+Jbsxa/aU2pBfTSiwr3QLF3Zw/ziA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422055; c=relaxed/simple;
	bh=DTTMDJKByPKC7ehWTcsucmo8elS+wrOX8xWvSk8FrTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ib9KjKNOmSvQmuCzCN6LIQsjwSMtXYYfvIoZ7JFCwJat6c63Fx9cEfI4g8I0drHO5QPo0qmR17hIUT1lCHDGIcIG/qqo3NPnW6yc80JVPM2olDUsorxLP0aMwcW3a+01ldBLOjl6oTqSajvPizZTKGJEEZ4Tdz/aPL9baMCfiqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cYbQUeuW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cYbQUeuW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBEC6C4CEE2;
	Wed, 23 Apr 2025 15:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422055;
	bh=DTTMDJKByPKC7ehWTcsucmo8elS+wrOX8xWvSk8FrTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cYbQUeuWTyse5t72XYVk1nGq3b5L/5DVMKcIcFUZWbwP4MeBKEEwc+oeB2g5oVQBW
	 1F77j9UbdhlaI3J6F/RvuP1ZWJv0eP85ZFJ5AnXFPV72URUCnwtj2tnZd4y3y2Xgx1
	 12WpckJnm1PI8naIf2JbgcgjuxafPCpWe2jJe0uw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Griffin <peter.griffin@linaro.org>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 225/291] scsi: ufs: exynos: Ensure consistent phy reference counts
Date: Wed, 23 Apr 2025 16:43:34 +0200
Message-ID: <20250423142633.617702224@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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


