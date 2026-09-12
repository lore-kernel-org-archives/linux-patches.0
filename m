Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B314429CE6;
	Sat, 12 Sep 2026 10:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210732; cv=none; b=lYF7z82bU3lxIN9G4XF0qSpoQiT7hgUMf5fuC8bVqhNZtnjkW0oWfMaA8Np0Pt9k53RayeHqgH+4S5gOFiXaf7OgypaEB/x5mPNxf8C4AuljQpHEvB1PSd/8rodffXqOjDF8BnLqF5shsKZpV6gzxuh1mkuOOoXWpDk569mfvaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210732; c=relaxed/simple;
	bh=YNgOPLVQR1E8icrwbqFGHdKElL3bAYKBot2BS25adYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KfvH4ImiUMOFCJYXmKJrZLcslzoH9WLCRWtNjiK8eAM1ccr+5RXg7Pw06bZ3Q8nA0tYazAT/FGa6JVkycGBOjDH9PX1PseWLbCHUY7OqBa8NGI3K6ItCTgB/Ei4GkJuCc9NbIVcN6BIVZe60S55V16tRTfb30IazCeiRh8+oE54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J6tps381; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J6tps381"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 203C31F000FF;
	Sat, 12 Sep 2026 10:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210730;
	bh=mPYoEY4Cmzgd7eo5jaHoe6y+j8CkKXrG8ouDfc+86qQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J6tps381e24BtIwbfG0qD+HmO2lm3lh+Axxe80XROp69/ZgDtJ60zOfNdDTTBVzbx
	 UZHokir1axKdn8nr8SZuYjyCICw4zDsMOn/yA09DO+ZrJagy2OsRlD2zdjrvj1AKH5
	 X2i1GapFE+UwAbKSibufubb3W20TArLJfYkLphhA=
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
Subject: [PATCH 6.18 1085/1518] nvmet: propagate percpu_ref_init() failure in nvmet_ns_enable()
Date: Sat, 12 Sep 2026 08:54:14 +0200
Message-ID: <20260912065647.994741465@linuxfoundation.org>
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
index 1cb07d279b44e..1f145b88120ba 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -601,7 +601,8 @@ int nvmet_ns_enable(struct nvmet_ns *ns)
 			goto out_dev_put;
 	}
 
-	if (percpu_ref_init(&ns->ref, nvmet_destroy_namespace, 0, GFP_KERNEL))
+	ret = percpu_ref_init(&ns->ref, nvmet_destroy_namespace, 0, GFP_KERNEL);
+	if (ret)
 		goto out_pr_exit;
 
 	nvmet_ns_changed(subsys, ns->nsid);
-- 
2.53.0



