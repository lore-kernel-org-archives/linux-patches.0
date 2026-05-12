Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A1A3955C1;
	Tue, 12 May 2026 17:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608417; cv=none; b=K0fLw8nwRxmiJd0JRGKRptA3tonw3oDUOtvojUOibnH1PHV5Y+boRIbilupE7/O3kiC8UGxzuHxz4CKkuRxlneM9fyOu6nhE63lQzC5Y/IgDDOd1w6aJPtmrFU6L/OS0KbIg9YBhESwsPiQ+p9R5p1baLxu0CmXgGPOrM/Ftg/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608417; c=relaxed/simple;
	bh=l/pEhASZIDWXBGq3RxlcCfonim6X1lFFn44p8UaSaTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gpiW8WBwnSyb6YcHviTmcJfnSaNpFtkPqVsJa5EmmdR4fQrs7HbxUIMXbUORLK4C/EJksKcGUNDiRvAYHC2UFg+odXItjM2gxtiomZONx0pq6hVfFIA+axnGu+YUn1wPI8bz+/U8NHxJ1D1hR9qYVDI5py8oQgD5Lok0js0LwWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yh3st5O0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yh3st5O0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8445C2BCB0;
	Tue, 12 May 2026 17:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608417;
	bh=l/pEhASZIDWXBGq3RxlcCfonim6X1lFFn44p8UaSaTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yh3st5O0Q3Juf9CC1O2BMP1QRIQjbfRreC5OaQxXEaFvzWJomXJNHa70MOUiywp6e
	 AC4MLYqJsbwnadFh7rfnN1Agk5JkCzjgbWWty0656XS9LbGUfFTWP4FMCF6la81foi
	 KpwQmDQwJ0VY/ev+V3V2Vjg8M2zt4xke77u5eOc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 070/270] Bluetooth: btmtk: validate WMT event SKB length before struct access
Date: Tue, 12 May 2026 19:37:51 +0200
Message-ID: <20260512173939.925203563@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tristan Madani <tristan@talencesecurity.com>

commit 634a4408c0615c523cf7531790f4f14a422b9206 upstream.

btmtk_usb_hci_wmt_sync() casts the WMT event response SKB data to
struct btmtk_hci_wmt_evt (7 bytes) and struct btmtk_hci_wmt_evt_funcc
(9 bytes) without first checking that the SKB contains enough data.
A short firmware response causes out-of-bounds reads from SKB tailroom.

Use skb_pull_data() to validate and advance past the base WMT event
header. For the FUNC_CTRL case, pull the additional status field bytes
before accessing them.

Fixes: d019930b0049 ("Bluetooth: btmtk: move btusb_mtk_hci_wmt_sync to btmtk.c")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btmtk.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/bluetooth/btmtk.c
+++ b/drivers/bluetooth/btmtk.c
@@ -654,8 +654,13 @@ static int btmtk_usb_hci_wmt_sync(struct
 	if (data->evt_skb == NULL)
 		goto err_free_wc;
 
-	/* Parse and handle the return WMT event */
-	wmt_evt = (struct btmtk_hci_wmt_evt *)data->evt_skb->data;
+	wmt_evt = skb_pull_data(data->evt_skb, sizeof(*wmt_evt));
+	if (!wmt_evt) {
+		bt_dev_err(hdev, "WMT event too short (%u bytes)",
+			   data->evt_skb->len);
+		err = -EINVAL;
+		goto err_free_skb;
+	}
 	if (wmt_evt->whdr.op != hdr->op) {
 		bt_dev_err(hdev, "Wrong op received %d expected %d",
 			   wmt_evt->whdr.op, hdr->op);
@@ -671,6 +676,12 @@ static int btmtk_usb_hci_wmt_sync(struct
 			status = BTMTK_WMT_PATCH_DONE;
 		break;
 	case BTMTK_WMT_FUNC_CTRL:
+		if (!skb_pull_data(data->evt_skb,
+				   sizeof(wmt_evt_funcc->status))) {
+			err = -EINVAL;
+			goto err_free_skb;
+		}
+
 		wmt_evt_funcc = (struct btmtk_hci_wmt_evt_funcc *)wmt_evt;
 		if (be16_to_cpu(wmt_evt_funcc->status) == 0x404)
 			status = BTMTK_WMT_ON_DONE;


