Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 256D5335931;
	Wed, 17 Sep 2025 12:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113951; cv=none; b=p74D1UYkspTrpNSHuJTew+ZRPyMEKRDSjyAEuWujootEpfYld+3nqpiiykw1WYup4FkH2cAGwIbUShbpovpSDRxnFIZqjxC3/wpB/N2rUmAjup+KtOf5mHe0YRzpcO79gS9AyreP4BlMgXlcPReQk/MmDRiytBWYBwQFF9TG4/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113951; c=relaxed/simple;
	bh=wxZ0xA/rzyp3A+tiMcQBmWSOjkDc6Rx7M2Hp02SRReI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bfQ40sN7bqgcwb+7ZIysp9P5zOqS2VLcXxui2OuxLMjuAf0gjqoaDJboAwZbRc93f6fuoZ22s3uZoAaAfDqcCiMjY/LMRaMq2gjS2BQRum9jul93X7xZVDB+0ktGDlQOBzUSpCRsOmrOX5e23Ue8+FnPdU2+dJ2KCB3wje8COik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l4O1lWlw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l4O1lWlw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D0B6C4CEF7;
	Wed, 17 Sep 2025 12:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113950;
	bh=wxZ0xA/rzyp3A+tiMcQBmWSOjkDc6Rx7M2Hp02SRReI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l4O1lWlwkQLenFOqyn7d7EWPpb6Vwrodn/XXRJLEFsUh80mFQ/zeRSyDReX8Dkcrg
	 v0LMFVkXjyO/At/FTArI+PvBmoZUMRGs/lPzAMcFYhi0SzNnK4YDdLX3zTdZDC3aA8
	 D7OoGbhPVi0r+Sx921vOSUueMLaeQk98UQNmYkWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 069/101] net: bridge: Bounce invalid boolopts
Date: Wed, 17 Sep 2025 14:34:52 +0200
Message-ID: <20250917123338.508670635@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Machata <petrm@nvidia.com>

[ Upstream commit 8625f5748fea960d2af4f3c3e9891ee8f6f80906 ]

The bridge driver currently tolerates options that it does not recognize.
Instead, it should bounce them.

Fixes: a428afe82f98 ("net: bridge: add support for user-controlled bool options")
Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/e6fdca3b5a8d54183fbda075daffef38bdd7ddce.1757070067.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/bridge/br.c b/net/bridge/br.c
index a6e94ceb7c9a0..a45db67197226 100644
--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -312,6 +312,13 @@ int br_boolopt_multi_toggle(struct net_bridge *br,
 	int err = 0;
 	int opt_id;
 
+	opt_id = find_next_bit(&bitmap, BITS_PER_LONG, BR_BOOLOPT_MAX);
+	if (opt_id != BITS_PER_LONG) {
+		NL_SET_ERR_MSG_FMT_MOD(extack, "Unknown boolean option %d",
+				       opt_id);
+		return -EINVAL;
+	}
+
 	for_each_set_bit(opt_id, &bitmap, BR_BOOLOPT_MAX) {
 		bool on = !!(bm->optval & BIT(opt_id));
 
-- 
2.51.0



