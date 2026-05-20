Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45937364EB0;
	Wed, 20 May 2026 17:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297150; cv=none; b=VceYewdLawHyOXhuRDE8KDkWUTHX0iLwsLExXpVX/YNXZFPzd7YhOfdZWF8Iai0MEhK9oy3X7jQGA/NaV2yZaHyquaVE/vb7fpQwKXuvuoB7Vqx4NTKuvF86TrUy5lOWCcpuv5ZGCPbeAUfJwYyiuUXffcGSGdg/Xic1BfNKqLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297150; c=relaxed/simple;
	bh=mZsZSEurYH8iX/bXSIaNpPeucQJQ08XoH3KE6fwz+VM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pn2Z958JXvAxNK33a/NyvmaR6wIbb/FWUgZMWeNZpNskK5CEXaif1IYablUBnpTzfo69rRufE/mbVL60ucOjVsPlRf50+XLKobNYsy396MqvAzil34cwmTZPRZhlaSff4dTp7tWAt/OERCBfKpL7UTsBYlHB9tVztHAt0VgRR7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P9iyCPkP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P9iyCPkP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC14D1F000E9;
	Wed, 20 May 2026 17:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297149;
	bh=zpCLM3epaJIWSrKfATFimcymIDbQu20CxeHjYeHpfIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P9iyCPkPge3u/YSiFnZ06OSQUh1EVFDF3PtxipbImpl5xKCKt8wnn3WTsSJ7h0ulg
	 nC7gTEJy+FrzJ3D7yIKG4TQqNuQVHjwGR2u7h1ebFaVmft6pTeEyE21VNUWbKD0hm0
	 mMc5pTnRay4BbkkbBWoihhPI12z8LdzYYp6ghqfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Subject: [PATCH 7.0 1069/1146] Bluetooth: btmtk: accept too short WMT FUNC_CTRL events
Date: Wed, 20 May 2026 18:21:59 +0200
Message-ID: <20260520162212.424949650@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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


