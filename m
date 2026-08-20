Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B9547DD5F;
	Thu, 20 Aug 2026 17:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248485; cv=none; b=mVxuTYOZrf1kbwznWwrPmQ2c2MSauPR7Ffr3mvMbaOKOby1Q6B9Ucjfk+PuX0G2PTPa422XIjyrUs9hQdzjp3YnJijmuYo5GvX0E8QarFxuRTqQvxOUIoUIWPFxjatB1MRvXBivoxe+fQm58npSEFnX0JsnYe4DRfvjP9CE24jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248485; c=relaxed/simple;
	bh=upi2FQG3M7pHt8kyEoQF1orunnaPkQYXNxpEMLDbe9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NNG1bbPJIT5dclP9EfYlsyIIYXWFTMed48mnrV/e7HA6w9KNh9C6Y0yUTmAJvgMgeoLNp7EwJvYoFwtnQzxD+R1Y7nNE0jmLV5aKZyLZomaZkx3oM1gXdriA11wALP/0GXZDd/K9RJDj/f8leGQP5Z9Ml86+5IQo9dfoUS/UK80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fNgSFAPM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fNgSFAPM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01D6F1F000E9;
	Thu, 20 Aug 2026 17:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248483;
	bh=6ABFWz438qwV+/1EQPIc8qri9FmKBuxVnRev3y+SU1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fNgSFAPMIuUKiumr+eoB7syVw4kEi/StiioymD4CUHgZ0g3kHxhQhFy6iTqugMt2+
	 xcuc3InElHT///bUlOcLKwbumAQyJjlHzeYFjNJ1d2wiA+D+CXU5Va6x7aUKQ+7abo
	 FEfT7DPIE0q7lpi1s6oScxw/xF7bQgxW9PFTK4yw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 244/303] Bluetooth: hci_core: Fix not handling hdev->le_num_of_adv_sets=1
Date: Thu, 20 Aug 2026 16:56:20 +0200
Message-ID: <20260820145300.780301898@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 net/bluetooth/hci_sync.c         |   17 ++++++++---------
 3 files changed, 18 insertions(+), 9 deletions(-)

--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -242,6 +242,7 @@ struct adv_info {
 	bool	periodic;
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
@@ -1183,11 +1183,10 @@ static int hci_disable_ext_adv_instance_
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
@@ -1206,7 +1205,7 @@ static int hci_disable_ext_adv_instance_
 	cp->num_of_sets = !!instance;
 	cp->enable = 0x00;
 
-	set->handle = instance;
+	set->handle = adv ? adv->handle : instance;
 
 	size = sizeof(*cp) + sizeof(*set) * cp->num_of_sets;
 
@@ -1301,7 +1300,7 @@ static int hci_set_ext_adv_data_sync(str
 				  HCI_MAX_EXT_AD_LENGTH);
 
 	pdu->length = len;
-	pdu->handle = instance;
+	pdu->handle = adv ? adv->handle : instance;
 	pdu->operation = LE_SET_ADV_DATA_OP_COMPLETE;
 	pdu->frag_pref = LE_SET_ADV_DATA_NO_FRAG;
 
@@ -1512,7 +1511,7 @@ static int hci_set_ext_scan_rsp_data_syn
 
 	len = eir_create_scan_rsp(hdev, instance, pdu->data);
 
-	pdu->handle = instance;
+	pdu->handle = adv ? adv->handle : instance;
 	pdu->length = len;
 	pdu->operation = LE_SET_ADV_DATA_OP_COMPLETE;
 	pdu->frag_pref = LE_SET_ADV_DATA_NO_FRAG;
@@ -1594,7 +1593,7 @@ int hci_enable_ext_advertising_sync(stru
 
 	memset(set, 0, sizeof(*set));
 
-	set->handle = instance;
+	set->handle = adv ? adv->handle : instance;
 
 	/* Set duration per instance since controller is responsible for
 	 * scheduling it.
@@ -1671,10 +1670,10 @@ static int hci_set_per_adv_data_sync(str
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
@@ -1682,7 +1681,7 @@ static int hci_set_per_adv_data_sync(str
 	len = eir_create_per_adv_data(hdev, instance, pdu->data);
 
 	pdu->length = len;
-	pdu->handle = instance;
+	pdu->handle = adv ? adv->handle : instance;
 	pdu->operation = LE_SET_ADV_DATA_OP_COMPLETE;
 
 	return __hci_cmd_sync_status(hdev, HCI_OP_LE_SET_PER_ADV_DATA,


