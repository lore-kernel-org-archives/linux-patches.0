Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A2246D55E;
	Tue, 21 Jul 2026 15:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648676; cv=none; b=G6K3+oGbxlJwyVMoPOVUHAJ5wahI2hjJ5AlI7WVvBFV4EjY1qbBhXO6/y1eMANXH/MGty44t6QVfwPwqVvAztmCdjhdVyCA162/ANmoCCcuu/L3XrjfGVLY318pyfTy5LY5Lz+tXFEa3sv8EPxKoABf0WkuvAMyP37FuCig/PTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648676; c=relaxed/simple;
	bh=LQzNTnKlZ/0gD9eZpacGJL0PgvAfConj34eRW2fYLtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M7SjRXYIYBFjMvwqDlnemb4Tm+rCfkUf7TOvUQPSRxw9uZ8XW1hc3ovNbLa94AvEQvuqAW/1AJYSLtFWEpw0pBw3B89Q11Jj9VTpUErcVQk9VDGyCkoCREmfFYYPRNdglDzbmZJzc1J6J4rMEyVCsic5umqaDUropUpYXD+9arI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lZxksdg7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lZxksdg7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C7DA1F00A3A;
	Tue, 21 Jul 2026 15:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648674;
	bh=cF9CDcG3LTvv5bu0sPqz0N5h8qv2dVOlgK87wLcT7MM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lZxksdg7AzjYWyVssJXZI8A3AKcmODgnaMJ6cnYdbq8J8amArU1urpSBxsw+wLEFV
	 utXYE8M2Gx8YdeedoTTS6ZnUTn1WAmmBmrrn7nb+9YixmSZt1mVi+hUZ0LOTWtg+Op
	 0+UQdOLkslcZCoNhU7kQL+CmCKbHnURLIHmA76bM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiraz Saleem <shirazsaleem@microsoft.com>,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0289/2077] RDMA/mana_ib: Use ib_get_eth_speed for reporting port speed
Date: Tue, 21 Jul 2026 16:59:22 +0200
Message-ID: <20260721152559.495255605@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shiraz Saleem <shirazsaleem@microsoft.com>

[ Upstream commit d28654518c8db5d06d27bd3211c0e9a70c18f7c2 ]

Replace hardcoded IB_WIDTH_4X/IB_SPEED_EDR with ib_get_eth_speed()
to report the actual link speed in mana_ib_query_port().

Fixes: 4bda1d5332ec ("RDMA/mana_ib: Implement port parameters")
Link: https://patch.msgid.link/r/20260512094056.264827-1-kotaranov@linux.microsoft.com
Signed-off-by: Shiraz Saleem <shirazsaleem@microsoft.com>
Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mana/main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mana/main.c b/drivers/infiniband/hw/mana/main.c
index afc2fc124fee30..307ae01bf26f34 100644
--- a/drivers/infiniband/hw/mana/main.c
+++ b/drivers/infiniband/hw/mana/main.c
@@ -600,8 +600,7 @@ int mana_ib_query_port(struct ib_device *ibdev, u32 port,
 		props->phys_state = IB_PORT_PHYS_STATE_DISABLED;
 	}
 
-	props->active_width = IB_WIDTH_4X;
-	props->active_speed = IB_SPEED_EDR;
+	ib_get_eth_speed(ibdev, port, &props->active_speed, &props->active_width);
 	props->pkey_tbl_len = 1;
 	if (mana_ib_is_rnic(dev)) {
 		props->gid_tbl_len = 16;
-- 
2.53.0



