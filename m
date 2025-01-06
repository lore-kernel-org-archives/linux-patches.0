Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41CB91DDA3C;
	Mon,  6 Jan 2025 15:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177140; cv=none; b=Z5y3LglQh7XLsf2zIn9vNAhLeo403Zw2KWOyVFlgRZ/ggB7i8SsTtOfGaeXjtTqohyzrJpDrE8cLx9mDcGTTUgAxzzT+UYSvebjXugD+vlQiFIfCti8AkMV8dIg89IX+5E2L4FRAUBrR4jwt/KlQAvB45O/c684pZCKstnN1vmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177140; c=relaxed/simple;
	bh=WYk0rakQ4r+iy0WZbbf7uc1e0FEGC8h6d8Jr7sLIkGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iOOvLK82OjzbP36gzmSO3qAIIkhsP7gYNFJq0VJtblheyvJolzdezRwZ+7ZYUXclDY7Q/zdOQp6OgnTxV8uap3GpdnLIhV8s4mAoR0yh950gUianOwL7qTMSPuw23frAIPu2oXPV9JbDpXWilDaDcztGgne5Zattf118Z4auLLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kwn7Bj/n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kwn7Bj/n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 693BEC4CED2;
	Mon,  6 Jan 2025 15:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177139;
	bh=WYk0rakQ4r+iy0WZbbf7uc1e0FEGC8h6d8Jr7sLIkGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kwn7Bj/nh1aoKPrXRBRjjeYusSNOE2FajkqJestOd9YYqF1XUWbWfVa/YG7JicI1c
	 DVV5n/IwXtAa4JAvbjlGOjOxMcOMht/U2wOrC5K7uzLFT277CCN/Vd4k+kercICFCT
	 77Eiu87UrAsXZwhPskk6EjlzSI7lq0cdYI44pKVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 065/222] usb: typec: ucsi: add update_connector callback
Date: Mon,  6 Jan 2025 16:14:29 +0100
Message-ID: <20250106151153.067193309@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 62866465196228917f233aea68de73be6cdb9fae ]

Add a callback to allow glue drivers to update the connector before
registering corresponding power supply and Type-C port. In particular
this is useful if glue drivers want to touch the connector's Type-C
capabilities structure.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20240411-ucsi-orient-aware-v2-4-d4b1cb22a33f@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: de9df030ccb5 ("usb: typec: ucsi: glink: be more precise on orientation-aware ports")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/ucsi/ucsi.c | 3 +++
 drivers/usb/typec/ucsi/ucsi.h | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index 3f7039a711c7..d6a3fd00c3a5 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -1261,6 +1261,9 @@ static int ucsi_register_port(struct ucsi *ucsi, struct ucsi_connector *con)
 	cap->driver_data = con;
 	cap->ops = &ucsi_ops;
 
+	if (ucsi->ops->update_connector)
+		ucsi->ops->update_connector(con);
+
 	ret = ucsi_register_port_psy(con);
 	if (ret)
 		goto out;
diff --git a/drivers/usb/typec/ucsi/ucsi.h b/drivers/usb/typec/ucsi/ucsi.h
index 3d23b52cf5a9..921ef0e115cf 100644
--- a/drivers/usb/typec/ucsi/ucsi.h
+++ b/drivers/usb/typec/ucsi/ucsi.h
@@ -53,6 +53,7 @@ struct dentry;
  * @sync_write: Blocking write operation
  * @async_write: Non-blocking write operation
  * @update_altmodes: Squashes duplicate DP altmodes
+ * @update_connector: Update connector capabilities before registering
  * @connector_status: Updates connector status, called holding connector lock
  *
  * Read and write routines for UCSI interface. @sync_write must wait for the
@@ -68,6 +69,7 @@ struct ucsi_operations {
 			   const void *val, size_t val_len);
 	bool (*update_altmodes)(struct ucsi *ucsi, struct ucsi_altmode *orig,
 				struct ucsi_altmode *updated);
+	void (*update_connector)(struct ucsi_connector *con);
 	void (*connector_status)(struct ucsi_connector *con);
 };
 
-- 
2.39.5



