Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD6317E90E;
	Mon, 27 May 2024 19:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837073; cv=none; b=Uw6A5JZ0EREtgcFdXbgG2XfOIW2OwdNt/ZHAXmvwX9KW7vKXiUZFU7T9RoxiyY29qSEkdJGV66AAagzrMSFgmDdOljwSLMTcmBlf6aDo7oQAmS4SxS+Liy8KetRK9fwldq9uCfAV8aQQ0hv+60Vo9a7DanqUNB08hVLdeKlOHGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837073; c=relaxed/simple;
	bh=p4Q7H151ytj4uMaqJ2J0rO7WZOg580F7TehNxfUcpkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D3u4qFc4iz2IgpdamTWVF+sQixNIaIZm6eEEDD0L7jPxBJ6rKEr3k2CCiZqYiVjnXDudmMrzkyG/i8WCJ2ZxdJhU+1wIdMUjk95/JVYISxzdT0MJbqC6oWbc1OOKaHTe5VfxfaDXIH81eyCilsjAArQdWB0h6+/PhIL5z2jQlX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nOisYsTX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nOisYsTX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF9CC2BBFC;
	Mon, 27 May 2024 19:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837073;
	bh=p4Q7H151ytj4uMaqJ2J0rO7WZOg580F7TehNxfUcpkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nOisYsTXBDY3vM3OK1DFZDDvrDA51p+tQnRXPhzgD8pgNl4rsWF7L4LW8U4vvsiTL
	 52VC/HfvALL+4lWpWW6E0ur+EfyQ5qUPVf7l7pWZWj/6JFsWNHe4fFoiK2TwxlNvBN
	 HAj5I7EaCwOVw6Q2nNAdwQOwofzaClK9YlYyFHe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 273/427] Bluetooth: hci_core: Fix not handling hdev->le_num_of_adv_sets=1
Date: Mon, 27 May 2024 20:55:20 +0200
Message-ID: <20240527185627.983084005@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit e77f43d531af41e9ce299eab10dcae8fa5dbc293 ]

If hdev->le_num_of_adv_sets is set to 1 it means that only handle 0x00
can be used, but since the MGMT interface instances start from 1
(instance 0 means all instances in case of MGMT_OP_REMOVE_ADVERTISING)
the code needs to map the instance to handle otherwise users will not be
able to advertise as instance 1 would attempt to use handle 0x01.

Fixes: 1d0fac2c38ed ("Bluetooth: Use controller sets when available")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci_core.h |  1 +
 net/bluetooth/hci_core.c         |  9 +++++++++
 net/bluetooth/hci_sync.c         | 17 ++++++++---------
 3 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 762b049bdabf1..5277c6d5134ca 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -246,6 +246,7 @@ struct adv_info {
 	bool	periodic;
 	__u8	mesh;
 	__u8	instance;
+	__u8	handle;
 	__u32	flags;
 	__u16	timeout;
 	__u16	remaining_time;
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index e32725650a319..24f6b6a5c7721 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1758,6 +1758,15 @@ struct adv_info *hci_add_adv_instance(struct hci_dev *hdev, u8 instance,
 
 		adv->pending = true;
 		adv->instance = instance;
+
+		/* If controller support only one set and the instance is set to
+		 * 1 then there is no option other than using handle 0x00.
+		 */
+		if (hdev->le_num_of_adv_sets == 1 && instance == 1)
+			adv->handle = 0x00;
+		else
+			adv->handle = instance;
+
 		list_add(&adv->list, &hdev->adv_instances);
 		hdev->adv_instance_cnt++;
 	}
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 4f736ff4cda23..64f794d198cdc 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -1043,11 +1043,10 @@ static int hci_disable_ext_adv_instance_sync(struct hci_dev *hdev, u8 instance)
 	struct hci_cp_ext_adv_set *set;
 	u8 data[sizeof(*cp) + sizeof(*set) * 1];
 	u8 size;
+	struct adv_info *adv = NULL;
 
 	/* If request specifies an instance that doesn't exist, fail */
 	if (instance > 0) {
-		struct adv_info *adv;
-
 		adv = hci_find_adv_instance(hdev, instance);
 		if (!adv)
 			return -EINVAL;
@@ -1066,7 +1065,7 @@ static int hci_disable_ext_adv_instance_sync(struct hci_dev *hdev, u8 instance)
 	cp->num_of_sets = !!instance;
 	cp->enable = 0x00;
 
-	set->handle = instance;
+	set->handle = adv ? adv->handle : instance;
 
 	size = sizeof(*cp) + sizeof(*set) * cp->num_of_sets;
 
@@ -1249,7 +1248,7 @@ static int hci_set_ext_scan_rsp_data_sync(struct hci_dev *hdev, u8 instance)
 
 	len = eir_create_scan_rsp(hdev, instance, pdu->data);
 
-	pdu->handle = instance;
+	pdu->handle = adv ? adv->handle : instance;
 	pdu->length = len;
 	pdu->operation = LE_SET_ADV_DATA_OP_COMPLETE;
 	pdu->frag_pref = LE_SET_ADV_DATA_NO_FRAG;
@@ -1331,7 +1330,7 @@ int hci_enable_ext_advertising_sync(struct hci_dev *hdev, u8 instance)
 
 	memset(set, 0, sizeof(*set));
 
-	set->handle = instance;
+	set->handle = adv ? adv->handle : instance;
 
 	/* Set duration per instance since controller is responsible for
 	 * scheduling it.
@@ -1410,10 +1409,10 @@ static int hci_set_per_adv_data_sync(struct hci_dev *hdev, u8 instance)
 	DEFINE_FLEX(struct hci_cp_le_set_per_adv_data, pdu, data, length,
 		    HCI_MAX_PER_AD_LENGTH);
 	u8 len;
+	struct adv_info *adv = NULL;
 
 	if (instance) {
-		struct adv_info *adv = hci_find_adv_instance(hdev, instance);
-
+		adv = hci_find_adv_instance(hdev, instance);
 		if (!adv || !adv->periodic)
 			return 0;
 	}
@@ -1421,7 +1420,7 @@ static int hci_set_per_adv_data_sync(struct hci_dev *hdev, u8 instance)
 	len = eir_create_per_adv_data(hdev, instance, pdu->data);
 
 	pdu->length = len;
-	pdu->handle = instance;
+	pdu->handle = adv ? adv->handle : instance;
 	pdu->operation = LE_SET_ADV_DATA_OP_COMPLETE;
 
 	return __hci_cmd_sync_status(hdev, HCI_OP_LE_SET_PER_ADV_DATA,
@@ -1734,7 +1733,7 @@ static int hci_set_ext_adv_data_sync(struct hci_dev *hdev, u8 instance)
 	len = eir_create_adv_data(hdev, instance, pdu->data);
 
 	pdu->length = len;
-	pdu->handle = instance;
+	pdu->handle = adv ? adv->handle : instance;
 	pdu->operation = LE_SET_ADV_DATA_OP_COMPLETE;
 	pdu->frag_pref = LE_SET_ADV_DATA_NO_FRAG;
 
-- 
2.43.0



