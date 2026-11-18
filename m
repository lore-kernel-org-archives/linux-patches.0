Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045244;
	b=Niy5SVOoOq/5nGN+lxVcluuqPaDXyhkTnpregWJNNNcZg/AMPkEWjUzZ6c3KVaFxcbUo
	 LaBkpjupSLzhSIhJGJfLhx7vzCUdNASZTnDK7K0NYK7uLPPz8bQRGbZKkGzCLfURIf80c
	 4GrQ8c4TiReZO40ynNuZVQNG5GcTEtJ4sLnLCjulkAoWyC2DQ3exxmUCsBb7l/NjtK+Hr
	 x813v+KfU1qrYo4AWXI6otb8eWwNje7FCaYiCSJXnk+m4R8jVIK72TQTBNxTDc/3Xx2DP
	 eHzA+Ct1OQfftXLgj0VSkTwH3Acr9CJ1LZySQZteSakZo6xzcV8qR7DYxSzUNv/CrCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045244;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ztotO2iGnt2kFt6TWJcn2ihCPmcWNI1r1OTxGm+8POY=;
	b=5HE/DebwRV2XD3+TK7xj7EwSrmg7kMtEb97ofRGZfN0a9bioUXG2NWtEk9kid4bdNVNS
	 NSWI+yhQAQ1QRRWGIGbzynJVvayJ7XyG+wYQafuISxyc33em/gBDYRaijtq06J4mdC+Bv
	 C2ho3ykNpRB6svTDSLhVZUMrsL8a42zH/PzLkYMC78ANmY5cKz5jEFH8lt/T9wZheUA8R
	 4w8G7utsacEPvh9hWKtOAXe9YZmcN5jMcLr5AVai/PBFeWKZ2nXahZ7w1M6mnnp4cnRzB
	 sEE/KQdupT8Y6usamABZWzRSXkM03FUfihrqcDiCCvCFJSMEUrSM1itkc0NokLqUX3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="wSCs/gUU";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84530606A320;
	Wed, 18 Nov 2026 23:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wSCs/gUU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D54441F000C4;
	Wed, 18 Nov 2026 23:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045244;
	bh=ztotO2iGnt2kFt6TWJcn2ihCPmcWNI1r1OTxGm+8POY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wSCs/gUUCngP2nm7Gu0p4yrPTK8chWxhvs/6cXzXdEZ8DfN824Lr5hN1zrK4AL3RT
	 j06R1wX0nyRLAnzvcn94xQ9UR1lPIdS74w3HtEnn4yw+7Guj0S0GWOd3RaN/ej6vx6
	 zgz/yGwQYMeKAPJxmKD9+tirfptWfhoq7dw/AKNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0855/2857] dm-writecache: fix uncommitted_blocks underflow
Date: Wed, 18 Nov 2026 15:31:29 +0100
Message-ID: <20261118150232.352740525@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 8a0cc5f3446a324b13f62020eeddb32d6ba1c2db ]

Revert the commit 39495b12ef1cf602e6abd350dce2ef4199906531

writecache_bio_copy_ssd sets wc->uncommitted_blocks = 0; and then queues
the flush work: queue_work(wc->writeback_wq, &wc->flush_work);

It may be possible that discard is dispatched in this window, and the
discard would decrement wc->uncommitted_blocks to -1U.

Note that this bug is benign - wc->uncommitted_blocks is only used to
trigged autocommit, so decrementing it to -1U will trigger a spurious
autocommit, but won't cause any data corruption.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5
Fixes: 39495b12ef1c ("dm writecache: correct uncommitted_block when discarding uncommitted entry")
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-writecache.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 97baa868eebe9..21b16a3c6945f 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -898,8 +898,6 @@ static void writecache_discard(struct dm_writecache *wc, sector_t start, sector_
 				}
 				discarded_something = true;
 			}
-			if (!writecache_entry_is_committed(wc, e))
-				wc->uncommitted_blocks--;
 			writecache_free_entry(wc, e);
 		}
 
-- 
2.53.0



