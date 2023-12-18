Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE211D14B;
	Mon, 18 Dec 2023 14:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b79904y6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1496C433C7;
	Mon, 18 Dec 2023 14:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908273;
	bh=FFeZUzrypIrQ49/APY7tpr2gT6nSODm3LNboTfipSL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b79904y6DVvYEfA8mWYQc+KJG9QGoRq3SewJXQyMj639IW5NHHcAiCnLgqV4G+sxp
	 5hEBzpKEXX4hMQet9sOOdvvegW0JsiGNxvvm4CfoJTazmsfrZWznH4msnOADdvmjV2
	 FzOt8RcxEFwDJXBYejCWgkoD4rdlqxMVuXT9BEVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nguyen Dinh Phi <phind.uet@gmail.com>,
	syzbot+6eb09d75211863f15e3e@syzkaller.appspotmail.com,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 115/166] nfc: virtual_ncidev: Add variable to check if ndev is running
Date: Mon, 18 Dec 2023 14:51:21 +0100
Message-ID: <20231218135110.180622697@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

From: Nguyen Dinh Phi <phind.uet@gmail.com>

[ Upstream commit 84d2db91f14a32dc856a5972e3f0907089093c7a ]

syzbot reported an memory leak that happens when an skb is add to
send_buff after virtual nci closed.
This patch adds a variable to track if the ndev is running before
handling new skb in send function.

Signed-off-by: Nguyen Dinh Phi <phind.uet@gmail.com>
Reported-by: syzbot+6eb09d75211863f15e3e@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/lkml/00000000000075472b06007df4fb@google.com
Reviewed-by: Bongsu Jeon
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/virtual_ncidev.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/nfc/virtual_ncidev.c b/drivers/nfc/virtual_ncidev.c
index b027be0b0b6ff..590b038e449e5 100644
--- a/drivers/nfc/virtual_ncidev.c
+++ b/drivers/nfc/virtual_ncidev.c
@@ -26,10 +26,14 @@ struct virtual_nci_dev {
 	struct mutex mtx;
 	struct sk_buff *send_buff;
 	struct wait_queue_head wq;
+	bool running;
 };
 
 static int virtual_nci_open(struct nci_dev *ndev)
 {
+	struct virtual_nci_dev *vdev = nci_get_drvdata(ndev);
+
+	vdev->running = true;
 	return 0;
 }
 
@@ -40,6 +44,7 @@ static int virtual_nci_close(struct nci_dev *ndev)
 	mutex_lock(&vdev->mtx);
 	kfree_skb(vdev->send_buff);
 	vdev->send_buff = NULL;
+	vdev->running = false;
 	mutex_unlock(&vdev->mtx);
 
 	return 0;
@@ -50,7 +55,7 @@ static int virtual_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
 	struct virtual_nci_dev *vdev = nci_get_drvdata(ndev);
 
 	mutex_lock(&vdev->mtx);
-	if (vdev->send_buff) {
+	if (vdev->send_buff || !vdev->running) {
 		mutex_unlock(&vdev->mtx);
 		kfree_skb(skb);
 		return -1;
-- 
2.43.0



