Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6617B33F5BE;
	Thu, 28 May 2026 20:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999139; cv=none; b=UsBAQAFZIXO0B7yyl2hUpPi8qVhGo9TfhMkZlDlqFTSLtMlS86JfTuSu2TcysFSFlSL9ExCkQ3E07wMORtNp8uLso8MKaWXgR/dTVU/+omwcQpUtTtlIDle7x3aZxUjzIH8nUi2zxWhEYng4sQDGQC4NW/1NlJwNutCZgnqVKcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999139; c=relaxed/simple;
	bh=su9kyS9IxBjbuqeYc6oOGAgWij7QWSebx9B8JCejxtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sGFttQAfXAWgvRQw9b79wXbrRQnzZtetb7CnuOCMT9ayD9vX6RloXUszoAfiwFO8h4SHHZdE6GuQUxhjyxzaSlGyZyydD8ylyoUuamjcBNKUTfCju9mIyWOL7alZhtFU3EM7JFforB26kwd8gqtom5wjt+6FTrZrpO6PPmOSGps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QWnl/0b0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QWnl/0b0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C40BA1F000E9;
	Thu, 28 May 2026 20:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999138;
	bh=aPizUL4q0x+opUbvmhat3nyxjvXgwsMt+eXRnF8CTcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QWnl/0b0b2nfTnfoqvXQ0Wg8+yOY8OXfdmg5kctfrNdycbuXlm0KgE8qaPxEpE+lf
	 fRhYNTlXNq17zGJBzsI1mFKPJBeI0kBQkcS6ipZ5sCR+H+HEmTNz/Hj2V4mxYrYk8J
	 kzoB9GIc1GUUuyurw5WA7LpYueQzU4HU0CjKtFvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiajia Liu <liujiajia@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 421/461] Bluetooth: btmtk: fix urb->setup_packet leak in error paths
Date: Thu, 28 May 2026 21:49:10 +0200
Message-ID: <20260528194659.688421360@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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
index a4b4dacfd2ad3..04f183fd3d12b 100644
--- a/drivers/bluetooth/btmtk.c
+++ b/drivers/bluetooth/btmtk.c
@@ -496,6 +496,7 @@ static void btmtk_usb_wmt_recv(struct urb *urb)
 		return;
 	} else if (urb->status == -ENOENT) {
 		/* Avoid suspend failed when usb_kill_urb */
+		kfree(urb->setup_packet);
 		return;
 	}
 
@@ -569,6 +570,7 @@ static int btmtk_usb_submit_wmt_recv_urb(struct hci_dev *hdev)
 		if (err != -EPERM && err != -ENODEV)
 			bt_dev_err(hdev, "urb %p submission failed (%d)",
 				   urb, -err);
+		kfree(dr);
 		usb_unanchor_urb(urb);
 	}
 
-- 
2.53.0



