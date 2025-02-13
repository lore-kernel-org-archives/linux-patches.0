Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E5426B091;
	Thu, 13 Feb 2025 15:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459801; cv=none; b=CGGBb5djtbOdVUAu+IjqmIN2NuV0tF0T6fuCFNFgXWoYCOHxPjlX5YKvd9gTdy+9xuhuXUdL+HLPqIoMSrkh3iZATjwAD8Rd9lCMbXSwCqlXlctiUEcH0irt65vbf2Kgcop9KXx9oWkb05ckEO0vw00MCwXvFjCpes7ZWewpPU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459801; c=relaxed/simple;
	bh=iRQMeZJSIMYk3xq8h0a6EAG8F5Tt4LrvWKZm8k7+LPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=URmNRwTwHThVMknz8w8scGaUPlr9JtIr2Yn1q3P6RZRntAXd9pUtRKXcr06kugU5LgGEFeVl8Xx1u2/yfXQ6QEmedLGp3sk2J2NVcnDgmvnwZwAgMtT/RelR3dfGCs5Q5QBadTGOucFBb2WwmZpRoQkvZ8kMb3m8dVwZILiUdI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uA7qmthA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uA7qmthA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C82C4CED1;
	Thu, 13 Feb 2025 15:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459800;
	bh=iRQMeZJSIMYk3xq8h0a6EAG8F5Tt4LrvWKZm8k7+LPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uA7qmthAunELvCyoQiQ6u55A09xA81ByKhj2hJHis7V1s3nPHsRMMJm01goD6SmHY
	 RSlOYZeVqWeNHl8goLRCuFhHImLlw8lnsqyTlI2vIA15Kd4QaXjDrnusPXM2PGpD4U
	 NIl9QwiKtmJp1V+3/uL4Zs+ndF16glckwvzkdyok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jai Luthra <jai.luthra@ideasonboard.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.13 367/443] media: i2c: ds90ub9x3: Fix extra fwnode_handle_put()
Date: Thu, 13 Feb 2025 15:28:52 +0100
Message-ID: <20250213142454.771715319@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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
@@ -793,7 +793,6 @@ static void ub913_subdev_uninit(struct u
 	v4l2_async_unregister_subdev(&priv->sd);
 	ub913_v4l2_nf_unregister(priv);
 	v4l2_subdev_cleanup(&priv->sd);
-	fwnode_handle_put(priv->sd.fwnode);
 	media_entity_cleanup(&priv->sd.entity);
 }
 
--- a/drivers/media/i2c/ds90ub953.c
+++ b/drivers/media/i2c/ds90ub953.c
@@ -1288,7 +1288,6 @@ static void ub953_subdev_uninit(struct u
 	v4l2_async_unregister_subdev(&priv->sd);
 	ub953_v4l2_notifier_unregister(priv);
 	v4l2_subdev_cleanup(&priv->sd);
-	fwnode_handle_put(priv->sd.fwnode);
 	media_entity_cleanup(&priv->sd.entity);
 }
 


