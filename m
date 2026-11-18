Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036531;
	b=x1Q8UFfvcGbCsI4Tdz471RzW0FtPdHEw1/T749/8meblfnH1u4NygY0vvu4nPq7B3ehb
	 pPJe3VDCBRlqnUtyPHPcQZxJiCkIXAQIzZqjLKqQcgFXQWM0F04BdriW6f8QpP/VVvMyw
	 X309smOcRdyiCD2MH8+BYilSO6DpysvXybaOK6WjJCz6TY3XAkh09dWVEdILV1y6+iT5P
	 jqu0GKsMeg6p0OxUy1NQn0FfAsRsoOhtA0M7Uwr7rtAbbBdQDhSQLJY157N/buE5tZQWx
	 AGi/RNDz6JCjjJ0EMrphtZNde/srfjNKCNhCeZDMmCD2cT1Qaty8u5pVM9thfpcN6Gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036531;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2a7VhQOGraUUqpvIyIU4um4fnO6AKg80UQGIX4gApQM=;
	b=rB5FL5SqnWJnbCtA/rHfIvRhM7of9WZVUuYEJNknfu70NcuVrwKOL8M0Et24XbJHE5iB
	 Yxoq6qEpGB2xqEcg2KtQd6ERO9F2xZFcyCnMn2lITgdSY0D56/cTtGJ2HDergrusMd4hR
	 ReUimreQFxDjxMTcMdmViYB5rydQzcKjjPeELZ8pZHVVhV990aLwBd20GZbtqRfD+hF23
	 WekTcpNFRvhlkhL33jZOg8iftmdnODH7k4U/zPDEnjzJ4Z11esSyWpCcAVb54OAmwxc7J
	 qt5DDSL5rkqvBqmQA8Rp5NrU2NoZOv3L6z3YFoddd1XX2dLuHYqD/gCbvaK6xRKc7xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J0kROtT5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23479606A320;
	Wed, 18 Nov 2026 21:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J0kROtT5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7485B1F000C4;
	Wed, 18 Nov 2026 21:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036531;
	bh=2a7VhQOGraUUqpvIyIU4um4fnO6AKg80UQGIX4gApQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J0kROtT5T2BvhMboKrSmGd4vWgqsx5kUgypc/5VhCBzmaVvc3+5sBrmrMpGRp/jf4
	 CIGApO6ODj85LgWDhVLJhQDKZVRMA1JtPZ7+LzCho2Bm8BJa5WczDoxs/vgBeKWpv4
	 3g7qgBthbW3i6iQzQwyoJn2pbPuoIc59+jrYvWRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1092/3318] nvme-rdma: dont complete a request after a bogus remote invalidation
Date: Wed, 18 Nov 2026 15:28:34 +0100
Message-ID: <20261118150352.738245723@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

[ Upstream commit 909307cea08aff4e486cdb7491de5c76a2c31341 ]

When a remote invalidation names an rkey that is not the one we handed out
for this request, nvme_rdma_process_nvme_rsp() logs and schedules error
recovery, then falls through to nvme_rdma_end_request().  The request is
completed with req->mr never invalidated, and nvme_rdma_unmap_data() hands
it back with ib_mr_pool_put(), which only puts it on a list.  The rkey
stays valid and still maps the pages the completed read filled, so a
controller that sent the bogus invalidation can write into those pages
after pread() has returned.

Return instead, the way the local invalidation path below already does,
and leave the request for error recovery to cancel.

Fixes: 3ef0279bb0031 ("nvme-rdma: Check remotely invalidated rkey matches our expected rkey")
Cc: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/rdma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 0e985dd471ab2..927a6631e3bc0 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1699,6 +1699,7 @@ static void nvme_rdma_process_nvme_rsp(struct nvme_rdma_queue *queue,
 				"Bogus remote invalidation for rkey %#x\n",
 				req->mr ? req->mr->rkey : 0);
 			nvme_rdma_error_recovery(queue->ctrl);
+			return;
 		}
 	} else if (req->mr) {
 		int ret;
-- 
2.53.0



