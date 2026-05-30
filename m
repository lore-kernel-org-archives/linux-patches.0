Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0B9DEEA8;
	Sat, 30 May 2026 18:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164016; cv=none; b=dWfTfF3Ii2z/2+UhajWx4vVF34P1RrsUr0vcBgzRzewbtmC5uQmNJCicNM96LmQ6uQes5zZ+O+LCO5cFLoXwIB8rBmHO9/UlIVRioMmlouhRZa6mJ1A/M+ilsxcu31iBz8Mfu02tiePl3IFsLBhNOssiKK1N9vFNvi2OmULkLXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164016; c=relaxed/simple;
	bh=faJ4o/8faIzsLn4e6UXL1BYpmSLioLcBbkFf/0cfOSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BzQejC16Xinj7eO9bXkR2xVHYrcTg/07u83WsqUsD5KotejzUEbF7EPrTvttsRScb5saY03QRsZjS/ff6UBDaQIlDZL2B1IJaQu5ByMG+6NbjnZFziTrOyicvYPsKIJCzUnIByTNXWT7sOhGXe5otEUpjaKVZ9qUYb2JcjU2R8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ff6ByeYJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ff6ByeYJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E4CB1F00893;
	Sat, 30 May 2026 18:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164015;
	bh=qGPJABBVveDH7tA9Qh9wcYttuTtISFtjT372JhSgHQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ff6ByeYJu24HN3Cf88rNRNjFzI5mdnmB0ZJlAFflQpYfBXQyOuoCz2rLkkWnNgOwY
	 j51SB0CBwhL6z1NBGx/U0nqfPuLb3HR0lJnl+4KNPwxf3QXDhGMLDWHcH1zXeFpO9c
	 waPCIxBK/yxFBURlwlg4+Jh7crNejwdX69DnxAw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Jeff Chen <jeff.chen_1@nxp.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 395/776] wifi: mwifiex: Fix memory leak in mwifiex_11n_aggregate_pkt()
Date: Sat, 30 May 2026 18:01:49 +0200
Message-ID: <20260530160250.697996783@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 990a73dec3fdc145fef6c827c29205437d533ece ]

In mwifiex_11n_aggregate_pkt(), skb_aggr is allocated via
mwifiex_alloc_dma_align_buf(). If mwifiex_is_ralist_valid() returns false,
the function currently returns -1 immediately without freeing the
previously allocated skb_aggr, causing a memory leak.

Since skb_aggr has not yet been queued via skb_queue_tail(), no other
references to this memory exist. Therefore, it has to be freed locally
before returning the error.

Fix this by calling mwifiex_write_data_complete() to free skb_aggr before
returning the error status.

Compile tested only. Issue found using a prototype static analysis tool
and code review.

Fixes: 5e6e3a92b9a4 ("wireless: mwifiex: initial commit for Marvell mwifiex driver")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Reviewed-by: Jeff Chen <jeff.chen_1@nxp.com>
Link: https://patch.msgid.link/20260119092625.1349934-1-zilin@seu.edu.cn
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/11n_aggr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/11n_aggr.c b/drivers/net/wireless/marvell/mwifiex/11n_aggr.c
index 46f41dbcf30dd..54662bc5bc152 100644
--- a/drivers/net/wireless/marvell/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/marvell/mwifiex/11n_aggr.c
@@ -215,6 +215,7 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 
 		if (!mwifiex_is_ralist_valid(priv, pra_list, ptrindex)) {
 			spin_unlock_bh(&priv->wmm.ra_list_spinlock);
+			mwifiex_write_data_complete(adapter, skb_aggr, 1, -1);
 			return -1;
 		}
 
-- 
2.53.0



