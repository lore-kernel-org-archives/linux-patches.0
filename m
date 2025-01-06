Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3042915958A;
	Mon,  6 Jan 2025 15:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177253; cv=none; b=tgR9+dgailmypp7mIhVaEr5TT3C3biSvZQPI1UGmDh4vkCT1DkpE9xK1YVIrMACf4NzfP1/3UjNl0UDY9fBOWbS648PFZF4tnUIRlTYCocNNppHNS26wiNoUKTVnfC0P9ke22ftwrM4u0hffVZk/PHO/mwHzcifzrxt+zjK0V4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177253; c=relaxed/simple;
	bh=2kXlZIy/etYXdNAqF0LSgec+VjRJgKoqU35pJxrL7KE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lQ0T1IRUiVaFnn9Zd4/qFQvkQ4lxUZdZeC8RA11tqDTQ9IDTjQmXCEGAUykb6bUM+qT8zntTN8e+PigYllSuUHRIfm21fBouUE6uFJVf3tctm7SruhJm9GcCNyJw6b5JDvzdoQllnEAMFhUul2TAEWvCpKxBfkuWEskVG8qVTAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pZspNbmz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pZspNbmz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE5FAC4CED2;
	Mon,  6 Jan 2025 15:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177253;
	bh=2kXlZIy/etYXdNAqF0LSgec+VjRJgKoqU35pJxrL7KE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pZspNbmzdSu9yPY+PlWxZW7708V4+veG7gCOm6TSVVQ+3tJ5KanxPHyWbZmsF3Jp8
	 AzEUGd8YqEYgUr5p8s7rBbHnn9Rea+ix7iKC2uPuwzDQK3UQ+Dqd2K03buPGL/Q91M
	 OyZUTZcM0/YOCMs2wprYwNmDsUCVPl+Tp4BGjEW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lu <chris.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 103/222] Bluetooth: btusb: mediatek: add callback function in btusb_disconnect
Date: Mon,  6 Jan 2025 16:15:07 +0100
Message-ID: <20250106151154.494763226@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit cea1805f165cdd783dd21f26df957118cb8641b4 ]

Add disconnect callback function in btusb_disconnect which is reserved
for vendor specific usage before deregister hci in btusb_disconnect.

Signed-off-by: Chris Lu <chris.lu@mediatek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 19d371aa8317..c80b5aa7628a 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -894,6 +894,7 @@ struct btusb_data {
 
 	int (*suspend)(struct hci_dev *hdev);
 	int (*resume)(struct hci_dev *hdev);
+	int (*disconnect)(struct hci_dev *hdev);
 
 	int oob_wake_irq;   /* irq for out-of-band wake-on-bt */
 	unsigned cmd_timeout_cnt;
@@ -4646,6 +4647,9 @@ static void btusb_disconnect(struct usb_interface *intf)
 	if (data->diag)
 		usb_set_intfdata(data->diag, NULL);
 
+	if (data->disconnect)
+		data->disconnect(hdev);
+
 	hci_unregister_dev(hdev);
 
 	if (intf == data->intf) {
-- 
2.39.5



