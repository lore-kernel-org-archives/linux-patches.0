Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55673488219;
	Wed, 23 Sep 2026 14:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173215; cv=none; b=dQyUU6mHWiFjVW+iisHY0Dd0MF71JhKQ837zX0YQlZCmRRUThoBKW7pw3a/7b0f9ucH6QmJliSttQnFdyjg05FQIx3HnfiqKROYBlIBDlJR5PfTVhf7X5naA7audghqqTlhEYDYij21jXvwj8iqVC/RaH4RzUjaEXaOk/M3C1rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173215; c=relaxed/simple;
	bh=Yq1//DOgkzce/xUH2RSJrAO9F+dwAuRJH4MsXWyuqZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PbTi5xGS3vSbWAp131IcWD+8JspwnzHK4wXa+EfWURt7/vq5fwL3qpdib71JlFU4YVzanjSoqDD+vC0O0nl9HS+s+0TSStOFBia3UM3LrG30PBBB55fDqoJ/sYvxyKzIm98Y+qhElH1lNEdtm2cDv9a8ZiOwzxOaVavWiadikpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eMK+BBUR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eMK+BBUR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A3111F000FF;
	Wed, 23 Sep 2026 14:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173214;
	bh=OgvUF8aeEiZFWzWu7vBj0ceIsNH73oZw/2/tQaWPR/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eMK+BBURp3z7+5h/p8qI+H9V94rKL+ad1DM1jU5k+/HWpb4kIrNGSTUpMWA0K+2ER
	 4cMR2iRiU8EAj44fsL+KhCS0cFYxmFoG4o4EpeCSJxccf9I2uf4NXZvpQIVe3Iu9K4
	 AOiL9fViw0rpUypRk2OcBW2tWNHNwppVhXfeI1jM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lu <chris.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 175/438] Bluetooth: btmtk: fix wrong status for short WMT FUNC_CTRL events
Date: Wed, 23 Sep 2026 16:03:16 +0200
Message-ID: <20260923140649.303653265@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 26d525acd6590..7ea8bcd8a7eca 100644
--- a/drivers/bluetooth/btmtk.c
+++ b/drivers/bluetooth/btmtk.c
@@ -721,7 +721,12 @@ static int btmtk_usb_hci_wmt_sync(struct hci_dev *hdev,
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



