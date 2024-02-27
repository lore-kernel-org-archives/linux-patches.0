Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 860C354BD4;
	Tue, 27 Feb 2024 13:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042363; cv=none; b=msTnaRhCgPFlaPlVNbnBVi6tpzPQB+G8GXnIGX28/LkJwzTHJMWw0dX6ERL+5BoZGTKNeP5Z/LQfFGH03wxgcDzJVDoyTuhIEypI4YkmoN8De+Rm0OmOx313MGYDGkrfMOBU780Q/cSw4m7saq0GEML5H8Shh+Q9pgOexz5IHvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042363; c=relaxed/simple;
	bh=a2t6ng3tDJ5aeZ/uQxy4LZLr3111RtBqznST3VLTb5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pBx6O6mKENTUE4v7UX/N8FYufI8v2tatfHDQcZzRZaTTfIcwisoODHvBZYvy0ffgag6eQYWquNF0qnQMOY4107tRdJr03NYirm+8kbmDBFPT8kswJcYrlPAQ0NtGYb+AZbyBjHEjywr26hrLpRpIm3VkAjnVcmIjAkzjPEIUDhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HpIh8PSg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HpIh8PSg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F2AC433C7;
	Tue, 27 Feb 2024 13:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042363;
	bh=a2t6ng3tDJ5aeZ/uQxy4LZLr3111RtBqznST3VLTb5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HpIh8PSgt1iv6CIaRJ4SfInS/iQB/NWp+K1bvL9qFqo+QZXinLhJkBEXxYEnsyI7x
	 +Dhhwou8a4a8VldCTtnXNJKNkW86biSS3BGtEUTD3+Hntcmp1PCsuTcu2350ZfikF+
	 yZdI2r5mmr7ZG2Cy7AjhMFyAAEfruoYDoKtQj7CQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 268/299] tls: break out of main loop when PEEK gets a non-data record
Date: Tue, 27 Feb 2024 14:26:19 +0100
Message-ID: <20240227131634.310736916@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 10f41d0710fc81b7af93fa6106678d57b1ff24a7 ]

PEEK needs to leave decrypted records on the rx_list so that we can
receive them later on, so it jumps back into the async code that
queues the skb. Unfortunately that makes us skip the
TLS_RECORD_TYPE_DATA check at the bottom of the main loop, so if two
records of the same (non-DATA) type are queued, we end up merging
them.

Add the same record type check, and make it unlikely to not penalize
the async fastpath. Async decrypt only applies to data record, so this
check is only needed for PEEK.

process_rx_list also has similar issues.

Fixes: 692d7b5d1f91 ("tls: Fix recvmsg() to be able to peek across multiple records")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://lore.kernel.org/r/3df2eef4fdae720c55e69472b5bea668772b45a2.1708007371.git.sd@queasysnail.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index e1f8ff6e9a739..67c8323b7cd11 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2064,6 +2064,8 @@ int tls_sw_recvmsg(struct sock *sk,
 				decrypted += chunk;
 				len -= chunk;
 				__skb_queue_tail(&ctx->rx_list, skb);
+				if (unlikely(control != TLS_RECORD_TYPE_DATA))
+					break;
 				continue;
 			}
 
-- 
2.43.0



