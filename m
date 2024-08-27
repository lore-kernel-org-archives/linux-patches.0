Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EFA21C6F49;
	Tue, 27 Aug 2024 15:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772357; cv=none; b=daUjdowcPVzEji3QamvRBCVByevMHFR+EMcovW+fyWbdN3fTvFLndnZG6f6iAUkMrGtA5yw37OEC5ZJ189Dsnm6ryS1hZi3RepViOnMkS8ExbZKsVGSy0GeEzlrVtiSGx/AzQK62TtPwXsGxvMKfsSBjqMS9ix1Dto8JInSjUNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772357; c=relaxed/simple;
	bh=i8TSW8Won1WFBCTEpZQwalgDy+DBvpkqIU6RX17hbpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lxif2t1coRvv2q+JJUDOhjvWuBGEVS2Tr6sGcZy+WJWV3T5J1DLfvrqcUA6nV74UB6jltc5831vIAPxTH5R9MDhlA4jsPjTIRcEvjXjX5wAljnhztOb+nzuTVa00pbTctW+Op1AVbZN4BnC+Gv4FkeadFyBDa8GO/tC7O+wh4+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RZkrYswM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RZkrYswM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F5BEC61071;
	Tue, 27 Aug 2024 15:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772357;
	bh=i8TSW8Won1WFBCTEpZQwalgDy+DBvpkqIU6RX17hbpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RZkrYswMxNr3ldhX9BvbBDOv33AzzKI0yYxOHkwYNRtuS2nG1jnXjMuRfXOmSWQtD
	 0EjPDMVto3l4d1kChv0nGfvokrrhX8tTy9/rBaSJ0EWYGgUN2lCfsyRNcWwXXLZur0
	 hV/RvJooC34cPkR5TSYIKvyAHUMrR+dFIrvNrm8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 190/321] Bluetooth: bnep: Fix out-of-bound access
Date: Tue, 27 Aug 2024 16:38:18 +0200
Message-ID: <20240827143845.463713931@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 0f0639b4d6f649338ce29c62da3ec0787fa08cd1 ]

This fixes attempting to access past ethhdr.h_source, although it seems
intentional to copy also the contents of h_proto this triggers
out-of-bound access problems with the likes of static analyzer, so this
instead just copy ETH_ALEN and then proceed to use put_unaligned to copy
h_proto separetely.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/bnep/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/bnep/core.c b/net/bluetooth/bnep/core.c
index 5a6a49885ab66..a660c428e2207 100644
--- a/net/bluetooth/bnep/core.c
+++ b/net/bluetooth/bnep/core.c
@@ -385,7 +385,8 @@ static int bnep_rx_frame(struct bnep_session *s, struct sk_buff *skb)
 
 	case BNEP_COMPRESSED_DST_ONLY:
 		__skb_put_data(nskb, skb_mac_header(skb), ETH_ALEN);
-		__skb_put_data(nskb, s->eh.h_source, ETH_ALEN + 2);
+		__skb_put_data(nskb, s->eh.h_source, ETH_ALEN);
+		put_unaligned(s->eh.h_proto, (__be16 *)__skb_put(nskb, 2));
 		break;
 
 	case BNEP_GENERAL:
-- 
2.43.0



