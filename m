Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B2573AD537;
	Mon, 23 Mar 2026 14:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274966; cv=none; b=jCiXOPIpD1J4cIYQjS2d6fZd5KRpBtzQuUJFMkLaI3FDZpPRWjXVZrkyJyNmMNUgnBUgICnuNG/tzySBPT/U2nEpDwRFW7uc7kpuL+lAkqLZ2IkqVQtvNDygibRsXaHXgRMPDYYDSCjv1Wq+lx7N5AUb3DfH2omFCKkZzjJ59xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274966; c=relaxed/simple;
	bh=JFnrhPyw7VNZgiOXWtbH2+MKwfM07owT+bQWyISsQ4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ai/erI2F+D+SPr1ahSEJqtVHKI7QYgzh0fnvgp+sop8HtTgm5Ciuj/yxiSM7QF8rycSI0l0QDMBxmEGxn9RwnK7ig0njSf1vIaB8t9kAGujW3fDMWvORyVomAhwzZe4m6NNqIyZS9Qew4vW6eF4TxQIDaO4glOjxUPuBq8KHPR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qiTuZBQW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qiTuZBQW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1BBFC4CEF7;
	Mon, 23 Mar 2026 14:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274966;
	bh=JFnrhPyw7VNZgiOXWtbH2+MKwfM07owT+bQWyISsQ4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qiTuZBQWXVJC2YoX9oLEyv5RtKQVLr7ld+dwstkRB1ffVbwH6jzMliQi5XJ5v+5wG
	 GZ0vEKtp1ScrcIJfo/AYRMnkYfDuZxy3dMIlqvPxVlCLqTdEOKOUQ+HctVMJSvWCrU
	 635pJGgo2ELz2/cGvTkpSYn9+dyDqBHGMxP7eD2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 133/212] mpls: add missing unregister_netdevice_notifier to mpls_init
Date: Mon, 23 Mar 2026 14:45:54 +0100
Message-ID: <20260323134507.976389860@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 25c88cba5c48b..1c70cb26e7ba1 100644
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -2777,6 +2777,7 @@ static int __init mpls_init(void)
 	rtnl_af_unregister(&mpls_af_ops);
 out_unregister_dev_type:
 	dev_remove_pack(&mpls_packet_type);
+	unregister_netdevice_notifier(&mpls_dev_notifier);
 out_unregister_pernet:
 	unregister_pernet_subsys(&mpls_net_ops);
 	goto out;
-- 
2.51.0



