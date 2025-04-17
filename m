Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7125019ABC6;
	Thu, 17 Apr 2025 18:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915702; cv=none; b=OyG8pV8tRs/Pd+oiMl9xaeOKaY8jaAomqOIy09NLejb57vj5KLmBUGXRDXcI/GzGPJMhEHeruIE28hnZPDmHYntIxhiTjFBABPgYhPuId3BdulAQbhYtYMH6IgmhTBK/Vtj/7eIXH4hanpveXwbMRG6TGhZWAlxWC+ZrTzTKuQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915702; c=relaxed/simple;
	bh=hnT2zxNTstPr+HqK4bFziUfbwcPkGZAUqEqSSs60Ako=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UJz4B39Z376QY6m10GrQKi9V3pJREsp5IJGFEQZ+bREIz0FQfFuRhME5G1TlgFeMei9Q72TjdcaPmUvrjUvwJdmJ0X6VmtCWTP5hVEqh8ltCQQ3HZgVRjnTeKB/Be6FLHJ4XGATbDpgqTyeA+vSyZu52UGN9OyykiOVYFnVIq1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R1ro7Xcg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R1ro7Xcg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD24C4CEE4;
	Thu, 17 Apr 2025 18:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915702;
	bh=hnT2zxNTstPr+HqK4bFziUfbwcPkGZAUqEqSSs60Ako=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R1ro7XcgCCbU0Jhbi3tFc1k8q3u+eRjs0WgC8Ziu8031Xl0en106OIS86sJYURzUX
	 KZYvGyZMvb6o4ptOGZLaXSL6aOif9WlSNXdUCCzEG1TBVQADsPm+LQyBpAUeL3ffAq
	 gVAZzozTV2Z+lgBJ88tXfrfJtEjTgU932Zbhs1D8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 212/393] media: hi556: Fix memory leak (on error) in hi556_check_hwcfg()
Date: Thu, 17 Apr 2025 19:50:21 +0200
Message-ID: <20250417175116.107796130@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

From: Hans de Goede <hdegoede@redhat.com>

commit ed554da65abd0c561e40d35272d1a61d030fe977 upstream.

Commit 7d968b5badfc ("media: hi556: Return -EPROBE_DEFER if no endpoint is
found") moved the v4l2_fwnode_endpoint_alloc_parse() call in
hi556_check_hwcfg() up, but it did not make the error-exit paths between
the old and new call-site use "goto check_hwcfg_error;" to free the bus_cfg
on errors.

Add the missing "goto check_hwcfg_error;" statements to fix a memleak on
early error-exits from hi556_check_hwcfg().

Fixes: 7d968b5badfc ("media: hi556: Return -EPROBE_DEFER if no endpoint is found")
Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/hi556.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/media/i2c/hi556.c
+++ b/drivers/media/i2c/hi556.c
@@ -1230,12 +1230,13 @@ static int hi556_check_hwcfg(struct devi
 	ret = fwnode_property_read_u32(fwnode, "clock-frequency", &mclk);
 	if (ret) {
 		dev_err(dev, "can't get clock frequency");
-		return ret;
+		goto check_hwcfg_error;
 	}
 
 	if (mclk != HI556_MCLK) {
 		dev_err(dev, "external clock %d is not supported", mclk);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto check_hwcfg_error;
 	}
 
 	if (bus_cfg.bus.mipi_csi2.num_data_lanes != 2) {


