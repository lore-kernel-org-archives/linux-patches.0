Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B4F1514CC;
	Mon, 24 Feb 2025 14:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409048; cv=none; b=oOv8ANQIPCWhjO5IN7Bn0OcxIrlkgpHBcfcqQ4FhdtsacRJgz+GZqljjaqR5bXaZhd4mRqBItCwLc9oG8ZAVo/+9hOP14LnZCd5S8pwKTEamPY+oljCwHaFpKZSrRjMuN6sttiW/boyP4WruEUjEFi8oUZOMSl+9chHJyq4N1UQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409048; c=relaxed/simple;
	bh=Sfe3W8Qq/t1hWc49CF5KqwZ/hOABB54n7u7aZRWP1Js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qmAsB3OMlbE/FEJ8gPIU5GO7wtFkPBhzxrdXckeaiWCCBIQr8LQ77iHR2aPikca9zcPYmcwSXn0napfZZJIiZDMW6J/EDY3VEZWmz3YuxHVlLk2mufIZaRDU7Iadv0BLkAYRmRpgM5lp82hd0VAXPDSQYobRlxsA50/q2REbOsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wg7l9trd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wg7l9trd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AB7DC4CED6;
	Mon, 24 Feb 2025 14:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740409047;
	bh=Sfe3W8Qq/t1hWc49CF5KqwZ/hOABB54n7u7aZRWP1Js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wg7l9trdz4bdmOGQPqrJicDID5qJf0+Lg7/z33FfWyyUkFkRLrUcsx2XWTNxI2w+s
	 x9gnaQVOWCWpkh5hXrlCqjdEo4dkWGOrmPfwT+ZgWtV+OsnqZLrDzTjm4fKe4w4iSe
	 5iLk2qYwxWE97i4GkPOoqUZ3t2FnLiLc/NbEUCUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Hannes Reinecke <hare@suse.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 081/138] nvme-tcp: fix connect failure on receiving partial ICResp PDU
Date: Mon, 24 Feb 2025 15:35:11 +0100
Message-ID: <20250224142607.664936752@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Caleb Sander Mateos <csander@purestorage.com>

[ Upstream commit 578539e0969028f711c34d9a4565931edfe1d730 ]

nvme_tcp_init_connection() attempts to receive an ICResp PDU but only
checks that the return value from recvmsg() is non-negative. If the
sender closes the TCP connection or sends fewer than 128 bytes, this
check will pass even though the full PDU wasn't received.

Ensure the full ICResp PDU is received by checking that recvmsg()
returns the expected 128 bytes.

Additionally set the MSG_WAITALL flag for recvmsg(), as a sender could
split the ICResp over multiple TCP frames. Without MSG_WAITALL,
recvmsg() could return prematurely with only part of the PDU.

Fixes: 3f2304f8c6d6 ("nvme-tcp: add NVMe over TCP host driver")
Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 4162893d49395..d7c193028e7c3 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1449,11 +1449,14 @@ static int nvme_tcp_init_connection(struct nvme_tcp_queue *queue)
 		msg.msg_control = cbuf;
 		msg.msg_controllen = sizeof(cbuf);
 	}
+	msg.msg_flags = MSG_WAITALL;
 	ret = kernel_recvmsg(queue->sock, &msg, &iov, 1,
 			iov.iov_len, msg.msg_flags);
-	if (ret < 0) {
+	if (ret < sizeof(*icresp)) {
 		pr_warn("queue %d: failed to receive icresp, error %d\n",
 			nvme_tcp_queue_id(queue), ret);
+		if (ret >= 0)
+			ret = -ECONNRESET;
 		goto free_icresp;
 	}
 	ret = -ENOTCONN;
-- 
2.39.5



