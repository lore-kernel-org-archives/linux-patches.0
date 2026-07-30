Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4693793A9;
	Thu, 30 Jul 2026 14:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422981; cv=none; b=QFVfYk8X46Qy2wXw1HIduo8R/Ud7VJ86ZXPS/WgUFBde/wNw5kSViOFfGx4saoUOzIEc6vjFb/n5g7E5hCaqravvE/lcKtulHTTSoZuSqYEYw8bLrhwRRsyUdRTuSkbaa/V25nScG4jw0Fq+MZUU2QslahZAbJLgJc0noKnBBXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422981; c=relaxed/simple;
	bh=rOFKalXZQ+e+HWl1n3x8sl66pwzTMXrHzZuG3SEDI7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O9eoyDSZ+CI8vNzaV6oSFyq3JMqMZE9ps13KHXbujqUHZFl6aFFXCYQ8nLKPLGT7hFw9ddRMmW+sSQpNQsOU1iyRw4WhhVeSUK7XZ6UIGWDiewbWCT9+hY0WqwjISDtc6x/e1MJ4M8x4FrXpWrQdjXCa2d0568X8xXqGenff9eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Plp4MWRt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Plp4MWRt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25FCD1F000E9;
	Thu, 30 Jul 2026 14:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422980;
	bh=77anVx++MrJHnddvpsgmPvx6bQhjbkhDYkfq7U+YquE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Plp4MWRtw0GCx7cQu9h0Q0mxYV6eDKhNpped2Jiymbe4mqAwwL8acQfiV2mzFenly
	 9BriOuRqEQbnjnpApYp3kvd2T4yxIg5/9XX0MECcnvy9WMKYUWKu6i8KUsInmDjcDY
	 BWClqUELegb0vZHUs4c40HY4qn0nFpHjL0G3Hy+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Zhiling Zou <roxy520tt@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 624/744] sctp: close UDP tunnel sockets during netns teardown
Date: Thu, 30 Jul 2026 16:14:57 +0200
Message-ID: <20260730141457.540519239@linuxfoundation.org>
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
@@ -1454,6 +1454,7 @@ static int __net_init sctp_ctrlsock_init
 static void __net_exit sctp_ctrlsock_exit(struct net *net)
 {
 	sctp_sysctl_net_unregister(net);
+	sctp_udp_sock_stop(net);
 
 	/* Free the control endpoint.  */
 	inet_ctl_sock_destroy(net->sctp.ctl_sock);


