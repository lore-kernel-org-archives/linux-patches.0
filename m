Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BD442571AD;
	Thu, 17 Apr 2025 18:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914459; cv=none; b=ZLzWHtmiS+hAaLselvfQEKSgHdtdHv+I2e5kbjsZvctk/WvtJNbvP4y3Vha+AgqLelkOEJ46NThN0Q3BUDE359LtlD3UtyjKAtKmTV1ZwQYRgj/NWpv3DOR0eQIAT4AUm0pnnADxCvvQ8ZNV/iqm2h8gPDFF2olzXirRH3m/OXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914459; c=relaxed/simple;
	bh=EtLOGR6MVcKVbjwsx0V3+LnAhbq8j+B0UGeOvbpLyFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sV24koHUoAlkjP6iybzFjakLWRjb5+sCJvIW796H5jputZXQCN2EAz0Yqjh0xWMvlR9qrcKCaV4XshtCeJYIYudOkLFuSCHvr0Et2CPit3z7X+rEZtURhA/vcRgcqLiyjraLIiSEKjHyoLCVeBgdCcOEYGlzHXMj4SnDi4b6ZDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y9WwVxZY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y9WwVxZY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1968C4CEE7;
	Thu, 17 Apr 2025 18:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914459;
	bh=EtLOGR6MVcKVbjwsx0V3+LnAhbq8j+B0UGeOvbpLyFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y9WwVxZY2Kqnw9rB19Q0icD/C6M9GhF7dTI3CsbETLKxiVIAVfmiC8u8dNeIeyGrK
	 PVMQDrIJe92eap1tzXglLsQjqcrMZFwngVl0yGg4Po5NsKbynioDyrRCgmdqWMzIUL
	 Z/4w1ZSigBVijgR30sP/sCGXuAfxZ/FZZkMdbD9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.13 223/414] media: hi556: Fix memory leak (on error) in hi556_check_hwcfg()
Date: Thu, 17 Apr 2025 19:49:41 +0200
Message-ID: <20250417175120.405148267@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


