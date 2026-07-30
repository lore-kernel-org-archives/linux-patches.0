Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D098436607D;
	Thu, 30 Jul 2026 15:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426594; cv=none; b=YyZNH8kpKo5G9RLHz0jSdW3Cizqgg5vhzD8FNlrxMNX3A3Y5g7Grct8SBk6eUR3Qw2PCCpK7kHcG97e/sVCHrPgnt9DCBxqhJszoMmVB0wYcrIDOnNLFqN8xylLi+bf0wRUszFFokZwSMyP7Znmb8vrKVwdwd6qbIlLxrl1143M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426594; c=relaxed/simple;
	bh=EZ2LVbd/YlBaOtJfZ+meX6j9gGBqA1X0fiqnNjxEUj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qKeJZeri6b8u8EBisyy/CIERftc/Bp8Jp6Nz+huCRRgYwMuCGeq5AVSjfMmsw8a86NlNK784kJ2VY2T+EsuhZt0R3TyDFypDZdqCopFlzgkt44lJ0+0C0/dMKetDyPPqnzpsItiqFsMjyuIZqOIj0O+XB7I+Nb/mIl9lt4tNJnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xyDkEUgt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xyDkEUgt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 385221F000E9;
	Thu, 30 Jul 2026 15:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426592;
	bh=7af6fdA7X0uilT6BQINLPr5WfLb0A3fDnij56p8PqDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xyDkEUgtY8njZ4LorSbqOVCHc5pLV0MjVP7Tflk4XbvhR3FIPiJKe4sTVVwZJHdms
	 8m7zVAM5NgF9QleIiLyQT8AVClIqDJq3symK3ZTfXmuGYmfI6vMyBMA76Iz5diKHvc
	 rCJIN7yGBIJHzabUt5vr/8kCIWIlPqCFzgZSA4cI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asim Viladi Oglu Manizada <manizada@pm.me>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 429/602] pppoe: reload header pointer after dev_hard_header()
Date: Thu, 30 Jul 2026 16:13:41 +0200
Message-ID: <20260730141444.980268834@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Asim Viladi Oglu Manizada <manizada@pm.me>

commit e9c238f6fe42fb1b4dba3a578277de32cb487937 upstream.

pppoe_sendmsg() saves a pointer to the PPPoE header before calling
dev_hard_header(). Device header callbacks are allowed to reallocate the
skb head, invalidating pointers into it.

This can happen when a send is blocked in copy_from_user() while the first
non-Ethernet port is added to an empty team device. The team's delegated
GRE header callback then expands the skb head. PPPoE subsequently writes
six bytes through the stale pointer into the freed head.

Reload the PPPoE header through the skb's network-header offset after
device header creation. pskb_expand_head() updates that offset when it
relocates the head.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Asim Viladi Oglu Manizada <manizada@pm.me>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260722093814.3017176-1-manizada@pm.me
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ppp/pppoe.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ppp/pppoe.c
+++ b/drivers/net/ppp/pppoe.c
@@ -900,6 +900,7 @@ static int pppoe_sendmsg(struct socket *
 	dev_hard_header(skb, dev, ETH_P_PPP_SES,
 			po->pppoe_pa.remote, NULL, total_len);
 
+	ph = pppoe_hdr(skb);
 	memcpy(ph, &hdr, sizeof(struct pppoe_hdr));
 
 	ph->length = htons(total_len);


