Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7475E4973B9;
	Thu, 17 Sep 2026 15:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660654; cv=none; b=RWAyQQFcjS9ptFBizj4AAwmTwo4XsdM3qo0fG5OFYjjlLdBcoTtGnAI8oAk0oG0ISLybE6SDK6wIph1D2VoTl9jgJpxSIQ+Xgy3FXwmCx4C0MaOjFmON3aF51MjCv2jSaq4JrIIMBrT5bSGYBsgn2yw45QvwMkkNV+Tfl96shmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660654; c=relaxed/simple;
	bh=Lrf83OyEv4HspsTAJL8O4uiJD2OlFhB9X3WxUpNTu9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nSbgiUN3Qwci8ol7VK/4tK5w6c5Gp6ViQ+/oKLV0G3ths14W/wkp66jQTanjTCtDwt/XmmJuH7vMHEJ8WUFOUm0ATcmdpF97JEYgdfyox2xIs3E/FEveHt4PnjCBys7zdXUra4SxSr+433ibatpwX5IbNb35ahNZpFEOnv/j2bE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uxpx463o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uxpx463o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB3751F00893;
	Thu, 17 Sep 2026 15:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660653;
	bh=Szqu+fJYIZ2eZDJw+8YIRfNlLflMb72H1P62gsGrtBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uxpx463opbhfhMqyEB6HCMErSmpf77uUmrvCJEd7n8MlYXxvA2iNse9v+fro0zPp/
	 FWOBinCYpWpy/b/3pkkHeY4UQvKu7MLJbnuZHzGQbzmwWNMoOXtdSb85Yesj3Him7b
	 Ks0RYY0fGpa4rSewiS3iTygDMj+TWOyVcBuAL8CM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Gang Yan <yangang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 617/733] selftests: mptcp: fix an UAF in mptcp_connect.c
Date: Thu, 17 Sep 2026 16:15:25 +0100
Message-ID: <20260917151407.894891427@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -381,6 +381,9 @@ static int sock_connect_mptcp(const char
 
 	hints.ai_family = pf;
 
+	/* Keep the resolved address alive for the whole execution: it is
+	 * used again when reconnecting, and will be released at exit time.
+	 */
 	xgetaddrinfo(remoteaddr, port, &hints, &addr);
 	for (a = addr; a; a = a->ai_next) {
 		sock = socket(a->ai_family, a->ai_socktype, proto);
@@ -421,7 +424,6 @@ static int sock_connect_mptcp(const char
 		sock = -1;
 	}
 
-	freeaddrinfo(addr);
 	if (sock != -1)
 		SOCK_TEST_TCPULP(sock, proto);
 	return sock;


