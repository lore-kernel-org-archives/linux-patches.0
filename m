Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E85C6FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:16:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB2C0C433C7;
	Sun, 17 Sep 2023 19:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694978208;
	bh=AowzVBOMXUjVHZDLDOWt5KlxuOqVfac+4P76kuLkK58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fm3o010ma9PDZ6kD2mfo5iuv45YvWgCwnu//+AwwUeWvwjF/95osV4Yc5Aq5atWXH
	 +rO663fKD3rtlp+W2zrdW/6DcpajcDMWc4lI5jqtK1WlaQZryB2vRAOrfYeMPSrtHN
	 /uzPJy22KRwDJA7v8J/0Y+YqahYcz8i9tBw4arpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Wang <zyytlz.wz@163.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	"Denis Efremov (Oracle)" <efremov@linux.com>
Subject: [PATCH 5.10 013/406] Bluetooth: btsdio: fix use after free bug in btsdio_remove due to race condition
Date: Sun, 17 Sep 2023 21:07:47 +0200
Message-ID: <20230917191101.481868540@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>
References: <20230917191101.035638219@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -355,6 +355,7 @@ static void btsdio_remove(struct sdio_fu
 	if (!data)
 		return;
 
+	cancel_work_sync(&data->work);
 	hdev = data->hdev;
 
 	sdio_set_drvdata(func, NULL);


