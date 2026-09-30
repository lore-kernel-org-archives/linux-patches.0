Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D32AF5221DE;
	Wed, 30 Sep 2026 17:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790968; cv=none; b=hTCNBbIz0caSfjamSP5SMducj4+6VDwgcl8FhurT47AqRikMNRUZtVfJu1xL3T/m0AaD1tzwxlf0sGkw5ZHxq98RLn6oscg91evIMcddJ7zkoDqhTjBBBedGq2+1k8MkAcBUjnWm9xy6c4ftRY4X4QvLTY5d2MpwSfMYaZGIJWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790968; c=relaxed/simple;
	bh=8MbsPF8XWRjJLDFBK59S651zvq69HId+c814u9dci78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cRmFzP9I/+v2EMuFELLQJE555FASJmcPu7RM2Ni3ABPuaTyEdcQZCyfOf7NOZ9QpKHzYRvRZQ4r3O9n6nDlVSxEQQoQpkg5kTTUnFtDECDck0Xpit8etZ0qWaX8FMi4QGsMWnBpOTgti67wv4flBwFxbCnC5UjGYdHSTAHCa8Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cLzdFrEw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cLzdFrEw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCA591F000FF;
	Wed, 30 Sep 2026 17:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790966;
	bh=iJofRW8wl3uVVr78sUufyCEtdmKa25nM6nooIBp0dr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cLzdFrEwX2Ok7c9PVD5WZ4RKluqGDp6FsoVr5/rAA24W+Kme6zx7T8pSsp4YRZ8Y9
	 DVBLbi34gO7OQoV7A7JX179BkmNox9+EcXvZfNJ9CmKm1Xefl3Ak4pVUxrYn3HUU3R
	 bjZwX9EeWb4vxGxG1UkuXyd5j8pwDMdEkHT+a0W4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 138/752] sctp: Unwind address notifier registration on failure
Date: Wed, 30 Sep 2026 17:20:08 +0200
Message-ID: <20260930152401.164093244@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit c8459ee2fef502d6ef6c063751c33d9ac7943eab ]

sctp_v4_add_protocol() and sctp_v6_add_protocol() register their
address notifiers before registering the SCTP protocol handlers. If
protocol registration fails, the functions return without unregistering
the notifiers.

Unregister the notifiers on the protocol registration failure paths.
Also propagate notifier registration failures instead of ignoring them.

Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Link: https://patch.msgid.link/20260608162230.46644-1-dbgh9129@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/ipv6.c     | 10 ++++++++--
 net/sctp/protocol.c | 10 ++++++++--
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index 107255d92037f..725836f3fdf3d 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -1202,11 +1202,17 @@ void sctp_v6_protosw_exit(void)
 /* Register with inet6 layer. */
 int sctp_v6_add_protocol(void)
 {
+	int ret;
+
 	/* Register notifier for inet6 address additions/deletions. */
-	register_inet6addr_notifier(&sctp_inet6addr_notifier);
+	ret = register_inet6addr_notifier(&sctp_inet6addr_notifier);
+	if (ret)
+		return ret;
 
-	if (inet6_add_protocol(&sctpv6_protocol, IPPROTO_SCTP) < 0)
+	if (inet6_add_protocol(&sctpv6_protocol, IPPROTO_SCTP) < 0) {
+		unregister_inet6addr_notifier(&sctp_inet6addr_notifier);
 		return -EAGAIN;
+	}
 
 	return 0;
 }
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index b5102cd7b42a3..a7cf6e3aefe97 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1272,12 +1272,18 @@ static void sctp_v4_protosw_exit(void)
 
 static int sctp_v4_add_protocol(void)
 {
+	int ret;
+
 	/* Register notifier for inet address additions/deletions. */
-	register_inetaddr_notifier(&sctp_inetaddr_notifier);
+	ret = register_inetaddr_notifier(&sctp_inetaddr_notifier);
+	if (ret)
+		return ret;
 
 	/* Register SCTP with inet layer.  */
-	if (inet_add_protocol(&sctp_protocol, IPPROTO_SCTP) < 0)
+	if (inet_add_protocol(&sctp_protocol, IPPROTO_SCTP) < 0) {
+		unregister_inetaddr_notifier(&sctp_inetaddr_notifier);
 		return -EAGAIN;
+	}
 
 	return 0;
 }
-- 
2.53.0



