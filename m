Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF5734389C;
	Sat, 12 Sep 2026 07:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198588; cv=none; b=IAP8r2ekdraP8p7+pGyqBTnP2PcJD/MTy9iVE6pQSyPRCemnKCaEvV/W2dX6GkMkPLKypYvp4QyLlhyHXk0pKYi1pL+8f2SjBu4UW1MvNGlDgk98v0AZTfWSqHfyP+6cM1b64BrwI1im/fy4W1qj6geBL/Hw/vcTGeuN0TR0yuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198588; c=relaxed/simple;
	bh=LjuZwA2FFL1qmlT6D+KEzPe7Px/xcddutONUk/FxlW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ubMuolhqZB49Qn0MCYTWx5bNW4elBjBlvL6C2X21E4mRO81215Suz5uG/7qzFqvwZKBjJmkz8OOkXrlM6aoee3MgLI34WVSkruN2jIvH9F/msV70JgPNQn6eclhgW9JrohGnx6r6nRpSB65HAQ2C8tGARryjWdDYtIZKQt6ov6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vDlcbZ2C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vDlcbZ2C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC06F1F000FF;
	Sat, 12 Sep 2026 07:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198587;
	bh=E1jWFOp5uVq84hWKKxlIbE9A7Egv0C2T5EoMpEkByYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vDlcbZ2CppsgQAuvZ9/x93w4b7xuwjgrFoj4dNwoAUGoObdtXZrZVRqnllNqVxN2X
	 KFNFCB8xIqX3BQQwwolglQUQ+BYpPnmLp0/G7WPH3GUNlI2yH8w6lVyHn/ajdJaVK9
	 rUihLh0IdDk/SNhNwLgCdslXza20U2GTC7XafBZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	yeeli <seven.yi.lee@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0368/1815] iommufd/selftest: Fix dmabuf leak in iommufd_test_dmabuf_get()
Date: Sat, 12 Sep 2026 08:35:18 +0200
Message-ID: <20260912065657.541103882@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: yeeli <seven.yi.lee@gmail.com>

[ Upstream commit dba4254e216d7482d91d93e45faa3ccbefe79337 ]

When dma_buf_export() succeeds but dma_buf_fd() fails (e.g. -EMFILE from
fd exhaustion), the dmabuf is leaked with no dma_buf_put() called.

Reproducer: exhaust fd table near RLIMIT_NOFILE, then repeatedly call
IOMMU_TEST_OP_DMABUF_GET — htop shows unbounded memory growth.

Fix by calling dma_buf_put(dmabuf) on error and returning directly.

Fixes: d2041f1f11dd ("iommufd/selftest: Add some tests for the dmabuf flow")
Link: https://patch.msgid.link/r/20260707030635.221577-1-seven.yi.lee@gmail.com
Signed-off-by: yeeli <seven.yi.lee@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommufd/selftest.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index 55f21c799d8e6..ee706f18f7e91 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -2055,7 +2055,12 @@ static int iommufd_test_dmabuf_get(struct iommufd_ucmd *ucmd,
 		goto err_free;
 	}
 
-	return dma_buf_fd(dmabuf, open_flags);
+	rc = dma_buf_fd(dmabuf, open_flags);
+	if (rc < 0) {
+		dma_buf_put(dmabuf);
+		return rc;
+	}
+	return 0;
 
 err_free:
 	kfree(priv->memory);
-- 
2.53.0



