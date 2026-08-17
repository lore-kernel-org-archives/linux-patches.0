Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13BC342D747;
	Mon, 17 Aug 2026 14:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977141; cv=none; b=jFEmc40glTGjsmbvPspITp4ND3yDNq1fWbwsgjQcaD0A03YmpFe1KPTVMk/Ie9VmviR1eRKCoSuqjhcrkjm+/Y/YlGH/Xf49KYFTPAbOJgxhVnSNBguh3ZchdyWeKWqjtwJzctu0KMsN3MLOkbBdRtlWkrvzlykQuVpSc2FI7N8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977141; c=relaxed/simple;
	bh=FPdpKLwA33VnBrAvyyJjOUz6lZgpr8wfnRhVfFMQtTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AvuUH4DaH/XM3GvKDcrVjpBAXmqLK3fcEVDdFE72BT3DsIm7sr2xXxOa8Ks6nFxERFPcwruLu6UbGnY/uoxR8Q5+7f3HqpOtuUZ5KKRI3n/9in98n9hgxxDgcoZ2QVFx7EcSf3wg7mNcVcKeuPaxySi8+GeB/pIErvsiegAAxj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KXbixwyV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KXbixwyV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56DDF1F000E9;
	Mon, 17 Aug 2026 14:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977139;
	bh=kZGul3SlfQqeGf7xWy/+8OC1qJuITUsihQZmqNJ1B64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KXbixwyVsritC+StM2t2he27HHLItbFRS73WXudnTKpIBY55i/D3lIdvg/gyYdhwq
	 Dd7LtkjFpBjFBeDtve4nVC3tM4OC+W0obkc24iUXBwMLk5hZ44lgN/6ucWzrUHMIun
	 nJw7g0YPMEjHWC7MUBFi/Q3tDnaI8l3WQJ++1Iuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asim Viladi Oglu Manizada <manizada@pm.me>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 224/456] pppoe: reload header pointer after dev_hard_header()
Date: Mon, 17 Aug 2026 15:30:14 +0200
Message-ID: <20260817132548.917750483@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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
@@ -899,6 +899,7 @@ static int pppoe_sendmsg(struct socket *
 	dev_hard_header(skb, dev, ETH_P_PPP_SES,
 			po->pppoe_pa.remote, NULL, total_len);
 
+	ph = pppoe_hdr(skb);
 	memcpy(ph, &hdr, sizeof(struct pppoe_hdr));
 
 	ph->length = htons(total_len);


