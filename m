Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF25396D28;
	Sat, 17 Oct 2026 16:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256063; cv=none; b=B31i8kDSFVr98oUap2zqeGODf6AgupGlijlVTbyzCrgNAdqXl2U+xTnsBWOCrQ5DQsy9WMHYNbH1eQ6j5hOP4aivleNnuOQ6XtlSZFVYiosIN3PbXq0rqSYWt+AiodMibv5BzQnNEnsxt/rt1MgR37XrqUeuaubbRFeYQa7pHbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256063; c=relaxed/simple;
	bh=Zc+k6KuHHE2W44DjDS6+W31ejaX7U4BW+HloU/tGguk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k8u8LuDMBudWYlvlVOx5mHfsDrU82Q8/sbear01UwI8oLf87bRXbjt7ZAba4MO3vYK9NFEYNzDmgq+K8/vTLkz3wmibywKH1s2bDBeGX6qkDV/M5FFmioxYH2byTm/XMrm2C5JleE/95R5SeNIAidUdSkoU7MYkk5j8BCCt05yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YYAmOwFQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YYAmOwFQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7E8C1F000C4;
	Sat, 17 Oct 2026 16:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256062;
	bh=zp3W2eYAPj1ZIndxuFaTTP10hFDYbiBIc512k3wZGZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YYAmOwFQTaANvALl/c+cgKqSHIktyErU6x93MOwmiyD16ztlgspjVWHxb6aOGh0NL
	 F/cVFx4qbqF7QzXPHztSifrk1s2M706CKLp91lxSMSKWdw8+cVojuvRaohPaePh68u
	 QtPT1oZYhmvxbT7YTUhM0Wv21v1MxxgG5Md+j4To=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0110/1674] sock: add sock_kmemdup helper
Date: Sat, 17 Oct 2026 17:39:42 +0200
Message-ID: <20261017160433.974409332@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Geliang Tang <tanggeliang@kylinos.cn>

[ Upstream commit 456cc675b6d4cadd4872a477d8976ff56eef4b6f ]

This patch adds the sock version of kmemdup() helper, named sock_kmemdup(),
to duplicate the input "src" memory block using the socket's option memory
buffer.

Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Acked-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/f828077394c7d1f3560123497348b438c875b510.1740735165.git.tanggeliang@kylinos.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: f9f0068e8813 ("mptcp: pm: userspace: fix address ID overflow")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h |  2 ++
 net/core/sock.c    | 16 ++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/include/net/sock.h b/include/net/sock.h
index ca476d93e3a33..69c0fac146734 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1955,6 +1955,8 @@ static inline struct sk_buff *sock_alloc_send_skb(struct sock *sk,
 }
 
 void *sock_kmalloc(struct sock *sk, int size, gfp_t priority);
+void *sock_kmemdup(struct sock *sk, const void *src,
+		   int size, gfp_t priority);
 void sock_kfree_s(struct sock *sk, void *mem, int size);
 void sock_kzfree_s(struct sock *sk, void *mem, int size);
 void sk_send_sigurg(struct sock *sk);
diff --git a/net/core/sock.c b/net/core/sock.c
index ef5f69a4b3abc..057ec36aa4710 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2736,6 +2736,22 @@ void *sock_kmalloc(struct sock *sk, int size, gfp_t priority)
 }
 EXPORT_SYMBOL(sock_kmalloc);
 
+/*
+ * Duplicate the input "src" memory block using the socket's
+ * option memory buffer.
+ */
+void *sock_kmemdup(struct sock *sk, const void *src,
+		   int size, gfp_t priority)
+{
+	void *mem;
+
+	mem = sock_kmalloc(sk, size, priority);
+	if (mem)
+		memcpy(mem, src, size);
+	return mem;
+}
+EXPORT_SYMBOL(sock_kmemdup);
+
 /* Free an option memory block. Note, we actually want the inline
  * here as this allows gcc to detect the nullify and fold away the
  * condition entirely.
-- 
2.53.0



