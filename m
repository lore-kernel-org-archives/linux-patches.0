Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E1C05012A5;
	Wed, 30 Sep 2026 16:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784908; cv=none; b=KIhsfh8FpihGtbiIgVDnJVA8gxnSh6zbSAs5Y3OD3CcHkuylBPGqOOcg8n5KxjBFj3QvzDNPK/n+iaTvAVbDI8Rv7CUj8y1LZQCHKdwn53XMNJoYCctlDqnE4R/KYp0HZlMjwzmVriTt0ZCO9DlCJXZpKtaUckY94gttoR0rWZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784908; c=relaxed/simple;
	bh=Db693xRjxeelWjSZW3AQe+Av+yBV/Gahdo5Rt7iF1U0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RD7W3Yv3qPk/BilyFIco2yiyxP5aPY3US0LQxZxxTx/8Dtd2n41uDV1HeN/63+MWRl5rLtIz2xTDjJIuhsA/nb5QgXTb2NMx4R9u3dcpM0+gB9FgxXGqh4HQQoIMHdOB9DpqVscSptvDOdlPHdyoAPKW3mcXPT7JcsSizyG+WVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JJOx8WOX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JJOx8WOX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCE141F00893;
	Wed, 30 Sep 2026 16:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784901;
	bh=zH29BoAstTejykvWj4lOwani36gefKCAxi/oFhmmsu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JJOx8WOXQ4K0LxkD148xr4nB2M88DOR2UA1JNjg3DFs4e5H++H+aFGT58nhJjBZmC
	 6jl7BBMIRIqiMm/UTXClEt1fUUEaOveLH94oFlukGMgO2z0eMny9nKEMjYWdJW/Y4K
	 UGyZ6reFKLV7X6Lhfq2awiQqOaRgX/0a9EVgjZIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Zhiling Zou <roxy520tt@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 302/982] sctp: close UDP tunnel sockets during netns teardown
Date: Wed, 30 Sep 2026 17:17:18 +0200
Message-ID: <20260930152423.298760097@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Zhiling Zou <roxy520tt@gmail.com>

[ Upstream commit ffb2bd7ade36ec4da32c46a6eddbf4515316d08c ]

proc_sctp_do_udp_port() starts per-net SCTP UDP tunneling sockets when
net.sctp.udp_port is set, and stops/restarts them when the sysctl value
changes. The netns exit path does not stop these sockets, so a namespace
can be torn down while its SCTP UDP tunnel sockets are still installed.

Close the UDP tunnel sockets from sctp_ctrlsock_exit() after unregistering
the per-net sysctl table. This prevents new sysctl writes from racing in
while the sockets are being released, and closes the sockets before the
control socket is destroyed.

Fixes: 046c052b475e ("sctp: enable udp tunneling socks")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/b9f1f02b0780ad6a719e2413f5f0bb8eb7702d94.1782585631.git.roxy520tt%40gmail.com
Signed-off-by: Zhiling Zou <roxy520tt@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/6dab75f22855cb219e2e30a5497cab03b970ab91.1784033357.git.roxy520tt@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/protocol.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index c6a5af7560748..94878fc63f07b 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1466,6 +1466,7 @@ static int __net_init sctp_ctrlsock_init(struct net *net)
 static void __net_exit sctp_ctrlsock_exit(struct net *net)
 {
 	sctp_sysctl_net_unregister(net);
+	sctp_udp_sock_stop(net);
 
 	/* Free the control endpoint.  */
 	inet_ctl_sock_destroy(net->sctp.ctl_sock);
-- 
2.53.0



