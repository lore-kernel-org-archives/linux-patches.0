Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B71509F06;
	Wed, 30 Sep 2026 18:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791305; cv=none; b=lXT12F2xc0vsixkjTxDEary803CjgVPnrNjKS4/ah+Lyada3yhGzpr8nNYn5izNCZuU9aj/LnZyaP1nVxiz/nNTSwv2/r4jMrOLECUkdI2n7yFtLN/KyhdZQAORGTUNs6R0fXC85jyuCtqd9y3KMTn78wMkbId8O1MFfEeTXfN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791305; c=relaxed/simple;
	bh=aSS2uOus809NOZnMaVaeKmPssTY4g/PLoGCIqIQUsy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oygAUO9jgGi3o7pnU6cloQafjBK86tDhYdIIURS14ydcy0TfJHZ6TedHu/i09iPQIBzuq7nnruocsGkDV9zBRRPh3VV7eUShQCsuarmN4T9QwTdpeatBNxjROxM8QctCscuvWLNZ6gnNrkx8Hqqepu3ofwHQ3/udT4S8rPe02ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rQCFaxXi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rQCFaxXi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF421F000FF;
	Wed, 30 Sep 2026 18:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791303;
	bh=V0EIMnm1PY9PyS7T71mlrbOdfsG2QUq2Md9NqIEQf/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rQCFaxXiamE/nA1gZtVwQ4CMyMMdu+0HiFHYijMRxLYtrPrs+dwrvm6RCx3bRTGCh
	 IhvU8Lnh5nq1tZ/KOcZK/XyDdaJ1yCOKJv2jlFhPtqb4TQ7pcSixpKzLs8vxEot5vm
	 xNuBYk2BeRCeJBjYS6jlXOUZkKj5V94shG/OQdDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gongwei Li <ligongwei@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 254/752] Bluetooth: hci_mrvl: Fix wrong return value check of wait_on_bit_timeout()
Date: Wed, 30 Sep 2026 17:22:04 +0200
Message-ID: <20260930152403.775974579@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index fbc3f7c3a5c71..b986bdbe09b56 100644
--- a/drivers/bluetooth/hci_mrvl.c
+++ b/drivers/bluetooth/hci_mrvl.c
@@ -297,9 +297,8 @@ static int mrvl_load_firmware(struct hci_dev *hdev, const char *name)
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



