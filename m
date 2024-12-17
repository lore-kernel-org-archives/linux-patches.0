Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9619D1DE2AC;
	Tue, 17 Dec 2024 17:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456307; cv=none; b=YwdSIktrXTAZH4hqs31THRDlU9OTHr52WFKJgBznFX99hUiOxLgG2Cab4Q1PUtH2OC2XYpQLEInZ1bX4+DDP+ViuZEBIjGubP2cgqg6bpCKvrX/BpTYWUsHqodPWGHfRL5vx1944tgHLf519T5Zo8aT+1tJnTuhljglLdGHdSa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456307; c=relaxed/simple;
	bh=ZB0bob5q+Jcpj/9+ySdTFFE/lT6EnJKFUImSBBMcoAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=csGcmiChUFDnHkVjQ9jOeS5etRY9ttpEPQYEvDxWuf1OLRevz8JsZK1maiYcu7SZ1QXmkVA1QTeNP5PBl4dzXbqJ4X/CtL8lPapxI6ZEMs9iE7MGfzR/W8npbnjzRGt/O4QYkAQZ7QlSQXyY2/BonjUFG+BB0yn/eXXxTdsuzo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=euojb25H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="euojb25H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0640C4CEE4;
	Tue, 17 Dec 2024 17:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456307;
	bh=ZB0bob5q+Jcpj/9+ySdTFFE/lT6EnJKFUImSBBMcoAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=euojb25HMX1f0Eb1zq9DQvwTASaFYobx6i2luBO/7PFeB3DfzT33sczYszXUCVSDr
	 gaD/RKTt3F2xrpzGswG/6U5SawjlNVFTUoMTVFJl19bNcxdgusnwRle61eHLDD1lSW
	 291Vc+xuYFhNHjY1SpdX/I4IQIHneSjZVS5adNH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederik Deweerdt <deweerdt.lkml@gmail.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Eric Dumazet <edumazet@google.com>,
	Joe Damato <jdamato@fastly.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 008/172] splice: do not checksum AF_UNIX sockets
Date: Tue, 17 Dec 2024 18:06:04 +0100
Message-ID: <20241217170546.592032578@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Frederik Deweerdt <deweerdt.lkml@gmail.com>

commit 6bd8614fc2d076fc21b7488c9f279853960964e2 upstream.

When `skb_splice_from_iter` was introduced, it inadvertently added
checksumming for AF_UNIX sockets. This resulted in significant
slowdowns, for example when using sendfile over unix sockets.

Using the test code in [1] in my test setup (2G single core qemu),
the client receives a 1000M file in:
- without the patch: 1482ms (+/- 36ms)
- with the patch: 652.5ms (+/- 22.9ms)

This commit addresses the issue by marking checksumming as unnecessary in
`unix_stream_sendmsg`

Cc: stable@vger.kernel.org
Signed-off-by: Frederik Deweerdt <deweerdt.lkml@gmail.com>
Fixes: 2e910b95329c ("net: Add a function to splice pages into an skbuff for MSG_SPLICE_PAGES")
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Joe Damato <jdamato@fastly.com>
Link: https://patch.msgid.link/Z1fMaHkRf8cfubuE@xiberoa
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/unix/af_unix.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2313,6 +2313,7 @@ static int unix_stream_sendmsg(struct so
 		fds_sent = true;
 
 		if (unlikely(msg->msg_flags & MSG_SPLICE_PAGES)) {
+			skb->ip_summed = CHECKSUM_UNNECESSARY;
 			err = skb_splice_from_iter(skb, &msg->msg_iter, size,
 						   sk->sk_allocation);
 			if (err < 0) {


