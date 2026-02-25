Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BFB82C0263;
	Wed, 25 Feb 2026 06:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002586; cv=none; b=XmB8EoqBdIiZZCYC5/1AIGpGmFtZpnvyOQSQuBt4d9YR8WChSieinwWpFQwpeiV/+99QCkR50fdKF57Lb2XYnIYMT0S3p+0tIO+buvkyKmxQvd30W/lbsJV7fTQxHSqVqokoio3a+SCkpmb0wJZC/5bHhFh+lByopP3WOPVVPwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002586; c=relaxed/simple;
	bh=ieGXJNtNcdDMZBUiAv1IE4v3sbqqUcsepDLPO+SO+Hk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pmPu0Ny7u7vqBNIVzbaaAPu96EZ7XP+JYwmubdqL0wJiNAXdXVrvbXL0xslqgMDcCuE7CKZ9D1DeJ3caJ1Hfy5cwtgXATuJO4J6mZEZO+X+i8VLyk4BGm5ySlxMc445tR0nqYvDQ79SgN8wo4tfN9Rs3WRqqKwC26EnOAXpJoo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L9Ejmmfz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L9Ejmmfz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54A68C116D0;
	Wed, 25 Feb 2026 06:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002586;
	bh=ieGXJNtNcdDMZBUiAv1IE4v3sbqqUcsepDLPO+SO+Hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L9Ejmmfzt1EhtXPj/Uf+SHm13rO9bGqj/Ox7j1Op9Gmmw3KuGcqqD8BsQ+La6REhd
	 40+FI4YF9ahXmv+7uBvaV4WTSyWJjKDRJ5cv5ZTlhYU2fiaN+n8R7U//EL87b2d1Op
	 UC9dvT20Pf4gXqKSnOcmv63OB6szd9yXSGB6TC4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Shen <shenjian15@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 323/641] net: hns3: fix double free issue for tx spare buffer
Date: Tue, 24 Feb 2026 17:20:49 -0800
Message-ID: <20260225012356.530577121@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit 6d2f142b1e4b203387a92519d9d2e34752a79dbb ]

In hns3_set_ringparam(), a temporary copy (tmp_rings) of the ring structure
is created for rollback. However, the tx_spare pointer in the original
ring handle is incorrectly left pointing to the old backup memory.

Later, if memory allocation fails in hns3_init_all_ring() during the setup,
the error path attempts to free all newly allocated rings. Since tx_spare
contains a stale (non-NULL) pointer from the backup, it is mistaken for
a newly allocated buffer and is erroneously freed, leading to a double-free
of the backup memory.

The root cause is that the tx_spare field was not cleared after its value
was saved in tmp_rings, leaving a dangling pointer.

Fix this by setting tx_spare to NULL in the original ring structure
when the creation of the new `tx_spare` fails. This ensures the
error cleanup path only frees genuinely newly allocated buffers.

Fixes: 907676b130711 ("net: hns3: use tx bounce buffer for small packets")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20260205121719.3285730-1-shaojijie@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index e976a88b952f0..c8eba180250e7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1048,13 +1048,13 @@ static void hns3_init_tx_spare_buffer(struct hns3_enet_ring *ring)
 	int order;
 
 	if (!alloc_size)
-		return;
+		goto not_init;
 
 	order = get_order(alloc_size);
 	if (order > MAX_PAGE_ORDER) {
 		if (net_ratelimit())
 			dev_warn(ring_to_dev(ring), "failed to allocate tx spare buffer, exceed to max order\n");
-		return;
+		goto not_init;
 	}
 
 	tx_spare = devm_kzalloc(ring_to_dev(ring), sizeof(*tx_spare),
@@ -1092,6 +1092,13 @@ static void hns3_init_tx_spare_buffer(struct hns3_enet_ring *ring)
 	devm_kfree(ring_to_dev(ring), tx_spare);
 devm_kzalloc_error:
 	ring->tqp->handle->kinfo.tx_spare_buf_size = 0;
+not_init:
+	/* When driver init or reset_init, the ring->tx_spare is always NULL;
+	 * but when called from hns3_set_ringparam, it's usually not NULL, and
+	 * will be restored if hns3_init_all_ring() failed. So it's safe to set
+	 * ring->tx_spare to NULL here.
+	 */
+	ring->tx_spare = NULL;
 }
 
 /* Use hns3_tx_spare_space() to make sure there is enough buffer
-- 
2.51.0



