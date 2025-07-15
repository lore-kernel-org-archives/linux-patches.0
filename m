Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB3DC2EF291;
	Tue, 15 Jul 2025 13:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587817; cv=none; b=tPiLrvdPndXa7TNYVusYkGX/+yfpCoreyOg5GkVWDEfJ4dQ5w1uYp5+7XPY6fX05eqgwWdk8/67flLLy44mKb4Qgz34uWwgzwwZ4mlu7FOWkTSHBPH7WMaZB5wm8OULQlKF8/KsOi3NVpakhjk8GLUeehuklCP7AiPt7l6tP5aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587817; c=relaxed/simple;
	bh=eRxrCnbpodGym7ngIe7hF/KJWUIDVAJzbuFAwbHWzRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KnCh3kWcHECvN3JT65cBJmievzNpTEs7VeaIzWw+2194K74wvAQQFYUtmuH1BDgX21i05oIXrfhCoB7D/04JNKliNkRNvNAm5B4ZV/UxysAlpX62i7WNo/iOKUWw8XxOdP7GFU0DaKzQEevZeZfkHbmGcDV6ip5ZnHkWNmG5ZPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2cwV+ZvR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2cwV+ZvR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0696EC4CEE3;
	Tue, 15 Jul 2025 13:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587817;
	bh=eRxrCnbpodGym7ngIe7hF/KJWUIDVAJzbuFAwbHWzRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2cwV+ZvR4FemAkYP3FhevYM8ZA4Tc4dPcWDOj6qBKYlKSsO2gbhocG9FXx3xxiUxX
	 0PEbMpnuMKOXlqID5MjudT/Fa0hTzXmeXBVMNzE/MGZtSG2ctTrhoJ5WkpUOwLE5AS
	 kANS5shK4xBoYTIeK3EjqJI/S/y/4Qc/QtTD+gFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Junvyyang, Tencent Zhuque Lab" <zhuque@tencent.com>,
	David Howells <dhowells@redhat.com>,
	LePremierHomme <kwqcheii@proton.me>,
	Marc Dionne <marc.dionne@auristor.com>,
	Willy Tarreau <w@1wt.eu>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 154/208] rxrpc: Fix oops due to non-existence of prealloc backlog struct
Date: Tue, 15 Jul 2025 15:14:23 +0200
Message-ID: <20250715130817.078825642@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: David Howells <dhowells@redhat.com>

commit 880a88f318cf1d2a0f4c0a7ff7b07e2062b434a4 upstream.

If an AF_RXRPC service socket is opened and bound, but calls are
preallocated, then rxrpc_alloc_incoming_call() will oops because the
rxrpc_backlog struct doesn't get allocated until the first preallocation is
made.

Fix this by returning NULL from rxrpc_alloc_incoming_call() if there is no
backlog struct.  This will cause the incoming call to be aborted.

Reported-by: Junvyyang, Tencent Zhuque Lab <zhuque@tencent.com>
Suggested-by: Junvyyang, Tencent Zhuque Lab <zhuque@tencent.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: LePremierHomme <kwqcheii@proton.me>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Willy Tarreau <w@1wt.eu>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
Link: https://patch.msgid.link/20250708211506.2699012-3-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/call_accept.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/rxrpc/call_accept.c
+++ b/net/rxrpc/call_accept.c
@@ -271,6 +271,9 @@ static struct rxrpc_call *rxrpc_alloc_in
 	unsigned short call_tail, conn_tail, peer_tail;
 	unsigned short call_count, conn_count;
 
+	if (!b)
+		return NULL;
+
 	/* #calls >= #conns >= #peers must hold true. */
 	call_head = smp_load_acquire(&b->call_backlog_head);
 	call_tail = b->call_backlog_tail;


