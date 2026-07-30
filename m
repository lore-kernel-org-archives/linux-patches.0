Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69694503FF;
	Thu, 30 Jul 2026 15:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424893; cv=none; b=S7qG2phcqGgGTfnNfHejcTX1tE2Np3lwScP4meLPRtEfXcx07lbO92Gw969IdjFpayUlGkp4xPII1XwO6bjyEd/+lUXGhM4kW69dxyc7RoNQyN5VHVyAUuKBQQrQUpkjgF9zrbNpqpGfi8Q5Wia372yhk7VLwkKExB4pQL6uBM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424893; c=relaxed/simple;
	bh=yWpvvSnWO6/VAgSUtm27dhrBzCRRMtnH0oLr/35ooHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FMy5HYR9W8t0diGziHew1maBhg5gl3pPJYnH4LVnAPtTqPEQMwliRiXLi6KSf0pTJgXvvRCgFTM7+0s0CpQhh7sKtRBh9tRa59W3YwXTHNhLpWND7RXL7OdKndR6sQaIwcByH8LmLRoVpjynrcWWs2k5aIdnHVahW4AcGoGH9HE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nt2+c27o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nt2+c27o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 246A01F00A3A;
	Thu, 30 Jul 2026 15:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424891;
	bh=lEHcImMFo913XEj0yyFFeujLTHUqD6wm42jz/hXyriU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nt2+c27od+6/iggNHvRwOkJClpnkfDtLXxhinj1MkYnxru6eMwlBgvuQJ4sp3Kn+x
	 dr/N7SROTiu8nIG9uCK4VAoS9Wd76eV35uVDCXogOYDHkJPGBrDJ0Xr9FO9Mn2pP5W
	 XkeiPoHTgO2P9kr3NIVOmlM01VKQ+IBfArCpgO5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Zhiling Zou <roxy520tt@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 509/675] sctp: close UDP tunnel sockets during netns teardown
Date: Thu, 30 Jul 2026 16:13:59 +0200
Message-ID: <20260730141455.946997878@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
@@ -1487,6 +1487,7 @@ static int __net_init sctp_ctrlsock_init
 static void __net_exit sctp_ctrlsock_exit(struct net *net)
 {
 	sctp_sysctl_net_unregister(net);
+	sctp_udp_sock_stop(net);
 
 	/* Free the control endpoint.  */
 	inet_ctl_sock_destroy(net->sctp.ctl_sock);


