Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370BF509EF3;
	Wed, 30 Sep 2026 16:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785647; cv=none; b=GswWDTNbNYNvq50BoVBliEM4vj55us1m8dpnvKumvbKSrEJubpEetJDiVpZ7gvy+xygAabBLlUYqYl9+uFsXvQ1ULh/WOFt8nd8oCKqR5FsidxlRSE3nVsruFfWqzZlH+rXLfyTdiaZ9Wha9r0MI/56unClJfMujMdcJxdoWyiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785647; c=relaxed/simple;
	bh=AehMW9FtjdzPAWAJc72TudPOGXZl8aVCAnr5gXEOTYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fqr5nSNX5hAwJa2bIo9rfqcudVP64yC4hoqfGg3C7MhpcvTcmcN3QR2tRe8UzMRuLZkAPIErk5exYg86dzjOzspKm6dYNhcV5IWF7vFgfoReuuZUCutfuZHqtDUzmSWP8CeWfLiURA8HubRbY3aye+IdbOgZpRGTBVkZiLze0c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KESMSLvF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KESMSLvF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C2A31F000FF;
	Wed, 30 Sep 2026 16:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785642;
	bh=arpH6TQRcKpt7d2YMjM1CSoFEXWpx2mrV0MejPNAXpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KESMSLvFZCst9w0Kdoie8gb99UIItV6xF7N4mLva5yzrHFEHQaS/YGuvdY5/gZCfc
	 s4wfKt+fiulHclYiOq03Mz2fDEQP1ykYwaGZc8+bulyiB23rMeurAKOfeTAHx9xvha
	 fq4WBf2NHHHxLYRLOEX2RPmGPRWigwP+63weQLoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Gang Yan <yangang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 544/982] selftests: mptcp: fix an UAF in mptcp_connect.c
Date: Wed, 30 Sep 2026 17:21:20 +0200
Message-ID: <20260930152428.456570554@linuxfoundation.org>
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

From: Gang Yan <yangang@kylinos.cn>

commit 730444f094b12052916ebd7e14fe57bc3d47bf38 upstream.

At the end of 'sock_connect_mptcp()', it calls 'freeaddrinfo(addr)',
the 'peer' pointer (which points into 'addr') remains. Later, the main
loop uses this peer pointer for reconnection attempts. If the memory has
been freed and reused, the address data could be overwritten, resulting
in an invalid remote address.

This patch keeps the addrinfo list allocated for the whole process
lifetime so "peer" remains valid across reconnects; the memory will be
released at exit() time.

Fixes: 05be5e273c84 ("selftests: mptcp: add disconnect tests")
Cc: stable@vger.kernel.org
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Gang Yan <yangang@kylinos.cn>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260908-net-mptcp-misc-fixes-7-3-rc1-v2-7-df1de70348b6@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_connect.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_connect.c
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.c
@@ -344,6 +344,9 @@ static int sock_connect_mptcp(const char
 
 	hints.ai_family = pf;
 
+	/* Keep the resolved address alive for the whole execution: it is
+	 * used again when reconnecting, and will be released at exit time.
+	 */
 	xgetaddrinfo(remoteaddr, port, &hints, &addr);
 	for (a = addr; a; a = a->ai_next) {
 		sock = socket(a->ai_family, a->ai_socktype, proto);
@@ -367,7 +370,6 @@ static int sock_connect_mptcp(const char
 		sock = -1;
 	}
 
-	freeaddrinfo(addr);
 	if (sock != -1)
 		SOCK_TEST_TCPULP(sock, proto);
 	return sock;


