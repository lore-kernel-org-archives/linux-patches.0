Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7308E318EC7;
	Thu, 17 Sep 2026 18:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668917; cv=none; b=EZCpdxvZLvxB9rF8UMwPQ7ygKHAF9TXWJTxogj73xCZwfhOjVhovSIkbmpyHPJlsQD+Yb17/Uvx8rQUsrEnoS3ZWQKn3EeRKi8xI+KcZjpCKUBwplbrr7gBhPP2OGRjlqqPnIQDztqbEmsqcCDvoqpH7DvjJLAmSpvbFmP0UtEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668917; c=relaxed/simple;
	bh=IuQEOULtU3jd9un4G68SstL0GH8Ned2LblekqQejpuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tuBELTm1pYt01Ar9K/0SpMjq8qbjam9YVXSY6o9lpLVmTOPpSLKsGSquqyfywIl2aNkdBIePl7SAUkxvnt2vErtWWLb4y5vk1+4EETFjgyyxPOZlMHiv8aRG8ffI+7s2ehV1Ax4OAdXpCOLs2COXQZJ8yJSclxyLRF85PObpxR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LtdXcFp4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LtdXcFp4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D4F41F000FF;
	Thu, 17 Sep 2026 18:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668916;
	bh=NjJe0VBbhByEWUIXbwRyQfCyPitye3rlXUzAFWkWXwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LtdXcFp4JypuVSEQcc6J/O+SBeYZ4rDrsRZcPW4/EkYUstIwJlOtW9uqlRHdNL5Sn
	 QXYAKFx0pIPDik5kapXK3wAVZuiXOqAVYjmnoA6A5RZhJW9V1jn+s3W9omYxlBwb93
	 xNIVwwIGgJQQBs8tUcqaAYOawjtWOOk0qjQygTPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gongwei Li <ligongwei@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0556/1102] Bluetooth: hci_mrvl: Fix wrong return value check of wait_on_bit_timeout()
Date: Thu, 17 Sep 2026 16:08:19 +0100
Message-ID: <20260917151553.813789673@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



