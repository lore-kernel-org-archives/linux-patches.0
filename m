Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18303E0750;
	Wed, 30 Sep 2026 19:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796215; cv=none; b=dk2iI4VlXlVx+BlioYnCpYdjxAsLtOCTDNGRTOdGUwlnAO3M+RSrv8UUqXqjWzLJjZ8CWD5GTUoMP7gWi63jr1KHYdDUwF/rkcVKCKR/5xkWpPO+UIoFRFggrLjYkpb02+nF2SkhX0LBqoRXCr/HP/PRoOd8w4TCnga78G5tewM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796215; c=relaxed/simple;
	bh=2ebp+1diY4FZyHd1jytMBQB32id6yi1s6U5o9FmxUCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sXUPpuvEJZNXSNtcANUW1LrLrpTlb94WOLqjragv/HO1Ep4C3encOmw1bzfnsLy8v/iGkU+qnzgIhWdxwW4hpaoTBjks/apTXKxfAY+GCm9Dav3W/9Ng8svh+KKMcXRARwPchZqfjDCS2IwKzuu9yqdnqVbQvQwtF9ClgFML2a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Gg1THPJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Gg1THPJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D271F000FF;
	Wed, 30 Sep 2026 19:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796213;
	bh=mFtExeOYGXHctOiB0CNQW6buLnPb7SEdpsI/5fGL6IE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Gg1THPJdKg0Yw7jVvdTjtGG5lyS2gke3Chp85xzlwOtNQ+yq91MXDZJheKNhsDoI
	 QkqP4aARSZwvbiXlT3nS/Q2NiqQ10rlh27Wh9f34fSKMB+7MnHcZPifOsEImBIidk7
	 ed6TrGdavf3tTIVa6V3CoPWgaPiRAEnqh4We6wxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lu <chris.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0807/1193] Bluetooth: btmtk: fix wrong status for short WMT FUNC_CTRL events
Date: Wed, 30 Sep 2026 17:24:51 +0200
Message-ID: <20260930152452.172832121@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index fe9710a236d9d..52a7f727d2dd5 100644
--- a/drivers/bluetooth/btmtk.c
+++ b/drivers/bluetooth/btmtk.c
@@ -677,7 +677,12 @@ static int btmtk_usb_hci_wmt_sync(struct hci_dev *hdev,
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



