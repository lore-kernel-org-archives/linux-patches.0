Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF4A28B4FA;
	Sat, 12 Sep 2026 08:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203007; cv=none; b=Cg0yOCE+Qhk7wVLg/GRxYiOC3GN+unBah+3kB3HvTdP2Dr7Dm1leT41tLyXRGwYD6EGOch6qWOep6MK8j20XKWFLcm6VLIoE71AFe+uB0xBfDZEKxlQZuZmaUtTxQ5VjFmmVBb5dZJnFCPw4IYovek6K1Icb/x4CCpVt105GbQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203007; c=relaxed/simple;
	bh=89IBUhJcYjHj0y49pNcjLgMU49EBeWaP+Ix7qbZHa2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qKFdoB3Fu8C/hKyB/mFqYRDzr7AvU0XMw7MK9HESPZAEQ7HqpQoLeYE7znkFJZ4TK6jmP5iC9HpCVnDuzMfPmE1/eCSqKKg6x3j9cB4BWwn5o3mJMaRRaoT76SWAKehgoilV4jA5u6Ly99JEJujANt/CU/eihKwi1bQeGKBYoYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0r3OSana; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0r3OSana"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FD171F000FF;
	Sat, 12 Sep 2026 08:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203006;
	bh=O6/jFjSUQq/LM3Uxx++7iENyp+x6vhh//3rhhD/V9no=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0r3OSanafrsWil5ZXqm+9p+CQCGeTxIu9DjXeqLafYBMY86m/s2WlML3Ulut+BPdc
	 9/bAuCCBGOYmNmBv8px4NpJLlyxQW48iWivDC5uvMJYcmd+vfHT4tLOzWU2CWr+GLN
	 hGlJax5itf+Xj30WV8sYV+m9GF98v2jOzIUnrRbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Guixin Liu <kanie@linux.alibaba.com>,
	Zhengrong Li <zhengrong_li@linux.alibaba.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1318/1815] nvmet: fix Reservation Register Replace for unregistered host with IEKEY
Date: Sat, 12 Sep 2026 08:51:08 +0200
Message-ID: <20260912065719.964723932@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhengrong Li <zhengrong_li@linux.alibaba.com>

[ Upstream commit 0a96b9e440331bffbf049f80d7e5c96417d37e36 ]

When a host sends a Reservation Register command with RREGA=Replace
and IEKEY=1 without being previously registered, nvmet returns
Reservation Conflict.

The NVMe specification states:

  "A host may replace its reservation key without regard to its
   registration status or current reservation key value by setting
   the Ignore Existing Key (IEKEY) bit to '1' in the Reservation
   Register command."

Fix nvmet_pr_replace() to add a new registrant when the host is not
found in the registrant list and IEKEY is set with a non-zero NRKEY.
If IEKEY is set but NRKEY is zero, return Invalid Field since there
is no valid reservation key to register.

Tested with nvme-cli against nvmet-tcp:

  # no prior registration
  nvme resv-register /dev/nvmeXn1 -n 1 --rrega=2 --iekey --nrkey=0x9999

  Before: RESERVATION_CONFLICT (0x4083)
  After:  success, registrant created with rkey 0x9999

Fixes: 5a47c2080a73 ("nvmet: support reservation feature")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Guixin Liu <kanie@linux.alibaba.com>
Signed-off-by: Zhengrong Li <zhengrong_li@linux.alibaba.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/pr.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/pr.c b/drivers/nvme/target/pr.c
index c71ae46244ffc..7d937093b2262 100644
--- a/drivers/nvme/target/pr.c
+++ b/drivers/nvme/target/pr.c
@@ -355,9 +355,15 @@ static u16 nvmet_pr_replace(struct nvmet_req *req,
 	u16 status = NVME_SC_RESERVATION_CONFLICT | NVME_STATUS_DNR;
 	struct nvmet_ctrl *ctrl = req->sq->ctrl;
 	struct nvmet_pr *pr = &req->ns->pr;
-	struct nvmet_pr_registrant *reg;
+	struct nvmet_pr_registrant *reg, *new = NULL;
 	u64 nrkey = le64_to_cpu(d->nrkey);
 
+	if (ignore_key && nrkey) {
+		new = kzalloc_obj(*new);
+		if (!new)
+			return NVME_SC_INTERNAL;
+	}
+
 	down(&pr->pr_sem);
 	list_for_each_entry_rcu(reg, &pr->registrant_list, entry) {
 		if (uuid_equal(&reg->hostid, &ctrl->hostid)) {
@@ -365,9 +371,26 @@ static u16 nvmet_pr_replace(struct nvmet_req *req,
 				status = nvmet_pr_update_reg_attr(pr, reg,
 						nvmet_pr_update_reg_rkey,
 						&nrkey);
-			break;
+			goto free_data;
+		}
+	}
+
+	if (ignore_key) {
+		if (!nrkey) {
+			status = NVME_SC_INVALID_FIELD | NVME_STATUS_DNR;
+			goto free_data;
 		}
+		INIT_LIST_HEAD(&new->entry);
+		new->rkey = nrkey;
+		uuid_copy(&new->hostid, &ctrl->hostid);
+		list_add_tail_rcu(&new->entry, &pr->registrant_list);
+		status = NVME_SC_SUCCESS;
+		goto out;
 	}
+
+free_data:
+	kfree(new);
+out:
 	up(&pr->pr_sem);
 	return status;
 }
-- 
2.53.0



