Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 377AC230BC3;
	Mon, 10 Mar 2025 17:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627645; cv=none; b=foYn32MC2lvkb/fwMBZWaHgSWl0zX0O38nYT49o8TyhcVgvv2p+1XMkldpiXU6ps8nucc4c1gpmk6ncI74fMUQIlwax+Fyc4Es4RuLHDAyov23zNGUV6zaFRwcOfzGAXVXxs9t6jYlAizLC6hpc8WX6ZkQN6yQKJWvp7AthohgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627645; c=relaxed/simple;
	bh=y7kpVnEuGIOjhbx4nRG5GjJ2Zi5EXarXIFDbLstuQLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lutMuxMt2oBeTgwzJp0ouGvkUOFbDSSAJhm2fAFDwl8ADhL51D0999gdTTy6LB3NJmJyhGjsX4xMjbJKAhsMAfzzDo//a85Dimn2iqlsg0BsAi2saSkZ1O9CfVkktZPIuH0A3WxZqX8Xr1cdgDextHTCTOUypM6P/83IC9It4pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jGFkViHj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jGFkViHj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4CDAC4CEEC;
	Mon, 10 Mar 2025 17:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627645;
	bh=y7kpVnEuGIOjhbx4nRG5GjJ2Zi5EXarXIFDbLstuQLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jGFkViHjyPxzxYa2z+xA0I3TZpazk4JvvT7Jw0jP1eDDaEZSy8G8H/qYFMugyTIJr
	 j/xIAAfzSoWDdxInMY7CUY+hiIzY3ZxhrOxBCA6vdsJW0HsfVbtY0ryaPjOZGIOZcw
	 DWwQUoMuaEZhE8ED9MzKdqAp1LksqjksHjws44lc=
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
Subject: [PATCH 6.12 200/269] nvme-tcp: fix signedness bug in nvme_tcp_init_connection()
Date: Mon, 10 Mar 2025 18:05:53 +0100
Message-ID: <20250310170505.668566827@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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
index 0bcc9bf57d1d0..3ee35f94660f9 100644
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



