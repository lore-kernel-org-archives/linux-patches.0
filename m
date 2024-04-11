Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E62D5145B3E;
	Thu, 11 Apr 2024 10:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830343; cv=none; b=oNKLk6SJfBQ58yc/EpuLvxj9CQlSEFxUwmW4y31dBopfQ2STn/sl65eJjypPDVe7BAQWxmanZNXfjmN+LieAHawpI3yF9t/zELrqiiSz4f2NrUY/6InEVCvd7pPD6fUH9JPbyu5CmhPN/cyVHo5905u7bJ/miZtS+ExRb8EFTdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830343; c=relaxed/simple;
	bh=BXfbcLLZkuKrI74syAq4BXQLMuv44swU+CC/bkPy7V0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p02BYv7g0vyybs7QSNDYB9KU4X+N0BFrpnyKQFnjaGkhGbqZUBWv3FC4L+wyXGn0ATQnc1iOfIGhW674/9S08XZI1UYOACimG7MLVtDiyLz0vP256uT269VjH511HbQzUb0533PrR7J3v5M7CJdOuHhGZPjaIznWjsGpUdLx2O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2lW23guA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2lW23guA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 651CEC433F1;
	Thu, 11 Apr 2024 10:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830342;
	bh=BXfbcLLZkuKrI74syAq4BXQLMuv44swU+CC/bkPy7V0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2lW23guAGaVmbaVgQih97RdhtAZv+aiU2RzvEL8FTheZQ6mLe5ZCDA+OpbKUSYofh
	 FHF8ffdhfaogPYNtasBftSTKxDhXYgmgkkxNbLoxkai39YY6qU2lnXcMjPy2/y1EMr
	 Plwfl/QIIxY4NfX9fh1+/2FiKu1ouWwPBKfTUxsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Prashant Malani <pmalani@chromium.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 115/143] usb: typec: ucsi: Limit read size on v1.2
Date: Thu, 11 Apr 2024 11:56:23 +0200
Message-ID: <20240411095424.368800768@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>

[ Upstream commit b3db266fb031fba88c423d4bb8983a73a3db6527 ]

Between UCSI 1.2 and UCSI 2.0, the size of the MESSAGE_IN region was
increased from 16 to 256. In order to avoid overflowing reads for older
systems, add a mechanism to use the read UCSI version to truncate read
sizes on UCSI v1.2.

Tested-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Prashant Malani <pmalani@chromium.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Link: https://lore.kernel.org/r/20240209143723.v5.1.Iacf5570a66b82b73ef03daa6557e2fc0db10266a@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/ucsi/ucsi.c | 26 ++++++++++++++++++++++++--
 drivers/usb/typec/ucsi/ucsi.h | 11 +++++++++++
 2 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index 0bfe5e906e543..cd415565b60a1 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -36,6 +36,19 @@
  */
 #define UCSI_SWAP_TIMEOUT_MS	5000
 
+static int ucsi_read_message_in(struct ucsi *ucsi, void *buf,
+					  size_t buf_size)
+{
+	/*
+	 * Below UCSI 2.0, MESSAGE_IN was limited to 16 bytes. Truncate the
+	 * reads here.
+	 */
+	if (ucsi->version <= UCSI_VERSION_1_2)
+		buf_size = clamp(buf_size, 0, 16);
+
+	return ucsi->ops->read(ucsi, UCSI_MESSAGE_IN, buf, buf_size);
+}
+
 static int ucsi_acknowledge_command(struct ucsi *ucsi)
 {
 	u64 ctrl;
@@ -72,7 +85,7 @@ static int ucsi_read_error(struct ucsi *ucsi)
 	if (ret < 0)
 		return ret;
 
-	ret = ucsi->ops->read(ucsi, UCSI_MESSAGE_IN, &error, sizeof(error));
+	ret = ucsi_read_message_in(ucsi, &error, sizeof(error));
 	if (ret)
 		return ret;
 
@@ -174,7 +187,7 @@ int ucsi_send_command(struct ucsi *ucsi, u64 command,
 	length = ret;
 
 	if (data) {
-		ret = ucsi->ops->read(ucsi, UCSI_MESSAGE_IN, data, size);
+		ret = ucsi_read_message_in(ucsi, data, size);
 		if (ret)
 			goto out;
 	}
@@ -1596,6 +1609,15 @@ int ucsi_register(struct ucsi *ucsi)
 	if (!ucsi->version)
 		return -ENODEV;
 
+	/*
+	 * Version format is JJ.M.N (JJ = Major version, M = Minor version,
+	 * N = sub-minor version).
+	 */
+	dev_dbg(ucsi->dev, "Registered UCSI interface with version %x.%x.%x",
+		UCSI_BCD_GET_MAJOR(ucsi->version),
+		UCSI_BCD_GET_MINOR(ucsi->version),
+		UCSI_BCD_GET_SUBMINOR(ucsi->version));
+
 	queue_delayed_work(system_long_wq, &ucsi->work, 0);
 
 	ucsi_debugfs_register(ucsi);
diff --git a/drivers/usb/typec/ucsi/ucsi.h b/drivers/usb/typec/ucsi/ucsi.h
index 4550f3e8cfe9c..ede9876488564 100644
--- a/drivers/usb/typec/ucsi/ucsi.h
+++ b/drivers/usb/typec/ucsi/ucsi.h
@@ -23,6 +23,17 @@ struct dentry;
 #define UCSI_CONTROL			8
 #define UCSI_MESSAGE_IN			16
 #define UCSI_MESSAGE_OUT		32
+#define UCSIv2_MESSAGE_OUT		272
+
+/* UCSI versions */
+#define UCSI_VERSION_1_2	0x0120
+#define UCSI_VERSION_2_0	0x0200
+#define UCSI_VERSION_2_1	0x0210
+#define UCSI_VERSION_3_0	0x0300
+
+#define UCSI_BCD_GET_MAJOR(_v_)		(((_v_) >> 8) & 0xFF)
+#define UCSI_BCD_GET_MINOR(_v_)		(((_v_) >> 4) & 0x0F)
+#define UCSI_BCD_GET_SUBMINOR(_v_)	((_v_) & 0x0F)
 
 /* Command Status and Connector Change Indication (CCI) bits */
 #define UCSI_CCI_CONNECTOR(_c_)		(((_c_) & GENMASK(7, 1)) >> 1)
-- 
2.43.0



