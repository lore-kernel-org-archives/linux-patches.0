Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 757631FB4
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:18:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA519C433EF;
	Fri,  3 Feb 2023 10:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419539;
	bh=+DuxHoLDq1pQ/HZ/BFLrRRpeJ/4BXh1hOVTNg/EXDe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RI0R/HroBSqbn7ZGdLRb1747wYlqGwmwGvQ7+t3BAYfBMLtTHemVnZwkEMsINNecB
	 vui6wslwGhatmsfceyU0eG5xpeuZz/pl8LqQvXJSK5irdbyozwm3/v2iqQDrZkkKyT
	 tcRFyygO7uIo1fEyd0C5tLTrnKdS2D4i22piK2Oc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Archie Pusaka <apusaka@chromium.org>,
	Abhishek Pandit-Subedi <abhishekpandit@google.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 36/80] Bluetooth: hci_sync: cancel cmd_timer if hci_open failed
Date: Fri,  3 Feb 2023 11:12:30 +0100
Message-Id: <20230203101016.721453196@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101015.263854890@linuxfoundation.org>
References: <20230203101015.263854890@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Archie Pusaka <apusaka@chromium.org>

commit 97dfaf073f5881c624856ef293be307b6166115c upstream.

If a command is already sent, we take care of freeing it, but we
also need to cancel the timeout as well.

Signed-off-by: Archie Pusaka <apusaka@chromium.org>
Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@google.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index e87777255c47..497c8ac140d1 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1519,6 +1519,7 @@ static int hci_dev_do_open(struct hci_dev *hdev)
 			hdev->flush(hdev);
 
 		if (hdev->sent_cmd) {
+			cancel_delayed_work_sync(&hdev->cmd_timer);
 			kfree_skb(hdev->sent_cmd);
 			hdev->sent_cmd = NULL;
 		}
-- 
2.39.0



