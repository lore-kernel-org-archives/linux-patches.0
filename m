Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B6E350A39;
	Tue, 21 Oct 2025 19:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076546; cv=none; b=rOu70Ncf8pvizL0bnbOVXidx2CAJE+vx91Jms//l73JLHU5JTqGyFTtM8uu0aaKvb3oxPM3dbqMzBK5Lr8zocUO3L2PTnM+VFnzKo1Yb2LlgK9qi3al5pkN7/FmwLgheabLuPcdTBNy0T2avxoQJ5GFGvPyAXYcmO+/76Ay5Sd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076546; c=relaxed/simple;
	bh=PLBDteV8vj52UzUZ3KRzLmXqiExyee1q1DPwbh4ESUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SBK/SZAtfq6JmTFkonYyPrl4Khc49OmW7guZ7qzUda4WAFLzPDhxT4RreGLpXJFQPdA4QBlIurxOle5xjdb31yVunaF9vb5czEEDxnpM95V/h0lz8jIygSDGCk1akIW41+2m5+h7OdgiVUe9+ShE3+yQ7qiroocPKlwWtPgN97c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O/WJJ55A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O/WJJ55A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E23C4CEF1;
	Tue, 21 Oct 2025 19:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076545;
	bh=PLBDteV8vj52UzUZ3KRzLmXqiExyee1q1DPwbh4ESUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O/WJJ55AsxNdAB2et1Kll7O1S5l+H50GggIduQJOhmVSQcco6H9VVfO5SGVzvcOqm
	 5hQvACjMfDBvwhi0h1xha8BpfmlGhb495olxQ/D3TvLMSLd1dJwCff1OAT5c5iyeqn
	 Kz0vpb817PfGfmVtYa2rlkmQOiaA/UCJlGcYnSWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 069/105] HID: multitouch: fix name of Stylus input devices
Date: Tue, 21 Oct 2025 21:51:18 +0200
Message-ID: <20251021195023.302615731@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195021.492915002@linuxfoundation.org>
References: <20251021195021.492915002@linuxfoundation.org>
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



