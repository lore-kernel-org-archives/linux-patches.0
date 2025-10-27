Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16AD31C580;
	Mon, 27 Oct 2025 19:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592286; cv=none; b=hSorB5iFcKtaoFi78J6nXAdjgkKeEd+R1qt3ts0uWnnFVUtcGqYfEiUlcNB6IxzXj+5T5bcsVmHKCdEE/3YKs2tK66RhlqOWoV1sucR/N6abID2DahmoCnpbxAj46qfiRm3fXWspCdRN6mUFWCkUQW94U2OvgyPNEYB2coh5l/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592286; c=relaxed/simple;
	bh=vaWqS1xA/z59OyiAy60/wUU4YMwTzVdpXlduIrZK8VE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ohnBKWMuUxbUMIs0Q0Rw4clX9bSSkipELZk5NA5LvylNmSV+WGqPn41asU/slGxHLSV/A26ODSwiBJueSwRpqvbKZEsJqV/oipJ7ArKVrOrDUKhzTP/mDDK+sPVgpna73u+NuwY6HSR/JPxTuWEX4nmGVV4FWe90iFzJii1V8F4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rU30/Vdq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rU30/Vdq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44945C4CEF1;
	Mon, 27 Oct 2025 19:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592286;
	bh=vaWqS1xA/z59OyiAy60/wUU4YMwTzVdpXlduIrZK8VE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rU30/Vdq+0E4wvi/DMA61Hu1jiQR9ODNmpDiTFD/rMloOD39/CfoUU+h9997m+wLJ
	 +7h8irItmeuu4ImYErGSH7ElBLO31j3ZeLi9ZOrGsJalIeW8zwQDE473hUAE/235ws
	 E0GHaIQW+i2vFmmogRfQi1VRPmG2raid06dNuvVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 064/157] HID: multitouch: fix name of Stylus input devices
Date: Mon, 27 Oct 2025 19:35:25 +0100
Message-ID: <20251027183503.000728679@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
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

From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>

[ Upstream commit aa4daea418ee4215dca5c8636090660c545cb233 ]

HID_DG_PEN devices should have a suffix of "Stylus", as pointed out by
commit c0ee1d571626 ("HID: hid-input: Add suffix also for HID_DG_PEN").
However, on multitouch devices, these suffixes may be overridden. Before
that commit, HID_DG_PEN devices would get the "Stylus" suffix, but after
that, multitouch would override them to have an "UNKNOWN" suffix. Just add
HID_DG_PEN to the list of non-overriden suffixes in multitouch.

Before this fix:

[    0.470981] input: ELAN9008:00 04F3:2E14 UNKNOWN as /devices/pci0000:00/0000:00:15.1/i2c_designware.1/i2c-16/i2c-ELAN9008:00/0018:04F3:2E14.0001/input/input8
ELAN9008:00 04F3:2E14 UNKNOWN

After this fix:

[    0.474332] input: ELAN9008:00 04F3:2E14 Stylus as /devices/pci0000:00/0000:00:15.1/i2c_designware.1/i2c-16/i2c-ELAN9008:00/0018:04F3:2E14.0001/input/input8

ELAN9008:00 04F3:2E14 Stylus

Fixes: c0ee1d571626 ("HID: hid-input: Add suffix also for HID_DG_PEN")
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-multitouch.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 6f1e54ee8f05d..b9e67b408a4b9 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1658,6 +1658,7 @@ static int mt_input_configured(struct hid_device *hdev, struct hid_input *hi)
 	case HID_CP_CONSUMER_CONTROL:
 	case HID_GD_WIRELESS_RADIO_CTLS:
 	case HID_GD_SYSTEM_MULTIAXIS:
+	case HID_DG_PEN:
 		/* already handled by hid core */
 		break;
 	case HID_DG_TOUCHSCREEN:
-- 
2.51.0



