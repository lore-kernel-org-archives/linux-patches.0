Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27DB42572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:44:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1517C433D2;
	Tue, 18 Apr 2023 12:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821847;
	bh=DSjdximMTUrLWe54ITUgmUiz9STA6qtlFvwGweGaIhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bUq1wfYgqN+vJmoitRahhqHtk8VBjcQo2rkQeqJgq5NocPTeZKuqdtfdsrKIyE2GP
	 kArmd2GV5FzOlVuwCJxMQGfUo3ldCKeYNi+zY1jimTfNB3O14QsBVmavr8ZpRCTdIF
	 1fVShn9/mSGHZfh/F3wGpVYy2NH+GaiqUP7gKYN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 063/134] sctp: fix a potential overflow in sctp_ifwdtsn_skip
Date: Tue, 18 Apr 2023 14:21:59 +0200
Message-Id: <20230418120315.159804892@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 32832a2caf82663870126c5186cf8f86c8b2a649 ]

Currently, when traversing ifwdtsn skips with _sctp_walk_ifwdtsn, it only
checks the pos against the end of the chunk. However, the data left for
the last pos may be < sizeof(struct sctp_ifwdtsn_skip), and dereference
it as struct sctp_ifwdtsn_skip may cause coverflow.

This patch fixes it by checking the pos against "the end of the chunk -
sizeof(struct sctp_ifwdtsn_skip)" in sctp_ifwdtsn_skip, similar to
sctp_fwdtsn_skip.

Fixes: 0fc2ea922c8a ("sctp: implement validate_ftsn for sctp_stream_interleave")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Link: https://lore.kernel.org/r/2a71bffcd80b4f2c61fac6d344bb2f11c8fd74f7.1681155810.git.lucien.xin@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/stream_interleave.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sctp/stream_interleave.c b/net/sctp/stream_interleave.c
index bb22b71df7a34..4fbd6d0529545 100644
--- a/net/sctp/stream_interleave.c
+++ b/net/sctp/stream_interleave.c
@@ -1160,7 +1160,8 @@ static void sctp_generate_iftsn(struct sctp_outq *q, __u32 ctsn)
 
 #define _sctp_walk_ifwdtsn(pos, chunk, end) \
 	for (pos = chunk->subh.ifwdtsn_hdr->skip; \
-	     (void *)pos < (void *)chunk->subh.ifwdtsn_hdr->skip + (end); pos++)
+	     (void *)pos <= (void *)chunk->subh.ifwdtsn_hdr->skip + (end) - \
+			    sizeof(struct sctp_ifwdtsn_skip); pos++)
 
 #define sctp_walk_ifwdtsn(pos, ch) \
 	_sctp_walk_ifwdtsn((pos), (ch), ntohs((ch)->chunk_hdr->length) - \
-- 
2.39.2



