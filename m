Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D57B126BF7;
	Tue, 29 Apr 2025 16:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945285; cv=none; b=E+9yPEL2RKlsCxi2Xr5b/syDHtI+C60IWxE7Lgew0UJjPi2oWP/21aNeiY3goZP48xQ4PRUEEOlCpdrv7JrPFv+q8wACHy+P2rw3FlTotiPeYRQNzbkdCF3L9dke1IJNl6C65LFVwSbMwUHDdnNfGIio92KJSpZkPNEerB0+7/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945285; c=relaxed/simple;
	bh=vfCyC3hZaubR3BIFY0RPmn3hPrF5fw1A/JS3B/DPpUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H8xg1aMK18X3hAodntDRBCucymw+klf2YUDvK5W7cRYXawEhoyDs0sU2KayHfAqu0JL9CNDk+Crhn3iPQSlvz5r3gnlpzQP3H1c0+0mltKsByQ5kc5PBy5aAtcIz1ar4u/0Y6E7+8oAtWy3IowBGVnxHg/6L3LMK9jhKcrScv5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ut9H1QzI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ut9H1QzI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E345C4CEE3;
	Tue, 29 Apr 2025 16:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945284;
	bh=vfCyC3hZaubR3BIFY0RPmn3hPrF5fw1A/JS3B/DPpUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ut9H1QzIM0qODMcVaoS9QDVUktEUBT+Ejq4obe+AomYHz38mPaC+yhBbYqgf8Uszy
	 Sgg4bVymCxQc6M7OKHMVR7+904ZvJQUVB6+zMfMbyEz6FoW47gUKkZZ3kBJJoYHice
	 lDu7eFLRcb/yGnmGx/X+eSnx4gFrVPhavOcMW8yI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	T Pratham <t-pratham@ti.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Jens Axboe <axboe@kernel.dk>,
	Kamlesh Gurudasani <kamlesh@ti.com>,
	Praneeth Bajjuri <praneeth@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.4 062/179] lib: scatterlist: fix sg_split_phys to preserve original scatterlist offsets
Date: Tue, 29 Apr 2025 18:40:03 +0200
Message-ID: <20250429161051.914743495@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: T Pratham <t-pratham@ti.com>

commit 8b46fdaea819a679da176b879e7b0674a1161a5e upstream.

The split_sg_phys function was incorrectly setting the offsets of all
scatterlist entries (except the first) to 0.  Only the first scatterlist
entry's offset and length needs to be modified to account for the skip.
Setting the rest entries' offsets to 0 could lead to incorrect data
access.

I am using this function in a crypto driver that I'm currently developing
(not yet sent to mailing list).  During testing, it was observed that the
output scatterlists (except the first one) contained incorrect garbage
data.

I narrowed this issue down to the call of sg_split().  Upon debugging
inside this function, I found that this resetting of offset is the cause
of the problem, causing the subsequent scatterlists to point to incorrect
memory locations in a page.  By removing this code, I am obtaining
expected data in all the split output scatterlists.  Thus, this was indeed
causing observable runtime effects!

This patch removes the offending code, ensuring that the page offsets in
the input scatterlist are preserved in the output scatterlist.

Link: https://lkml.kernel.org/r/20250319111437.1969903-1-t-pratham@ti.com
Fixes: f8bcbe62acd0 ("lib: scatterlist: add sg splitting function")
Signed-off-by: T Pratham <t-pratham@ti.com>
Cc: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kamlesh Gurudasani <kamlesh@ti.com>
Cc: Praneeth Bajjuri <praneeth@ti.com>
Cc: Vignesh Raghavendra <vigneshr@ti.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/sg_split.c |    2 --
 1 file changed, 2 deletions(-)

--- a/lib/sg_split.c
+++ b/lib/sg_split.c
@@ -88,8 +88,6 @@ static void sg_split_phys(struct sg_spli
 			if (!j) {
 				out_sg->offset += split->skip_sg0;
 				out_sg->length -= split->skip_sg0;
-			} else {
-				out_sg->offset = 0;
 			}
 			sg_dma_address(out_sg) = 0;
 			sg_dma_len(out_sg) = 0;


