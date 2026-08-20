Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF07537A858;
	Thu, 20 Aug 2026 16:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244330; cv=none; b=ZX2zltQ4okygKfDpI77zItoy9qjF2zx678WWqWjZQ8ezPJX48I4oPYv8mxLpoxSw8NbtLJjcSU0J20YOR6NXh9SON47dWP3W/VrKPM1JTv7HbGfo//qjAuJ02EEmc7ECxoEJq8Y4I4DoqXwFG4yEOK3Auu9DVidK64LZDc40jU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244330; c=relaxed/simple;
	bh=2EVCZb1UFZhGHRWmmIDeBwsrZ4xcalNr7CRMqRnCFms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r+tOQmGqxL5eivTF9dyeP0/Ok0S7vJjaY3kd5MVvjaF6f+W0QqhrjagSm/Q/UgRNSPTZmJbm5FftvATq6mtwq4r3N+UL4hzM+y9hb8ntdie+2ZlbleJL6Pk25Jhrv/cpPrOIwLOKPV8mgUBKpY19wYr+6p+x7BpnMr/Nin9jOMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WWPuthQi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WWPuthQi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 204BF1F000E9;
	Thu, 20 Aug 2026 16:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244328;
	bh=+k0VyuZ1Yv5RFgX+vBu5YxMQUMcOKE+/RluJlqDf+Ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WWPuthQisgFpTiqPW1mAg07wMgDkKKVzebgsWR4tAVIdrKY71hVqWD0C2evWX7yNW
	 ZYaNIYI6o0jQKnlpoYkq9R4u8a20oaSzsvOvvxFeEzUFD/4rX9mXV/ePWMg7wvcoPd
	 Sbme05Zc238QN++z0mJplGJ8rGE28VloJ+goPr6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Esau <aaron1esau@gmail.com>,
	Yiming Qian <yimingqian591@gmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 130/235] espintcp: use sk_msg_free_partial to fix partial send
Date: Thu, 20 Aug 2026 16:56:06 +0200
Message-ID: <20260820145220.390730656@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 007800408002d871f5699bdb944f985896730b8f ]

sk_msg_free_partial() ensures consistency of the skmsg at every
iteration, without having to manually handle uncharges and offsets.
This simplifies the code, and fixes some bugs in skmsg accounting when
we don't send the full contents.

Cc: stable@vger.kernel.org
Fixes: e27cca96cd68 ("xfrm: add espintcp (RFC 8229)")
Reported-by: Aaron Esau <aaron1esau@gmail.com>
Reported-by: Yiming Qian <yimingqian591@gmail.com>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/espintcp.c |   32 ++++++--------------------------
 1 file changed, 6 insertions(+), 26 deletions(-)

--- a/net/xfrm/espintcp.c
+++ b/net/xfrm/espintcp.c
@@ -208,41 +208,21 @@ static int espintcp_sendskmsg_locked(str
 {
 	struct sk_msg *skmsg = &emsg->skmsg;
 	struct scatterlist *sg;
-	int done = 0;
 	int ret;
 
 	flags |= MSG_SENDPAGE_NOTLAST;
-	sg = &skmsg->sg.data[skmsg->sg.start];
 	do {
-		size_t size = sg->length - emsg->offset;
-		int offset = sg->offset + emsg->offset;
-		struct page *p;
-
-		emsg->offset = 0;
-
+		sg = &skmsg->sg.data[skmsg->sg.start];
 		if (sg_is_last(sg))
 			flags &= ~MSG_SENDPAGE_NOTLAST;
 
-		p = sg_page(sg);
-retry:
-		ret = do_tcp_sendpages(sk, p, offset, size, flags);
-		if (ret < 0) {
-			emsg->offset = offset - sg->offset;
-			skmsg->sg.start += done;
+		ret = do_tcp_sendpages(sk, sg_page(sg), sg->offset,
+				       sg->length, flags);
+		if (ret < 0)
 			return ret;
-		}
-
-		if (ret != size) {
-			offset += ret;
-			size -= ret;
-			goto retry;
-		}
 
-		done++;
-		put_page(p);
-		sk_mem_uncharge(sk, sg->length);
-		sg = sg_next(sg);
-	} while (sg);
+		sk_msg_free_partial(sk, skmsg, ret);
+	} while (skmsg->sg.size);
 
 	memset(emsg, 0, sizeof(*emsg));
 


