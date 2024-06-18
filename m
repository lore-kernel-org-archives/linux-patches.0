Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7FAE14A08D;
	Tue, 18 Jun 2024 12:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715345; cv=none; b=mGz4FE9oTeHuOtmIAfJ5S+GjoBCkppZeNu3ysVm745zmUUdWF1MnA+xrrsXZNJoQ7KQJFnd4a7hGanqTyhs5oVKlXhmOiUopoGCaSz+70nEGx8ah+am72Y1hgMfFpIgxsDAKlWbi2KToShn4LFpRf49m7vXFQHpQMvyimUylKXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715345; c=relaxed/simple;
	bh=74GcESybBOKFkgF+e7K9JqVHJ6fhcuc9z/ijfIhsKkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tf+IaX6a3xYJCHzbP7GKbbtfFqHFNyB4clrAJt6gVudr9I5F2YjFZyKmKn44Pue9V8iHsA2DhLUiPLbTr2vm9qxKs23f3FUsN6bMDXt30TdsvBy+HmIPxaoh//7lOXVJ+qpV6iZCi7kkzV5BaZ5Y+ibMBYHiuZt2UnrVAyBSp/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K+vwTzF9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K+vwTzF9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51399C3277B;
	Tue, 18 Jun 2024 12:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715345;
	bh=74GcESybBOKFkgF+e7K9JqVHJ6fhcuc9z/ijfIhsKkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K+vwTzF9WXQAAl5Fdik4pbGu2Hmnx+mebB2LI18tkJPHU9tAhBH8bG3FqyEA6i7ms
	 rzo8MpcXc5JA4RulXzFSQtx27/1E9klSSGQvaGgvEHjDmmfoT2f6SIaqY12IaFwrL4
	 8ABrc1bOAZrYqDlrjTiW9JIckBKoaEsTr/24HyYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 246/770] SUNRPC: Export svc_xprt_received()
Date: Tue, 18 Jun 2024 14:31:39 +0200
Message-ID: <20240618123416.774148530@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 7dcfbd86adc45f6d6b37278efd22530cf80ab474 ]

Prepare svc_xprt_received() to be called from transport code instead
of from generic RPC server code.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sunrpc/svc_xprt.h |  1 +
 include/trace/events/sunrpc.h   |  1 +
 net/sunrpc/svc_xprt.c           | 13 +++++++++----
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/include/linux/sunrpc/svc_xprt.h b/include/linux/sunrpc/svc_xprt.h
index 92455e0d52445..c5278871f9e40 100644
--- a/include/linux/sunrpc/svc_xprt.h
+++ b/include/linux/sunrpc/svc_xprt.h
@@ -130,6 +130,7 @@ void	svc_xprt_init(struct net *, struct svc_xprt_class *, struct svc_xprt *,
 int	svc_create_xprt(struct svc_serv *, const char *, struct net *,
 			const int, const unsigned short, int,
 			const struct cred *);
+void	svc_xprt_received(struct svc_xprt *xprt);
 void	svc_xprt_do_enqueue(struct svc_xprt *xprt);
 void	svc_xprt_enqueue(struct svc_xprt *xprt);
 void	svc_xprt_put(struct svc_xprt *xprt);
diff --git a/include/trace/events/sunrpc.h b/include/trace/events/sunrpc.h
index 200978b94a0b9..657138ab1f91f 100644
--- a/include/trace/events/sunrpc.h
+++ b/include/trace/events/sunrpc.h
@@ -1756,6 +1756,7 @@ DECLARE_EVENT_CLASS(svc_xprt_event,
 			), \
 			TP_ARGS(xprt))
 
+DEFINE_SVC_XPRT_EVENT(received);
 DEFINE_SVC_XPRT_EVENT(no_write_space);
 DEFINE_SVC_XPRT_EVENT(close);
 DEFINE_SVC_XPRT_EVENT(detach);
diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index 06e503466c32c..d150e25b4d45e 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -233,21 +233,25 @@ static struct svc_xprt *__svc_xpo_create(struct svc_xprt_class *xcl,
 	return xprt;
 }
 
-/*
- * svc_xprt_received conditionally queues the transport for processing
- * by another thread. The caller must hold the XPT_BUSY bit and must
+/**
+ * svc_xprt_received - start next receiver thread
+ * @xprt: controlling transport
+ *
+ * The caller must hold the XPT_BUSY bit and must
  * not thereafter touch transport data.
  *
  * Note: XPT_DATA only gets cleared when a read-attempt finds no (or
  * insufficient) data.
  */
-static void svc_xprt_received(struct svc_xprt *xprt)
+void svc_xprt_received(struct svc_xprt *xprt)
 {
 	if (!test_bit(XPT_BUSY, &xprt->xpt_flags)) {
 		WARN_ONCE(1, "xprt=0x%p already busy!", xprt);
 		return;
 	}
 
+	trace_svc_xprt_received(xprt);
+
 	/* As soon as we clear busy, the xprt could be closed and
 	 * 'put', so we need a reference to call svc_enqueue_xprt with:
 	 */
@@ -257,6 +261,7 @@ static void svc_xprt_received(struct svc_xprt *xprt)
 	xprt->xpt_server->sv_ops->svo_enqueue_xprt(xprt);
 	svc_xprt_put(xprt);
 }
+EXPORT_SYMBOL_GPL(svc_xprt_received);
 
 void svc_add_new_perm_xprt(struct svc_serv *serv, struct svc_xprt *new)
 {
-- 
2.43.0



