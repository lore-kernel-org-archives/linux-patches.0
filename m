Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10B6360745;
	Thu, 20 Aug 2026 15:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238700; cv=none; b=iBPDRzlbZ+u3lZ5/gePy0hSBmfoO4VSsNGRwtW9NOLw7ujXx6G0YyUm2tusZXkKeJxKiv5jwp6jHzXtQp3zfgtER1yXfScgGQhmBNDpoIljqj40dyb+a2NsWvXg0eS7ib6GLzWFV6YLuFO4eTh4tDgCmud4OaVTzohC4oJZHLzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238700; c=relaxed/simple;
	bh=OiRfXO7atxlUSXb+4awWc/ZU7eX5udI+C1P2dnglsWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mqTcaqTPRpHIlfjMLNHQoXCOOl1yF103VgYeZ1twpsf/Y5um7Dakm5AdAlSiGfMiu8LsSYrRyBD0mSugTaVVXfQoG8DVgxZRrmYQqDOTqy8qBQ06jQEfkt5iYhMIqklbN+yi+Oj9VKnXOsfFyoMA9g0QWDx1YIB/lYddUMY1HCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xx94KJMR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xx94KJMR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3603D1F000E9;
	Thu, 20 Aug 2026 15:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238699;
	bh=kDgndPcnYek9iS/YdWylOGtQBlzBOLsfhDZNCSMaSPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xx94KJMRcSNf/J7dwZ2ei5sug5QoaPmbOlXPor05vL5EB+psngVskuA22vjz6kA3m
	 xn1+9cyHdIIK6qycvZZyPKzab2I2calkH1mjgis2U/8wuNqASjByHJwLkCa29yg/k5
	 e0teJUqN2yZz1tEcaDS47d3XgwMVoIPu1Etzn04U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 011/217] mptcp: reclaim forward-allocated memory on RX path errors
Date: Thu, 20 Aug 2026 16:52:59 +0200
Message-ID: <20260820145237.941567033@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

commit 41b49a8b914ec7dcb03eae93fb27f3c464078644 upstream.

After commit 9db5b3cec4ec ("mptcp: borrow forward memory from subflow"),
errors in the receive path prior to queueing skbs into the receive
queue do not trigger forward-allocated memory reclaiming.

Prevent forward memory from growing unboundedly in pathological drop
scenarios by explicitly reclaiming memory when skbs are dropped.

Fixes: 9db5b3cec4ec ("mptcp: borrow forward memory from subflow")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260803-net-mptcp-misc-fixes-7-2-rc6-v2-8-b8f496d71664@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -147,6 +147,12 @@ struct sock *__mptcp_nmpc_sk(struct mptc
 
 static void mptcp_drop(struct sock *sk, struct sk_buff *skb)
 {
+	/* The skb forward memory was already transferred to sk by
+	 * mptcp_borrow_fwdmem(), even before setting the destructor.
+	 */
+	if (!skb->destructor)
+		sk_mem_reclaim(sk);
+
 	sk_drops_skbadd(sk, skb);
 	__kfree_skb(skb);
 }


