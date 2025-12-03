Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503F234BA28;
	Wed,  3 Dec 2025 16:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778477; cv=none; b=BmvFuHG/FDm5+TorbiNjKTNOKX7LcoCyjkPu6aEBUSa38UwFVNBH4yS37bNWZbm5du8nAqTXeF/hWZoWqdf4PLgHF5N3RA82ocM21ComARTZRynP4u/lVY42lcTwacvcY5RRbU1qMGw2WSInrB2ENqdldPQmINDghnRsNR56R1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778477; c=relaxed/simple;
	bh=J7kR6cFGXGms8u2EOdBxhGwPiPeSThneeD5Q3mmYuhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t8Uq2RmeeMmXwpYvbVMLgI3Pffm6qkwT3g3uMRVw77sQ1GRlJsdfnrhYWG5hdUIY14+Tn4LdEms7SZeaYrN3wE2301ej4Foaqt4F4Q98Cyi82ktMshvqlmfHMo9znsxm1yKzTCOsxE00rg+ZQP1A8g3d1uyahhPrbUsqyayQGEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ab4W6ch+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ab4W6ch+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3736C4CEF5;
	Wed,  3 Dec 2025 16:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778477;
	bh=J7kR6cFGXGms8u2EOdBxhGwPiPeSThneeD5Q3mmYuhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ab4W6ch+ecurmZ5+H4Mf+wmGyaqDHbxaVyQJiTZSizBWyaCJVBiX1n7Z1gR0etGKQ
	 muo+dxFRb21eUiRfc4CVcLM4p5x4ZL5wdEBbhbyQX/Hs579J7BOnifa65pSybBEBLb
	 8lxddMVfCLl6bzkUtVZoHLtndLOHzs9Lfq1OjKBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 5.15 358/392] dm-verity: fix unreliable memory allocation
Date: Wed,  3 Dec 2025 16:28:28 +0100
Message-ID: <20251203152427.339754563@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit fe680d8c747f4e676ac835c8c7fb0f287cd98758 upstream.

GFP_NOWAIT allocation may fail anytime. It needs to be changed to
GFP_NOIO. There's no need to handle an error because mempool_alloc with
GFP_NOIO can't fail.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Reviewed-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-verity-fec.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -314,11 +314,7 @@ static int fec_alloc_bufs(struct dm_veri
 		if (fio->bufs[n])
 			continue;
 
-		fio->bufs[n] = mempool_alloc(&v->fec->prealloc_pool, GFP_NOWAIT);
-		if (unlikely(!fio->bufs[n])) {
-			DMERR("failed to allocate FEC buffer");
-			return -ENOMEM;
-		}
+		fio->bufs[n] = mempool_alloc(&v->fec->prealloc_pool, GFP_NOIO);
 	}
 
 	/* try to allocate the maximum number of buffers */


