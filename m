Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0699115C8A
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:43:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7884FC433C1;
	Mon,  5 Dec 2022 19:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670269389;
	bh=bRqdeSdg0UopUKDXfEBckA2rb76aku/3pYWAqfRWkNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VyaRaq21MLYS07U8qHRbepTfW2UqKomooab2AmJ3PVz3LK75Y2nVz9WSxdljkhUkC
	 dUEfPsq+nM17YiEFcsw7n8KtOnJ3P0gDhm+IrzOJSq4UaXL1da2JfF/LMbvwJnAbS/
	 zRNBbLMRAowgtJdqFNkxKBetLb6YdnyQJ1nZQnDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 109/153] afs: Fix fileserver probe RTT handling
Date: Mon,  5 Dec 2022 20:10:33 +0100
Message-Id: <20221205190811.869569102@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
References: <20221205190808.733996403@linuxfoundation.org>
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

[ Upstream commit ca57f02295f188d6c65ec02202402979880fa6d8 ]

The fileserver probing code attempts to work out the best fileserver to
use for a volume by retrieving the RTT calculated by AF_RXRPC for the
probe call sent to each server and comparing them.  Sometimes, however,
no RTT estimate is available and rxrpc_kernel_get_srtt() returns false,
leading good fileservers to be given an RTT of UINT_MAX and thus causing
the rotation algorithm to ignore them.

Fix afs_select_fileserver() to ignore rxrpc_kernel_get_srtt()'s return
value and just take the estimated RTT it provides - which will be capped
at 1 second.

Fixes: 1d4adfaf6574 ("rxrpc: Make rxrpc_kernel_get_srtt() indicate validity")
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Marc Dionne <marc.dionne@auristor.com>
Tested-by: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Link: https://lore.kernel.org/r/166965503999.3392585.13954054113218099395.stgit@warthog.procyon.org.uk/
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/fs_probe.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/afs/fs_probe.c b/fs/afs/fs_probe.c
index 51ee3dd79700..e9282e025912 100644
--- a/fs/afs/fs_probe.c
+++ b/fs/afs/fs_probe.c
@@ -92,8 +92,8 @@ void afs_fileserver_probe_result(struct afs_call *call)
 		}
 	}
 
-	if (rxrpc_kernel_get_srtt(call->net->socket, call->rxcall, &rtt_us) &&
-	    rtt_us < server->probe.rtt) {
+	rxrpc_kernel_get_srtt(call->net->socket, call->rxcall, &rtt_us);
+	if (rtt_us < server->probe.rtt) {
 		server->probe.rtt = rtt_us;
 		alist->preferred = index;
 		have_result = true;
-- 
2.35.1



