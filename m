Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CAE3288C2C;
	Thu, 17 Sep 2026 17:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666550; cv=none; b=XYwHncQMi+eq8MGPyQujhgJs2x+wEofFMRypE/X/luDzbwVKfYrM5TupFECVxRVM3pAbewyEj5O9CWlNZKqLTwFjj0gm378QGOuiLCuSbV6b9YMVdJ8tmO7qe2Xd74con0KnTucggItBjEHGtl91Wp20aRbK0qyNUhn/I9uvS0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666550; c=relaxed/simple;
	bh=irzGdoLFgza1HILYjw+PJSEZylHNGM9D5y1SYp7m2uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=By1ENtnsPe5gvC/Fd6r9IhUx+2yW6WDZUqM3Sh3ardJHAmImcFO5IG3PVUnI1RkkTCOoeMkeqpPC4UI94D4Q3d4A8XXUg+EE/ahqu1dNJN79DtF4MsVUA+pWTS/mbMHG3YRFJaTm3VHN+CGRkzeeM1i5amlIkDDxZexCqvNezSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jTzDk2ES; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jTzDk2ES"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBDF31F000FF;
	Thu, 17 Sep 2026 17:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666548;
	bh=CqKe2dAn5y4AhVxpUYdzUBqx6bDt104qS5HQp3ippp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jTzDk2ES+eWvAGT4+KvaFfpDU5wyYJEM728YniCKZvXyVJ9ZkqbML91Zy6aHqqTVe
	 DOkHFhnp+NcDorrqVVLfP4zPZ3e94PCCZ3OeLC8mZfuC5Jiy0b1xf/HpVEcaFnbPmm
	 3VhVx+aZvqtFxI5Jc/Ko1Od4t1soXAp9gCkm5uIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Gang Yan <yangang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 1075/1250] selftests: mptcp: fix an UAF in mptcp_connect.c
Date: Thu, 17 Sep 2026 16:14:30 +0100
Message-ID: <20260917151621.276501922@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
@@ -379,6 +379,9 @@ static int sock_connect_mptcp(const char
 
 	hints.ai_family = pf;
 
+	/* Keep the resolved address alive for the whole execution: it is
+	 * used again when reconnecting, and will be released at exit time.
+	 */
 	xgetaddrinfo(remoteaddr, port, &hints, &addr);
 	for (a = addr; a; a = a->ai_next) {
 		sock = socket(a->ai_family, a->ai_socktype, proto);
@@ -422,7 +425,6 @@ static int sock_connect_mptcp(const char
 		}
 	}
 
-	freeaddrinfo(addr);
 	if (sock != -1)
 		SOCK_TEST_TCPULP(sock, proto);
 	return sock;


