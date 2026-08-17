Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B87EE3AAF6D;
	Mon, 17 Aug 2026 15:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979603; cv=none; b=DXBtHuC3y6sZxqvx6TEh2fHJ/vQFU2UNuyi9MACeCBlwyyjwEasTrdHiv46nIzgPfL7T8QyjYAIkop3xHIELbgk/bdllgr2uh8CnWQsr8jCf3PWZ/ROproKqTih+lCROGVM0SAsV9GH9GnvfwcPPCSf3E4aobnlTrl7rcIb/yHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979603; c=relaxed/simple;
	bh=NXvPqJP5yPNxUB7zyJIZahwhTe3NYAP4am5XLRXGeUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VQFSs6UhsQBcWaLTaNyNxZD1s0e2L0xVAUGdVe3ElRw0zaY5dWrrmqI5V1UpnpkmW96K0c9yxYSwo6m6jb0RZdF9LTH8u35bugo+4qxXvuQlhCY4WTgd5kE4nN9KTW2vO5r4WWFrj3m/iAM3hQj+5/ox0OnL57c9+rIkk8Dc/fA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K4Tgxti8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K4Tgxti8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CD691F000E9;
	Mon, 17 Aug 2026 15:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979602;
	bh=wvt5H6zQLPDvucTgyqcZX6GuoCOeh35WSSM9SDSy+0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K4Tgxti819RWKc9droxKrznTYvtf6yuuAWLi0XTntheDHHQz5KBUZLKG+uyFUYgAK
	 21XDxrODjZMLWnPqVXxTW+k+53acGeCxru1Mwcj3UkIIyCzaHWQ2tZVhAzkMybl00O
	 iMW+L9U4N8WXLasxLr1WW0zIr03SfDhWMuWM9w3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asim Viladi Oglu Manizada <manizada@pm.me>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 276/609] pppoe: reload header pointer after dev_hard_header()
Date: Mon, 17 Aug 2026 15:29:32 +0200
Message-ID: <20260817132553.385381288@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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


