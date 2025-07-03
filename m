Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A712E339E;
	Thu,  3 Jul 2025 15:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554934; cv=none; b=qsBegSE6KckLmGnDP/+B6GI1UWB5+29sp7WUGtKtX8DeBSBKU33+zqblS+pOequIsKDEvYqJ64OByPBNkLzx996cZeXWgiPyw/T3ar+SU8ELo0XRpwLPwHHURzjqOQpEYLrdpNnuFNP3xlCrAmI7URycQQpsMbNs5jrIfhCmIKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554934; c=relaxed/simple;
	bh=pe+pmp1J4l5DNaG7S6O4Exqsbf0n9yyQ2bruNyVrPOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YBl4ZlMMB0xZ/v2kNFhNgkuwQ96n6RK1VwukNM9qcCrJ1usx8zMRN/SbV0FRp+w3Cydkc67MfTDufLHZ8Ym1bw513wRyAS5u+6zy5Zm/8XxhpxODF7KamKWeV/v/zoc+v8OHEug3yVd1hbTAT6kF0FiBVl3OfouRHo1963fgosw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dpfpAVfI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dpfpAVfI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10F38C4CEE3;
	Thu,  3 Jul 2025 15:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554934;
	bh=pe+pmp1J4l5DNaG7S6O4Exqsbf0n9yyQ2bruNyVrPOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dpfpAVfILT7+yauyzJ0sZtqJImyYNlOC74UM+oi55eN2ymJbfYaTM6nhzfO219T3c
	 TS6tbUt5OG2V1yoUhmfcPWOCj9hgwYFNg+wfiX2lM4VmJ1UQVJj8Ij0RG4bKTcexM5
	 QodBRgmii1IcQwa+zM/3K68vvr79ZpC1TTUfIt7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 094/263] io_uring/zcrx: fix area release on registration failure
Date: Thu,  3 Jul 2025 16:40:14 +0200
Message-ID: <20250703144008.064147616@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 0ec33c81d9c7342f03864101ddb2e717a0cce03e ]

On area registration failure there might be no ifq set and it's not safe
to access area->ifq in the release path without checking it first.

Cc: stable@vger.kernel.org
Fixes: f12ecf5e1c5ec ("io_uring/zcrx: fix late dma unmap for a dead dev")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/bc02878678a5fec28bc77d33355cdba735418484.1748365640.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/zcrx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 7214236c14882..a53058dd6b7a1 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -222,7 +222,8 @@ static void io_free_rbuf_ring(struct io_zcrx_ifq *ifq)
 
 static void io_zcrx_free_area(struct io_zcrx_area *area)
 {
-	io_zcrx_unmap_area(area->ifq, area);
+	if (area->ifq)
+		io_zcrx_unmap_area(area->ifq, area);
 	io_release_area_mem(&area->mem);
 
 	kvfree(area->freelist);
-- 
2.39.5



