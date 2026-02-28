Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A60375AC1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301635; cv=none; b=pO17GTYWRpt2cn/seULcJnf/J8ZClKJZ/ludLodFoG5ZlSxVbWMxuJ6r1SzE0BclUKeLjHefGw4yvrjVb52fVc8lddeBSi3G+9mAvXU8TYueWj2FH3lo2uCsO4qtL/8WWkp+CzLnvBap1soBUs8j447j1i6EAdORJMKlxX8R+gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301635; c=relaxed/simple;
	bh=J+9e44xM3ume1sVBwZ+BbvOdW0JzmhOHdLzq+kgTG3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rrttZsisHceSIJhDYtnrMfpZ0YdHIuY03YP5tnLCfe1ZbUhndZeZbFdaw9YIdvige3S7JpwXAAdP6PtuLVOsM+/UtB0DZf4FEp5hAC42CGhnIlXZh2qNK+wHm60o1vrUthIxV6JsDo397ozaVagyaQDqlDHzLRwDalDp+7qCGSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WlBKTAFR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WlBKTAFR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C917C19425;
	Sat, 28 Feb 2026 18:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301634;
	bh=J+9e44xM3ume1sVBwZ+BbvOdW0JzmhOHdLzq+kgTG3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WlBKTAFRk2JX6yf+Bq2WRIQil7BcZFRcxNuGQ1ckMSkJGT2xIVWM5T7wrmtZ9cdSF
	 E51weNnjfBn9vBu5/Pua1tCLxYr3oHghIdxKGLCto7EQBoKVKGeMCMlce4UQiKSKC5
	 3nXL62KfK1XTwG9P3oOuD9Kt8NV2igJhN40enXJoOOpt2cSoiPhmHKBhXUNs/3c+tm
	 ZjiL2YDY72F3HDleOL3ukCyKofl5pdyE6XLrTzmqqaFBnqj/n/sX4oc/8OAa/ApX/T
	 J4v6j2rgtrTRASFepwMCyJAHGHsIaa6IfaNkgysPiWw0TQIkGhB0Gtj3NSIbxIQVuU
	 wMON8Z6wObz/A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Teddy Astie <teddy.astie@vates.tech>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 027/385] xen/virtio: Don't use grant-dma-ops when running as Dom0
Date: Sat, 28 Feb 2026 12:54:09 -0500
Message-ID: <20260228180011.1568201-27-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Teddy Astie <teddy.astie@vates.tech>

[ Upstream commit dc8ea8714311e549ee93a2b0bdd5487d20bfadbf ]

Dom0 inherit devices from the machine and is usually in PV mode.
If we are running in a virtual that has virtio devices, these devices
would be considered as using grants with Dom0 as backend, while being
the said Dom0 itself, while we want to use these devices like regular
PCI devices.

Fix this by preventing grant-dma-ops from being used when running as Dom0
(initial domain). We still keep the device-tree logic as-is.

Signed-off-by: Teddy Astie <teddy.astie@vates.tech>
Fixes: 61367688f1fb0 ("xen/virtio: enable grant based virtio on x86")
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <6698564dd2270a9f7377b78ebfb20cb425cabbe8.1767720955.git.teddy.astie@vates.tech>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/grant-dma-ops.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/grant-dma-ops.c b/drivers/xen/grant-dma-ops.c
index 29257d2639dbf..43a918c498c6c 100644
--- a/drivers/xen/grant-dma-ops.c
+++ b/drivers/xen/grant-dma-ops.c
@@ -362,7 +362,8 @@ static int xen_grant_init_backend_domid(struct device *dev,
 	if (np) {
 		ret = xen_dt_grant_init_backend_domid(dev, np, backend_domid);
 		of_node_put(np);
-	} else if (IS_ENABLED(CONFIG_XEN_VIRTIO_FORCE_GRANT) || xen_pv_domain()) {
+	} else if (!xen_initial_domain() &&
+		   (IS_ENABLED(CONFIG_XEN_VIRTIO_FORCE_GRANT) || xen_pv_domain())) {
 		dev_info(dev, "Using dom0 as backend\n");
 		*backend_domid = 0;
 		ret = 0;
-- 
2.51.0

