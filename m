Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC79D24BD02;
	Tue, 29 Apr 2025 17:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948809; cv=none; b=FkS4k/stD8LdJueRSCns35DTR9sPFp+4qyI4dDyOf5gy/9bLoVeMXbVZkKp3QrPbV+ldvRM5lhLX5izvMyQ5/MeUO9p0UEAciO6CZPu4Fhe9fwArktjiOSl4S0aCm3qps3nGujr0Dhuc7+jZG4ONYMj/a7JOGFKkhVQZBrc3Zko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948809; c=relaxed/simple;
	bh=TgUt9oMsA19oNT1taEXpRhF9dQMvSt4cY3vRqcMjMUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NxvpbF/u0H2ZyNYhRCPyim4h83jFjaLfubONtH2OnnmR9zcEDDNRQda8C9y4h1L/w3ucq/q8LeW70oNfJL1gwFosntQ3/+olyz/wquRagQ+kGnNbxEgKY8wPsrtKY+4/3k6DHNva/h+6FRGhXdYYz7Lsh6ayXXdHVZ6UZSJO5Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K6N2JsfP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K6N2JsfP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4120DC4CEE3;
	Tue, 29 Apr 2025 17:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948809;
	bh=TgUt9oMsA19oNT1taEXpRhF9dQMvSt4cY3vRqcMjMUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K6N2JsfPUavuDxayGI21chNS/p0ERl5i0MbKf67X+HYuHEA9PbynWSH+HL18OW0Fb
	 OA73t/VYa1m81UHoc6a4Rd7SPf/1CeXxoNsgXy2wE3EL5+M8I3g6kLIGJn5TAbTLi8
	 A2UYqRUPloXv3cBkzNPvw9CGAM26n1qfOI6xEQHE=
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
Subject: [PATCH 5.15 093/373] lib: scatterlist: fix sg_split_phys to preserve original scatterlist offsets
Date: Tue, 29 Apr 2025 18:39:30 +0200
Message-ID: <20250429161126.984531227@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


