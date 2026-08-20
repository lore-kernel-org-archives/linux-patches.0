Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F6B47CA9D;
	Thu, 20 Aug 2026 17:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247614; cv=none; b=dwNLP4DwPxGP17/0nqOHqUMLwR0PSXhFVV9XmRmXSIK7Z7BaaiPYMGvIxYYcIRLTYoas0F0AS19OWCN2ITNXlfkvJJ3LZAX83mOMw7pQQDcerBXznEQ2r6pxA8zyFUNlcgCm/QdCVBcyS719W/9Ap7nscqn73fChMSwJ3JONWGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247614; c=relaxed/simple;
	bh=MJplg2Cz9AG79NdjdTFdHv/fvf6Y+tcJl2GPCk6ry6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D0eNYnfaMnjJxxCLQ2KpA6MAC/qsCPQhol7DIx5PNqdgfHD6bgVc7VcBE3t8rR4szDafZVEsIOLVTFNcU+b9t4aDLAdp2+ABr8mfM8fvgtsSbRMHbh3ufUX/vT3piPNvMVR9DjQXVFJUKPIKP33kaXhBlbhZlAuiQH2Wi8wbVss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uzHsGXgT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uzHsGXgT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A60F1F000E9;
	Thu, 20 Aug 2026 17:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247612;
	bh=X1MxjoJtqsmBURKpa/aMK+FZA1Eq23LL0ee/lNyQe58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uzHsGXgTUNiXFDYjb4rOIR2sW4FV6B7F3ATPBTYTojNUU91iC2GsoX/j88Y0l77ye
	 bxPXx3lMoQJpcVtCgkF+YpGq0DgDx0W4PRcAZtsYdEAMWI3X7PPXicp1CkjX5THn2Q
	 i0LjDHihQoJtBAxmMC1h3xdpeetlj3kyoAmRdQE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 106/166] Bluetooth: hci_core: Fix not handling hdev->le_num_of_adv_sets=1
Date: Thu, 20 Aug 2026 16:56:05 +0200
Message-ID: <20260820145214.353069449@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: cdc36db204ff ("Bluetooth: hci_sync: Fix advertising data UAFs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/bluetooth/hci_core.h |    1 +
 net/bluetooth/hci_core.c         |    9 +++++++++
 net/bluetooth/hci_sync.c         |   19 +++++++++----------
 3 files changed, 19 insertions(+), 10 deletions(-)

--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -245,6 +245,7 @@ struct adv_info {
 	bool	periodic_enabled;
 	__u8	mesh;
 	__u8	instance;
+	__u8	handle;
 	__u32	flags;
 	__u16	timeout;
 	__u16	remaining_time;
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1706,6 +1706,15 @@ struct adv_info *hci_add_adv_instance(st
 
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
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -1195,11 +1195,10 @@ static int hci_disable_ext_adv_instance_
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
@@ -1218,7 +1217,7 @@ static int hci_disable_ext_adv_instance_
 	cp->num_of_sets = !!instance;
 	cp->enable = 0x00;
 
-	set->handle = instance;
+	set->handle = adv ? adv->handle : instance;
 
 	size = sizeof(*cp) + sizeof(*set) * cp->num_of_sets;
 
@@ -1312,7 +1311,7 @@ static int hci_set_ext_adv_data_sync(str
 	len = eir_create_adv_data(hdev, instance, pdu->data);
 
 	pdu->length = len;
-	pdu->handle = instance;
+	pdu->handle = adv ? adv->handle : instance;
 	pdu->operation = LE_SET_ADV_DATA_OP_COMPLETE;
 	pdu->frag_pref = LE_SET_ADV_DATA_NO_FRAG;
 
@@ -1465,7 +1464,7 @@ int hci_setup_ext_adv_instance_sync(stru
 
 	cp.own_addr_type = own_addr_type;
 	cp.channel_map = hdev->le_adv_channel_map;
-	cp.handle = instance;
+	cp.handle = adv ? adv->handle : instance;
 
 	if (flags & MGMT_ADV_FLAG_SEC_2M) {
 		cp.primary_phy = HCI_ADV_PHY_1M;
@@ -1523,7 +1522,7 @@ static int hci_set_ext_scan_rsp_data_syn
 
 	len = eir_create_scan_rsp(hdev, instance, pdu->data);
 
-	pdu->handle = instance;
+	pdu->handle = adv ? adv->handle : instance;
 	pdu->length = len;
 	pdu->operation = LE_SET_ADV_DATA_OP_COMPLETE;
 	pdu->frag_pref = LE_SET_ADV_DATA_NO_FRAG;
@@ -1605,7 +1604,7 @@ int hci_enable_ext_advertising_sync(stru
 
 	memset(set, 0, sizeof(*set));
 
-	set->handle = instance;
+	set->handle = adv ? adv->handle : instance;
 
 	/* Set duration per instance since controller is responsible for
 	 * scheduling it.
@@ -1684,10 +1683,10 @@ static int hci_set_per_adv_data_sync(str
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
@@ -1695,7 +1694,7 @@ static int hci_set_per_adv_data_sync(str
 	len = eir_create_per_adv_data(hdev, instance, pdu->data);
 
 	pdu->length = len;
-	pdu->handle = instance;
+	pdu->handle = adv ? adv->handle : instance;
 	pdu->operation = LE_SET_ADV_DATA_OP_COMPLETE;
 
 	return __hci_cmd_sync_status(hdev, HCI_OP_LE_SET_PER_ADV_DATA,


