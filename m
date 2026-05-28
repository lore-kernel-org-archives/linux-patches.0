Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 197E635C1A6;
	Thu, 28 May 2026 20:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001575; cv=none; b=eadbfoqvzKuIt6fO13/GcFsQ1yrF+cCYJtv8JIIWTyFOr+kxayE8fbxcN6P5Ecdxc86pCYEk49uBJMT1Smr4tVSFSNGfMfyDCN/2YzLbb7cFQn1JOkRhan+917w5uvqbEI8A6CD7n3osdlwSdygesdYbWFE9u6CEmksJPrUOkB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001575; c=relaxed/simple;
	bh=FG4kXqoCXQ4P0CAwmIy+E8LSARQQsniqILPvaOOAtak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kc4lyWQ6eJK2Fyh99ef0IaBTVe4/oBj+WLWIHqrIa55yHV8h4nok2AlnadSx4YuG616iDk/xBLS/UXMq/ixoJi1u30oBoOXVYtoPrZemRjZKUsSeaZQGTEIaHseDnYhyNmw3e8LO5mE/N2zJe6Ws9S2czj+Zj6WQ2JnhnR1WfgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I5bcg/4w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I5bcg/4w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF191F00A3A;
	Thu, 28 May 2026 20:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001573;
	bh=QrTQg/cqvdW7EeEVYE9hCi9httQIidRJkwd19xGLAXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I5bcg/4w+gCLda9WXfhpulez40+goW65af9hspYKk1pgK5V7H/GdXuc5E2/j2F9S2
	 yr67cYBMg5aPE/bDfojXuiwTZbaRiLLuUG1HdIbNHn4b0neRR/78RxGYBxEc6hdTx1
	 NsFK9RBFEs5zBEG8R+vUel1p8KFGSBV7KhKp7R4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiajia Liu <liujiajia@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 175/186] Bluetooth: btmtk: fix urb->setup_packet leak in error paths
Date: Thu, 28 May 2026 21:50:55 +0200
Message-ID: <20260528194933.708922588@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

From: Jiajia Liu <liujiajia@kylinos.cn>

[ Upstream commit dd1dda6b8d6e1f4376a5b3055a04f0ecbdb4d6bd ]

The setup_packet of control urb is not freed if usb_submit_urb fails or
the submitted urb is killed. Add free in these two paths.

Fixes: a1c49c434e150 ("Bluetooth: btusb: Add protocol support for MediaTek MT7668U USB devices")
Signed-off-by: Jiajia Liu <liujiajia@kylinos.cn>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtk.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btmtk.c b/drivers/bluetooth/btmtk.c
index 17cb58dce8140..ad8753dda826b 100644
--- a/drivers/bluetooth/btmtk.c
+++ b/drivers/bluetooth/btmtk.c
@@ -490,6 +490,7 @@ static void btmtk_usb_wmt_recv(struct urb *urb)
 		return;
 	} else if (urb->status == -ENOENT) {
 		/* Avoid suspend failed when usb_kill_urb */
+		kfree(urb->setup_packet);
 		return;
 	}
 
@@ -563,6 +564,7 @@ static int btmtk_usb_submit_wmt_recv_urb(struct hci_dev *hdev)
 		if (err != -EPERM && err != -ENODEV)
 			bt_dev_err(hdev, "urb %p submission failed (%d)",
 				   urb, -err);
+		kfree(dr);
 		usb_unanchor_urb(urb);
 	}
 
-- 
2.53.0



