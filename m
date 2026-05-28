Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D3C2C15AC;
	Thu, 28 May 2026 20:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000770; cv=none; b=QUXBhq+bNjOLS+FMwbhCPbdjtg6jq3ZydOrFHusK90WvhXhD3FUsG7BfPO5AsAD0Ie0BhRaihBdLjWz0ACCKYxzIARA8ycwM8yAWkuSc2ELJLGa088ap72JhUBUbxOcUQEskdPCfrLnDwh4gvEwkgGyRIAW27i62qWFNxeB89Jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000770; c=relaxed/simple;
	bh=Gbqb7DJVF4zap3nWMYpILFc+Ea6WFHmY+qW3XZD/rnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U3xBPBRjOmf0tcWgqhMn3tOO7WtQU8TJhVbcfqY3H3CJuqHldzc/qe3Ap8gKMZbi/XIwavDMlYLfbEk0/Zg7RCiWiBrBnlKTzQDeFKz3bM6hOtOTf7qV4OKmcI76AdoOvLRzmpXJUMcFPsBGabbByRCKHDrZZZOYzxl6uA4bOyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1iBSAl8c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1iBSAl8c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25A661F000E9;
	Thu, 28 May 2026 20:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000769;
	bh=ZLV7MWzc1jaHO+hQhX9UDcUSaUBvdmQU6w2PcpM2IuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1iBSAl8c1VnxAfC3hHmbr+ZaAgUKRjwADHCbGWYzPEj1s9APLZ2XPzkxkH3z3u3OK
	 DA0eP8BQBOgbvvAAWZFlQ0tyPtIzfn5UyLNsKFqN+eGmelnzITsGjdNgNL2Y5M8tv6
	 DpE7buu/oYy5JB8cZvywTfm6xqY6gbPxbgL5BF9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 161/272] firmware: arm_ffa: Fix sched-recv callback partition lookup
Date: Thu, 28 May 2026 21:48:55 +0200
Message-ID: <20260528194633.850214691@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sudeep Holla <sudeep.holla@kernel.org>

[ Upstream commit a6848a50404eefb6f0b131c21881a2d8d21b31a9 ]

ffa_sched_recv_cb_update() used list_for_each_entry_safe() to search for
a matching partition and then tested the iterator against NULL. That is
not a valid end-of-list check for circular lists and can fall through
with an invalid pointer. Use a normal iterator and detect the not-found
case correctly before touching the partition state.

Fixes: be61da938576 ("firmware: arm_ffa: Allow multiple UUIDs per partition to register SRI callback")
Link: https://patch.msgid.link/20260428-ffa_fixes-v2-11-8595ae450034@kernel.org
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_ffa/driver.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index f35c3a56326c7..89474fa3c80e5 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -1155,7 +1155,7 @@ static int
 ffa_sched_recv_cb_update(struct ffa_device *dev, ffa_sched_recv_cb callback,
 			 void *cb_data, bool is_registration)
 {
-	struct ffa_dev_part_info *partition = NULL, *tmp;
+	struct ffa_dev_part_info *partition = NULL;
 	struct list_head *phead;
 	bool cb_valid;
 
@@ -1168,11 +1168,11 @@ ffa_sched_recv_cb_update(struct ffa_device *dev, ffa_sched_recv_cb callback,
 		return -EINVAL;
 	}
 
-	list_for_each_entry_safe(partition, tmp, phead, node)
+	list_for_each_entry(partition, phead, node)
 		if (partition->dev == dev)
 			break;
 
-	if (!partition) {
+	if (&partition->node == phead) {
 		pr_err("%s: No such partition ID 0x%x\n", __func__, dev->vm_id);
 		return -EINVAL;
 	}
-- 
2.53.0



