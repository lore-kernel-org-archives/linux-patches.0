Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A1E372B57;
	Tue, 21 Jul 2026 17:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653974; cv=none; b=Vxhx49faYJPjHFpEBkjb7W/ZJrpMhg4wYHSCTgGTg+Oqacif5D2lLJjAOh2PQbvNACp21fk3TJb+R7SltrMRZeewQS3Z7pqhARze/5h8TIoeUJf5p87/KyBGgRZqRj5YSgnJS5G7+CWo9bP8Wfcx9AUmi8y9tda1UEpb2vD12kI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653974; c=relaxed/simple;
	bh=O/GK+T4KIzC+4rXpxY1vdJ8fh/TYFvEugdq+/YJQgdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bJLrkBhsGOkXphpozQ7/77b6d90Mo4t5cfZ6gUYReXQoITWeupFXgoELn+axcQ3Xjm2y35/NSHPsSsdyrMtDfNSBYuE4yrg8J1H7o/QI47DD6EhQIeRMISj5MtyjNAidkfk7CaBijVuz/eNA/XsFbn+iB9RV3u/gxEp3YNgM2SU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RMW5XEZp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RMW5XEZp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88E531F00A3A;
	Tue, 21 Jul 2026 17:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653973;
	bh=+o+jyVtx4CUvnL/C3S7dJCm3nFYNgysLYIbdVPOKHrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RMW5XEZpnnhwLZttIbyP4OayfLWlkqdatZAi4xMgC+CH8KGWTsCqHJXM6Fl6tJd1v
	 HVtYecGnF2YY9VL+7lw1Iy4IcJ2eqox+3Wpxdj14rBay71/6pBir0A9+9wKepBZ05z
	 8bAPgovXb+C7cDEu1Humj7zotOI8KpTATn7GPdlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Tan <yuantan098@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Yong Wang <edragain@163.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 1530/2077] net: ife: require ETH_HLEN to be pullable in ife_decode()
Date: Tue, 21 Jul 2026 17:20:03 +0200
Message-ID: <20260721152628.867698259@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yong Wang <edragain@163.com>

commit 9406f6012b7343661efb516a11c62d4db2b62f75 upstream.

ife decode may return after making only the outer IFE header and
metadata pullable. The caller then passes the decapsulated packet to
eth_type_trans(), which expects the inner Ethernet header to be
accessible from the linear data area.

With a malformed IFE frame, the inner Ethernet header may still be
shorter than ETH_HLEN in the linear area, which can lead to a crash in
the original code.

Fix this by extending the pull check in ife_decode() so that the inner
Ethernet header is also guaranteed to be pullable before returning.

Fixes: ef6980b6becb ("introduce IFE action")
Cc: stable@vger.kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Yong Wang <edragain@163.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Link: https://patch.msgid.link/20260610183814.1648888-2-n05ec@lzu.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ife/ife.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ife/ife.c
+++ b/net/ife/ife.c
@@ -79,7 +79,7 @@ void *ife_decode(struct sk_buff *skb, u1
 	if (unlikely(ifehdrln < 2))
 		return NULL;
 
-	if (unlikely(!pskb_may_pull(skb, total_pull)))
+	if (unlikely(!pskb_may_pull(skb, total_pull + ETH_HLEN)))
 		return NULL;
 
 	ifehdr = (struct ifeheadr *)(skb->data + skb->dev->hard_header_len);


