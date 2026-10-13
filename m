Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541544E8E08;
	Tue, 13 Oct 2026 12:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893042; cv=none; b=MkKykdnV3Zm4msF1xv/BE0Sg3ZNh4fdBZA1Ep4dAawOKXv0OVknhrayzvTW2cJBp36/nM4TMWFi8W6DImMdWPa+JXw7W1ywWFhMskhWq6sTXkSHzD8S8MVGrfU8R6xY7ab0je0eziRDmazW2+GwH78lXEqVzp2h+Py0bwGgk0G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893042; c=relaxed/simple;
	bh=gM5uUY3jTXWXFTAl4ETiSvFFsN3jQ3MrHzO+oVnzdt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mF236mySzz2ivyYRU0bHDOqNz/YssO1FDqvKS35T1YI7u6gNN98MT9cv2mO8XU3ALVEtAzRtFdUkvseqmqJCMo/z0Zt9etk3R1075Yw2ezxZoVQ9kmDlMUE+L3PLiZdSF1VVwfpAThNSxjBmsddBjSmOlJysz4WuvEAzfYHTQiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IUZzH04S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IUZzH04S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFB251F00898;
	Tue, 13 Oct 2026 12:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893041;
	bh=ZIBB2Trs5/fX7aP6ddhitLOPxVCRWd35D3eHz/5jUFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IUZzH04S7Xf4lv45xCSIZG2i8dL7htU9Nd8pIYcx/QJFS+P+jOKRQ+2LVCCdHmeFe
	 HsRHdK/Aw1ZADZiLTWsxgPd5WCOSWDSiQ45v05m20S6kRLOQACQ9DnlWxQ6ULZqiO6
	 0gmS63wtLe0pIZccQlAwzNMJUvgusDcwI0K5zemg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.18 092/621] pmdomain: rockchip: dont ignore clock lookup errors on attach
Date: Tue, 13 Oct 2026 13:31:27 +0200
Message-ID: <20261013112923.035313301@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shawn Lin <shawn.lin@rock-chips.com>

commit 4c66c423593e26273ea0d644906ed007630c6f6d upstream.

rockchip_pd_attach_dev() treated every of_clk_get() error as the end
of the clock list, so a clock that exists but is not available yet
(e.g. -EPROBE_DEFER) was silently skipped and the device ended up
without pm_clk management.  Only -ENOENT means there are no more
clocks.

Fixes: 7c696693a4f5 ("soc: rockchip: power-domain: Add power domain driver")
Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/rockchip/pm-domains.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/pmdomain/rockchip/pm-domains.c
+++ b/drivers/pmdomain/rockchip/pm-domains.c
@@ -728,7 +728,19 @@ static int rockchip_pd_attach_dev(struct
 	}
 
 	i = 0;
-	while ((clk = of_clk_get(dev->of_node, i++)) && !IS_ERR(clk)) {
+	while (1) {
+		clk = of_clk_get(dev->of_node, i++);
+		if (IS_ERR(clk)) {
+			error = PTR_ERR(clk);
+			if (error == -ENOENT)
+				break;
+
+			dev_err(dev, "failed to get clock %d: %d\n", i - 1,
+				error);
+			pm_clk_destroy(dev);
+			return error;
+		}
+
 		dev_dbg(dev, "adding clock '%pC' to list of PM clocks\n", clk);
 		error = pm_clk_add_clk(dev, clk);
 		if (error) {


