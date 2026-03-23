Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7553B5841;
	Mon, 23 Mar 2026 15:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279345; cv=none; b=SpKdStuHpiuIArOgGwsfy5LhZiWlH+A5i1WCtCj8Xk6FR+TlJ2Y0QB9TxMKGqylqdI9EznYeuAh7qSSmMDWfKVr2ALcUsyJKhwOexyBPQYDNDY7e7D18zFf7RcpO22MWhv/8lFyJAOXb/c0zv27MPOT/4Oy/nxYk3Bbv7JJxXuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279345; c=relaxed/simple;
	bh=mDDKoJIZ218VsfxU789z6t26BCins7r5Ty/tbxgOXrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LrPemRiVJOBnmOo8lyHY9N4K9EuihQ7L5uAlg3tHiI9xGqDeEZwKt3M7wQKJZihL+DUuMhhKfwr3tTs+Y/DT+mIkFB77gA4ffdKhSkAVLTWYhgpn9CjF/7kLz39SJDHJqR/sZu2t7is5d20T+bbO3RoArAkY8z6Z7u51rdCcfSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WPznbnMz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WPznbnMz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A915C4CEF7;
	Mon, 23 Mar 2026 15:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774279345;
	bh=mDDKoJIZ218VsfxU789z6t26BCins7r5Ty/tbxgOXrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WPznbnMzB6mbPkpVwBE+rpAAsaFYzbK1BrEHxBhch3K36xA6TsYZWqnAqkBH4RcyR
	 Pn3mSa66Hj+fzpyMT1xCMUmJ9dQJMWo0S6KyUNiOCxxVwKvAPAObrN0UdYnntKrJqu
	 OgbhyC0GCiHSqsGqpkG294M9jX37aS7IuJhyOoAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 512/567] mpls: add missing unregister_netdevice_notifier to mpls_init
Date: Mon, 23 Mar 2026 14:47:12 +0100
Message-ID: <20260323134546.684026121@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 99600f79b28c83c68bae199a3d8e95049a758308 ]

If mpls_init() fails after registering mpls_dev_notifier, it never
gets removed. Add the missing unregister_netdevice_notifier() call to
the error handling path.

Fixes: 5be2062e3080 ("mpls: Handle error of rtnl_register_module().")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://patch.msgid.link/7c55363c4f743d19e2306204a134407c90a69bbb.1773228081.git.sd@queasysnail.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mpls/af_mpls.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mpls/af_mpls.c b/net/mpls/af_mpls.c
index 5a4b175b78c8c..0561a530ecf0d 100644
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -2775,6 +2775,7 @@ static int __init mpls_init(void)
 out_unregister_rtnl_af:
 	rtnl_af_unregister(&mpls_af_ops);
 	dev_remove_pack(&mpls_packet_type);
+	unregister_netdevice_notifier(&mpls_dev_notifier);
 out_unregister_pernet:
 	unregister_pernet_subsys(&mpls_net_ops);
 	goto out;
-- 
2.51.0



