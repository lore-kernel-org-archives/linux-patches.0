Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047921D54FA;
	Thu, 17 Sep 2026 18:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671287; cv=none; b=lWPh+VW7JUiBoV6eVuBW5DserIlw1X4Sd2PSgM7Tr4xFB6FmDN0dU6ys5TUd8kCEQ1vDZnC9LYj8stSd9IGIzpX87dhZyDhbk2X24WbwXYhDxVJ6fjS+KuVE2ba92j2qjyfuQ3awd9f6iKQGz5O6vprBGcXoF+6Drx3ipSM7ln4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671287; c=relaxed/simple;
	bh=PjJW9stFqhmoxviP3srx/IYUg8jgVIXJzz5EsmMh6Bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZEGeIm33yLxu1FdWiygtsGj0jSsdUtZ6l4j3DKdgBKJabtVNdqvPgmv17h46qPbS3kIExLvniLXDGjfiF4avt/4IFSGLuAgddUk8KxhcnwjxPRgA8ifCdF6i0HeQN4H5bBvWMk7u2pRoWxNqlme3cGajrRyc+SDd09jRUAxdM28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NZN36zIE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NZN36zIE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5009B1F000FF;
	Thu, 17 Sep 2026 18:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671285;
	bh=q3CCfkDmsw741d+GvcDD0NE42mP++lb1wREx+RC2/ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NZN36zIEigc682eprewomjN6FoZN2YgXe7sMsCCPY/zjEBfaD48iA4QgNmgkEj/VU
	 K/PvyStiBsBjDma0fm+ShN7H8Ymh7cgQUK39GA/+wp/XFOsRwLxjRN+da+IWMWKEpA
	 aimuoZHe4L9MsSLEhqsxlQo09WcQkZDdfqlVM1YE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Gang Yan <yangang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 0888/1102] selftests: mptcp: fix an UAF in mptcp_connect.c
Date: Thu, 17 Sep 2026 16:13:51 +0100
Message-ID: <20260917151602.870921232@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
@@ -365,6 +365,9 @@ static int sock_connect_mptcp(const char
 
 	hints.ai_family = pf;
 
+	/* Keep the resolved address alive for the whole execution: it is
+	 * used again when reconnecting, and will be released at exit time.
+	 */
 	xgetaddrinfo(remoteaddr, port, &hints, &addr);
 	for (a = addr; a; a = a->ai_next) {
 		sock = socket(a->ai_family, a->ai_socktype, proto);
@@ -408,7 +411,6 @@ static int sock_connect_mptcp(const char
 		}
 	}
 
-	freeaddrinfo(addr);
 	if (sock != -1)
 		SOCK_TEST_TCPULP(sock, proto);
 	return sock;


