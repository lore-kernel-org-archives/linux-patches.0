Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902ED2E63B
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:09:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13F4BC433C7;
	Wed, 20 Sep 2023 12:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211788;
	bh=S7ruFL9kXdOuq4RtPcaEkPOf4OGH3Vvbr5qcIw9AeTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ke0mVvzgzBI5ngA9ca8UNVFXCCLzrMQh0cKOdsSBxzCNmct2i2PtnVY8QpXh9irgH
	 nRkHO8A6wujezpxtG33wcVznWAYBgdMEidbS4GBJpLB8s0Zqa3rWw3F5HN47V013vT
	 uB0jtecblth0vJk0XXfsbeUEnBRW922BECQ8ycyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Wang <zyytlz.wz@163.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	"Denis Efremov (Oracle)" <efremov@linux.com>
Subject: [PATCH 4.19 009/273] Bluetooth: btsdio: fix use after free bug in btsdio_remove due to race condition
Date: Wed, 20 Sep 2023 13:27:29 +0200
Message-ID: <20230920112846.721021880@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
References: <20230920112846.440597133@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zheng Wang <zyytlz.wz@163.com>

commit 73f7b171b7c09139eb3c6a5677c200dc1be5f318 upstream.

In btsdio_probe, the data->work is bound with btsdio_work. It will be
started in btsdio_send_frame.

If the btsdio_remove runs with a unfinished work, there may be a race
condition that hdev is freed but used in btsdio_work. Fix it by
canceling the work before do cleanup in btsdio_remove.

Fixes: CVE-2023-1989
Fixes: ddbaf13e3609 ("[Bluetooth] Add generic driver for Bluetooth SDIO devices")
Cc: stable@vger.kernel.org
Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
[ Denis: Added CVE-2023-1989 and fixes tags. ]
Signed-off-by: Denis Efremov (Oracle) <efremov@linux.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btsdio.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/bluetooth/btsdio.c
+++ b/drivers/bluetooth/btsdio.c
@@ -356,6 +356,7 @@ static void btsdio_remove(struct sdio_fu
 	if (!data)
 		return;
 
+	cancel_work_sync(&data->work);
 	hdev = data->hdev;
 
 	sdio_set_drvdata(func, NULL);


