Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A8E412D74B;
	Tue, 30 Apr 2024 11:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475348; cv=none; b=sDuoioPhuBkUfFl2Utrk5KWHAZ1Nt6cMPuTIB+/3b9IVkmJ7vaTLUd2GyIxMz7eLo+7u1nVe+Svo4o/ot65qlI+GQiLI/p8Ok9qD6NVDg6of68xSBKlZ0t/IRPWpDF5l91pMS9cQ6QpPfV1kU5GcQhMCvcpE2MxIwnxRqAz4gXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475348; c=relaxed/simple;
	bh=Ake82PXdwjPdd14EXxQrDgO9aTelmV9SpbxkF81+DEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pjcd/rsDFQWQcc1YMEZTKAH9bOoN94kpuWr4WbKqi7TKA7wlm3dyL9VNDikfGsbbu0NBkxGehVia2d0RyfbzsNeUXIqVmJPutUyTktlrspkzKFY5jJMoucOa5bLZqxKXwIVLHgqozP6qm4cQdg7fRTJken+yrBnWvbmf9Ufx0Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MP7oarj2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MP7oarj2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FCCFC4AF18;
	Tue, 30 Apr 2024 11:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475348;
	bh=Ake82PXdwjPdd14EXxQrDgO9aTelmV9SpbxkF81+DEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MP7oarj2T1CTgRoKTgVRcpw1AwFGQ65p9DaEGL+rImJU3HBzs4l+bxNftAYiX3+NS
	 88AslDTpmzioOP3N6BemiaFisoDM+ZkszZwDTnjh+OAVEzUYP9l6p7QUd49cekj2RA
	 78s8YO9GAXP2sOHdstGXnfqDbqL6+yKjKl56Fm8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Wang <sean.wang@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 069/186] Bluetooth: btusb: mediatek: Fix double free of skb in coredump
Date: Tue, 30 Apr 2024 12:38:41 +0200
Message-ID: <20240430103100.039866670@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit 18bdb386a1a30e7a3d7732a98e45e69cf6b5710d ]

hci_devcd_append() would free the skb on error so the caller don't
have to free it again otherwise it would cause the double free of skb.

Fixes: 0b7015132878 ("Bluetooth: btusb: mediatek: add MediaTek devcoredump support")
Reported-by : Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtk.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/bluetooth/btmtk.c b/drivers/bluetooth/btmtk.c
index ac8ebccd35075..812fd2a8f853e 100644
--- a/drivers/bluetooth/btmtk.c
+++ b/drivers/bluetooth/btmtk.c
@@ -380,8 +380,10 @@ int btmtk_process_coredump(struct hci_dev *hdev, struct sk_buff *skb)
 	switch (data->cd_info.state) {
 	case HCI_DEVCOREDUMP_IDLE:
 		err = hci_devcd_init(hdev, MTK_COREDUMP_SIZE);
-		if (err < 0)
+		if (err < 0) {
+			kfree_skb(skb);
 			break;
+		}
 		data->cd_info.cnt = 0;
 
 		/* It is supposed coredump can be done within 5 seconds */
@@ -407,9 +409,6 @@ int btmtk_process_coredump(struct hci_dev *hdev, struct sk_buff *skb)
 		break;
 	}
 
-	if (err < 0)
-		kfree_skb(skb);
-
 	return err;
 }
 EXPORT_SYMBOL_GPL(btmtk_process_coredump);
-- 
2.43.0



