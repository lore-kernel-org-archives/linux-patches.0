Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3540833A6E2;
	Tue, 12 May 2026 18:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609185; cv=none; b=tmdet5E8Ikvtp113kLuPyE2RvOvItHAEtz+sXdEEtLwVVQNQZ4hw8+rIOHnuWMUPqOYFJ+O4SUmqMhSsMFBRmgn1pF0fsX2UctYU2tGttQRIJksVkqI3a2rPiPEP/ppFN6EXnI4MkePZn6FtBJkgSZIzXdF5gB7VmKeTzv3fkgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609185; c=relaxed/simple;
	bh=I3xcrc1MLAiiF8ut1F2uZoM1lhIUIJGH7wM70vMJaG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lr1JnlFEj1T4spTHsZtfvOWHefXKFi+QZyQaVc/nza5npoxzByGpe/cMWjROxrGPS1hfzD/f1YzQz/fgdoQxsYSovgnhERVTixyvJD3c79Ng01MV12hUtFD8l526huksjNYJ0iOOz+O/Lz1gdTUs5d/NV2F5WrIJeEyQSS4AZbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AK4K0Rp+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AK4K0Rp+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD600C2BCB0;
	Tue, 12 May 2026 18:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609185;
	bh=I3xcrc1MLAiiF8ut1F2uZoM1lhIUIJGH7wM70vMJaG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AK4K0Rp+T4Oqg8akN/CXAMDImA2JmCsp5WZMPb70B603Rn003pMJr+5OL6oSQzmLW
	 626QrLocUbkWMQF36ArbKG6NGQ6mAXej8OiImwy0yI19Kf8R087LTCNi9U3lFhg4ha
	 PpcSlBMXQivhQxGEky9jasStS24pUlYhyh1SGSak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.0 071/307] Bluetooth: btmtk: validate WMT event SKB length before struct access
Date: Tue, 12 May 2026 19:37:46 +0200
Message-ID: <20260512173941.621414343@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


