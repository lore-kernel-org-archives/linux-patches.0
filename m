Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 691A013D514;
	Tue, 14 May 2024 10:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683353; cv=none; b=GFVqzjB1or4o0QxmjIyh4YO+qgZ7ZIzw/G6F2wF0zH/lgmu47Lr5KPWtsEIpJXdrJQNlkt/7DLUz/3tkj6obnjmAFCatMMPNgjSHbn0KRa4hAmD1uXmpASGpKCQ+qZDekAR/ugbOW8s7l+8ra0DQWyhgfBSgAh6qrQqplwKZKd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683353; c=relaxed/simple;
	bh=q/QBK7P5CUxElN6Rev/8KP9aI+ZFHZsEM4pQoifcxM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MRtA+/EG2vznrwbYk3e7l+qhA5lKgEY4Gx5Qvi8k81XLjvHlpHHcmlH4YPXhuckBIdW7OR1wohhN3wZKV7Yr9dtpJn/fBy74+Uw2g+/UCMYum1snwsOfcJl2XPPWvJHvcW+enWuzRndVWnIojXwIQTeUzdyhHNmh1yPMkpFwTe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2nbAghlk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2nbAghlk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 098E0C2BD10;
	Tue, 14 May 2024 10:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683353;
	bh=q/QBK7P5CUxElN6Rev/8KP9aI+ZFHZsEM4pQoifcxM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2nbAghlkRXwf5ND8muRElLPWymTvYCLFIiATYwUF33tEBCHwvdcoqnsHeJGt8ClCC
	 Vym6IHJpXUbzdvINVYsFFmBsTHBRgSrCzQHzaAdrxoKsSDGWrzLyn6D3ZTiYydkSTy
	 4PWNab3atn7Gah6kJOQ1l/FXQJPdf0mBqzjzoLPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sungwoo Kim <iam@sung-woo.kim>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 203/336] Bluetooth: HCI: Fix potential null-ptr-deref
Date: Tue, 14 May 2024 12:16:47 +0200
Message-ID: <20240514101046.266795912@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sungwoo Kim <iam@sung-woo.kim>

[ Upstream commit d2706004a1b8b526592e823d7e52551b518a7941 ]

Fix potential null-ptr-deref in hci_le_big_sync_established_evt().

Fixes: f777d8827817 (Bluetooth: ISO: Notify user space about failed bis connections)
Signed-off-by: Sungwoo Kim <iam@sung-woo.kim>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 9d1063c51ed29..0f56ad33801e3 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -7181,6 +7181,8 @@ static void hci_le_big_sync_established_evt(struct hci_dev *hdev, void *data,
 			u16 handle = le16_to_cpu(ev->bis[i]);
 
 			bis = hci_conn_hash_lookup_handle(hdev, handle);
+			if (!bis)
+				continue;
 
 			set_bit(HCI_CONN_BIG_SYNC_FAILED, &bis->flags);
 			hci_connect_cfm(bis, ev->status);
-- 
2.43.0



