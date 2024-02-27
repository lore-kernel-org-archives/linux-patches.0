Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2048613F01E;
	Tue, 27 Feb 2024 13:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041339; cv=none; b=BrwNnU1m10jzFuQQ6fSmzXpCntfHjw7PGeLF15IK2kWdORo/WJgljN/BCh6cAlkGJ5acAPKiqNJG99J9Shn1huQRj81TEFgBKdYm11yVGcGipm27dYS5djcr/+FtptbDReru/zVIov2dzxhzWXp8fQ/I7b/UIjz2BJVhFYy98Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041339; c=relaxed/simple;
	bh=iDzxBO/xLAIAf5qRc1L77EArM07WLc1TczBzrwFCe54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bXMPA0bpVvH5Tcf8Hpy3DUy9yOlZ78MwscaaWj2TKvQokAIx4/o+5Ieqo3VA6/42NfrVWFykcDNXAIubYRFfwylFLcQs3YPW8NXshoyt2MQvKG8OEtgeXkQWNX9DtOYY5l8B/tpS7urzA07bcbREVWKEpXksdxLYP3IMW7+4N50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aqutN5ie; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aqutN5ie"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0823C433C7;
	Tue, 27 Feb 2024 13:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041339;
	bh=iDzxBO/xLAIAf5qRc1L77EArM07WLc1TczBzrwFCe54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aqutN5iejABSXnCebH3OdB39va6pXUj5AnQiPqtoCiNFtirfxNtF3L70adjTP01SJ
	 Y7xE4GqY4aW+G36i6IIE4Auwo5wJJPA90jvZOxomvtt4bXuUe+6qhVgznf8F18ZCet
	 CFDWudywNpD4uCgbyhMWyMmfggBM2c1C3aEcHvWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 303/334] tls: break out of main loop when PEEK gets a non-data record
Date: Tue, 27 Feb 2024 14:22:41 +0100
Message-ID: <20240227131640.827947777@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 9fbc70200cd0f..78aedfc682ba8 100644
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



