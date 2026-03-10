Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21CFE387362;
	Tue, 10 Mar 2026 11:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141205; cv=none; b=f7m1BQtv70dvbUd+6zjdeCAXEW1JJ21H9q8xMRzWXufwmkiE9nUH16GRE2bH9uN7bLpRVvRnyxQ3GZbpqIgNp867gbYEqZrgNU7Cb6v3hLgqEhtM4Fn6S/qSQYRHuc6puKdE6NP7Fk0JBRBrYWPlppPNSxB9btPtE10c54Wio6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141205; c=relaxed/simple;
	bh=t5CvwlLpAZwmrgnCnWCqVSVeP0EcyKN5jfGGURH/g4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HowB71kysuZj0BLbtAchT48bHdDo1wV1mWakJL0qrbX3pokNE+EixRvTIfBveLW65wKCJU+mHPxiqLIfHUI4zuRNFYepsP9+rUlpWbAdmxdCTiwm6ITN5bvPnkFDAIqcDH3HXUIhQVxpFQoLK5SKrvVqFI36Qts4wYER6goDmfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HyAL+C+0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HyAL+C+0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 446C0C2BC9E;
	Tue, 10 Mar 2026 11:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141205;
	bh=t5CvwlLpAZwmrgnCnWCqVSVeP0EcyKN5jfGGURH/g4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HyAL+C+0XeUbq00Euq9uBWvGAcxtXrSxZx6i337G+4lN74dPf973CWSxPDzC/m4Dg
	 ch7gAWP7KCUTg1EgOklngDV3xmzuFOH4/zD1mD+hntTn92H5yvyzDBEM+9+Qbv6ixF
	 /T5u231+v1dvKjIl4fhL5Bkh5o6QuwmBpg9iEwW/hJfutki+mJFJ93HWbDD2ZhXwEL
	 Xq4VkFrCBxixjWs3nKrQcBQoRnez/cw3DyCHvCFZukcMZvG7H99OwrQVgO0WMeY4bB
	 POSpajERC7ORMC3h765H2VfUBshwDL0m1C5yU5CTKFYEH1LmEU+L5iao978RNd2odh
	 2T02M1MZqUIdQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Keith Busch <kbusch@kernel.org>,
	Nilay Shroff <nilay@linux.ibm.com>,
	John Garry <john.g.garry@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 205/311] nvme-multipath: fix leak on try_module_get failure
Date: Tue, 10 Mar 2026 07:04:12 -0400
Message-ID: <6c2cb6fb2a344b0639c2cdc778e52d5ce092264b.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 0f5197ea9a73a4c406c75e6d8af3a13f7f96ae89 ]

We need to fall back to the synchronous removal if we can't get a
reference on the module needed for the deferred removal.

Fixes: 62188639ec16 ("nvme-multipath: introduce delayed removal of the multipath head node")
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/multipath.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 174027d1cc198..5e41fbaf5f46a 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -1310,13 +1310,11 @@ void nvme_mpath_remove_disk(struct nvme_ns_head *head)
 	if (!list_empty(&head->list))
 		goto out;
 
-	if (head->delayed_removal_secs) {
-		/*
-		 * Ensure that no one could remove this module while the head
-		 * remove work is pending.
-		 */
-		if (!try_module_get(THIS_MODULE))
-			goto out;
+	/*
+	 * Ensure that no one could remove this module while the head
+	 * remove work is pending.
+	 */
+	if (head->delayed_removal_secs && try_module_get(THIS_MODULE)) {
 		mod_delayed_work(nvme_wq, &head->remove_work,
 				head->delayed_removal_secs * HZ);
 	} else {
-- 
2.51.0

