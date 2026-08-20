Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A0F44062A;
	Thu, 20 Aug 2026 17:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248248; cv=none; b=MQeP2qdgp2bANyW1SChYuchcrLDUVignH/ukxmtV7PAh7h5pX0D8CSpg87iEfi3DC5PpvF28ysb01b6L8Okv1u74+nW2/3k7ihqxUxL9NpqwL11woc7J+d56mgJoamveG0wQuLja0ExFD9EI6p7dISoqix2+BtBLqXWPVWMT2bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248248; c=relaxed/simple;
	bh=EKV40ET7h/r6oyKgU+14IOxq8KlsBjxQcE3rK01yDlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Od0nxvYcPbYrNrB4BjXdAOzb1VBVcCpapCJYC37e/TTAKbamBDCoRB3VJ1J8SWT4pVq34XgSP1bRDQRfnYCNxpBwGVaJaLujZJRzpuXncPXzxF+rBaQ9Qf74+dDaxrr1wMxlXXlBj8ekj2KNa+LCQr958GZtcCqvh4OxcMDS8pY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cLeRdYYV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cLeRdYYV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C5BE1F000E9;
	Thu, 20 Aug 2026 17:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248246;
	bh=796HY/N1wJ38isoFGVnBf2QJckpfY4jaepfDIhXUIKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cLeRdYYVkC4AQoH3WxQ6e/68Q7haRWK2ZFNkz7LoClUD4fZzALSm/Hang52gj5Wug
	 324RpI2GEk2pnEmPObIBUmrdjQ3Jblx0caIdGI0ktlmXACt67BpeZ1lR/TWW+SZm10
	 pWszvph8i51U9Ldsk6s4Zx2QKOEFTWebkmrTZ2xY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Esau <aaron1esau@gmail.com>,
	Yiming Qian <yimingqian591@gmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 162/303] espintcp: use sk_msg_free_partial to fix partial send
Date: Thu, 20 Aug 2026 16:54:58 +0200
Message-ID: <20260820145258.167206120@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 net/xfrm/espintcp.c |   34 +++++++---------------------------
 1 file changed, 7 insertions(+), 27 deletions(-)

--- a/net/xfrm/espintcp.c
+++ b/net/xfrm/espintcp.c
@@ -212,43 +212,23 @@ static int espintcp_sendskmsg_locked(str
 	struct sk_msg *skmsg = &emsg->skmsg;
 	bool more = flags & MSG_MORE;
 	struct scatterlist *sg;
-	int done = 0;
 	int ret;
 
-	sg = &skmsg->sg.data[skmsg->sg.start];
 	do {
 		struct bio_vec bvec;
-		size_t size = sg->length - emsg->offset;
-		int offset = sg->offset + emsg->offset;
-		struct page *p;
-
-		emsg->offset = 0;
 
+		sg = &skmsg->sg.data[skmsg->sg.start];
 		if (sg_is_last(sg) && !more)
 			msghdr.msg_flags &= ~MSG_MORE;
 
-		p = sg_page(sg);
-retry:
-		bvec_set_page(&bvec, p, size, offset);
-		iov_iter_bvec(&msghdr.msg_iter, ITER_SOURCE, &bvec, 1, size);
-		ret = tcp_sendmsg_locked(sk, &msghdr, size);
-		if (ret < 0) {
-			emsg->offset = offset - sg->offset;
-			skmsg->sg.start += done;
+		bvec_set_page(&bvec, sg_page(sg), sg->length, sg->offset);
+		iov_iter_bvec(&msghdr.msg_iter, ITER_SOURCE, &bvec, 1, sg->length);
+		ret = tcp_sendmsg_locked(sk, &msghdr, sg->length);
+		if (ret < 0)
 			return ret;
-		}
 
-		if (ret != size) {
-			offset += ret;
-			size -= ret;
-			goto retry;
-		}
-
-		done++;
-		put_page(p);
-		sk_mem_uncharge(sk, sg->length);
-		sg = sg_next(sg);
-	} while (sg);
+		sk_msg_free_partial(sk, skmsg, ret);
+	} while (skmsg->sg.size);
 
 	memset(emsg, 0, sizeof(*emsg));
 


