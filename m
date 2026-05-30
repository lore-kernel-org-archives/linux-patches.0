Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932B434389F;
	Sat, 30 May 2026 17:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163053; cv=none; b=CJQE7B4wbtz+P9Bg+12+7gkF0cEDmN7z4iTme/0N4g44cIuQs/PvJlm0XWMIaznPOO5Q+0V3t7J9e5csLwyqJ9L4ebM8DKFpjUtxbT5nHOBvsyCsJKf16N5v5ZEenK9PdBKE3vq6z5zEbJ2rYiqXr5ikpq6pyDzr45/IOJkJ5Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163053; c=relaxed/simple;
	bh=K8+/MpFnI/1Ivl0s2Tc5Edx6QqWorKbhqhpysmbulOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q77RFdFWFHgWXGBsvZW44bknvM3lq5/VquV6DaB08M7r/befP6UOyiQg4YjaCmjDWZNHwBQWgSn6Q7G6Gye3D1b/Cu93B9D78IeXnPUDCa2tWfWGd2AguOj+jWDKR5MDNxyq/D3Xk8fy+BYYRvS++4jXjJJn0I1f14iEES0ipdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V38TyJ9B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V38TyJ9B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D7D1F00893;
	Sat, 30 May 2026 17:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163052;
	bh=RB36YaaBUtEz1n5tTHh4dxFkPIzDF7uQsbRKGb6w/nM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V38TyJ9BHogeuLfdB8js+wqC/6kNdu6w3QhTqgmdMcKqFXJuiD2ceRK13FYHl2sp9
	 Z9Gfr5+rww7E9X5tQqDC23FkV88NqXUw8Ww4QAuZR46Hg+7glocXgZ847DzZuoNmv2
	 M2s6drEOufwt/K14jGva31dpQewLKp0+Myim89Sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wagner <dwagner@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Leon Chen <leonchen.oss@139.com>
Subject: [PATCH 5.15 141/776] nvmet: always initialize cqe.result
Date: Sat, 30 May 2026 17:57:35 +0200
Message-ID: <20260530160244.061798642@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Wagner <dwagner@suse.de>

[ Upstream commit cd0c1b8e045a8d2785342b385cb2684d9b48e426 ]

The spec doesn't mandate that the first two double words (aka results)
for the command queue entry need to be set to 0 when they are not
used (not specified). Though, the target implemention returns 0 for TCP
and FC but not for RDMA.

Let's make RDMA behave the same and thus explicitly initializing the
result field. This prevents leaking any data from the stack.

Signed-off-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
[ Ignored the fabrics-cmd-auth.c, it was introduced in commit:db1312dd9548
("nvmet: implement basic In-Band Authentication") ]
Signed-off-by: Leon Chen <leonchen.oss@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/target/core.c        |    1 +
 drivers/nvme/target/fabrics-cmd.c |    6 ------
 2 files changed, 1 insertion(+), 6 deletions(-)

--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -932,6 +932,7 @@ bool nvmet_req_init(struct nvmet_req *re
 	req->metadata_sg_cnt = 0;
 	req->transfer_len = 0;
 	req->metadata_len = 0;
+	req->cqe->result.u64 = 0;
 	req->cqe->status = 0;
 	req->cqe->sq_head = 0;
 	req->ns = NULL;
--- a/drivers/nvme/target/fabrics-cmd.c
+++ b/drivers/nvme/target/fabrics-cmd.c
@@ -187,9 +187,6 @@ static void nvmet_execute_admin_connect(
 	if (status)
 		goto out;
 
-	/* zero out initial completion result, assign values as needed */
-	req->cqe->result.u32 = 0;
-
 	if (c->recfmt != 0) {
 		pr_warn("invalid connect version (%d).\n",
 			le16_to_cpu(c->recfmt));
@@ -255,9 +252,6 @@ static void nvmet_execute_io_connect(str
 	if (status)
 		goto out;
 
-	/* zero out initial completion result, assign values as needed */
-	req->cqe->result.u32 = 0;
-
 	if (c->recfmt != 0) {
 		pr_warn("invalid connect version (%d).\n",
 			le16_to_cpu(c->recfmt));


