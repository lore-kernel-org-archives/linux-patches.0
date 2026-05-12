Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78E53EDE59;
	Tue, 12 May 2026 17:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608744; cv=none; b=Ms0v8u+WuhwhA+OSmCbqQI0phL8EO6lLU2oL463hzj/SDMQY3Ms7QeIIP6/xcIboFML5TW+zQpbuC4gDS7fSz6rIXOsc+PMi5A3fZ3USdsiKH5RffC5UqNrV3Ucltgh4eEPtwN6J86mwmv4u+FZFWD8J+9f7agB8SeVvWGcGuAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608744; c=relaxed/simple;
	bh=OIh/K190n4GVmguy9DtWKelBtYPZ7pC5XOUcLFMZ3oU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YkBJQv+lEHtaoeXClSuCNhl5uzigWGu+FWX8YsiGJKNGP5NyZxyVoVGBOmccJ7E5kT3W1K1eDx5RvQNVSjN0e5F7q2Pbo/AKhfn2ZTYtujdYinvacbRqLyAo2ytbIJMPPJ3HADK16eOqhKn3hN9DmhbKez7lYt/MEqynLpkVUPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zilHqfh1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zilHqfh1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E99AC2BCB0;
	Tue, 12 May 2026 17:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608744;
	bh=OIh/K190n4GVmguy9DtWKelBtYPZ7pC5XOUcLFMZ3oU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zilHqfh1JdQy1ywEn40/f7f4yKk3rcbL/JWWAGL30pDKedoF3icLjWBdEqFMTVX3z
	 2ai9NrWjDcUbfK9mBfFoB9+fXAi3vRbibFhE1Tj3ZZRCfstoEYgRElQvHtmpRbI0q9
	 S+FHRiJ7Cg7YHx21g3xVPIlcdYqIpMPLC1VFbJVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <longli@microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.18 197/270] RDMA/mana: Validate rx_hash_key_len
Date: Tue, 12 May 2026 19:39:58 +0200
Message-ID: <20260512173942.596761055@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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


