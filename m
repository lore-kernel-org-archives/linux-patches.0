Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 859373C063A;
	Wed, 30 Sep 2026 19:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795055; cv=none; b=QXCmVHyszM0EgYE9Wq3snFHfsCQE9ONhDmEoazAzvu3UrV+BsTRbmcCw4jThSyeeav5o2gyIG1FtP00VF5xhyUfewp6jvG0iYm2AEokZ8D+Vn0lkRQglXy1d9e5JU2hwJ/us2/grzvylybjmvtI0dgURG0IFhdkhzZQbBtVhtRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795055; c=relaxed/simple;
	bh=I2SnVoBjphIvZ7Yx3GYvOPy+6LFgMbC/toRvA906JPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CdKsG3bSxE3nII2kMR43PNGahaEs8Fwf+RD/EW4n3KkVx3+gG9S+UQbd24cjU1mPJ7+/Wbdt7pA5C6+I7iT0myPXoipgKwwr7PcwOeBWudurAfQP/YghB8hPq47XucLkFQ374udiYcuQnQPNlFPGKvjPUt7QK90aQAT34IwkmXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qUxpQs6R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qUxpQs6R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E01791F000FF;
	Wed, 30 Sep 2026 19:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795054;
	bh=Y2B5OZNHpygPLNMSasiZWV56Rj+viZOSQBodyl+GDrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qUxpQs6RKtJjwEVUQThGs13I4euN7R1XiL1636XveteA0oh62cqhNzHoXXcYXKWev
	 lQUMv0m8eLV+J6Mib/fr3OIzNXs7deaJhfkcQ8TLMj4XJ2eaVrV7HcBkpLrlWfoz3R
	 Al3ewve6vUU08govNgm/79ADDISpqnRunsYP1+Hw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gongwei Li <ligongwei@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0420/1193] Bluetooth: hci_mrvl: Fix wrong return value check of wait_on_bit_timeout()
Date: Wed, 30 Sep 2026 17:18:24 +0200
Message-ID: <20260930152443.535002869@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Gongwei Li <ligongwei@kylinos.cn>

[ Upstream commit 2deb76c21b81e42b3282224f7dd2046fe73fd1e0 ]

wait_on_bit_timeout() returns 0 if the bit was cleared, -EINTR if the
process received a signal and the mode permitted wake up on that signal,
or -EAGAIN if the timeout elapsed.  It never returns 1.

Hence the check "err == 1" in mrvl_load_firmware() is dead code: when
the waiting task is interrupted by a signal (-EINTR), the code falls
into the "else if (err)" branch and misreports it as "Firmware request
timeout" with -ETIMEDOUT instead of propagating -EINTR.

Fix this by testing for -EINTR so that an interrupted firmware load is
properly detected and reported.

Fixes: 162f812f23ba ("Bluetooth: hci_uart: Add Marvell support")
Signed-off-by: Gongwei Li <ligongwei@kylinos.cn>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_mrvl.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/bluetooth/hci_mrvl.c b/drivers/bluetooth/hci_mrvl.c
index e08222395772d..b4edaac2032e8 100644
--- a/drivers/bluetooth/hci_mrvl.c
+++ b/drivers/bluetooth/hci_mrvl.c
@@ -307,9 +307,8 @@ static int mrvl_load_firmware(struct hci_dev *hdev, const char *name)
 		err = wait_on_bit_timeout(&mrvl->flags, STATE_FW_REQ_PENDING,
 					  TASK_INTERRUPTIBLE,
 					  msecs_to_jiffies(2000));
-		if (err == 1) {
+		if (err == -EINTR) {
 			bt_dev_err(hdev, "Firmware load interrupted");
-			err = -EINTR;
 			break;
 		} else if (err) {
 			bt_dev_err(hdev, "Firmware request timeout");
-- 
2.53.0



