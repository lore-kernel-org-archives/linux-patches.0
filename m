Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE8641B8E4;
	Sat, 12 Sep 2026 10:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210722; cv=none; b=GtwmVbm4HtQ68vVsOy/9DG7l2AMJhSrfA32SWs+QnKoh2v61lfStFqtIN7osxecw+QvWmCi1piTXahyd4SYWT0e3AVFTeDZ54Q98hEBQixvbQDSyBLJjf2RQVkfTBbGFM4UPD/NgLN4wY7h6ojZop27yH7hWk+Zij2YdQmuUQv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210722; c=relaxed/simple;
	bh=7BWJBma+Ln6wTvrONRa+xt1l9GjQpf2R0Ir6Bv3nHEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eQE2PLLb1NOatDL09a/TaoFLiQLvM2GdqX0Dm27vKg1+4mblOaIiBJaDN0PMSv6Nm+SsDxjzzEtQ0UM6hZkfhXnrXHvwNNl1O1QVnSEbtef3fKgVTlBs4JDJMbJHfrvwmh/glyDEKzPYO231Ct0CKUMPtAXa5AsjKOzfHrVGwrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TDNoYAWk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TDNoYAWk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F26A01F000FF;
	Sat, 12 Sep 2026 10:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210721;
	bh=qSnPhVbib2dqzkWFiXudRGTV8dFv/92BHPP6gi9lIhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TDNoYAWkyOSZukfVDnfoqIQKAz4wanDUksvQ9wI8kSAjjAr2R4DDuR3RcIqqvqarW
	 VQRYIzhSbe0iNVGjyK7m05CxzyMFFAZ6XMCzrUWxjd++UJyryS0G1FyqShooFU9K1H
	 kX7i18vWNKqWGvBOBMsDrq5vQ98fUI9FrxWXnZgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Guixin Liu <kanie@linux.alibaba.com>,
	Zhengrong Li <zhengrong_li@linux.alibaba.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1084/1518] nvmet: fix Reservation Register Replace for unregistered host with IEKEY
Date: Sat, 12 Sep 2026 08:54:13 +0200
Message-ID: <20260912065647.971666651@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index cd22d8333314e..783e6a5ec3e04 100644
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



