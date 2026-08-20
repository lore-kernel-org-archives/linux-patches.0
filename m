Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B792147B403;
	Thu, 20 Aug 2026 16:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243700; cv=none; b=HAVlT3NDfFjI072aTtVAT5KnoTYgGB6plNdTnBh67alaLrQblmobv2tPaCNBnuGxs6PMJ2BAFPI+Iq2aaDp+xcSxAFGUb7jDU8MdA666rlD9Ds/B7lX31wd052k1VijciZGSasiCcGTg2zplF4rUrOqu/1Eb+6Mo2S7XvBMq8hU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243700; c=relaxed/simple;
	bh=7abewUYPyjKHQQUQn8WJqmejXgxk7jz9Ge2oQMWgGq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sg1Ua7p71lGveQKsLvRRFE8vUxW5/gvEZ1NLRjqkmre0YCKDNoUvN3VGxgRBOnG/dKgqvWrKrdEMw3EUkz+ij4/ANjKbGw0KJdI0vWGB1C/2ePOvcpw0yaKvo6t/+2/S3A8phuOhmnhDvJXGIG56tZL8wMWkD/78Vw0e00scOPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IrWW4YkG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IrWW4YkG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E5401F000E9;
	Thu, 20 Aug 2026 16:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243698;
	bh=h2HV4Z1Zo7oXpufMbHWcGn+PwEAZ7FRlRgh1ji/N4oM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IrWW4YkGGeVF4DqhMijabhCSJSJvcXpSQ1D7DrrOyreL5tyxmInrPiv0KWa9YRIZC
	 y/xiYKEkUp9zhYV9EwgtEaDuUu7wv6Gbc8wGoiMSrAE10cxCeY8ARW/vPc30ouquf6
	 Src7Ha6K8C/ZGC/a7PiEzrZBKWMvYebQrz7GklI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Esau <aaron1esau@gmail.com>,
	Yiming Qian <yimingqian591@gmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 158/272] espintcp: use sk_msg_free_partial to fix partial send
Date: Thu, 20 Aug 2026 16:55:42 +0200
Message-ID: <20260820145236.059248951@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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
@@ -210,41 +210,21 @@ static int espintcp_sendskmsg_locked(str
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
 


