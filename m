Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF35C38947F;
	Fri,  7 Aug 2026 15:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116508; cv=none; b=oOZoZOEithuSuCu59NC+01TN98OpPWxrmVJhWvYOeH+Bw515rM1mHf4LmjnN40Hplw0zTQ5naHSrrVBdwuEDrea1nMRZhV05PJ1G3N5Fk8ZOhVHL38Pg3b2ZtAXKQg/WX09zcFqEB8JvvoRMb9j3H6HkzBJJeWulyjlibgPYr1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116508; c=relaxed/simple;
	bh=8wLiYgo0C0RPzqbYYUWs+5Zsw5U4IWFo9fPTBp9ZOII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JYuzK2pqaOKtPBR5GYJfepCTTMAIRf8E6PLXM4mFY0Jf+OYdnwS7ulVEolnK7PJB6dQ0srBKnGOhZlTe6xsJYhfbKB0AOzA5VZ6Mss5v9cacSX+TwZt3pVBvAzOu5ZBj7CTcw8dFD9/zMzOtGaC3Bx3ErjhgOWEMm22uCv5fjCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gq4NXksB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gq4NXksB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CD2D1F000E9;
	Fri,  7 Aug 2026 15:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116507;
	bh=aL/SKxB9RMKmutjXLyyNvAepBmDVkGgNihWAu50nHRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gq4NXksBFKesKXPLhOuIImy/yaxseAedm9L6ruX7hJFKFq+CjqsnaARWJEGBcDxcv
	 OI9MOqhXemZiT8XSqo+e4eW8VIHj6I9vV6Iv6mXRxCpHuJ6kdiWPiba6AXIWjHtomu
	 7OHLFCtYrZvNbUGxC097PnaY7gOiwOQiIR90y2XY=
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
Subject: [PATCH 6.6 253/261] sctp: close UDP tunnel sockets during netns teardown
Date: Fri,  7 Aug 2026 16:40:10 +0200
Message-ID: <20260807143420.876223720@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/protocol.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1471,6 +1471,7 @@ static int __net_init sctp_ctrlsock_init
 static void __net_exit sctp_ctrlsock_exit(struct net *net)
 {
 	sctp_sysctl_net_unregister(net);
+	sctp_udp_sock_stop(net);
 
 	/* Free the control endpoint.  */
 	inet_ctl_sock_destroy(net->sctp.ctl_sock);


