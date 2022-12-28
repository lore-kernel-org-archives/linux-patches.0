Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B7131C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:09:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 867A5C433D2;
	Wed, 28 Dec 2022 16:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243784;
	bh=o7AMaP2fMCGzbBE6JGcaXnh2AL9tSOHx8jT3Oh7ody0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O7v5Qa+RPDBpoC5Xp9vCeW8V1OEaqbMxRPC8oNMBVgNuR1EimmKm7O4RrwwdbFeBf
	 xTi7hNiYZ0Ak7Yo1ZQs0k2TkF7ygvXKqZkdRA6QVDlGIxE4lcwN+CBu0lgbMH1QP4e
	 B+BQ3MIJJOVd6NCe6Xl4z3Yeusv8T/p5qVJYzKas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0555/1146] Bluetooth: hci_core: fix error handling in hci_register_dev()
Date: Wed, 28 Dec 2022 15:34:54 +0100
Message-Id: <20221228144345.244292207@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 0d75da38e060d21f948b3df5f5e349c962cf1ed2 ]

If hci_register_suspend_notifier() returns error, the hdev and rfkill
are leaked. We could disregard the error and print a warning message
instead to avoid leaks, as it just means we won't be handing suspend
requests.

Fixes: 9952d90ea288 ("Bluetooth: Handle PM_SUSPEND_PREPARE and PM_POST_SUSPEND")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index d97fac4f7130..56f8569ace86 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2660,7 +2660,7 @@ int hci_register_dev(struct hci_dev *hdev)
 
 	error = hci_register_suspend_notifier(hdev);
 	if (error)
-		goto err_wqueue;
+		BT_WARN("register suspend notifier failed error:%d\n", error);
 
 	queue_work(hdev->req_workqueue, &hdev->power_on);
 
-- 
2.35.1



