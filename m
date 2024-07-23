Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E8613D600;
	Tue, 23 Jul 2024 18:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759793; cv=none; b=JFoOColrU1FXAObZhZ5+ug+4yulcWt9xuz8UhIOTfvHEJ4Cuzl877nLzPA/U8IVy2NDHQgGYJD2KusBoyWMbyC+5RI0CPOOnwM7Ee1mq+4A8FU3mBXklwl+V+bmdpKiw5LA+Rr8OLWQHcpp3TvdymEiVi+TjEtGVoV12DxsCG8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759793; c=relaxed/simple;
	bh=o0aFCpupDaM1y/wy0q6VgaFOBOb48S+lTsS611ulrR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FzaqMCUlFIlhkAYFAvhicas3mpcnD2OMpp9Wu8msxTr+acE2BG8AzkmuIIGIpzVNowCSJ6auz5Z83YbfZRHew5ma9Jv3UT59lgZZOaW9UE4G+X93BZofebxoIfF4rf7oVNmyEpS7xiNUrUmezXuzdpzjX0PK53otZGT/0eHSAi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B+BYeNvK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B+BYeNvK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65559C4AF0A;
	Tue, 23 Jul 2024 18:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759792;
	bh=o0aFCpupDaM1y/wy0q6VgaFOBOb48S+lTsS611ulrR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B+BYeNvKyKWU0na2b0TW0ijkSem+JL6Wu3fgX/9/zTRnePl8cpgY8AS1yWNr8yg5G
	 0An9eIXJDQczyd1KTw5I/vCanr8Zq5jkh4LglJx0h/NupzTRs+shBbpVUbPt5VCV0z
	 dvu2vxTD5fGcXYsXfaIjRZ/ZsAWIoxyU9xN4CzJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+da0a9c9721e36db712e8@syzkaller.appspotmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 098/129] Bluetooth: hci_core: cancel all works upon hci_unregister_dev()
Date: Tue, 23 Jul 2024 20:24:06 +0200
Message-ID: <20240723180408.575182340@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
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

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 0d151a103775dd9645c78c97f77d6e2a5298d913 ]

syzbot is reporting that calling hci_release_dev() from hci_error_reset()
due to hci_dev_put() from hci_error_reset() can cause deadlock at
destroy_workqueue(), for hci_error_reset() is called from
hdev->req_workqueue which destroy_workqueue() needs to flush.

We need to make sure that hdev->{rx_work,cmd_work,tx_work} which are
queued into hdev->workqueue and hdev->{power_on,error_reset} which are
queued into hdev->req_workqueue are no longer running by the moment

       destroy_workqueue(hdev->workqueue);
       destroy_workqueue(hdev->req_workqueue);

are called from hci_release_dev().

Call cancel_work_sync() on these work items from hci_unregister_dev()
as soon as hdev->list is removed from hci_dev_list.

Reported-by: syzbot <syzbot+da0a9c9721e36db712e8@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=da0a9c9721e36db712e8
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 3817d6369f0cc..b4d5b7200ff9c 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2704,7 +2704,11 @@ void hci_unregister_dev(struct hci_dev *hdev)
 	list_del(&hdev->list);
 	write_unlock(&hci_dev_list_lock);
 
+	cancel_work_sync(&hdev->rx_work);
+	cancel_work_sync(&hdev->cmd_work);
+	cancel_work_sync(&hdev->tx_work);
 	cancel_work_sync(&hdev->power_on);
+	cancel_work_sync(&hdev->error_reset);
 
 	hci_cmd_sync_clear(hdev);
 
-- 
2.43.0



