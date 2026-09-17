Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8CB94E4C23;
	Thu, 17 Sep 2026 15:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659030; cv=none; b=Cu2UxjQZjP5tcju/vp6v5DpOIU+N49khOB6Ile5WTJSq83Vz5LPkWGMRWZuXrul0zHvC+RbepTbrKkDfo4hzLVPjWoqBSKgpcD65fosDwGicmIHBjKyYa4GymdbtYGA4QMwQuV+3RlEhnkdOR/vAHUiwSWPTnnVSOQ6nA16ccgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659030; c=relaxed/simple;
	bh=AFF72GypFsQ4ydovVHrY8Q91CleZEiZPz+Mj7/g/UrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RJBGSOdL1uMNb9uXjyoYOrSOdZdrTvS+Kxuug4uab/zhup0iL7Z/SGKhvrkr73rtIs7bYb4pEtutTcEDP0Q6bG2+yDfjRbx8dehXCladXazdnydCWkDLGxNt/amZdnfwS//rDoJKGpNZ9mbapVQdGTeInxVSCaZ2AH+zNqe9MzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rUXoAqXr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rUXoAqXr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 032D01F0089C;
	Thu, 17 Sep 2026 15:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659019;
	bh=BqwqbccGgtb5UPwYZLQgOii1+0kHrs9wMEuU9Gq1CyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rUXoAqXrmpLDLBBrmlaEoBRGqx+EbK4/dt1NsqYyt1oh5+V9/vL2N4WbCwSe8fXj8
	 8SNCkis+moJkD5jawX1J9lJP6SV67oulW/O9gUdecDtfnZufIuoaDCrYD8xFcPZ3PH
	 6KGdJF0Fe1BIuX2wjoEPylA2r2owAnF9cdXRCmnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gongwei Li <ligongwei@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 115/733] Bluetooth: hci_mrvl: Fix wrong return value check of wait_on_bit_timeout()
Date: Thu, 17 Sep 2026 16:07:03 +0100
Message-ID: <20260917151353.858477087@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 516b8f74c4340..5798a8db016ee 100644
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



