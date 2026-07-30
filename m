Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4127E419304;
	Thu, 30 Jul 2026 14:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423158; cv=none; b=myab2z5F6heQv6Smzky88o3HfPwEpmS68Lzs5g/zISCPIRvBiv9HE7ATKnIk2QR2fqcAToz525qJhYVFXuQPEjeOLqHx8ce/XEKNg7/Ih5Mb0lKW70OVGf26Wh50guBbW9KVeFBOZbi/MYdsdHsALhXmqXvB2LGnakCzXGHRp+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423158; c=relaxed/simple;
	bh=rzwlzCSsxYZZKITrN2bzuBs8CgWYzu4M53tvQaNIrtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SJCdOTbBGlKn5Jx3J3iYPoh6X4E83Bv/wJ7a+GFmGxUzzN+XXI5BG2Z6R59si8lmHtQJKIxx7PiTe83NXg1FKgLabDfjINUqHSlbVyPmSUYLvScfheWUsDl4tvDhnQaAasw9vdN9NNia4lL68KhiqM34HyEPYEI31UxASbtRTqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g+7ls4CJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g+7ls4CJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F941F000E9;
	Thu, 30 Jul 2026 14:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423156;
	bh=Bn9yVlnp858KqWGyeL4f5sc3Qz/WNYmEd4yBlnBxOYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g+7ls4CJ0JEkqG3TqM6cZ5GGabNEXivG6XIK1hzSz7DBO1qcNnrtPh93dC8IboZvr
	 YNh8EtpS9EHho1tEWfeWvWGf1eU5ewyE4FD3SnsvgXmdiXTiMgWlzTt8ajx7zpzQRr
	 RVPh5WQIzYMLMNt3nZRuzMbWI8LVWE5/x21csitI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asim Viladi Oglu Manizada <manizada@pm.me>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 685/744] pppoe: reload header pointer after dev_hard_header()
Date: Thu, 30 Jul 2026 16:15:58 +0200
Message-ID: <20260730141458.825000819@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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
@@ -824,6 +824,7 @@ static int pppoe_sendmsg(struct socket *
 	dev_hard_header(skb, dev, ETH_P_PPP_SES,
 			po->pppoe_pa.remote, NULL, total_len);
 
+	ph = pppoe_hdr(skb);
 	memcpy(ph, &hdr, sizeof(struct pppoe_hdr));
 
 	ph->length = htons(total_len);


