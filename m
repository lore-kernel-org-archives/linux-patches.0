Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C866B28EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:03:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49D7CC433EF;
	Mon, 30 Jan 2023 14:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087409;
	bh=l1H+fOC0Nc1Nao39+ApHRgz7glpZpqmOr+cw/n12dh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ID+A6vR2lPJlOt+MdC08fx/9WPgfRfW66HnkXqfSpvv+1VsN+6U581KTrhQqX1FBH
	 hPT5KuZ6TK43WWgyomhaujudZgB2uh6YnmLPVtuJt+VWD8AGMyz7NVrto2ASC52sKe
	 +Yc4pifSi4xOe1qaHWRlioCecJo1273moeAS4a6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Archie Pusaka <apusaka@chromium.org>,
	Abhishek Pandit-Subedi <abhishekpandit@google.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 197/313] Bluetooth: hci_sync: cancel cmd_timer if hci_open failed
Date: Mon, 30 Jan 2023 14:50:32 +0100
Message-Id: <20230130134345.879993697@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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
 net/bluetooth/hci_sync.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 67dd4c9fa4a5..3eec688a88a9 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -4703,6 +4703,7 @@ int hci_dev_open_sync(struct hci_dev *hdev)
 			hdev->flush(hdev);
 
 		if (hdev->sent_cmd) {
+			cancel_delayed_work_sync(&hdev->cmd_timer);
 			kfree_skb(hdev->sent_cmd);
 			hdev->sent_cmd = NULL;
 		}
-- 
2.39.0



