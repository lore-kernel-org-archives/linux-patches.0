Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 925523ED110;
	Tue, 17 Mar 2026 16:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765703; cv=none; b=i3SjFfA9a+n5jVM0C2wCuc+EZ1aKIfafCZuFWJWA2fdsngjlu+g7ETP0P10i7KAnttlnqfKepX4Gt79NKG6QxFkEPvkCQC0gyOCpIKwfkaIes2jMRXA6OH5ez21Icj+w2eqvMaGnpZtLe+5hoFt+l/KnOctb0rmHlt4IX8Yht4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765703; c=relaxed/simple;
	bh=+ADILC2je+1E2YXsjsnZAUkE35UA1rEwJDIPUFIQGBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C3SP4w8eRcnVbM7DpRc0SsS0OQYZlSoJh119Tcoxzk51kmycR3RdUR9GVjq1iOvmOyTJ4ulSu9UI/9xRMvvw54ztSbZrIOtCKhQvf4oB5j4sbWUBbXSKy44LJUkVw0ir4VNmAOiichcavxPnzQx1SjQnfn7xQurIYK9YOLU16Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1TFCJJKI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1TFCJJKI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06348C4CEF7;
	Tue, 17 Mar 2026 16:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765703;
	bh=+ADILC2je+1E2YXsjsnZAUkE35UA1rEwJDIPUFIQGBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1TFCJJKI4VWYbKYSHbWFFzXorUj+F9xLKx0iDV3hKIN2pPC0Tlk6bxr3e8gcJfbgO
	 xEcTSO3+fQ0Em09AYYAMmBlFBPozBi4FmY5xnoj4LF1WSsMp/jUHFqAn1law3wu5Gw
	 ilXnQ5sS8cwpGfyRsbr3Mm9Kh/ewB2pQ/TnLfbis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 075/378] netfilter: nf_tables: always walk all pending catchall elements
Date: Tue, 17 Mar 2026 17:30:32 +0100
Message-ID: <20260317163009.777154089@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 7cb9a23d7ae40a702577d3d8bacb7026f04ac2a9 ]

During transaction processing we might have more than one catchall element:
1 live catchall element and 1 pending element that is coming as part of the
new batch.

If the map holding the catchall elements is also going away, its
required to toggle all catchall elements and not just the first viable
candidate.

Otherwise, we get:
 WARNING: ./include/net/netfilter/nf_tables.h:1281 at nft_data_release+0xb7/0xe0 [nf_tables], CPU#2: nft/1404
 RIP: 0010:nft_data_release+0xb7/0xe0 [nf_tables]
 [..]
 __nft_set_elem_destroy+0x106/0x380 [nf_tables]
 nf_tables_abort_release+0x348/0x8d0 [nf_tables]
 nf_tables_abort+0xcf2/0x3ac0 [nf_tables]
 nfnetlink_rcv_batch+0x9c9/0x20e0 [..]

Fixes: 628bd3e49cba ("netfilter: nf_tables: drop map element references from preparation phase")
Reported-by: Yiming Qian <yimingqian591@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c75c2379d30bd..c9a76c760b17c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -828,7 +828,6 @@ static void nft_map_catchall_deactivate(const struct nft_ctx *ctx,
 
 		nft_set_elem_change_active(ctx->net, set, ext);
 		nft_setelem_data_deactivate(ctx->net, set, catchall->elem);
-		break;
 	}
 }
 
@@ -5873,7 +5872,6 @@ static void nft_map_catchall_activate(const struct nft_ctx *ctx,
 
 		nft_clear(ctx->net, ext);
 		nft_setelem_data_activate(ctx->net, set, catchall->elem);
-		break;
 	}
 }
 
-- 
2.51.0



