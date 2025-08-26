Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 992B1239573;
	Tue, 26 Aug 2025 11:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207331; cv=none; b=safc1tM0SM2P8eIpC97MNKzWAzWNUhgREHRremDS/jqVy+BpvdX2jSatUxyv7qk96cfhAXMGm7SR4siWddninSLaBlfofy5m/9dV5MJG4lJDsxf51NjMIJ4d8SMPdHVakZV63UuKJ2dsLZqAK+iBPt2R4lipo40R4UaSgyx/ZcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207331; c=relaxed/simple;
	bh=ciBxAtvZXoJKA8yC8EmXB6pb0Tay5Y3g22d18RDx/1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ctu3XK6/WjhUg1Z2Vn5ehCPHq7YAtc38w4pGBSEN9KDxi7cH0iGVEK8ZJyZP7371j+A1OsUBSIQeRkgec7sRwehYsu1uEl8P+1Ytf76UyNy7Y1P+vstLXwUaLa/GONZ+PxGknu2TBuvzFDWl8VzabS28ZeWlfSOeu1bkCOUfu6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QzRcem81; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QzRcem81"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 349C4C4CEF1;
	Tue, 26 Aug 2025 11:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207331;
	bh=ciBxAtvZXoJKA8yC8EmXB6pb0Tay5Y3g22d18RDx/1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QzRcem81gqyqpHSUUD1JlhgTdtt1DC3qbI6sGhv3mMn6YFiDHhYPav82Gd3W5VkYh
	 j2oUw36tB4g/WgI1wdwn8BZIGBIMLS3okbIcA5A1HmtYhIpXEJnTwV2SSb6VMdzZ/f
	 Ft50F36J/DWZEsRl9vFZMIofjAmwQv2+Ht6WbS4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Shurong <zhang_shurong@foxmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.16 140/457] media: ov2659: Fix memory leaks in ov2659_probe()
Date: Tue, 26 Aug 2025 13:07:04 +0200
Message-ID: <20250826110940.835746482@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Shurong <zhang_shurong@foxmail.com>

commit 76142b137b968d47b35cdd8d1dc924677d319c8b upstream.

ov2659_probe() doesn't properly free control handler resources in failure
paths, causing memory leaks. Add v4l2_ctrl_handler_free() to prevent these
memory leaks and reorder the ctrl_handler assignment for better code flow.

Fixes: c4c0283ab3cd ("[media] media: i2c: add support for omnivision's ov2659 sensor")
Cc: stable@vger.kernel.org
Signed-off-by: Zhang Shurong <zhang_shurong@foxmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ov2659.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/media/i2c/ov2659.c
+++ b/drivers/media/i2c/ov2659.c
@@ -1469,14 +1469,15 @@ static int ov2659_probe(struct i2c_clien
 				     V4L2_CID_TEST_PATTERN,
 				     ARRAY_SIZE(ov2659_test_pattern_menu) - 1,
 				     0, 0, ov2659_test_pattern_menu);
-	ov2659->sd.ctrl_handler = &ov2659->ctrls;
 
 	if (ov2659->ctrls.error) {
 		dev_err(&client->dev, "%s: control initialization error %d\n",
 			__func__, ov2659->ctrls.error);
+		v4l2_ctrl_handler_free(&ov2659->ctrls);
 		return  ov2659->ctrls.error;
 	}
 
+	ov2659->sd.ctrl_handler = &ov2659->ctrls;
 	sd = &ov2659->sd;
 	client->flags |= I2C_CLIENT_SCCB;
 


