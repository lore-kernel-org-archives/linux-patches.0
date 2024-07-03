Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D934DA14;
	Wed,  3 Jul 2024 11:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005265; cv=none; b=st8D8o7n0sZLhWMXKM+bA/oZ2ErXtuxZR6P/arKMtOGLUEXHIrglCMXDygy0Kuprh5XjOEcgAyxFwFHBHQWL+2wuYM9xHMpve26Y5tXSGrPV0x0HpSaGrAOLENPizRIK2HTYWA6ThpFAeUpwB2ovbpt9D0pW/nlirgrSUUsr3Vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005265; c=relaxed/simple;
	bh=QAGlhRU+B67V8FB4BNdUP051kwwgmyjfCp7VqDnfUaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pfTLUp/1ktuawAQCt+2bBwrYH3teFPElLVn0agBzmM1WEjHbrleIyb84RyYTdy8NTBHJxef/0lREAyWAU8KDOKRhsHWXL1hFKfmhQ4CJKIPY9zowMmRw93SnjQMveoMaGL7udB2UP8hmgtm2dGMSDPx4hPG+BZVauYT4596HNPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n1XB+eDf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n1XB+eDf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 510D7C2BD10;
	Wed,  3 Jul 2024 11:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005265;
	bh=QAGlhRU+B67V8FB4BNdUP051kwwgmyjfCp7VqDnfUaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n1XB+eDfHoLmwOkOtBDejqxFoN6Rh7teIiaPToq6w0fg8LW+2vSC5nwVGbmC7msfd
	 bQhmYEZcApA0hhzBhvZi1KsKzZ017rgedbxg0rs2O+SINMSRKOdhNBY8QhDn7nUimg
	 IxPgAR6S6r5TUgnln7EFlD3exy8YHPgcmxXO/Nfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 024/356] net: inline sock_prot_inuse_add()
Date: Wed,  3 Jul 2024 12:36:00 +0200
Message-ID: <20240703102914.015090221@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 2a12ae5d433df3d3c3f1a930799ec09cb2b8058f ]

sock_prot_inuse_add() is very small, we can inline it.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: a9bf9c7dc6a5 ("af_unix: Annotate data-race of sk->sk_state in unix_stream_connect().")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h | 14 +++++++++++---
 net/core/sock.c    | 11 -----------
 2 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index b8de579b916e8..c13c284222424 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1460,13 +1460,21 @@ proto_memory_pressure(struct proto *prot)
 
 
 #ifdef CONFIG_PROC_FS
+#define PROTO_INUSE_NR	64	/* should be enough for the first time */
+struct prot_inuse {
+	int val[PROTO_INUSE_NR];
+};
 /* Called with local bh disabled */
-void sock_prot_inuse_add(struct net *net, struct proto *prot, int inc);
+static inline void sock_prot_inuse_add(const struct net *net,
+				       const struct proto *prot, int val)
+{
+	__this_cpu_add(net->core.prot_inuse->val[prot->inuse_idx], val);
+}
 int sock_prot_inuse_get(struct net *net, struct proto *proto);
 int sock_inuse_get(struct net *net);
 #else
-static inline void sock_prot_inuse_add(struct net *net, struct proto *prot,
-		int inc)
+static inline void sock_prot_inuse_add(const struct net *net,
+				       const struct proto *prot, int val)
 {
 }
 #endif
diff --git a/net/core/sock.c b/net/core/sock.c
index 62e376f09f957..e79e1c7933537 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3497,19 +3497,8 @@ void sk_get_meminfo(const struct sock *sk, u32 *mem)
 }
 
 #ifdef CONFIG_PROC_FS
-#define PROTO_INUSE_NR	64	/* should be enough for the first time */
-struct prot_inuse {
-	int val[PROTO_INUSE_NR];
-};
-
 static DECLARE_BITMAP(proto_inuse_idx, PROTO_INUSE_NR);
 
-void sock_prot_inuse_add(struct net *net, struct proto *prot, int val)
-{
-	__this_cpu_add(net->core.prot_inuse->val[prot->inuse_idx], val);
-}
-EXPORT_SYMBOL_GPL(sock_prot_inuse_add);
-
 int sock_prot_inuse_get(struct net *net, struct proto *prot)
 {
 	int cpu, idx = prot->inuse_idx;
-- 
2.43.0



