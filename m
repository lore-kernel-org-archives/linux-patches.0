Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A052DC78C;
	Thu,  2 Jul 2026 16:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010775; cv=none; b=kxZ+GwtEOrA/Cka2Nzv2sMZguDUctN6zMaySWmHsgjULv5N3x8sS2mp8ShnCTXBppy9+MfEopmKY5FwH5ZipxGgUYEZKFImcY4mbLg6QhndXJhhrzsSPPRIliUtoJs+7uDHT5bIq9weZHhDbYj+YDi3BVj2GIBp8w1OZi/MmENU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010775; c=relaxed/simple;
	bh=peQZA4U1ooryZq8S3/zMlg7n2TqQtgPKUv+fuUss7J4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HIiigTuQQF20d0lFGSrCqnDTY3Xz1RNtwPm+9lbG01ZaeRAK90BfUD7rvYxeyjk1OOrTVvy84AHYaBQlc7gNcEgAdek3RJN0g0tIPlmkEGMZRrAkiVqqFAza5Enj4gSXgRuKuOpTjekkkbxGhKzKAU0AnGQ1KHxWCy2RzVNwF0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0JyeMBO3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0JyeMBO3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1EE91F000E9;
	Thu,  2 Jul 2026 16:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010774;
	bh=d8BA7OBHDrLxYWiluFl9V9GTKj/znSRvm5GCwB7TwSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0JyeMBO3sHzEv+wMdYr+0d3aA6htgxYZTvPTPc+1b8etnLUFi2ptYEGmeksJIc/iB
	 j9LRHCEOSum0jvjpNv0PFmye2gd+YobtZGlos44DUUpOL9P0f0TO8oYWlyOZVz7z/w
	 ChQ9R9bV5r9HcB2ABaYR+J1vgjIhDjCZuL81LHKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Shivani Agarwal <shivani.agarwal@broadcom.com>
Subject: [PATCH 6.6 031/175] netfilter: nf_tables: always walk all pending catchall elements
Date: Thu,  2 Jul 2026 18:18:52 +0200
Message-ID: <20260702155116.453188734@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

commit 7cb9a23d7ae40a702577d3d8bacb7026f04ac2a9 upstream.

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
[ Shivani: Modified to apply on v6.6.y-v6.1.y ]
Signed-off-by: Shivani Agarwal <shivani.agarwal@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    2 --
 1 file changed, 2 deletions(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -652,7 +652,6 @@ static void nft_map_catchall_deactivate(
 		elem.priv = catchall->elem;
 		nft_set_elem_change_active(ctx->net, set, ext);
 		nft_setelem_data_deactivate(ctx->net, set, &elem);
-		break;
 	}
 }
 
@@ -5615,7 +5614,6 @@ static void nft_map_catchall_activate(co
 		nft_clear(ctx->net, ext);
 		elem.priv = catchall->elem;
 		nft_setelem_data_activate(ctx->net, set, &elem);
-		break;
 	}
 }
 


