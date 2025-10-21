Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82FFB278143;
	Tue, 21 Oct 2025 20:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077526; cv=none; b=Mq1uahlw8n6CKkHW8INX4bTuqxp0IGNWFYKZl5yQRuCrgTOmVcT3ka2DGUgjgrTVJjgLCnJBy4tILwTlJFiGie4nthEDuMhjKoG8WI5+B3aQuxlc37FkBywOY8uJ6rU4+4Gbx2kgs0txxAIr5f1XWtB2qSQRBZTwXEonHYKaegY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077526; c=relaxed/simple;
	bh=NoIaLyWhafcUtGaI0tgHtG74THFK8I5+MQl/0cmMnb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HClw/qpuOJpGY57NqQsqTlZ4OK5AHcLfq7tKkNASv9nlA2B98jM45JGgtDR8fIoOh4H8PLS7k57wzF/sZ2Xxs6K1FlE9e7rW9CfXuPX9DP3TFJyOB/HO3T/uP84M92HbH7Esw1RBb1uZCPj21u5uiuz+iKyK7KvdT7C6j/tUP0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2k6Fs0Bz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2k6Fs0Bz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B5F4C4CEF1;
	Tue, 21 Oct 2025 20:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077526;
	bh=NoIaLyWhafcUtGaI0tgHtG74THFK8I5+MQl/0cmMnb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2k6Fs0BznbiEmwb/ynkzIpDnSP/xn4740GOqLpAzR3ziyg9dJztHbwc0ntK3e1lkr
	 3Crxk0WUkvt++PNdminxoAvcu6i5/SRNj2cLfDhUo2PWOSdHGKswV7TSb8RXviqc1E
	 ZVPgaBtTjKc3HLwNEhe/G3lMlXGfpz6SPq8otDMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 131/159] HID: multitouch: fix name of Stylus input devices
Date: Tue, 21 Oct 2025 21:51:48 +0200
Message-ID: <20251021195046.300765850@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 7587a7748a82d..a9ff84f0bd9bb 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1711,6 +1711,7 @@ static int mt_input_configured(struct hid_device *hdev, struct hid_input *hi)
 	case HID_CP_CONSUMER_CONTROL:
 	case HID_GD_WIRELESS_RADIO_CTLS:
 	case HID_GD_SYSTEM_MULTIAXIS:
+	case HID_DG_PEN:
 		/* already handled by hid core */
 		break;
 	case HID_DG_TOUCHSCREEN:
-- 
2.51.0



