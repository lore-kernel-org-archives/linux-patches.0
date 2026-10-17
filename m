Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7673138654F;
	Sat, 17 Oct 2026 16:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254425; cv=none; b=px5xScXJ0Gpznz2GZDVWE6iMAXNR7Pb7i1zvYfJ783u4in8w6soSDZhKgOZ4eOQsfJGMggL4E/2vunP7yPy3sS0v2Fi12h1QRvE/hBbLopcqn1LCSoeJ6/NhcmMva/vBrh9pnZU5Q1newJWcEIzwlwv4mF4qmEpLwmz7ZSxvqgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254425; c=relaxed/simple;
	bh=agIn7Ab1nuquaciQE82gFATOXiYcD3E8i55ZWKwBn+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XXzmKCDh1u04dxru/gjeR+yOinmmIVE838rPiMFccbYnghJYW2wxd7n5uZ6tq1Y63jO2zV9HRohJLFDoJc/AqX54DgnXqyt+/UhWbydJgyAl0+V650z/97mBFMifCGlotePtsbPjvY2BWdp6Uug8NKiyQahs5+iU/y+1Bt9o+Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hek+hruM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hek+hruM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC29F1F000C4;
	Sat, 17 Oct 2026 16:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254424;
	bh=J6ALUerKi+CM48uUfRrWPEXmjdLZ8sXTxi2z/LkbOgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hek+hruMAfbCzkuqI6B/g5qJc8gwNj8sXZPBCjkWso4P9psaOOxq5DmyI61SJIkp7
	 BbllLHG+ajp9QSl03HSexI7sFc2z/2BliNDBRczUWOwEyfAtOE2Hh5TVvzCNlntGm5
	 RUDY5tl++wPPHgB79UVBVbyv7Gb9uF/H3a9Z3zDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 425/869] dm-verity: fix buffer overflow in FEC calculation
Date: Sat, 17 Oct 2026 17:54:26 +0200
Message-ID: <20261017160048.033131718@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 31d6e6c0ba8d5a7bd59660035a089307100c5e8e ]

There's a buffer overflow in dm-verity-fec:

if (neras && *neras <= v->fec->roots)
	fio->erasures[(*neras)++] = i;

This allows *neras to reach roots + 1 (the post-increment pushes it past
roots). This value is then passed as no_eras to decode_rs8(). Inside the
RS decoder (lib/reed_solomon/decode_rs.c:113-121), the erasure locator
polynomial loop writes lambda[j] where j can reach nroots + 1 — one
element past the end of lambda[] (which is sized nroots + 1, valid
indices 0..nroots). The out-of-bounds write lands on syn[0], corrupting
the syndrome buffer.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Cc: stable@vger.kernel.org
Fixes: a739ff3f543a ("dm verity: add support for forward error correction")
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-verity-fec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index 56813d02d5465..b6115ac9c8256 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -263,7 +263,7 @@ static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
 				     (unsigned long long)block, PTR_ERR(bbuf));
 
 			/* assume the block is corrupted */
-			if (neras && *neras <= v->fec->roots)
+			if (neras && *neras < v->fec->roots)
 				fio->erasures[(*neras)++] = i;
 
 			continue;
@@ -281,7 +281,7 @@ static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
 			 * skip if we have already found the theoretical
 			 * maximum number (i.e. fec->roots) of erasures
 			 */
-			if (neras && *neras <= v->fec->roots &&
+			if (neras && *neras < v->fec->roots &&
 			    fec_is_erasure(v, io, want_digest, bbuf))
 				fio->erasures[(*neras)++] = i;
 		}
-- 
2.53.0



