Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A4CE1E1A17;
	Wed, 30 Sep 2026 18:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794422; cv=none; b=R1Uu+F/1d58FvQf8TX1+kBPMe7q7qG0WIWluIJWlry1dnWoRBUOuIY3DoX9ANJCpo5+67TD0OSjQbx9k7IDf3zw+i3kBRc8IJ5AV6sYsL5wacBi6YkZIr3/LhH4Wr3KQxab/VCh7NitixRjnlTgtV1KeNyAzaLXGK8lYmLJo164=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794422; c=relaxed/simple;
	bh=vQNEa5EIXpruL+sEfzIolHu8XWzzdb7JNnCiA2r00KY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CgXaDr2CnI4PMjh1G4h5o7s08r/CwmtJDzoSmE24F0jEBTOBijQ0vPvt887VAJAxcPFW4HpTdvsn7od9wVaQ2z9YchyzxuyPcC87jvIWZNQqSyBvyM02WzYpUENm7T95y/46oyAeChkAu2JmBu53kLMHdbo8yqySCac+Vtprqek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BlX2pyP1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BlX2pyP1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C871F000FF;
	Wed, 30 Sep 2026 18:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794421;
	bh=ZzVA9hhCO0PiQzZANkEpw2Ve38+IuHmkpKl8esiz1r0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BlX2pyP1esTxTUrWGOoC+CQC5fH+DrhvSvn2cruO1QpeShVP7gsn0onKQYhfRh6tV
	 9gt7LsM9Dz6owuQGd/q2UaW1n+3OXHMiD9Z6VRPusdZTdw6UB4WQcGD/IyVUF5bWYR
	 Uoyd3k8k89Nl9IIEb7+NSgfbJxTfj8hISx1INz6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0206/1193] sctp: Unwind address notifier registration on failure
Date: Wed, 30 Sep 2026 17:14:50 +0200
Message-ID: <20260930152438.783658774@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index 0673857cb3d8b..02989e5612df5 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -1221,11 +1221,17 @@ void sctp_v6_protosw_exit(void)
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
index e4b4575708464..ee598e319d0ed 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1276,12 +1276,18 @@ static void sctp_v4_protosw_exit(void)
 
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



