Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78934F85CB;
	Wed, 30 Sep 2026 17:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790242; cv=none; b=AC/Cv2vs7iWtk1Bqf3AvZpJzqHzAMN2eAB+QJo7ICXNyuV60CNrbASFrCld0r5HxsZT8GompVCFJs5S5xTUHlSoXrXMtmZgsHVm2PptCainul3zZl3XaUFda9RaxwLDi4B7f3uofepNVHU2Qh+el6rOSLA2OYhBWtt0277z37iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790242; c=relaxed/simple;
	bh=bA+XHXESyMhX1s+VJ/GO2tvvLZs6bc03daDKpyfUPPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MLuTEJ1jrOd9jXWX2Ds8lmf3CIWNffHn7krcyhTELqhyL/TARgLtLuTgVknFkyc5/0L9WyKEKgErPxphWG5KpQsKE5skI0Z3NYcFYhFBQMmVv+MtvaFhIyO3HqCgorljnLFgFjISarrZHCzF52Z7xmUC5dLLLrYeAIZBn23ow5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TZyKtkJW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TZyKtkJW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FFFE1F000FF;
	Wed, 30 Sep 2026 17:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790241;
	bh=SvXhs9nevmHhB4qDz0RThmWQP+1pxw2443vyITZrZO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TZyKtkJWPEFVhu9I3dkkOlvdbfA7auLCGrjr3QrlvEgECSKCdMzjn1WDVI92cCkvQ
	 R3q8TYe1g382UDtMAdyRNTNaGl26ZXDDGbk+DRYD8mEORa7yDqTtXiIg1AI16gNrhW
	 40imh+qGoP5bCmFjswwJ3NXXwIFL2czou/yB8C+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 760/877] sock: add sock_kmemdup helper
Date: Wed, 30 Sep 2026 17:27:51 +0200
Message-ID: <20260930152431.103037156@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/sock.h |    2 ++
 net/core/sock.c    |   16 ++++++++++++++++
 2 files changed, 18 insertions(+)

--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1840,6 +1840,8 @@ static inline struct sk_buff *sock_alloc
 }
 
 void *sock_kmalloc(struct sock *sk, int size, gfp_t priority);
+void *sock_kmemdup(struct sock *sk, const void *src,
+		   int size, gfp_t priority);
 void sock_kfree_s(struct sock *sk, void *mem, int size);
 void sock_kzfree_s(struct sock *sk, void *mem, int size);
 void sk_send_sigurg(struct sock *sk);
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2837,6 +2837,22 @@ void *sock_kmalloc(struct sock *sk, int
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


