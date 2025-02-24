Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3B924A04F;
	Mon, 24 Feb 2025 14:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408585; cv=none; b=jxl/7SunKAPx/Ngk8JhcI07nFCv10ytWBuUk/mjMiADZ+TXgBSzqviTrUBveaC/6gafz6fpQVKyVwcMdYtJbhfI+1h/i8lv/fhK4hgjgILXbdbzhUwiMIgPIUgDNmhYwprcgZM3L9kZmkrLGQAeP92VKbRD1HgDPohe9MvjlCh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408585; c=relaxed/simple;
	bh=Uv1cWE+MjvmB2ueIggm+ikkHgthMelUjnPU/+vIN0aE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uJIiF1NDuwwGJ0gbIGobC2BUi92uqBwA22aV8+BxoKaY5kKp9ObQrcXq2XcRJ/PLZe2cCvzGzmhVBr1BZIjtnkBRsVZ0PniHDgJT1Ljzp8Wg3+a9hu/HjtN9jk7WfRtnUfh3d0vN/CHWaJfmpR1a1UXy2oLcJ0ChvQgIxbPU9T8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qn54gsmF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qn54gsmF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27761C4CED6;
	Mon, 24 Feb 2025 14:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408585;
	bh=Uv1cWE+MjvmB2ueIggm+ikkHgthMelUjnPU/+vIN0aE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qn54gsmFGzxnaHgk+hoVxgViqM1+1rAT5zoBCtHlPbOT9mDVyeBIaLosCv51H+M7b
	 x2/dcviZT6NhcDzyw7mLI8qi6+j32gQJNWAPeqGEHyB3FoGF44cYgkntsPxOXZW9BA
	 4GergBNBN3a8ejGuK0bD7QL3totMuU+F53yEQR6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Hannes Reinecke <hare@suse.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 101/154] nvme-tcp: fix connect failure on receiving partial ICResp PDU
Date: Mon, 24 Feb 2025 15:35:00 +0100
Message-ID: <20250224142611.019385466@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 34eb3dabdc8a6..840ae475074d0 100644
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



