Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620864;
	b=mIJQOtDeXTva8w8AHIFNTjg2kHG6hudznKaBrMIWhjmV7CsCxbW8Em4Yb4T2EbhH6r5I
	 DS8kPGhmUxdDWsfW5YbmRgVP9zq6ys92g/SKrv3SZenL6TK4QFyPzy6yfNJsxFyUI37+n
	 msbKWWi2whBV96Z0+kTBieNF7YZTtolSrHqrnxcUO4jlHzuODvGKpYEKntX+RwqQ4Ehov
	 8cO3EDw1rd421ohOAS0laQ9JYlAgIs0zBPYp7lVR7vcK7Iu6qYfU2MWIqaUCESyR6Vc/g
	 ITV7aEXnicHE5L/Gs1s6RK4sUdnt0rp0QMea5aekXdddmZ7ywozI3d2FsGY+T96MHng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620864;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lkcCN+NWqWMpz55Ed67lVJjPWQqj6PfOmoy/ztNCxhw=;
	b=EgmnZG7YB5HsC0u0NxOs8iYZAnNSsb7qA6/oEa4O+MLmbyvEEPHQwZAkcRNnPOahmwpq
	 L+Bh2JXTORuocwW/WHqnmEiOpczQjtWHepOqaT2dOuDAcfaKid+9Jk2stJ+K42lXzUkXy
	 KCuxE8Vy2YQeLkRbk6NsMeyUNyx+lpOOxwj7ZdO/9S1obKos1vgySZSlZZWsVGEAznJzs
	 Aeg6FKmUk133dqfLEwV0wm/GMm4JusUKaFA5ZaaR6sbiNkvwLRhEMmqL3J4jO7XlFCg2t
	 uv4Sg++/KdTRjwjhpN34nXrSYWBTq/HdYTv8kYoh4h8CrW/e06TX8hvtB1L2cqsICtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YUWloNzp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C899606A32C;
	Wed, 25 Nov 2026 15:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YUWloNzp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CA8C1F000C6;
	Wed, 25 Nov 2026 15:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620864;
	bh=lkcCN+NWqWMpz55Ed67lVJjPWQqj6PfOmoy/ztNCxhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YUWloNzpUOH/4hP87L/tkJZK3/jUoChj8eJESCBPIy1FFg0ktgPXzsU/wgmr7GHD3
	 YwwJa+pn1uSrh423j9Wxg8EAyHwhb1SoBpuQSvR67fJs00GVpFmVHpyfvw8/phf4cF
	 CPW9QGuUiuJJhm+9SPvnKclWm2VYTvZiX+ZB54qA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 046/990] io_uring/rw: fail soft links on IOPOLL short or error IO
Date: Wed, 25 Nov 2026 15:23:33 +0100
Message-ID: <20261125143823.170419139@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Xiuwei <yangxiuwei@kylinos.cn>

Commit 4d3db66c5363dcf42c3d43ebaea330ac2d1888bb upstream.

io_complete_rw_iopoll() updates cqe.res when the transfer does not
match the requested length, but it does not call req_set_fail().
Soft linked requests then still run after a short or failed IOPOLL
read or write.

Fixes: b66ceaf324b3 ("io_uring: move iopoll reissue into regular IO path")
Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
Link: https://patch.msgid.link/20261114072246.741950-3-yangxiuwei@kylinos.cn
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/rw.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index f46d08bbe9d88..48ef87b4697bb 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -618,8 +618,10 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res)
 
 	if (res == -EAGAIN && io_rw_should_reissue(req))
 		req->flags |= REQ_F_REISSUE | REQ_F_BL_NO_RECYCLE;
-	else if (unlikely(final_res != req->cqe.res))
+	else if (unlikely(final_res != req->cqe.res)) {
+		req_set_fail(req);
 		req->cqe.res = final_res;
+	}
 
 	/* order with io_iopoll_complete() checking ->iopoll_completed */
 	smp_store_release(&req->iopoll_completed, 1);
-- 
2.53.0



