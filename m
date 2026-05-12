Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CE243C09F2;
	Tue, 12 May 2026 17:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608106; cv=none; b=g7pAm0oF4N2iUJwUHhhi0b4rX7IuwRzN5rXsLPhGR8d3DZBUqXIjiMVOVhmUVySQnVWAcozLyDcxdt2LPdTQnt2/EutPYAdLt36phc2zoi76GSEuaJ4xhZGPUAZoJycSF0g2RxTl3HinCiijkTnIGiu+1BrLuFcpWfBfsLv6mkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608106; c=relaxed/simple;
	bh=waDQCS6xOXmI2qPCLBdEaQfEw5rBYIHMFpKjFIwco2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lVMULiILA9lT537vLX9kaApiHGSns0j+3frt0c8XMXC3UzMpbewwxwIQ6Jjvpp13P81AGfdrc/w/qoTRQMOuQjbDJjWfa5oCYAn1OdZdv7BLk3Llva6jGok4ChDlBy8M+Ytv/1RIloo6O97Npi1AmpgGBG+qPWAMXSqHBeIYq6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rqk21C9f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rqk21C9f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F802C2BCFF;
	Tue, 12 May 2026 17:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608106;
	bh=waDQCS6xOXmI2qPCLBdEaQfEw5rBYIHMFpKjFIwco2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rqk21C9fYp6bd9iEW4mvEqghf0eI2QPZ3hCMPCs+2dyimoRNDUz9wUdYpgYNznLpz
	 d+xZfHN3m/cRhFNDd9OVHTzSWM/gwSfl4p1GN2YzWIcqCuoLOsiLyg1OX0z7r3NWQG
	 OYl6u20HNCSavMnE9Eay4zsbsml/cs3I5uaaPKxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <longli@microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.12 150/206] RDMA/mana: Validate rx_hash_key_len
Date: Tue, 12 May 2026 19:40:02 +0200
Message-ID: <20260512173936.039709541@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


