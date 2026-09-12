Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9CD82EBDE9;
	Sat, 12 Sep 2026 07:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197578; cv=none; b=FODMZhQ6JPDdBD41ZLSXFjbqjqpM9Rp+eblbLZx7ktSERqi2Cd16js4I3SAYoYHFDUfuCNnllf4ZuvX7HnpNLYhJ6twZhG/r3Hixb5GgU55n2tyPZ8ur5gAtpeZfRl7G0+FBd3shnuu446C5LFS8OGAImSqxLr1tbu8mIzFhWKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197578; c=relaxed/simple;
	bh=aF8W3tFOoJnndAZsT6aH5HVRAZcB0LlUJRkqZ5juNqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LkCgbkHB8rI2xYy5/WUTxf1CgDhoYqErvvGiGnRVRz/GllMYPHjfjwjyQjB/sIBMDSzdkHmv3R2QdTAGPi1FARZTCOi5EZl5p1qyxwlxyBIzwQUIpn6l7Y+K61NtdlULz93tMmJA07ch5a1PR8YDv6qj6tmvtFTBzH55kI1RGVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IhkuTlUx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IhkuTlUx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F84E1F000FF;
	Sat, 12 Sep 2026 07:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197575;
	bh=JPSTwhle0OuF4l7AcAi2kYEpS7e4FatMc032wTARMFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IhkuTlUxKkscnCAaELjAkqVLNY8A0g0LY4tY+2dqDNo05UymJNb5+KVMyMxE4cy/H
	 lePA28pqJ7W5HRyzr4cXAsm3FCQley3cAFwyfZdHgRMlsgyd4OtSfbGxssRyBs3vQQ
	 UC4n/iKMNStqmw2uRJo2aBd4nzgNySQa7RelmW68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Siva Reddy Kallam <siva.kallam@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0203/1815] RDMA/bng_re: return a timeout when firmware responses stall
Date: Sat, 12 Sep 2026 08:32:33 +0200
Message-ID: <20260912065653.767733249@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 5f9576c6734abca88a02db72c466e09d2eddf160 ]

__wait_for_resp() documents that it returns a non-zero error when a
firmware command does not complete, and bng_re_rcfw_send_message() already
marks the firmware as stalled when the helper returns -ENODEV.

However, the helper ignores wait_event_timeout() expiry.  If the response
slot remains in use after the timeout and after the polled CREQ service
attempt, the loop starts another full timeout period and can repeat
forever.

Return -ENODEV after a timed out wait that still has no response.  The
existing caller then marks FIRMWARE_STALL_DETECTED and returns
-ETIMEDOUT to the command issuer.

Fixes: 53c6ee7d7f68 ("RDMA/bng_re: Enable Firmware channel and query device attributes")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260625003614.27515-1-pengpeng@iscas.ac.cn
Reviewed-by: Siva Reddy Kallam <siva.kallam@broadcom.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bng_re/bng_fw.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/bng_re/bng_fw.c b/drivers/infiniband/hw/bng_re/bng_fw.c
index 50156c300b335..ab6a2d2e95b53 100644
--- a/drivers/infiniband/hw/bng_re/bng_fw.c
+++ b/drivers/infiniband/hw/bng_re/bng_fw.c
@@ -401,14 +401,15 @@ static int __wait_for_resp(struct bng_re_rcfw *rcfw, u16 cookie)
 {
 	struct bng_re_cmdq_ctx *cmdq;
 	struct bng_re_crsqe *crsqe;
+	unsigned long time_left;
 
 	cmdq = &rcfw->cmdq;
 	crsqe = &rcfw->crsqe_tbl[cookie];
 
 	do {
-		wait_event_timeout(cmdq->waitq,
-				   !crsqe->is_in_used,
-				   secs_to_jiffies(rcfw->max_timeout));
+		time_left = wait_event_timeout(cmdq->waitq,
+					       !crsqe->is_in_used,
+					       secs_to_jiffies(rcfw->max_timeout));
 
 		if (!crsqe->is_in_used)
 			return 0;
@@ -417,6 +418,9 @@ static int __wait_for_resp(struct bng_re_rcfw *rcfw, u16 cookie)
 
 		if (!crsqe->is_in_used)
 			return 0;
+
+		if (!time_left)
+			return -ENODEV;
 	} while (true);
 };
 
-- 
2.53.0



