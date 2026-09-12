Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A4620ED;
	Sat, 12 Sep 2026 08:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203012; cv=none; b=O8xvymhyamCiUCjwBE5U8/ZoiAzA9okCCc/keMxqP7GZ1WESeEsOjX5DfMxaD8BZp/uUvm1truwNTsFw3E8z84tw99qvdOl3edVQQvwbpy9LXhkEerZ7GFsulb6ifYKYacLOfimUDZ2ce/ZaB6KyeOPNdyXm10pjS0ryJFAcGd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203012; c=relaxed/simple;
	bh=Zn/hxpbUwb0EDXXNie3gRGMz2e1OKZWZ/9BYc6HXFXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RJ4Y9CDZdLzynBy9Hg02KN/JyzR5SOEYo+G1g8rAj08FXdPoWuiFQTFxC2mx3SO3W/ih6NXOiiaZB/2qkcWyKOEXk+tuNH8Tj3gbXHSa8bCeXw0pHulBbDQIQ7nhEUaoIJXwIJdwxJzW68SlNeyy9gPpjgDzGcN9xxOxu4Bsqmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iDJt6Y1p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iDJt6Y1p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24DC21F000FF;
	Sat, 12 Sep 2026 08:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203010;
	bh=d2OLgJxklJT5F9iOq5mXphhjp15evySqcGqca8ykZRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iDJt6Y1piLU1N4KhTKeFCCMVVaFSdoZDHnr8vsVVDhS9XOfcphGN/dyGReiAclGsC
	 TJnY3GZdi43b1NHSs7/G9/8i8HX1mrkzpuEREFsqKX36IObKPNyEqm0wN1iVfcTu2m
	 0KujVTdODWYfXztZ9KoLpq1wkmYXdMXzV/Q4pWiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1319/1815] nvmet: propagate percpu_ref_init() failure in nvmet_ns_enable()
Date: Sat, 12 Sep 2026 08:51:09 +0200
Message-ID: <20260912065719.988680730@linuxfoundation.org>
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

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit 751709592d2626eaa8dc17ef8137796758a3c37f ]

The return value of percpu_ref_init() is discarded. At this point ret is
0 from the preceding successful steps, so when the allocation inside
percpu_ref_init() fails the code jumps to the out_pr_exit cleanup chain
which ends with "return ret", i.e. reports success. The configfs enable
store then tells userspace the namespace was enabled even though it was
not and its backing device has already been torn down.

Capture the return value so the failure is propagated.

Fixes: 408232680707 ("nvmet: Fix crash when a namespace is disabled")
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 7e565a84d341a..48a9a07f0f624 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -610,7 +610,8 @@ int nvmet_ns_enable(struct nvmet_ns *ns)
 			goto out_dev_put;
 	}
 
-	if (percpu_ref_init(&ns->ref, nvmet_destroy_namespace, 0, GFP_KERNEL))
+	ret = percpu_ref_init(&ns->ref, nvmet_destroy_namespace, 0, GFP_KERNEL);
+	if (ret)
 		goto out_pr_exit;
 
 	nvmet_ns_changed(subsys, ns->nsid);
-- 
2.53.0



