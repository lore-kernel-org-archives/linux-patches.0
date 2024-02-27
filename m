Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252FF54BD4;
	Tue, 27 Feb 2024 13:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041712; cv=none; b=BdC8up6WnJBFekoWS1o7KyxDaBOQAYjNjpi7T0uB2h4SovPlJTWX330XahbOH+z2lCGWGQFwJuc86iBZtDqNYCOjrA+xL5gnqwrLAUARwv6XbRaMLTFS3WnxPqPXeGrtLIuKusYRbeXi3jfMAkq12IjXU6C3u54ghBXCCRylYIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041712; c=relaxed/simple;
	bh=uTQAGcSBwOaYvHC6bH9ipvcH7BqP5ovynDghNQaWx4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qCq2oN31QDXcl4lxHjkJ1HDVuWHcdzX/lz0PnvhqcQGrZCyjeWbAE+2S2nbsooMF6psDk96HyFUfwN39UJLg7Wl1QQ1WhWiULz83cOzGEgQFOsMnYNUHOydJHQj0LRDolG4K8JZQ6bVsTzHvI14MvLDNBVkmWYtRxxANDnNcj8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0OpEYWsB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0OpEYWsB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8079C433F1;
	Tue, 27 Feb 2024 13:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041712;
	bh=uTQAGcSBwOaYvHC6bH9ipvcH7BqP5ovynDghNQaWx4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0OpEYWsBIGJE+vPugkrf+Y1P7VOWmTpaYoVNcJwxb9TIbVxAdBgw3LuABKf4m0DOJ
	 cThZsd+IcoKPFk12TLTzkdi+6I8k+28hkVxcLXYc8IuQ1vq3Td2lKGmi5KHA+R919W
	 uGpOp8S2vvUmomRk8XrgheZbGxafiUTfVbOFKh04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Christoph Hellwig <hch@lst.de>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 044/299] nvmet-tcp: fix nvme tcp ida memory leak
Date: Tue, 27 Feb 2024 14:22:35 +0100
Message-ID: <20240227131627.402881173@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit 47c5dd66c1840524572dcdd956f4af2bdb6fbdff ]

The nvmet_tcp_queue_ida should be destroy when the nvmet-tcp module
exit.

Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index a4f802790ca02..8e5d547aa16cb 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1927,6 +1927,7 @@ static void __exit nvmet_tcp_exit(void)
 	flush_workqueue(nvmet_wq);
 
 	destroy_workqueue(nvmet_tcp_wq);
+	ida_destroy(&nvmet_tcp_queue_ida);
 }
 
 module_init(nvmet_tcp_init);
-- 
2.43.0



