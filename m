Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B689F14389A;
	Tue, 23 Apr 2024 21:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908502; cv=none; b=Ztd99W74qEsz3jtO/i/u2xAAh4AEEcgsqjPz5mK17xn2yK3byEBedbNuSXOuPD6mbnstcw3cBF9i0MaRKlDj6hd3VUbw4V7+wi51+Lqs4DDK5zhDBNjtwN3nSkRyF8Y38J3tZZr3WZHT8ckJPiszvAOHUEnc41/UIPpI4n5zKho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908502; c=relaxed/simple;
	bh=tNSMIfPsOu72mx+ZFdCy4vtyG7lfD5C3w6yCrqFMQJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PtUk7tGz91P5ILDMPd5Q1g3yltFu5meWNcY7QHKnUuuch/gAAHzLdgNTL1Q84J9lscla5hiyIrCxuQe4y7ccz4pBJzGbe/pRyaSxzRJIeei8vqCIiMTXQutVmhHnddwF3jq1gQDMcF0jyNessjK+sVqZJ1iiTLGG2fxM2apiVQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bBsdw/mc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bBsdw/mc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 830A5C32782;
	Tue, 23 Apr 2024 21:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908502;
	bh=tNSMIfPsOu72mx+ZFdCy4vtyG7lfD5C3w6yCrqFMQJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bBsdw/mczPmjrWI0yqcOAEgfdVf9xEmIGv6umEfFRzBFP4YcVBaX3DQgkdLVoL7dW
	 UZyL91tpu/M5Fb6qNL8470kaZIppje7zvfeFCnul5YWafZUjRnKqzLxolMGcJMmE6I
	 MZ8XzGizb5P60YIwn+L8OaxzPLhHeF/dRH8FUEcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Yanjun.Zhu" <yanjun.zhu@linux.dev>,
	Daisuke Matsuda <matsuda-daisuke@fujitsu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 055/158] RDMA/rxe: Fix the problem "mutex_destroy missing"
Date: Tue, 23 Apr 2024 14:37:57 -0700
Message-ID: <20240423213857.718738067@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yanjun.Zhu <yanjun.zhu@linux.dev>

[ Upstream commit 481047d7e8391d3842ae59025806531cdad710d9 ]

When a mutex lock is not used any more, the function mutex_destroy
should be called to mark the mutex lock uninitialized.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Signed-off-by: Yanjun.Zhu <yanjun.zhu@linux.dev>
Link: https://lore.kernel.org/r/20240314065140.27468-1-yanjun.zhu@linux.dev
Reviewed-by: Daisuke Matsuda <matsuda-daisuke@fujitsu.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe.c b/drivers/infiniband/sw/rxe/rxe.c
index 54c723a6eddac..6f9ec8db014c7 100644
--- a/drivers/infiniband/sw/rxe/rxe.c
+++ b/drivers/infiniband/sw/rxe/rxe.c
@@ -33,6 +33,8 @@ void rxe_dealloc(struct ib_device *ib_dev)
 
 	if (rxe->tfm)
 		crypto_free_shash(rxe->tfm);
+
+	mutex_destroy(&rxe->usdev_lock);
 }
 
 /* initialize rxe device parameters */
-- 
2.43.0



