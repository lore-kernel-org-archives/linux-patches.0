Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C24C360EE5;
	Thu,  2 Jul 2026 16:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010924; cv=none; b=m1CpPke9YFF58s6Dk6nXGzVuW7Oqik6urrNX9kTNLOD8wpPGP9mpTX8mYCual/c3l+4gREldWuQoXSjTLAztjcF847oJkD0WWQeb4H8Y5B4TpUfXo4ClRuOVLzaiLIP71qG5GcztZoLwOLWvi1lLWHJ5hDdPiQQBfSiPAf1cwL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010924; c=relaxed/simple;
	bh=OgvXSaGPVXZgMP69y2ZLIL7dXT1eG9pEj8jlYPmPva0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HjnX5zln9RdUbW3rLbRT/qlhnfsM0tGrGwvKq9ihV/V8VAY6DpYBKjErOPci77gE9BSrU/zA+mj1uJTiN8i+Heb7+PFnwDLOn3cgyHozEpULres796Uf95D5Srg2lLZ77kAMzWcYKnaSrV8AU3bhfKwQ1cOLOYSLnuB3PHRQLA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fA/a0C2C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fA/a0C2C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DCE81F000E9;
	Thu,  2 Jul 2026 16:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010923;
	bh=A65I5KOUKKFa5xl6WCKyY1MPl2+5nD9p5n0g25MgxdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fA/a0C2CCZTWyApvI+VU5x4UI5+TN8+zN6wpE2Jz4aor5mh3j+otaj0ASMlSX++MM
	 kBw9QUxpMOFBOrQIx09KUFgU9XNZWzF6UkISD7KywG/RtBNJ1I4w1s5egY+0ZXiPWC
	 WyxQJeAi2uvp3m5M8do+H6COkhqX0v02Uk0p2P5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Subject: [PATCH 6.6 087/175] Bluetooth: btmtk: accept too short WMT FUNC_CTRL events
Date: Thu,  2 Jul 2026 18:19:48 +0200
Message-ID: <20260702155117.613263939@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
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

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit e3ac0d9f1a205f33a43fba3b79ef74d2f604c78b ]

MT7925 (USB ID 0e8d:e025) on fw version 20260106153314 sends WMT
FUNC_CTRL events that are missing the status field.

Prior to commit 006b9943b982 ("Bluetooth: btmtk: validate WMT event SKB
length before struct access") the status was read from out-of-bounds of
SKB data, which usually would result to success with
BTMTK_WMT_ON_UNDONE, although I don't know the intent here.  The bounds
check added in that commit returns with error instead, producing
"Bluetooth: hci0: Failed to send wmt func ctrl (-22)" and makes the
device unusable.

Fix the regression by interpreting too short packet as status
BTMTK_WMT_ON_UNDONE, which makes the device work normally again.

Fixes: 634a4408c061 ("Bluetooth: btmtk: validate WMT event SKB length before struct access")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Tested-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com> # MT7922 (0489:e0e2)
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/bluetooth/btmtk.c b/drivers/bluetooth/btmtk.c
index 5c6f4d4b2e7f0c..582915f9a8d700 100644
--- a/drivers/bluetooth/btmtk.c
+++ b/drivers/bluetooth/btmtk.c
@@ -679,8 +679,8 @@ int btmtk_usb_hci_wmt_sync(struct hci_dev *hdev,
 	case BTMTK_WMT_FUNC_CTRL:
 		if (!skb_pull_data(data->evt_skb,
 				   sizeof(wmt_evt_funcc->status))) {
-			err = -EINVAL;
-			goto err_free_skb;
+			status = BTMTK_WMT_ON_UNDONE;
+			break;
 		}
 
 		wmt_evt_funcc = (struct btmtk_hci_wmt_evt_funcc *)wmt_evt;
-- 
2.53.0



