Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D66371048;
	Wed, 20 May 2026 18:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301619; cv=none; b=V3Cwnix8PTupGbA0M3APui00PWAiJTD0emdrRfKl5om3fuppRxpifpLclYyf6Lf0aYLP1T0JdUOSbGcIKZZx0eGnV37SPljBh2nZDjG/iSXuCwnF/ETyZQzTSVgbXMTA3tz39L3GEp+5E89YL0zUhvDWe+ECfz9QQ+BKly7pWoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301619; c=relaxed/simple;
	bh=T+F5Z+CypjNbA+NOQuMLiBaTBI3JUF3u/WBG6/q7uf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Av/wS34mAk7nuLgofeHTxQ4O4bkSfQwc7nCt/DU8N6uN6B+yxDpCvzSP77q7cOvZQrbyBVZsEZlJW61Nb2GJ3RjuE++Pw0zLgmNZ9z7z21XIy7RE6jLvYcX0/KlneB/GI+kcLEsU9uKj6KwuLlNvYaQh5UctVJdXe1KeB7m9cY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EMQ6ardt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EMQ6ardt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6874B1F000E9;
	Wed, 20 May 2026 18:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301617;
	bh=XXgIHywmpYDimFuuXN9dQfoub1XBqRSTG+yLA0FGH5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EMQ6ardtltzj4fdqazJKmGdOIOeU/25IbmnM08MoA9WWpejztZJ0QWNoFb/edLEAC
	 4ufj+pttAMu803Fw6e5yKxFEN2QS4EZEqkFsdLW/zoiPk09vMeO6qrp13IrIa+NS9m
	 1TckzyoK64YeP12j9FdqAozRpJLKxMQH0oIn0x14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Subject: [PATCH 6.12 624/666] Bluetooth: btmtk: accept too short WMT FUNC_CTRL events
Date: Wed, 20 May 2026 18:23:55 +0200
Message-ID: <20260520162124.798447239@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


