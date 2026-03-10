Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED273C3BF4;
	Tue, 10 Mar 2026 11:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142142; cv=none; b=j0HMFSKnOHZjwEi1mhtTYgaDAwkaAPBcWiWzJ0Y54E8t83r6PUK9V68gLG6LvBTpLB5qFn1z/XQKmdCq2bsCmpaQvSgdOPcDs95l4a8KdBjJPVObENN0bgaME1Srs6cStY8+9YiwMJ6rPuXuY0rw4Tv/GZ2mD7LqYBzbDlfkFIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142142; c=relaxed/simple;
	bh=xOzQ79KIStV3wTIjF7DaQjVGiM/WFAXn6+lfOREvynE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rbaXjdQ8++QH+tXi/D89t4SJPz+aYJV+50GLBBPMKoWHkRf1HryrMaB9Xz6RbcxYdyPHBsBWUwRg2+dJMK7/lFIKZbzs8eOtjbU+EAkPRxSg5ngxH49wNzwP7s+L3bcaFj0dLkj02B1uOfU8xqb9JOcWZpdu0LU0lGhAlRCq+so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IApt9yRp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IApt9yRp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5965BC2BC9E;
	Tue, 10 Mar 2026 11:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142142;
	bh=xOzQ79KIStV3wTIjF7DaQjVGiM/WFAXn6+lfOREvynE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IApt9yRpx0eqPiIpYowAtR/h5dnwoJ+zvc+F+docA/UX2ENiILkJtn2lmnhEqwVlh
	 ysdIU6GWwoqV7D3sHs3xyXVrT3+Iv1I8TaDDbpgyG+mMRYQD6VrBBQW/hjjKFjSBAZ
	 3lrTkFGFtjNOn6mMfI16cnCagJ4XNxBq7NR0702gdBnmj+RK3+eNt8UsWqfxWJj19p
	 pusxiuN3gsxlzuR02Ob9lLetpu0+DAKl/AAO1d0CYhw0p3rSKoySSURXmqgzvrx7S5
	 tvMagW0q6DZT/z0UDUIW6pUPiDDKt3Q0snIyvyyqDGlKgjYsb0Bj2jpqfo4enc5lv8
	 IerS+4whE47pw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Keith Busch <kbusch@kernel.org>,
	Nilay Shroff <nilay@linux.ibm.com>,
	John Garry <john.g.garry@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 229/314] nvme-multipath: fix leak on try_module_get failure
Date: Tue, 10 Mar 2026 07:18:08 -0400
Message-ID: <0c0f738512816aface34efded56ae8d87c5f7edb.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
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
index e35eccacee8c8..81ccdd91f7790 100644
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

