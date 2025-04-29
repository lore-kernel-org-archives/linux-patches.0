Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532C025178B;
	Tue, 29 Apr 2025 16:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945899; cv=none; b=p0vu3jIL1CkZLJYzDeuHI1eOxvhMzn1LedfhCofpvZLnxWAH91nuiuyZ9+pWT99gdSI4R3BSnAvuv7DYvcza+xrgflgOel8jXYHuD1Wz5uKLNKTTeqjjHgcAvAp4/ne0h6QLs42DErQZAyJ1jCWR3WPkrLUNxSA4nWppvVVi+Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945899; c=relaxed/simple;
	bh=mL98ytNfwguR2+BvsYZzlYljUFk2g5lk9trgZ5y9EoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=foGsIGdGHVLU5OmQLS/CLfaGKK8KPxdpFRApAnxZk8bgYDDuk6eJKRlYhjsvxMIuHPcTc++tekscRl/yJlVqxMo6bvC4agAofk2fKfqgcYQsnkCfv3M2YeCTC18Q0GqSd4zkSTw+zNPvoWH0jy6WYnfrTdLk8zrP3/wfMXnyR4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DJVEo83t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DJVEo83t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8D85C4CEE9;
	Tue, 29 Apr 2025 16:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945899;
	bh=mL98ytNfwguR2+BvsYZzlYljUFk2g5lk9trgZ5y9EoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DJVEo83tCTN6JjbWq6S1A9NKSb+cTwM0+LzgMPdsyQ/pQQnMBvrA1wpMsSNjlHOiw
	 8v0rTObxKzYWxiRMA1uXAz3uMqPJHukdmGDQDGDwn4PT6sdPpfzWRFxXGjxTAgVNhj
	 8jUDxIk/iIOcze2gN0evf2/wCUYxpkvwyDh2zQF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Weinberger <richard@nod.at>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 057/311] nvmet: fix out-of-bounds access in nvmet_enable_port
Date: Tue, 29 Apr 2025 18:38:14 +0200
Message-ID: <20250429161123.376182715@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Weinberger <richard@nod.at>

[ Upstream commit 3d7aa0c7b4e96cd460826d932e44710cdeb3378b ]

When trying to enable a port that has no transport configured yet,
nvmet_enable_port() uses NVMF_TRTYPE_MAX (255) to query the transports
array, causing an out-of-bounds access:

[  106.058694] BUG: KASAN: global-out-of-bounds in nvmet_enable_port+0x42/0x1da
[  106.058719] Read of size 8 at addr ffffffff89dafa58 by task ln/632
[...]
[  106.076026] nvmet: transport type 255 not supported

Since commit 200adac75888, NVMF_TRTYPE_MAX is the default state as configured by
nvmet_ports_make().
Avoid this by checking for NVMF_TRTYPE_MAX before proceeding.

Fixes: 200adac75888 ("nvme: Add PCI transport type")
Signed-off-by: Richard Weinberger <richard@nod.at>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 2e741696f3712..6ccce0ee51573 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -324,6 +324,9 @@ int nvmet_enable_port(struct nvmet_port *port)
 
 	lockdep_assert_held(&nvmet_config_sem);
 
+	if (port->disc_addr.trtype == NVMF_TRTYPE_MAX)
+		return -EINVAL;
+
 	ops = nvmet_transports[port->disc_addr.trtype];
 	if (!ops) {
 		up_write(&nvmet_config_sem);
-- 
2.39.5



