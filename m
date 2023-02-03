Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C32C1FB4
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:15:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 768E3C433D2;
	Fri,  3 Feb 2023 10:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419305;
	bh=Zyo5FTrGry/McMnAJYMNO149LS+7CakmgYvSCFniIGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dNZO5qH65olaAN6a/NnKLJQY33CIK4N+jl+32MLVIThrYRVhvNse9prslWOEhZL6o
	 0vY6cK7JVcGK3PxNSeVFfm7rXyUxencHB8RRndwTagLOIm//aIEDG0cjpopuym8D8g
	 K/V6lWIVaNeob1Cbir3uLIXCa5VAQKwaYKiCDGNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Archie Pusaka <apusaka@chromium.org>,
	Abhishek Pandit-Subedi <abhishekpandit@google.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 24/62] Bluetooth: hci_sync: cancel cmd_timer if hci_open failed
Date: Fri,  3 Feb 2023 11:12:20 +0100
Message-Id: <20230203101014.059672721@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101012.959398849@linuxfoundation.org>
References: <20230203101012.959398849@linuxfoundation.org>
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
index 81a151ca4a24..1fd6498e3387 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1479,6 +1479,7 @@ static int hci_dev_do_open(struct hci_dev *hdev)
 			hdev->flush(hdev);
 
 		if (hdev->sent_cmd) {
+			cancel_delayed_work_sync(&hdev->cmd_timer);
 			kfree_skb(hdev->sent_cmd);
 			hdev->sent_cmd = NULL;
 		}
-- 
2.39.0



