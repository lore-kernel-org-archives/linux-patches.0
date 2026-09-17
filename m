Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9990A383980;
	Thu, 17 Sep 2026 17:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665324; cv=none; b=p1bIJctqPmO3QjdG9oxwdAZEpkKaEwYFE+UxI4w4Zlnbh2aR1XbB3ydh/iNmwwnBlaJq0sBJthD0HW2f2BY4SOTPmN5CtlgIFr5Greo+N+wsuPyzJT2kNf+5qinpUQ3vWPOsAw2QTuVgwcsegZ/9u44MTBAFPzzKlL5bzxLm6Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665324; c=relaxed/simple;
	bh=fVo+7vtA+7XPDu6pFIhAK5w/+wpLTYx34n83T3BbMck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BCFrIeTNH/TX2+XKpzfAOkOPwoTTV6AedQob1XbBwbv2UcNRkn72tIgoeiN1kzzG+s+cfGMsFSZjfhsm1+gOZWKQuE7rg/94hZG1B+cR6jYmIJoGlYgchg631zQ64yzSnQStBM6lwjtm5Fc4oAzu70C53k5WNtWAM0eADJtnkng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m7R3zE5h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m7R3zE5h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEC051F000FF;
	Thu, 17 Sep 2026 17:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665323;
	bh=mGJHiO+oMRf7PVHYy/8SuPw3C4vnI2BpQVBmu4Fza4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m7R3zE5h8c0vGJ1KiSB9KprkqL4JTeCMbchOyp0sxBWhMUleO0GIxBKPENZlXadSI
	 o0nsKj3xG7UkOs/KJ7KOCF3JQiqNiDlTYx1JMmJuDvYXDuGPquHVPWF18886K2KatG
	 GuMm4tHE96yRn21vKp6PWBJkNNtMEjMBCM5aFpgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gongwei Li <ligongwei@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0667/1250] Bluetooth: hci_mrvl: Fix wrong return value check of wait_on_bit_timeout()
Date: Thu, 17 Sep 2026 16:07:42 +0100
Message-ID: <20260917151609.967772309@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 8767522ec4c68..c0db366502749 100644
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



