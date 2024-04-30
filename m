Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B062712C805;
	Tue, 30 Apr 2024 11:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476072; cv=none; b=jMt332CS2Qs/59nKKYZVt1km10Ed5f0f4u5W5wq/J5TgdQStOdecePlBc9mrSKycC1bJ2zfbxN2aSeuOwAjWr9qRvUjtQYrs2T4Gjd6AbtfHaVt6TyRxgNEg3Njq4ZV+UN0h+qiN3/2WMosroKy+noVY6/kUEg7Gbb3yjte+8yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476072; c=relaxed/simple;
	bh=HgDv0P8AmDCURZVOXaHoHvBN6qb9mzqXOTO0x/llzZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kga30tdwADz8h5lVh3qqRroQZ+6dnR73yAMdMTdXC0L4iOX10Gz8P7WwemIlvNxw4V8XsTTJwbNHkm6wW4MiFoADTSFQqYt3mDXtBrTkfi+fhpuz4wL8/Bet2d8c6NRl6uOXY+1NvsXVcmbh0K0IxC5ngHTI+f73KStaSb/+Gx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bhAJQTPn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bhAJQTPn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00DA7C2BBFC;
	Tue, 30 Apr 2024 11:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476072;
	bh=HgDv0P8AmDCURZVOXaHoHvBN6qb9mzqXOTO0x/llzZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bhAJQTPnO7UX02wbDOmbKwBDom9EQiyJJcPiZlY/Q3AjOktR5SoGNc7LsdkS+xNct
	 TDbC20aUsMP9ALhuCN9a7nheho8TKLhI9T08xoR9QML+frAPyZZZ0qrYnXqBWFmtFW
	 Dm52RLVucLAp85RfzFfK9LlTiJ+N4ZgpVL6cjUtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Yanjun.Zhu" <yanjun.zhu@linux.dev>,
	Daisuke Matsuda <matsuda-daisuke@fujitsu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 025/107] RDMA/rxe: Fix the problem "mutex_destroy missing"
Date: Tue, 30 Apr 2024 12:39:45 +0200
Message-ID: <20240430103045.406374741@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103044.655968143@linuxfoundation.org>
References: <20240430103044.655968143@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index de5f3efe9fcb4..76e103ef5be31 100644
--- a/drivers/infiniband/sw/rxe/rxe.c
+++ b/drivers/infiniband/sw/rxe/rxe.c
@@ -72,6 +72,8 @@ void rxe_dealloc(struct ib_device *ib_dev)
 
 	if (rxe->tfm)
 		crypto_free_shash(rxe->tfm);
+
+	mutex_destroy(&rxe->usdev_lock);
 }
 
 /* initialize rxe device parameters */
-- 
2.43.0



