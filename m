Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750713C23
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEB77C433C8;
	Mon, 19 Jun 2023 10:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171216;
	bh=O6RYYlVwXXYj/HuWmYtTzIP5NXx3z0ZGT25etE+QaYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FruSBzirCZuNrZFEk3LK1BNmrA8tesaVssCgoyKtepb9tUT4kFr2l2+v7odUVcF6a
	 Zq8n1fO5mJpbA22GXtYU/i/K4aBItq5sE9Qpxgy6vDD6ywqVEAcn34qZlm+FNBt4FC
	 f1b+EgNCmZM5k3c1MTaSXV4KOLBa0MH6AWSaDQqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Dionne <marc.dionne@auristor.com>,
	David Howells <dhowells@redhat.com>,
	linux-afs@lists.infradead.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 182/187] afs: Fix vlserver probe RTT handling
Date: Mon, 19 Jun 2023 12:30:00 +0200
Message-ID: <20230619102206.513259937@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>
References: <20230619102157.579823843@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David Howells <dhowells@redhat.com>

[ Upstream commit ba00b190670809c1a89326d80de96d714f6004f2 ]

In the same spirit as commit ca57f02295f1 ("afs: Fix fileserver probe
RTT handling"), don't rule out using a vlserver just because there
haven't been enough packets yet to calculate a real rtt.  Always set the
server's probe rtt from the estimate provided by rxrpc_kernel_get_srtt,
which is capped at 1 second.

This could lead to EDESTADDRREQ errors when accessing a cell for the
first time, even though the vl servers are known and have responded to a
probe.

Fixes: 1d4adfaf6574 ("rxrpc: Make rxrpc_kernel_get_srtt() indicate validity")
Signed-off-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: linux-afs@lists.infradead.org
Link: http://lists.infradead.org/pipermail/linux-afs/2023-June/006746.html
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/vl_probe.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/afs/vl_probe.c b/fs/afs/vl_probe.c
index d1c7068b4346f..58452b86e6727 100644
--- a/fs/afs/vl_probe.c
+++ b/fs/afs/vl_probe.c
@@ -115,8 +115,8 @@ void afs_vlserver_probe_result(struct afs_call *call)
 		}
 	}
 
-	if (rxrpc_kernel_get_srtt(call->net->socket, call->rxcall, &rtt_us) &&
-	    rtt_us < server->probe.rtt) {
+	rxrpc_kernel_get_srtt(call->net->socket, call->rxcall, &rtt_us);
+	if (rtt_us < server->probe.rtt) {
 		server->probe.rtt = rtt_us;
 		server->rtt = rtt_us;
 		alist->preferred = index;
-- 
2.39.2



