Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71993233148;
	Mon, 10 Mar 2025 17:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626969; cv=none; b=VIb/X8tx7AjGIGO2x/UdxzYMdpo7v1kFgsy9DZ9moTBGftsgoEFL+4ks7h319Dr7XzEVuPgxv80D+B/TkYTORwnG8p3L0AdIo3orpEm33BVOsLADFB0FoY7chYdq0esc94TpcykLBWZNBD8UfBtHSbUwm1bUMpt2GdzgJCxRY1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626969; c=relaxed/simple;
	bh=y9+VU2xmPaRjAoDrXqU/TBtH7tp1M8ZY2yfh7cQ64Gk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O2xBlmYiQxvqMxslhN31zMG244/yc0RBlvDNz1z53NixGB3BoQmQ02ZybH2iaKmGv0DlaCTMrLM9isv/K6uvlzY342pr0ZlXTssQWa2FeZISXMGeUvDa7EkUN28aWL+FAwI/R4aQBwpPDqnPFHR7ou78xeqa9fKg2/7IerXqvTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NJV69H0s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NJV69H0s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 977C9C4CEE5;
	Mon, 10 Mar 2025 17:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626969;
	bh=y9+VU2xmPaRjAoDrXqU/TBtH7tp1M8ZY2yfh7cQ64Gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NJV69H0sm1Qi5YUft8x3NCFXEzET58nr65/CGT4Nsh9Y5lYtIcln0NOEMTnzDfUrv
	 P5mvwHlaIdpcbV9Uf5soT2nK9AiHvwURggvtxH+Z/ls0pihTJNh/d+/XM8/E7NoHZs
	 G3aUdrq2kHuPCfbZMuSgFNRkDSLJupguWDcEpgu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 144/207] nvme-tcp: fix signedness bug in nvme_tcp_init_connection()
Date: Mon, 10 Mar 2025 18:05:37 +0100
Message-ID: <20250310170453.523260801@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 528361c49962708a60f51a1afafeb00987cebedf ]

The kernel_recvmsg() function returns an int which could be either
negative error codes or the number of bytes received.  The problem is
that the condition:

        if (ret < sizeof(*icresp)) {

is type promoted to type unsigned long and negative values are treated
as high positive values which is success, when they should be treated as
failure.  Handle invalid positive returns separately from negative
error codes to avoid this problem.

Fixes: 578539e09690 ("nvme-tcp: fix connect failure on receiving partial ICResp PDU")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index ade7f1af33d80..5c50f1a5af957 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1521,11 +1521,11 @@ static int nvme_tcp_init_connection(struct nvme_tcp_queue *queue)
 	msg.msg_flags = MSG_WAITALL;
 	ret = kernel_recvmsg(queue->sock, &msg, &iov, 1,
 			iov.iov_len, msg.msg_flags);
-	if (ret < sizeof(*icresp)) {
+	if (ret >= 0 && ret < sizeof(*icresp))
+		ret = -ECONNRESET;
+	if (ret < 0) {
 		pr_warn("queue %d: failed to receive icresp, error %d\n",
 			nvme_tcp_queue_id(queue), ret);
-		if (ret >= 0)
-			ret = -ECONNRESET;
 		goto free_icresp;
 	}
 	ret = -ENOTCONN;
-- 
2.39.5



