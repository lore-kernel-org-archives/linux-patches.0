Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B0C2459E6;
	Mon,  9 Jun 2025 13:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749476715; cv=none; b=L//ePfl/rfxaYrZiHWJ+B1OC7COHxkHwEOGAzcStOs82LYp5ptEjSnDSHITcthiHfQEkCk762Tpornbc1/ChvNqzlxvjSKXYvOOpW9wbkNukQD1rEx2AG4PEQUiv8ewvaIJr9wSYymgXXcAUQz2JY2/tWKBaoe5KXH26QQtb9sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749476715; c=relaxed/simple;
	bh=Abs9S2945jQSsxN7n7zFDdFEWQn4R4N3TTzRenZeQXk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=D33bPGRtVlQ5tDerf6IxMrnKv9fD24KB5ZU3c0Y31cxVVsw/meT3SXvvLaBXcLSKaDYvcwiTx9YQErd0d1X5HsNMmXeh2oxLuJt/iGfI37HU3NU2A/5lxbLR2BtyW6vbROVpRFDeHvJKnK4k7ZE6GeZoKS8qOZdmdFWN+zGz4ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XfzGRI1f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XfzGRI1f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09329C4CEED;
	Mon,  9 Jun 2025 13:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749476714;
	bh=Abs9S2945jQSsxN7n7zFDdFEWQn4R4N3TTzRenZeQXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XfzGRI1fkKkVlekEuC9AMFSBOMspR7nCDvewfnxx5mkyc1nyxWhkBwVFz9qlGMAHE
	 IFvnudm1w6J/Wu4Jjlv42iicAQqHI3QZ7jba3rC3k4rqD8sbFWyVhAgr2ypRkuve61
	 6ZIWh+QpqeALawkZegkKV1WMIJtY2FS90dYkp3NmMSsU3dg0V2e9s5wGPf+gXCvoxE
	 SOUEXKZg26U6sGHJl07rp5huatT1M729tfZF8CB8tFwtTIzDbolURGCWnaDhyoipn+
	 E6gnybThqw7QHypbwTWF1kUMy45VMSe41BGzcvFFg7MQQShr6+s4H5c5z+wavatksx
	 487QHzyuSU3Ng==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Hannes Reinecke <hare@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>,
	kbusch@kernel.org,
	linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 6.14 02/29] nvme-tcp: sanitize request list handling
Date: Mon,  9 Jun 2025 09:44:43 -0400
Message-Id: <20250609134511.1342999-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250609134511.1342999-1-sashal@kernel.org>
References: <20250609134511.1342999-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.10
Content-Transfer-Encoding: 8bit

From: Hannes Reinecke <hare@kernel.org>

[ Upstream commit 0bf04c874fcb1ae46a863034296e4b33d8fbd66c ]

Validate the request in nvme_tcp_handle_r2t() to ensure it's not part of
any list, otherwise a malicious R2T PDU might inject a loop in request
list processing.

Signed-off-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

Based on my analysis of the commit message and code changes, I provide
the following assessment:

**YES**, this commit should be backported to stable kernel trees.

## Extensive Explanation:

### 1. **Security Vulnerability Fix**
This commit fixes a serious security vulnerability where a malicious
NVMe-TCP target can inject loops in request list processing. The code
changes show clear validation being added to prevent this attack:

```c
if (llist_on_list(&req->lentry) || !list_empty(&req->entry)) {
    dev_err(queue->ctrl->ctrl.device,
        "req %d unexpected r2t while processing request\n",
        rq->tag);
    return -EPROTO;
}
```

### 2. **Attack Vector and Impact**
The vulnerability allows a compromised storage target to send R2T (Ready
to Transfer) PDUs for requests that are already being processed. Without
this validation:
- The same request could be added to lists multiple times
- This creates circular references or list corruption
- Can lead to infinite loops, system hangs, or memory corruption
- Potential for arbitrary code execution through use-after-free
  conditions

### 3. **Minimal and Contained Fix**
The fix is:
- Small in scope (only touches request list handling)
- Well-contained to the nvme-tcp subsystem
- Adds simple validation checks without architectural changes
- Initializes list nodes properly to maintain clean state

### 4. **Clear Bug Fix Pattern**
Looking at the similar commits provided:
- Commit #3 (marked YES for backport) also fixed a validation issue in
  nvme-tcp
- This follows the same pattern of adding necessary validation to
  prevent malicious behavior
- It's fixing a clear bug rather than adding features or optimizations

### 5. **High Security Impact**
This vulnerability affects:
- Any system using NVMe-TCP with untrusted storage targets
- Cloud environments and multi-tenant storage systems
- Data centers with NVMe-over-Fabrics deployments

The security impact is significant enough to warrant backporting to
protect stable kernel users.

### 6. **No Complex Dependencies**
The changes are self-contained and don't depend on major architectural
changes or new features. The fix:
- Uses existing list handling APIs (`llist_on_list`, `list_empty`)
- Adds proper initialization with standard macros
- Returns existing error codes (`-EPROTO`)

### 7. **Follows Stable Kernel Rules**
This commit clearly follows stable kernel criteria:
- Fixes a real bug that affects users (security vulnerability)
- Small change with minimal risk
- No new features or architectural changes
- Important for system security and stability

The commit prevents a serious security issue where malicious storage
devices could compromise system stability or potentially gain
unauthorized access through memory corruption. This makes it a critical
candidate for stable kernel backporting.

 drivers/nvme/host/tcp.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index a2e825e37b38b..28310b124b4ea 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -453,7 +453,8 @@ nvme_tcp_fetch_request(struct nvme_tcp_queue *queue)
 			return NULL;
 	}
 
-	list_del(&req->entry);
+	list_del_init(&req->entry);
+	init_llist_node(&req->lentry);
 	return req;
 }
 
@@ -561,6 +562,8 @@ static int nvme_tcp_init_request(struct blk_mq_tag_set *set,
 	req->queue = queue;
 	nvme_req(rq)->ctrl = &ctrl->ctrl;
 	nvme_req(rq)->cmd = &pdu->cmd;
+	init_llist_node(&req->lentry);
+	INIT_LIST_HEAD(&req->entry);
 
 	return 0;
 }
@@ -765,6 +768,14 @@ static int nvme_tcp_handle_r2t(struct nvme_tcp_queue *queue,
 		return -EPROTO;
 	}
 
+	if (llist_on_list(&req->lentry) ||
+	    !list_empty(&req->entry)) {
+		dev_err(queue->ctrl->ctrl.device,
+			"req %d unexpected r2t while processing request\n",
+			rq->tag);
+		return -EPROTO;
+	}
+
 	req->pdu_len = 0;
 	req->h2cdata_left = r2t_length;
 	req->h2cdata_offset = r2t_offset;
@@ -2588,6 +2599,8 @@ static void nvme_tcp_submit_async_event(struct nvme_ctrl *arg)
 	ctrl->async_req.offset = 0;
 	ctrl->async_req.curr_bio = NULL;
 	ctrl->async_req.data_len = 0;
+	init_llist_node(&ctrl->async_req.lentry);
+	INIT_LIST_HEAD(&ctrl->async_req.entry);
 
 	nvme_tcp_queue_request(&ctrl->async_req, true, true);
 }
-- 
2.39.5

