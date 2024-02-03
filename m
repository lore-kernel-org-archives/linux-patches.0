Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D41831C6A6;
	Sat,  3 Feb 2024 04:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933833; cv=none; b=ljaZ88lIHBRDkS8xtEPQ3x5AfcWFBji19hPN9Pbi50wSrq9n4EaFNnRucHyDIi92ERLszD2KR8tnRVuU1W9c9IhoU75n+jg22HKuPue5keJFaCVgIXwhs6CI+RRx12G2+LBEuf/k6+E2bX3ufMUC6wMEcX5YihAawbaZB2dZ9Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933833; c=relaxed/simple;
	bh=Hy+o41DHp8BKmssljAIhmiBCPhF32Lje/6dhCzCUmvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O89O/rCbJE7nVDT2amZfpRv9spcZBNlbbJB5X6Kep4KuyBX+JepZtE353WGQZisCxCa6kEbCqgdSxhh1JQ1aOVtAS6wsKoiIdZ8P7qUsrUnHayzG+wvQ85Vpxfmz5vZuY80xbcL83H5LUSkwiaRYlgbjLtTOUejUEfcc1pCXKvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bk3wUFpi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bk3wUFpi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D737C433C7;
	Sat,  3 Feb 2024 04:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933833;
	bh=Hy+o41DHp8BKmssljAIhmiBCPhF32Lje/6dhCzCUmvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bk3wUFpiYAwDJiHLxnhD23+5MuJuaSXFnscSbY6vcb3Ks4EA8F/gSPaP4PoJf0eHh
	 6ITR+BpNYeBw++YTb1ss5gFVPr39DvbCIqhWStj23vZDIc3M49OngoxIboKFc3A6oE
	 9yI9aFQ15l0dZ/fZTrTbx+bGQFCisvTohUkpbDnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mina Almasry <almasrymina@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 158/353] net: kcm: fix direct access to bv_len
Date: Fri,  2 Feb 2024 20:04:36 -0800
Message-ID: <20240203035408.650105687@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mina Almasry <almasrymina@google.com>

[ Upstream commit b15a4cfe100b9acd097d3ae7052448bd1cdc2a3b ]

Minor fix for kcm: code wanting to access the fields inside an skb
frag should use the skb_frag_*() helpers, instead of accessing the
fields directly.

Signed-off-by: Mina Almasry <almasrymina@google.com>
Link: https://lore.kernel.org/r/20240102205959.794513-1-almasrymina@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/kcm/kcmsock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index 65d1f6755f98..1184d40167b8 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -634,7 +634,7 @@ static int kcm_write_msgs(struct kcm_sock *kcm)
 
 		msize = 0;
 		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++)
-			msize += skb_shinfo(skb)->frags[i].bv_len;
+			msize += skb_frag_size(&skb_shinfo(skb)->frags[i]);
 
 		iov_iter_bvec(&msg.msg_iter, ITER_SOURCE,
 			      skb_shinfo(skb)->frags, skb_shinfo(skb)->nr_frags,
-- 
2.43.0



