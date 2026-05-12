Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C1033B6CC;
	Tue, 12 May 2026 18:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609546; cv=none; b=Dm4UCyaqYcr5P94LgO75dssrpgK9jlm07T5xt/L4fQb+CFmNZM3vWdmWbD96P5nRH9+HlNO7CqZKsU7ifL0vb+IAOhEVL/BqaDt+wd6bdE/+OgtzdWrqZAsd5w91RWLz9PXoGvDjOqlhYLcwcck4MKGXVziU3EQsmbDEE6sS/ME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609546; c=relaxed/simple;
	bh=+DBabdwwPDKPll6fTPPauNSGRfNds8qqLMaTnMr1OCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EOiqa6U6Qq7EheGnHvkBxgVy4g88oFI62FGae2ZE+WnsYtkHnootmsUZLQYzWyT+Ky2GKzWbIHT8zogZ3IrdPNdK3wGhVipnaBVVKzbiXRhd8S0iqSowhKWO9qGe51IoeDcLyUiPtFiQyRqaY1k+mtGskDydWEPJORi++Pyrh6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2bEgisHA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2bEgisHA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FD52C2BCB0;
	Tue, 12 May 2026 18:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609545;
	bh=+DBabdwwPDKPll6fTPPauNSGRfNds8qqLMaTnMr1OCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2bEgisHA9mNX18juZNelTeg1gNDPa5V1V5uMh8Nhwx1iGrm27thMFMsbNLJfwHHjo
	 29JqPNbZb1N+2YhEWjzJr+OLfErUYEz9xp3q42ZyaAS/1sy4Q4HaB7Xndpn/IjKDhm
	 GU+6Mw5jWiCekQKitG3Y16EPOLJtZUehmDKTDzr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <longli@microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 7.0 236/307] RDMA/mana: Validate rx_hash_key_len
Date: Tue, 12 May 2026 19:40:31 +0200
Message-ID: <20260512173945.102727186@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

commit 6dd2d4ad9c8429523b1c220c5132bd551c006425 upstream.

Sashiko points out that rx_hash_key_len comes from a uAPI structure and is
blindly passed to memcpy, allowing the userspace to trash kernel
memory. Bounds check it so the memcpy cannot overflow.

Cc: stable@vger.kernel.org
Fixes: 0266a177631d ("RDMA/mana_ib: Add a driver for Microsoft Azure Network Adapter")
Link: https://sashiko.dev/#/patchset/0-v2-1c49eeb88c48%2B91-rdma_udata_rep_jgg%40nvidia.com?part=1
Link: https://patch.msgid.link/r/4-v1-41f3135e5565+9d2-rdma_ai_fixes1_jgg@nvidia.com
Reviewed-by: Long Li <longli@microsoft.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/mana/qp.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/infiniband/hw/mana/qp.c
+++ b/drivers/infiniband/hw/mana/qp.c
@@ -21,6 +21,9 @@ static int mana_ib_cfg_vport_steering(st
 
 	gc = mdev_to_gc(dev);
 
+	if (rx_hash_key_len > sizeof(req->hashkey))
+		return -EINVAL;
+
 	req_buf_size = struct_size(req, indir_tab, MANA_INDIRECT_TABLE_DEF_SIZE);
 	req = kzalloc(req_buf_size, GFP_KERNEL);
 	if (!req)


