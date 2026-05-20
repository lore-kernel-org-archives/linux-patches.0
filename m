Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB142F0C62;
	Wed, 20 May 2026 16:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294527; cv=none; b=HWkl4jWrEGOkH5zDET1Nwf3tdycZeW0LbFnPGmSwv8FwQOWrT7QZC+ZLIHIMOKOOjGL26954N2zYMN8persWYuZ829RZBIbvpy7XbecBnz5u44NGKAzOnJWG7iKa1TfWQJrjPJdqKLwwW4WhuVHErTgXf/Ifqn8sBfOC1YQMW+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294527; c=relaxed/simple;
	bh=vWwJ0PCUkM5h8LsECNlNhXgFhG5MURo67x3fGBiX+lo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uKVjMcG5MYpwLecEkFOkbN68ernKgMZgjGc/wt4L650OhnAJlv+XFs4wG1u4rv9rcuPE19FuL/0MGtfnlm+Y2IgNW8k51uLiY0Wb1UC3rrY0Q39hgTLwWOFucjJaFScLqMNzrlVLghYetbVgupl/WSvOhG9YHAXnv4KOgtV3mXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ix1zhbHU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ix1zhbHU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD05C1F00893;
	Wed, 20 May 2026 16:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294524;
	bh=IhrvCV5V+TS+gqYOR6V9Q/t5Bfqs5r6zcrxFvLn11CA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ix1zhbHUbfZgCD/odv70F8Sok9SXtOImt68AehLy5VZwBJAYMiuRxSRmCQePN/1Ci
	 2izsg70urEQnc4b+rifJsc3MD2YzHzqe9hn2rn28eZsKK2by+WiNk1t5thZMurOIkc
	 e+MvfE/lV5J4UdY6g81a2rzvy9tYV2DKgQs/lJzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Jeff Chen <jeff.chen_1@nxp.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0071/1146] wifi: mwifiex: Fix memory leak in mwifiex_11n_aggregate_pkt()
Date: Wed, 20 May 2026 18:05:21 +0200
Message-ID: <20260520162149.964208060@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 34b4b34276d6d..042b1fe5f0d67 100644
--- a/drivers/net/wireless/marvell/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/marvell/mwifiex/11n_aggr.c
@@ -203,6 +203,7 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 
 		if (!mwifiex_is_ralist_valid(priv, pra_list, ptrindex)) {
 			spin_unlock_bh(&priv->wmm.ra_list_spinlock);
+			mwifiex_write_data_complete(adapter, skb_aggr, 1, -1);
 			return -1;
 		}
 
-- 
2.53.0



