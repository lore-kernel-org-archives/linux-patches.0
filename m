Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215355;
	b=WspkvES67XjG4eI95WAwfIYQAziv8inxaJr6UxOhy4kq4wEJhcDnGGPiOYgrmCaBjMX9
	 1zVYd017bSClPILgp5nyrDyNYwIW68v1e/1SOoXLyrLp/BDTChwM9DxVcqZLASdFqobj1
	 8n4AIhvJBHd0qSv8zlAoAl6m0xMsQbhpYKKqR4EX5Z1FqLGa+yJUEiVV3TGRDGalIGxzp
	 ZLLqNJKymLANLqMwROeRm6YPwI0/RRulcFYV9q0nHU0VytR/zRHFgbmuWyf5UqtaqDG5a
	 mX5zpMhFZ9hYjDekFwQ5FkaMByTKrPu3aaqLg8M9AyFhp0pOfjeNabEXeupRIRw8Ifg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215355;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YvXkYvzUTPYrkjmRRA+j1N7yM5ed4QacFMjDQhv29FM=;
	b=p2qUh1vNYqN0t+yOg4MORMcrF1w1+3/xYVmIxEWFNEz17xzzJskclOguGyB8QDb948W7
	 qv5xP7wvxd1UbEdR/EnIefkJs0Mk9nUsBKV1wHbWSnBR1aIwAyC9ezbp4ijpAs3fH3r1/
	 Z5JC73tBot+/8vmNHgmYuenrDhgH88WZLBB0+LlDXh2mBLLGimMrkbefp3YXM6gefpbBa
	 63EvgNTrfq3j6nIZcobWiMf5ckR1zgKhCQ6KpPq3KVyLJnlBAYDIu1aFtM7LdxMSuQcEV
	 zTcIp1pviOA3vt5Mw+WrMha5L7f+j6z+a/mVH/XhEFSHwg6Y8c6KKIJisOgIkrMd/Bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=itti0Tv3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 323F5606A31A;
	Wed, 28 Oct 2026 19:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=itti0Tv3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82F881F01825;
	Wed, 28 Oct 2026 19:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215355;
	bh=YvXkYvzUTPYrkjmRRA+j1N7yM5ed4QacFMjDQhv29FM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=itti0Tv3pNUTdosZZECNczJ/L5iw4S9y0v309aG07Bf3oN0ssQNuK9RBHZgNWSu+h
	 nvAYmzTr4HZmu5g7vzvh7wAD1/C1wS8XByPinEk4d0ImbehS3p8Oo8iPgImQyc32YF
	 gsGw3iLjRRri28EqFGCsHyyfet7gvK5A6mdd2RM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiajia Liu <liujiajia@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1139/1887] Bluetooth: btmtk: fix urb->setup_packet leak in error paths
Date: Wed, 28 Oct 2026 17:53:55 +0100
Message-ID: <20261028170525.326896349@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/bluetooth/btusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 3ffe8e3bcac9a..5196731ce892e 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2562,6 +2562,7 @@ static void btusb_mtk_wmt_recv(struct urb *urb)
 		return;
 	} else if (urb->status == -ENOENT) {
 		/* Avoid suspend failed when usb_kill_urb */
+		kfree(urb->setup_packet);
 		return;
 	}
 
@@ -2635,6 +2636,7 @@ static int btusb_mtk_submit_wmt_recv_urb(struct hci_dev *hdev)
 		if (err != -EPERM && err != -ENODEV)
 			bt_dev_err(hdev, "urb %p submission failed (%d)",
 				   urb, -err);
+		kfree(dr);
 		usb_unanchor_urb(urb);
 	}
 
-- 
2.53.0



