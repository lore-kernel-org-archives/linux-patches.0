Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19548143C6C;
	Tue, 23 Apr 2024 21:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908799; cv=none; b=JAw9Ib5IYgAEgnh9RrL8kEW2HyGZTcDaI0mYhq1uqdiPblpaszbq2hndy6a51xC9rbcHRcZxxPMo0DzbHb/FW1Jbs2kAop9Kkp3MptAlW3f55BJClb9hkvAcBvk+/TyIFdtxYP+gR7OdnDCqVSP/eWyVpd2DGtlMbAZXXHme6Ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908799; c=relaxed/simple;
	bh=8hJtWrjgA1EvxzcgbwAnKfiWTOk+PZsANhxTtpx5I3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ReTSEKaHrI0+yavURJmZoNqAt2zEK/VKYctl2JxBJl2Q/CVMeGxlIdcv2QQvWTow5AMW8ABOw6NH+9L2jeul3r75E8XKHiPT0ruQGaZgEbHzo0L6LkoAAd5ZauCtCV95j30vHePrymifT/iwfkWkjMSGVSEThv9M9h/oS0MEo3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qDT3VCgU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qDT3VCgU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D118BC3277B;
	Tue, 23 Apr 2024 21:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908798;
	bh=8hJtWrjgA1EvxzcgbwAnKfiWTOk+PZsANhxTtpx5I3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qDT3VCgU8KXRi9KFnWBXY0OgJCTh/Wg4KZXmvq/RKk/Q145aZWSq3BWFqyB23vSYn
	 0EHSGOhvu8p6PxDk6dcC3gr6O0lAIa6FwiUnUiuvrWhH0hW44tbpKsjU7JzJZAYZug
	 qjR97FNPdffoooAhC3ZJNCfMkTZP9et/8EYc9/wY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Yanjun.Zhu" <yanjun.zhu@linux.dev>,
	Daisuke Matsuda <matsuda-daisuke@fujitsu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 27/71] RDMA/rxe: Fix the problem "mutex_destroy missing"
Date: Tue, 23 Apr 2024 14:39:40 -0700
Message-ID: <20240423213845.084317185@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213844.122920086@linuxfoundation.org>
References: <20240423213844.122920086@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8e0f9c489cab2..f6ef782ce75c1 100644
--- a/drivers/infiniband/sw/rxe/rxe.c
+++ b/drivers/infiniband/sw/rxe/rxe.c
@@ -35,6 +35,8 @@ void rxe_dealloc(struct ib_device *ib_dev)
 
 	if (rxe->tfm)
 		crypto_free_shash(rxe->tfm);
+
+	mutex_destroy(&rxe->usdev_lock);
 }
 
 /* initialize rxe device parameters */
-- 
2.43.0



