Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC4C46444;
	Tue, 10 Sep 2024 10:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963227; cv=none; b=t7294xaDi2rD7nu/KIjNqGqmSTsHrBINMmhUMoD0Bz/+lGVND0Yze9B1JwA0t1O5jMwbjWY1miiF4a0/SA9eFXALIGboNE2IGnYpSx9TLfN9b2mqBx/OxtZEnXTmfHMgHrlxgjXk6sHA8QIOf/RQu48vlboph4qRGhW9OAqH2ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963227; c=relaxed/simple;
	bh=7ehMe4ImqruXCoz6HHNH5B+Haw0yH5Dus3C/JVGkLMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jGPpJ1gU/YmFko/R1UFcwduvGsPrsF6JlqHb2aPODSnG09aJmxF4yTVrfUIfkKpmoj7xJoRiPyHTbJtWsckRndeiecAZdmqLseLFwkpZK2RvKbBaLazGXV821HrNmJkufUDOtyDgevPaDwiCdPv7Cpc/U9L3yRMYVnJy3HeiEG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C5lxoc4m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C5lxoc4m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10CA4C4CEC3;
	Tue, 10 Sep 2024 10:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963227;
	bh=7ehMe4ImqruXCoz6HHNH5B+Haw0yH5Dus3C/JVGkLMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C5lxoc4mbJVH608SyMCLBbea03Xd6ZTw4r6kLMyd358Gs6lP+T6KVwImygShsnzwS
	 n8r2EACbuJXtSDquhcLPOUgCuGXSmux70/9ICBhtkvClF0voMB1+lxXq1CDr5Xhk3g
	 eLQQvmMDyXTnUg9T0+UPfRGKN/pGEa2ROZwJBfJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 179/192] nvmet-tcp: fix kernel crash if commands allocation fails
Date: Tue, 10 Sep 2024 11:33:23 +0200
Message-ID: <20240910092605.211954442@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit 5572a55a6f830ee3f3a994b6b962a5c327d28cb3 ]

If the commands allocation fails in nvmet_tcp_alloc_cmds()
the kernel crashes in nvmet_tcp_release_queue_work() because of
a NULL pointer dereference.

  nvmet: failed to install queue 0 cntlid 1 ret 6
  Unable to handle kernel NULL pointer dereference at
         virtual address 0000000000000008

Fix the bug by setting queue->nr_cmds to zero in case
nvmet_tcp_alloc_cmd() fails.

Fixes: 872d26a391da ("nvmet-tcp: add NVMe over TCP target driver")
Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 76b9eb438268..81574500a57c 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1816,8 +1816,10 @@ static u16 nvmet_tcp_install_queue(struct nvmet_sq *sq)
 	}
 
 	queue->nr_cmds = sq->size * 2;
-	if (nvmet_tcp_alloc_cmds(queue))
+	if (nvmet_tcp_alloc_cmds(queue)) {
+		queue->nr_cmds = 0;
 		return NVME_SC_INTERNAL;
+	}
 	return 0;
 }
 
-- 
2.43.0



