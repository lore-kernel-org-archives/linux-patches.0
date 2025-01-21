Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C31921F543F;
	Tue, 21 Jan 2025 18:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482625; cv=none; b=s7zILf/2FiJfqUkDGXVujmGn4PXNyeciYI8jkWlwazcNt/0/tomqhfR9qjX8viadrpTTSTdcE3fUdC8XTuVADRxCG9V9Ksg5z0f2KXCx0lMX1/j484DueSZoNZA/wRFUCtbtbivSFqDGMusCu8atNASuheWsP1oxxwD+ICg5lw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482625; c=relaxed/simple;
	bh=i2srAFijowdsL01s4BH1+MPPHMHzGqndnZyNpXqjNbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DAGaVSdw+guXoK6JIuBxfn2KDkQKbrZZk/P7VCwEv1afms9w7Oa1X8b0ZnswXSEIOTjgJbTG6czxI4XK/25T+oyszPdJh30C9ivJ2zOOrqSU4uUyMLQ8bjztPzn4PuEmk+y8EX0ZfzOcoBNKUuTKgEQFAVe5CJIgcm7lhPcUo5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TfQ+Gj+n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TfQ+Gj+n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1787C4CEDF;
	Tue, 21 Jan 2025 18:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482624;
	bh=i2srAFijowdsL01s4BH1+MPPHMHzGqndnZyNpXqjNbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TfQ+Gj+nvOXFHgOusnvFm+EHPgxXzjXw1MmLDNnzgJbfVzz1W8ixlWs+9rhCr2gUU
	 ueRYxFuWl6pD0/rhW0VNaQCnSJDEJn+zC6e+2pdqaxF58RuM4dVzHK8BOaA2KrJCV7
	 veJXkfRMHEX8LNfdSoO6NXl2aB2KhBh338QykFKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Chamberlain <mcgrof@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 18/64] nvmet: propagate npwg topology
Date: Tue, 21 Jan 2025 18:52:17 +0100
Message-ID: <20250121174522.254052155@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174521.568417761@linuxfoundation.org>
References: <20250121174521.568417761@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luis Chamberlain <mcgrof@kernel.org>

[ Upstream commit b579d6fdc3a9149bb4d2b3133cc0767130ed13e6 ]

Ensure we propagate npwg to the target as well instead
of assuming its the same logical blocks per physical block.

This ensures devices with large IUs information properly
propagated on the target.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/io-cmd-bdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io-cmd-bdev.c
index c2d6cea0236b0..ada58a4d0d0cf 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -36,7 +36,7 @@ void nvmet_bdev_set_limits(struct block_device *bdev, struct nvme_id_ns *id)
 	 */
 	id->nsfeat |= 1 << 4;
 	/* NPWG = Namespace Preferred Write Granularity. 0's based */
-	id->npwg = lpp0b;
+	id->npwg = to0based(bdev_io_min(bdev) / bdev_logical_block_size(bdev));
 	/* NPWA = Namespace Preferred Write Alignment. 0's based */
 	id->npwa = id->npwg;
 	/* NPDG = Namespace Preferred Deallocate Granularity. 0's based */
-- 
2.39.5



