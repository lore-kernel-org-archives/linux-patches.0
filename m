Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 765763A5E91;
	Tue, 16 Jun 2026 17:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630303; cv=none; b=oJVbHHO3g39C8Qa5mesuUHnWLgP0Qn6i7U++2T+f5aEvm73Q6b2gOU81fJ75Or3NpETosUhFQmRirc7fFfXQ2/+xtzPA8Zrkjhs0AyniIMr7J9xfII9dBZdV0ErQ6lhpdLFtN0KkBGzGHWqg4UCWeDHqBSqADUYy/+ZhUGKHUCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630303; c=relaxed/simple;
	bh=9PbfTrQQbOnIF6uwx1Nk4PMTdnb54WfbROFBGRB0r/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tqi11U5QfkzG5W2eI0tMXWT3cvwOuX99AKKxhxWM/wZUSNXyqDuDB1osVg991O6bLoBxcWZT6jq9hcP+7x+H/wvGkCWEGrW5AcBCKMbt8pZdhsNGjx7GLCdwLFuZp+eweNsXyrwfieAgJRdCiXDiRjVq+0xXLRK1shMOBCSG8jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xpx8DMK7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xpx8DMK7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D2E91F000E9;
	Tue, 16 Jun 2026 17:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630302;
	bh=s6YpXx+eZ0f74ij5oGZaMF8ApOQu+YsRR9J8qTfBFS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xpx8DMK73knk49kVpKh0nk0gkhhwgNlPphfDtGjnmYvP1ge6pEXU1AwT/KKMH83oX
	 c2W0JNxuH5TKOJD6qmV3txGr7McSyGyFx5YsfnUFg0vjfDXV91gFxan+WWJWZ5Lqhf
	 8JgkbIeBN0XCrEwnuEXlD1QtZYzGHit/RUFQmWJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 406/452] Bluetooth: hci_qca: Migrate to serdev specific shutdown function
Date: Tue, 16 Jun 2026 20:30:33 +0530
Message-ID: <20260616145138.141467823@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

[ Upstream commit 12a6a5726c515455935982429ac35dee2307233d ]

This saves a cast in the driver. The motivation is stop using the callback
.shutdown in qca_serdev_driver.driver to make it possible to drop that.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Link: https://patch.msgid.link/261a3384e25c4837d4efee87958805f15d7d4e3c.1765526117.git.u.kleine-koenig@baylibre.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 375ba7484132 ("Bluetooth: hci_qca: Convert timeout from jiffies to ms")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/hci_qca.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -2425,11 +2425,10 @@ static void qca_serdev_remove(struct ser
 	hci_uart_unregister_device(&qcadev->serdev_hu);
 }
 
-static void qca_serdev_shutdown(struct device *dev)
+static void qca_serdev_shutdown(struct serdev_device *serdev)
 {
 	int ret;
 	int timeout = msecs_to_jiffies(CMD_TRANS_TIMEOUT_MS);
-	struct serdev_device *serdev = to_serdev_device(dev);
 	struct qca_serdev *qcadev = serdev_device_get_drvdata(serdev);
 	struct hci_uart *hu = &qcadev->serdev_hu;
 	struct hci_dev *hdev = hu->hdev;
@@ -2650,11 +2649,11 @@ static void hciqca_coredump(struct devic
 static struct serdev_device_driver qca_serdev_driver = {
 	.probe = qca_serdev_probe,
 	.remove = qca_serdev_remove,
+	.shutdown = qca_serdev_shutdown,
 	.driver = {
 		.name = "hci_uart_qca",
 		.of_match_table = of_match_ptr(qca_bluetooth_of_match),
 		.acpi_match_table = ACPI_PTR(qca_bluetooth_acpi_match),
-		.shutdown = qca_serdev_shutdown,
 		.pm = &qca_pm_ops,
 #ifdef CONFIG_DEV_COREDUMP
 		.coredump = hciqca_coredump,


