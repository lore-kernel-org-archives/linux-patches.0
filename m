Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C0F27055F;
	Wed, 23 Apr 2025 15:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420950; cv=none; b=l/fg97zGMyLMpYbGlVcaA+de0oxIzVzbfYxqkXply41pT8p4BQ7giY/7igJDcEtc8BaEWM6CaC1KriAORNsGz8CR6o+7CaxbtetJ9h6cqUBf6qI8Lz7VRdD1IQ38cMrX/X6tTby2q1Rb9y2h4gurqZDbrb7Q224yumofaC1ygb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420950; c=relaxed/simple;
	bh=rwWE5GoicQx7goHrywG+hzFIM7brtIz+78oySnFxQaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G8AdMpx1rQzJZctKlEb+fLEdx3HRyf4ysU55JtWInOmS4S/8J20FvG6lNoqvvX9lhI9arWcnGca1A9TBlUbAvuBiX2dpVASnuhJLRnzfFDI+029lnpIYpFDwiptr6tVOSvhDZE1hOVVMypa+3x0BKoyXcDwrN8Dt96+vaJhexjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LW94NSGY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LW94NSGY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0548C4CEE8;
	Wed, 23 Apr 2025 15:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420950;
	bh=rwWE5GoicQx7goHrywG+hzFIM7brtIz+78oySnFxQaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LW94NSGYSvgJ/b5JF//uwe7aSua6stncJW2uHk1E1hjEl5VOOcvLb9CUnd2M8l+ui
	 974CHnlI5NnfaeiEjFCCrp7FCe4MFI7mgLscvpAUhrR8Z3QyciFMKSd5vdFVF88hgi
	 HqxEb0I5XqxVVElLXJcvEKzHmt7JYrkMTFr0UPbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.1 095/291] media: i2c: ccs: Set the devices runtime PM status correctly in remove
Date: Wed, 23 Apr 2025 16:41:24 +0200
Message-ID: <20250423142628.236261052@linuxfoundation.org>
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

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit e04604583095faf455b3490b004254a225fd60d4 upstream.

Set the device's runtime PM status to suspended in device removal only if
it wasn't suspended already.

Fixes: 9447082ae666 ("[media] smiapp: Implement power-on and power-off sequences without runtime PM")
Cc: stable@vger.kernel.org # for >= v5.15
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ccs/ccs-core.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/media/i2c/ccs/ccs-core.c
+++ b/drivers/media/i2c/ccs/ccs-core.c
@@ -3674,9 +3674,10 @@ static void ccs_remove(struct i2c_client
 	v4l2_async_unregister_subdev(subdev);
 
 	pm_runtime_disable(&client->dev);
-	if (!pm_runtime_status_suspended(&client->dev))
+	if (!pm_runtime_status_suspended(&client->dev)) {
 		ccs_power_off(&client->dev);
-	pm_runtime_set_suspended(&client->dev);
+		pm_runtime_set_suspended(&client->dev);
+	}
 
 	for (i = 0; i < sensor->ssds_used; i++) {
 		v4l2_device_unregister_subdev(&sensor->ssds[i].sd);


