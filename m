Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E1D3EA953;
	Wed, 20 May 2026 17:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299824; cv=none; b=T2QxD903lhuZi5bPOR11dGArpgbADkvD3OqoXIgGYPftk9US4YQzqOi+nFUDsXYqk/9WCv5kDHnA+jQH4TdHTKq6C5gQ0xx+Wjp/PHVDDZ30OxIRes8QqGOOTwqE3jwWDRs3FMAgB+e+tE3hh6a1V3Cl536CSOKL4bUuWHZe9Gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299824; c=relaxed/simple;
	bh=oob4HVZ2Y5TYGYx14pYiE5aBR8+Z2bcIUuJMkzxXSQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uYuWgumdg7yooOutk4QZwbuW3IEPYiC7lVyAB/uS9rkZRo77XorRkfOn0JICpu5dxYVCx/SPlhNvdIb1yeaycLBEPttDBcIJQIs+WEk+c3Gp9GWr/DMJvsqSxhIA7C/JlxaLcrp9cD2xtC+OCJVyWRRD9uw8q7DgBWF/mFjKioI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WkgiEtc5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WkgiEtc5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D91B71F000E9;
	Wed, 20 May 2026 17:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299823;
	bh=h3dFz6EUjyanQtyDFXyU36XGrAo5MM+EP5DhdbBqhag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WkgiEtc5QSeCjUz1bvcuynPpfUmT6j5N8PyeFg4pZMtIJ6nXNEUPzJqGUd1F3DXUG
	 4cE+wUWyWcps8VMNyJoGg61QnF2yot81xwoHzAMVmuV1OGLW96NS8crZRxV0n7ybeX
	 d47v2FhafCJRGVdGsCErZ36XJXv6V04r9Yr3s1dw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Subject: [PATCH 6.18 901/957] Bluetooth: btmtk: accept too short WMT FUNC_CTRL events
Date: Wed, 20 May 2026 18:23:04 +0200
Message-ID: <20260520162154.113878408@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Pauli Virtanen <pav@iki.fi>

commit e3ac0d9f1a205f33a43fba3b79ef74d2f604c78b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btmtk.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/bluetooth/btmtk.c
+++ b/drivers/bluetooth/btmtk.c
@@ -678,8 +678,8 @@ static int btmtk_usb_hci_wmt_sync(struct
 	case BTMTK_WMT_FUNC_CTRL:
 		if (!skb_pull_data(data->evt_skb,
 				   sizeof(wmt_evt_funcc->status))) {
-			err = -EINVAL;
-			goto err_free_skb;
+			status = BTMTK_WMT_ON_UNDONE;
+			break;
 		}
 
 		wmt_evt_funcc = (struct btmtk_hci_wmt_evt_funcc *)wmt_evt;


