Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F0DC5372FA;
	Wed, 23 Sep 2026 14:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174547; cv=none; b=ET3xzSvOdQyDE5UOfC/xJm0gpV4MF76SW3rDGN70yeOBM6FA/dEVZu4+CStX1+yTgLZo2Z4EnzVZkvQmGtidp/+DQXMAO4XeDXZmMyrTDwtgD8c9CYJhhRT1+NX/ynFuQF2pj1ri6KSPW7ozNid8H9/UDpi43w7etyIoJhZAY8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174547; c=relaxed/simple;
	bh=ErGWIjSa2GF5dgVTeSxomuS5P9/j+oI9um07QliDq+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j6UwNVfUTUO7ij7+khhaXTIbqNL3VCU4+4sg3F6z4Qrto2buErfkwndJNpWfv/06W9PX2xYKcvOY/LqBrvyg2EYGlJDdPmoHzVH+cdYNsff8SJh/5wfj6su3MYjkIk7HagISu3pT4qA9zIKCXwXB1s4S6Ge/BQVYejiQZ3Esjs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VITHyPPt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VITHyPPt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75DF41F000FF;
	Wed, 23 Sep 2026 14:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174546;
	bh=/ZITgDOwrzKeA8K215ecV/IANHuEnXAhfhLtOAqTanc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VITHyPPtHpdkezFWdet8SZT7AmIrAQ1B3M68i0RNaoK+z31HNpyrCcIGguSgk+xlu
	 QOF0C0I+7vIho/HahTcbSmFBAJeavQFuMmnniPFA+1BoKrAr0GtkzRSTt/zcNRvoSU
	 gh8KthhUncx/AX28ArrbBYmhTLcxQIrA/NBw67RA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lu <chris.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 150/398] Bluetooth: btmtk: fix wrong status for short WMT FUNC_CTRL events
Date: Wed, 23 Sep 2026 16:03:44 +0200
Message-ID: <20260923140647.319936960@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Chris Lu <chris.lu@mediatek.com>

[ Upstream commit 78b6abd6c7a7591aacdae657f813214dae4fcd3b ]

A too-short BTMTK_WMT_FUNC_CTRL event (WMT header only, no trailing
2-byte status word) is always treated as BTMTK_WMT_ON_UNDONE. This
short form is how firmware acks a plain enable/disable request, and
the actual result is carried in the header's own flag byte (0 =
success), not a separate status word. Decode it from there instead of
assuming failure.

Verified setup on MT7920, MT7921, MT7922 and MT7925: no regression.

Fixes: e3ac0d9f1a20 ("Bluetooth: btmtk: accept too short WMT FUNC_CTRL events")
Assisted-by: Claude:claude-opus-5
Signed-off-by: Chris Lu <chris.lu@mediatek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtk.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btmtk.c b/drivers/bluetooth/btmtk.c
index d1817dd6ab650..c525e2685a861 100644
--- a/drivers/bluetooth/btmtk.c
+++ b/drivers/bluetooth/btmtk.c
@@ -709,7 +709,12 @@ static int btmtk_usb_hci_wmt_sync(struct hci_dev *hdev,
 	case BTMTK_WMT_FUNC_CTRL:
 		if (!skb_pull_data(data->evt_skb,
 				   sizeof(wmt_evt_funcc->status))) {
-			status = BTMTK_WMT_ON_UNDONE;
+			/* A plain enable/disable request is acked with just
+			 * the WMT header and no trailing status word; the
+			 * result is carried in the header's own flag byte.
+			 */
+			status = wmt_evt->whdr.flag ? BTMTK_WMT_ON_UNDONE :
+						       BTMTK_WMT_ON_DONE;
 			break;
 		}
 
-- 
2.53.0



