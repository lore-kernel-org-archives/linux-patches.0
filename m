Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6DE15CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:07:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C44AC433D6;
	Tue,  8 Nov 2022 14:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916478;
	bh=ok5lzuleHGznZ4RsIULJ8xPBPQm9EZ9Z4l4GgU1BSfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2C+JzgdlZOHqylVJ/J//2c5NKntaRsrcn88QVI3FDfrDvamIwp/gfWxmAQhlPswkv
	 b0FtT0EWoJInmRdP/5qPSjRkPTcaH2CejsP2ljA25/STSUnxeHjqlHCUv+AQpVj6RY
	 ZFD4TtpvwS1vYjXz0KbYX9rbyBi9mpvNt8RpyMos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Vorel <pvorel@suse.cz>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 034/197] nfsd: fix net-namespace logic in __nfsd_file_cache_purge
Date: Tue,  8 Nov 2022 14:37:52 +0100
Message-Id: <20221108133356.367290963@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit d3aefd2b29ff5ffdeb5c06a7d3191a027a18cdb8 ]

If the namespace doesn't match the one in "net", then we'll continue,
but that doesn't cause another rhashtable_walk_next call, so it will
loop infinitely.

Fixes: ce502f81ba88 ("NFSD: Convert the filecache to use rhashtable")
Reported-by: Petr Vorel <pvorel@suse.cz>
Link: https://lore.kernel.org/ltp/Y1%2FP8gDAcWC%2F+VR3@pevik/
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 844c41832d50..173b38ffa423 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -893,9 +893,8 @@ __nfsd_file_cache_purge(struct net *net)
 
 		nf = rhashtable_walk_next(&iter);
 		while (!IS_ERR_OR_NULL(nf)) {
-			if (net && nf->nf_net != net)
-				continue;
-			nfsd_file_unhash_and_dispose(nf, &dispose);
+			if (!net || nf->nf_net == net)
+				nfsd_file_unhash_and_dispose(nf, &dispose);
 			nf = rhashtable_walk_next(&iter);
 		}
 
-- 
2.35.1



