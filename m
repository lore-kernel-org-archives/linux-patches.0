Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92D5317163;
	Thu, 28 May 2026 20:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999870; cv=none; b=JOcRxmdJxC8dPxu0QSF79gvHrSoUHG2h/KVQ908OqPQFpMNwPa+t3ssIK90v4iSGMdZXPABm8Ac7HkMC5WmUw3GaMl0iNKNvkNc4hp82pvRu26Y1Uwrbu/CacTd62s2ocZaWVRWVJzeq9IOtpUrZJkLvIDygSbIj5IS61MQ1Ids=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999870; c=relaxed/simple;
	bh=l4MTEjaak3XC96SqEWv/w2BgZpaAIBJSpnKLpKrqBLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IEDyyazJlcSdFVHGBvkuAC4pWko14pDShu2lnvpatfuN/I86zps5wT/n2BFCXjx7Myf+/1eT9mTjhuIzBcq61B4neHWDslX0ArfPMPj9UknO/25XdRdY/qUgqpSr04YxlARUnwQTD+S2pIP+PxL47u2eih4+A4ZNgSQ3F2hJCJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CSits3zl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CSits3zl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22A981F000E9;
	Thu, 28 May 2026 20:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999869;
	bh=I2veWTLarbEdG3ztB/DMEyIvwNZBy/CtSLXpbWb0OXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CSits3zlUdFwsGprJsnzclVRGwWrqG9nKIBIrbuYvwJSDY3KYGiUc9g5LYRWWiO4U
	 AJJoQCGLwNiu+u34uzw5F4BVCTFHt24k8qqgkOQNV5i3OMx3VjmFbeUOg38kj0w5LM
	 eC2egUt+o4vYX/r0AJUVXwYXvtVt9jl8mzsi82gA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 193/377] firmware: arm_ffa: Fix sched-recv callback partition lookup
Date: Thu, 28 May 2026 21:47:11 +0200
Message-ID: <20260528194643.999374257@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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
index f518c87031022..827aac08a8e9e 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -1203,7 +1203,7 @@ static int
 ffa_sched_recv_cb_update(struct ffa_device *dev, ffa_sched_recv_cb callback,
 			 void *cb_data, bool is_registration)
 {
-	struct ffa_dev_part_info *partition = NULL, *tmp;
+	struct ffa_dev_part_info *partition = NULL;
 	struct list_head *phead;
 	bool cb_valid;
 
@@ -1216,11 +1216,11 @@ ffa_sched_recv_cb_update(struct ffa_device *dev, ffa_sched_recv_cb callback,
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



