Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9140B257851;
	Mon, 23 Mar 2026 16:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282253; cv=none; b=pNw+y668flSG9tIsn93EWW6tc9ZiEtaWLh1u8SyNZ7DLjBjtxwew/sEPg9P1anMH7Dg17hom3qCwM5qh929iYhBSO+cKslvXzfvHIbDJ3qnDoLyk/Mrddt2O/JD5z8lX/8xGpwxwWMt726FOXXaOPk6cW6JvXaYnXo8VLUKTXoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282253; c=relaxed/simple;
	bh=k5zT8rjWaaHhMY5H4q6SnbPvgDumUYfrAOpxICaQgdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YS7MG6X392Qmousf4+nHzeBdhJFgJbLCForZ7fAfxiTFhz1E12pxwsl8nUjPtuYCf5xJQsrhoLaJvcQUf4VY6T4H891zQmEQhCv8c1Igzp4QQiY1Iz4M4xWe30YMcRla5OL3o33hQZnCODIyWZm7uvBrge9iQAySdw6i/1NIOFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WmgBrzPU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WmgBrzPU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22419C2BC9E;
	Mon, 23 Mar 2026 16:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282253;
	bh=k5zT8rjWaaHhMY5H4q6SnbPvgDumUYfrAOpxICaQgdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WmgBrzPUD1gCuSeTG+T4CqmKtsaMDiuV9mH2W4jRomm2++c0igQzV1wZqT5wLHyCJ
	 vaj0hmaw1RpmTxrvRIdJW6nzPFolJIUMXzq5FYe9S9buq0aUuV2903kpv4nWHKi/KX
	 GUKQBoh2IomYe3Bs1chpAr63dn+sowtAfj1Q39MI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 6.1 086/481] RDMA/irdma: Fix kernel stack leak in irdma_create_user_ah()
Date: Mon, 23 Mar 2026 14:41:08 +0100
Message-ID: <20260323134527.362364874@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

commit 74586c6da9ea222a61c98394f2fc0a604748438c upstream.

struct irdma_create_ah_resp {  // 8 bytes, no padding
    __u32 ah_id;               // offset 0 - SET (uresp.ah_id = ah->sc_ah.ah_info.ah_idx)
    __u8  rsvd[4];             // offset 4 - NEVER SET <- LEAK
};

rsvd[4]: 4 bytes of stack memory leaked unconditionally. Only ah_id is assigned before ib_respond_udata().

The reserved members of the structure were not zeroed.

Cc: stable@vger.kernel.org
Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://patch.msgid.link/3-v1-83e918d69e73+a9-rdma_udata_rc_jgg@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/irdma/verbs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -4338,7 +4338,7 @@ static int irdma_create_user_ah(struct i
 #define IRDMA_CREATE_AH_MIN_RESP_LEN offsetofend(struct irdma_create_ah_resp, rsvd)
 	struct irdma_ah *ah = container_of(ibah, struct irdma_ah, ibah);
 	struct irdma_device *iwdev = to_iwdev(ibah->pd->device);
-	struct irdma_create_ah_resp uresp;
+	struct irdma_create_ah_resp uresp = {};
 	struct irdma_ah *parent_ah;
 	int err;
 


