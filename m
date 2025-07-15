Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC782E612A;
	Tue, 15 Jul 2025 13:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585852; cv=none; b=r2y0VRuoT0rACtmNfNbjV7I1uF+IeotnxAxidDxHo069rhLNVmL1CWN9WRdbxveZaYpPIMERaQj/G422Opqww9s4deg/xgP4jk6kJ34aOvMawqaU5ZcYPKZR42JSxFivv0x5ZREijsAoeIibw8zXhQfNYxek3wVINUXkaQ1HzWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585852; c=relaxed/simple;
	bh=sSDqYYaKYhnlV4hB9sy75A2WzR2NSgWzLYgMfBR+Vk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hCGzLjabb9Qc0trqYH+iMBtvD+vMMO956J8IZsmRQa/zchij9GW6nXq3k9P8nP3ILIUaprNRFUasWrX4cmQZ65/FIephQhjTfFvz+yUXbHbgKq7VzIDxRcMa6HuCQWAahemOc0G9oc8gQQdS9XEGkQaB0eEBL3x+Ayg+GhEdMbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o1Wf4Ni+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o1Wf4Ni+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B368C4CEF7;
	Tue, 15 Jul 2025 13:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585851;
	bh=sSDqYYaKYhnlV4hB9sy75A2WzR2NSgWzLYgMfBR+Vk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o1Wf4Ni+iDuytVlikO8HqwFqP8z0w2n8rcd962B1xps1gb0qrC0Ty3dPJU4sPEzaV
	 hsWFIETEhJw1WK01fE3vzbEMbGzpio96NgDFYJzNEG8osqyjexcrDGpXK8zcw5ucgN
	 6gOeo5IWxk2BOJWGM5+V2gtw2XwpwUwvdnxHOCvQ=
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
Subject: [PATCH 6.6 031/109] rxrpc: Fix oops due to non-existence of prealloc backlog struct
Date: Tue, 15 Jul 2025 15:12:47 +0200
Message-ID: <20250715130800.129611790@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130758.864940641@linuxfoundation.org>
References: <20250715130758.864940641@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -254,6 +254,9 @@ static struct rxrpc_call *rxrpc_alloc_in
 	unsigned short call_tail, conn_tail, peer_tail;
 	unsigned short call_count, conn_count;
 
+	if (!b)
+		return NULL;
+
 	/* #calls >= #conns >= #peers must hold true. */
 	call_head = smp_load_acquire(&b->call_backlog_head);
 	call_tail = b->call_backlog_tail;


