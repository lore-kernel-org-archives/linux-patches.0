Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5FA2363C50;
	Tue,  6 Jan 2026 17:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721834; cv=none; b=KcU9ejkI+/2qhhPwPAeC607AZNBzOL80Uj9E1/6QX13rgEHHsLYht90z0TTSFi1RZbzwd0qO5i5gwuqrLCHiWPNwJz1fjbLgWYwSwyVv8guS3wlli0Ok8kemY83NftqsWqgal8NhIp1R2XfVrZTWCUp/8sXu2mzoggY+5sLUBz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721834; c=relaxed/simple;
	bh=OxlhnbOmN8u0vbqZrSsbJc4uT1QpiWJ//kMeMvOSSs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gV497GVLcQuu9TCRDssvl6tldrIlgnBycUl3tMd4rqZCgZjF8qIMeGG2TgdZAYCmrYDU2FvO1L84oNlT1UDLQHsRs8zRRFbJNe75hJJrNgDp+WaLftYBIeI0yabhk1Q7Byz89bFpFvBug6DFHw3pRqV0MXgaPgCL4RMhNZyaico=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bXbfn7F9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bXbfn7F9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A94FC116C6;
	Tue,  6 Jan 2026 17:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721833;
	bh=OxlhnbOmN8u0vbqZrSsbJc4uT1QpiWJ//kMeMvOSSs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bXbfn7F9yls6xf6RnyYVnEOE/wYII1hSApJZNHeuqvf2yWjWNlFq9vAWl6xCrkGQT
	 1+7LqgL3zNJ2xlr7SWFM9adLcfIqY1+iTQEGpJ/B54wwyrwtcn8xQf4+sxELkq5II2
	 Q8VGTd+fFSaZUkBMXBKzzbSbOwZQNmKEuAsEoIxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Zhijian <lizhijian@fujitsu.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 084/312] IB/rxe: Fix missing umem_odp->umem_mutex unlock on error path
Date: Tue,  6 Jan 2026 18:02:38 +0100
Message-ID: <20260106170550.878405946@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Li Zhijian <lizhijian@fujitsu.com>

[ Upstream commit 3c68cf68233e556e0102f45b69f7448908dc1f44 ]

rxe_odp_map_range_and_lock() must release umem_odp->umem_mutex when an
error occurs, including cases where rxe_check_pagefault() fails.

Fixes: 2fae67ab63db ("RDMA/rxe: Add support for Send/Recv/Write/Read with ODP")
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
Link: https://patch.msgid.link/20251226094112.3042583-1-lizhijian@fujitsu.com
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_odp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_odp.c b/drivers/infiniband/sw/rxe/rxe_odp.c
index f58e3ec6252f..4d4e3b324dd2 100644
--- a/drivers/infiniband/sw/rxe/rxe_odp.c
+++ b/drivers/infiniband/sw/rxe/rxe_odp.c
@@ -179,8 +179,10 @@ static int rxe_odp_map_range_and_lock(struct rxe_mr *mr, u64 iova, int length, u
 			return err;
 
 		need_fault = rxe_check_pagefault(umem_odp, iova, length);
-		if (need_fault)
+		if (need_fault) {
+			mutex_unlock(&umem_odp->umem_mutex);
 			return -EFAULT;
+		}
 	}
 
 	return 0;
-- 
2.51.0



