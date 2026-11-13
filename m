Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585897;
	b=RktB3SqQBIiTYiGojBP5U8LXdhxnGkMTNbQl0vKFvex+vzAYYJH1vNP8PBQgmDQticgM
	 DVMjWsJOoyBgZHeVkq8LpUljXqWItqiu21ivINROYql2Gmf7CGDtaZsFYSF4Rsa8dHXFl
	 8rZuQ4Xw+nrz8R7Vv69yT/PaopL4WzBenchqEHy2SxdsOBQgvDH1pKtXqXzSYFX4AzYdN
	 20og+I6GI+vabARzrpADsGUTWgPpaV6oc2GF6tHDHmx5QJ+IGWpL7TkNsvd9HsoVyLw5q
	 isiXsjhWZbdR9liE/0+slPGBjV2AzZZTjGtpu8k/5rHzR9u7vsLAWKuUzLJEgNzXIeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585897;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mnf1NF91qLoF8p27HZN9/QHWMgy2HwyGXT0wJfTSM0k=;
	b=Sf/+ckoC8nS8JFIA/OJQt+gBHPlVlNdUk/AjWgf1DODUaAjs4SbS0lSXXwisjl9ugXD5
	 Z+yn+6+auUAt0c7YVvTUUi8dxe3BTIhVPo1zHLmvil8FkG8OXRvwfvKKC2bTqMesJT5UY
	 y4Up9Fm7QBohV6H9fGIkU1Yns2i9QCNzr5v//LWRrr06prEPyN5rGrjlwd6aeTj2l8Try
	 oTXt33WVOfcvHO+ZAvQ/MKTcpHxC0GUNosyjGAmer9/azWCEX0FRcrYn6DAtzVeGUG6zl
	 sZBNEWnGVBW/x32yMQLyvUUoWw25Bg6Gd70ByDbmitjWYSF5hjcqvhQGU0gDxkN+Itw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fLkc5axZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F3C606A893;
	Fri, 13 Nov 2026 16:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fLkc5axZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CD191F000C4;
	Fri, 13 Nov 2026 16:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585897;
	bh=mnf1NF91qLoF8p27HZN9/QHWMgy2HwyGXT0wJfTSM0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fLkc5axZnjncsl54lvQvZFm3tOha0OIdtTpA/NwDJgtihoA2Cdcvls74/oMOHctTO
	 J/nafkKemA4av450Ct6QHeE+H9JubhtmPotOoNFPhb4qGOVX0/BKAT/nzKC1vVZ0vJ
	 5j8+weUcw7cBbatwelkmKe7ieALCtNvk2co4D3RY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiliang Yuan <odys.yuan@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 420/507] nvme: wait for SRCU readers before splicing the namespace list
Date: Fri, 13 Nov 2026 10:52:04 -0500
Message-ID: <20261113153810.975920865@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiliang Yuan <odys.yuan@gmail.com>

[ Upstream commit 8a0449832b50cd4f99f2d2952cfc1476e5f26d0f ]

Readers walk ctrl->namespaces under ctrl->srcu, and some of them sleep
there, e.g. nvme_wait_freeze() waiting for I/O to drain.

nvme_remove_namespaces() moves the list onto its on-stack ns_list with
list_splice_init_rcu(), which only waits for RCU readers before
relinking the entries. A reader still on the last namespace then follows
its next pointer to ns_list instead of ctrl->namespaces and treats the
stack as a namespace. Deleting a controller while a Format NVM
passthrough waits for a delayed read on the last namespace gives:

  BUG: KASAN: stack-out-of-bounds in nvme_wait_freeze+0x102/0x120
  Read of size 8 at addr ff110001d2f3fc38 by task nvme/4413
  Call Trace:
   nvme_wait_freeze
   nvme_passthru_start
   nvme_submit_user_cmd
   nvme_user_cmd
   nvme_dev_ioctl
  BUG: unable to handle page fault for address: ffffffff8af04850

Use list_splice_init_srcu() instead, which waits for the SRCU readers.
This also takes the RCU grace period out of every controller deletion.
Deleting 64 tcp controllers with one namespace each, median of 3 runs on
each of two boots per kernel:

                                      before        after
  nvme disconnect-all (ms)            3491 / 3509   2996 / 3165
  nvme_remove_namespaces() avg (ms)   39.0 / 40.5   31.9 / 34.7

Fixes: be647e2c76b2 ("nvme: use srcu for iterating namespace list")
Cc: stable@vger.kernel.org
Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 9ea9db0271c2d..a0811b49710ce 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4755,9 +4755,8 @@ void nvme_remove_namespaces(struct nvme_ctrl *ctrl)
 	nvme_change_ctrl_state(ctrl, NVME_CTRL_DELETING_NOIO);
 
 	mutex_lock(&ctrl->namespaces_lock);
-	list_splice_init_rcu(&ctrl->namespaces, &ns_list, synchronize_rcu);
+	list_splice_init_srcu(&ctrl->namespaces, &ns_list, &ctrl->srcu);
 	mutex_unlock(&ctrl->namespaces_lock);
-	synchronize_srcu(&ctrl->srcu);
 
 	list_for_each_entry_safe(ns, next, &ns_list, list)
 		nvme_ns_remove(ns);
-- 
2.53.0



