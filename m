Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B194237F8D7;
	Thu, 30 Jul 2026 15:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426347; cv=none; b=nSs0mXUXQE1naLOnUZWY5KTMtYhr956NQvlJt4rwkO/qurK1DyAT0lwAQ3J569YH0mJo8yY8yDs/NpWABdVQrrDRg+5FvVn/rJ1vfpnrzmwX3f6cMN58DDeIgaumVDyoC4rkv34mC2YG2gcwcS0GvNV3cEMRR6UVxJa4wt9Lq8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426347; c=relaxed/simple;
	bh=wEZqkLPRA7fgJq7gqlBxwgGUMZbCiQ8yhXEW5XvY7WQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pMrOoikkAgieokwpWPXGZj0hQaP7jYOJp2sVNlNvLUnGUGI4oydRYxglYd6sXMr7pPljiXgMFwKCMNGQU7vIMGJwEHGcXBIl+0/3Us27pTTLaBt2gFux3N20XwqMuwpLLs4FAxGau+Rk4xutzoNrh8sZHwKP8KDaLhPRc4A+9b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fXQMx57i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fXQMx57i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C96B31F000E9;
	Thu, 30 Jul 2026 15:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426346;
	bh=lGICb3Q+euGMN9HjHlSxqZluNBppzLUHiwk2WWfQXsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fXQMx57iWEpuRm9TtfVf+9ztNrtDx8QBqAtYFbOJnF7sUgd23wfZwHW11ke4qdZ44
	 pg4RcbktHk4HgMHVe9pbfyz5rVer/r3iqN8Iu89TWGW5VbMM0ao75jsJG5P3ktiizw
	 ivVTioLYL/rU6AeP+nKBVn8m2wuTjGdFnS7lVQeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Zhiling Zou <roxy520tt@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 388/602] sctp: close UDP tunnel sockets during netns teardown
Date: Thu, 30 Jul 2026 16:13:00 +0200
Message-ID: <20260730141444.110704369@linuxfoundation.org>
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

From: Zhiling Zou <roxy520tt@gmail.com>

commit ffb2bd7ade36ec4da32c46a6eddbf4515316d08c upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/protocol.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1474,6 +1474,7 @@ static int __net_init sctp_ctrlsock_init
 static void __net_exit sctp_ctrlsock_exit(struct net *net)
 {
 	sctp_sysctl_net_unregister(net);
+	sctp_udp_sock_stop(net);
 
 	/* Free the control endpoint.  */
 	inet_ctl_sock_destroy(net->sctp.ctl_sock);


