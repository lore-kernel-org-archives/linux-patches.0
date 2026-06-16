Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA1047D929;
	Tue, 16 Jun 2026 18:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636243; cv=none; b=ff4IGIAxaM1Q+itrG/40WRS5fQOovTrf9bKzIbC/qbN/6gRKY5XG+WXJTm6vX1quUhbOTXxHrLyqJvglcw3A/c4EYI0WNFh91uuZw8esZYO5VWsPrHQjPupqBR+wj3tXdwwrYbsjwTBGOUkpnE8cE7WqIhlZuomYDAco7DNMnGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636243; c=relaxed/simple;
	bh=KEyVN9oOMXigMz/+oiTPZv4gZK2pJO9R6wKKg55S84Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FZacyF0NekvpjU1DnrjHQtTDLMoU91CQyWxbB+BVLmkgK9XLCMc73H7Hdpx29KaweF6qdcBffgQjjzEjRoC+3CqR0H/Mlm7elfifFQ3+1IpawtKsUhVSL+BN0+ZOUQvsK9N7bUENgjWJmoNSHBjY+e/uSk8PXEiUI3gF6QJE8+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H0mQxzlI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H0mQxzlI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87CD81F000E9;
	Tue, 16 Jun 2026 18:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636242;
	bh=xPXOc6onNbJdavYNwFCcyvSatHrq0aNQ0Dw0bI6Py0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H0mQxzlIv2R4M5JVFaziiduNLYLfnv2nWCFjeL1bKoI7qjs2MwzBHhbtPBycwRJu6
	 4ZAD5l26cVz7QZU1oPbqL7s4xC/RHKthtAjd8k0Am0ePq1f1p9pG63nKfnjeOeaxku
	 vwy1phcqIMTI7tUceRSfjThZN1jUXhYMzGfABVUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yuan Tan <yuantan098@gmail.com>,
	Zhengchuan Liang <zcliangcn@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Yuqi Xu <xuyq21@lenovo.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 202/342] net: rds: clear i_sends on setup unwind
Date: Tue, 16 Jun 2026 20:28:18 +0530
Message-ID: <20260616145057.600152381@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuqi Xu <xuyq21@lenovo.com>

commit 20cf0fb715c41111469577e85e35d15f099473e0 upstream.

The RDS IB connection teardown path is written so it can run during
partial startup and on repeated shutdown attempts. It uses NULL
pointers to distinguish resources that are still owned from resources
that have already been released.

When rds_ib_setup_qp() fails after allocating i_sends but before
allocating i_recvs, the sends_out path frees i_sends without clearing
the pointer. A later shutdown pass can still treat that stale pointer
as a live send ring allocation.

Clear i_sends after vfree() in the error unwind path so the existing
shutdown logic continues to use the correct ownership state.

Fixes: 3b12f73a5c29 ("rds: ib: add error handle")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Zhengchuan Liang <zcliangcn@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Yuqi Xu <xuyq21@lenovo.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Reviewed-by: Allison Henderson <achender@kernel.org>
Link: https://patch.msgid.link/5a0f7624bb9845a7b67d26166a150b59e7f394ce.1779632468.git.xuyq21@lenovo.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rds/ib_cm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -690,6 +690,7 @@ static int rds_ib_setup_qp(struct rds_co
 
 sends_out:
 	vfree(ic->i_sends);
+	ic->i_sends = NULL;
 
 ack_dma_out:
 	rds_dma_hdr_free(rds_ibdev->dev, ic->i_ack, ic->i_ack_dma,


