Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D03D2561B3;
	Thu, 17 Apr 2025 18:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913487; cv=none; b=NTyMYIFfDBJROIRqmINEDwz+LgP+zEgLN0OBiuWUPsXxqyM4YP/sCng2XJIpJzKopMaYyhQ3JI3Latc2NaZeuoNxT9NKPzHSHh1KFeWY7EBDUQkgH87ds0wq4bNOX7q1Tou6UvUr9JrF0mKe1QZT1nJ92F229pIZ+vA0TmxRIzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913487; c=relaxed/simple;
	bh=VunoKxkUY1WitWyEl5CnfUA8Pd72N1tAWCHaFuFzjzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tmNdQBdjiBTtRtuoOv7ZiA/uKbzmKOXuiyR/s7jWEeKaLYcOXaM2Ri9AW2tIa9HAeZdYBjTH1xH5zwceeYjPwELazuqGgWqSCTsuOS/n+obfx3WXwTwrroBH3CO74F2OlSk/aPokqOyJFdszQVEKRhhLj1VIuOiqq4aorpLv5Ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jyXJg4L0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jyXJg4L0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB061C4CEE4;
	Thu, 17 Apr 2025 18:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913487;
	bh=VunoKxkUY1WitWyEl5CnfUA8Pd72N1tAWCHaFuFzjzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jyXJg4L0VZNBkUbBAEXXGAHJ1uccEssU/sVa9MlU0Db+Z0Z53FXtL6FTmQ5hNcsc/
	 noPubw6LpJj2bxyXjURQQPi82VEw66xiDnIsxnRA1Zgqofy1KuOvG8zv/OoHPt1xOi
	 qye3zT8pGPABAelBgXagoEgIl4c6rzRb16970m4c=
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
Subject: [PATCH 6.14 328/449] lib: scatterlist: fix sg_split_phys to preserve original scatterlist offsets
Date: Thu, 17 Apr 2025 19:50:16 +0200
Message-ID: <20250417175131.336051109@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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


