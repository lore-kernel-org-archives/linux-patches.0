Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2149870805;
	Thu, 13 Feb 2025 15:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460889; cv=none; b=GNj7vxEcVS+GQ0drahwn/nSbqaXDXXrHOUOpt15QYv6TdZzcrcbXCeMXAxYuW8raewny/e9Saz/HP2iMf1ua5QJgE8+YODaS1C4rQDz67RNtyZQD2JtZ3T7p/xkdW5dOYtkP+IUxHylDRuDbOEgdybJ+J50exg1podNe9sNyuuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460889; c=relaxed/simple;
	bh=pQcx62++ACIqj0vVM1hx2C+ZqUqGdlS6bHoSn1x0pAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LBocPH++U92C1BHloJ/KgdywL4ePU2ZGzn1/iHrCqHNPwmtX0wdQr+/57XDRnw9Wm7uOXO8qhSVYlH5vajI5h/oWYhwE1+XZER8u7npn5T6ESQPMxTMFZljbRZn+iPl0gIDn57yfDJn/Nzdoltga1kszA1Vfc3jYoMMyaA9fp+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BVqfJUng; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BVqfJUng"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B1DC4CEE4;
	Thu, 13 Feb 2025 15:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460889;
	bh=pQcx62++ACIqj0vVM1hx2C+ZqUqGdlS6bHoSn1x0pAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BVqfJUngNlsC5y7z7JFOsVWdGy7zLXpdvFKvw/Frr6YjxHVHutPrsuenCP2/TqYRX
	 +nE7T2q6FqOzEL21p6bks/JIlHMXWPja+aACAWX8Z8urnNGq073EHmLzrV7fTlA9QL
	 joGIrqSJBSubKwME+13ffcM0AdRdmE4Nw5y5/+rA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jai Luthra <jai.luthra@ideasonboard.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.6 209/273] media: i2c: ds90ub9x3: Fix extra fwnode_handle_put()
Date: Thu, 13 Feb 2025 15:29:41 +0100
Message-ID: <20250213142415.579242122@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

commit 60b45ece41c5632a3a3274115a401cb244180646 upstream.

The ub913 and ub953 drivers call fwnode_handle_put(priv->sd.fwnode) as
part of their remove process, and if the driver is removed multiple
times, eventually leads to put "overflow", possibly causing memory
corruption or crash.

The fwnode_handle_put() is a leftover from commit 905f88ccebb1 ("media:
i2c: ds90ub9x3: Fix sub-device matching"), which changed the code
related to the sd.fwnode, but missed removing these fwnode_handle_put()
calls.

Cc: stable@vger.kernel.org
Fixes: 905f88ccebb1 ("media: i2c: ds90ub9x3: Fix sub-device matching")
Reviewed-by: Jai Luthra <jai.luthra@ideasonboard.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ds90ub913.c |    1 -
 drivers/media/i2c/ds90ub953.c |    1 -
 2 files changed, 2 deletions(-)

--- a/drivers/media/i2c/ds90ub913.c
+++ b/drivers/media/i2c/ds90ub913.c
@@ -792,7 +792,6 @@ static void ub913_subdev_uninit(struct u
 	v4l2_async_unregister_subdev(&priv->sd);
 	ub913_v4l2_nf_unregister(priv);
 	v4l2_subdev_cleanup(&priv->sd);
-	fwnode_handle_put(priv->sd.fwnode);
 	media_entity_cleanup(&priv->sd.entity);
 }
 
--- a/drivers/media/i2c/ds90ub953.c
+++ b/drivers/media/i2c/ds90ub953.c
@@ -1290,7 +1290,6 @@ static void ub953_subdev_uninit(struct u
 	v4l2_async_unregister_subdev(&priv->sd);
 	ub953_v4l2_notifier_unregister(priv);
 	v4l2_subdev_cleanup(&priv->sd);
-	fwnode_handle_put(priv->sd.fwnode);
 	media_entity_cleanup(&priv->sd.entity);
 }
 


