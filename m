Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EBF935F619;
	Wed, 20 May 2026 17:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296918; cv=none; b=ewOQ9l18roxUQQutb3am1r8MrDTrkO+zvzP2nBkwFr+bIq6Qm42CX9yPV1JhGYi54NSVnz/f43h/Ny/+SP9vcAs0uJHIOQjsZq4lbglUISLe9nEmZNN9XTC+JSbmS5ogV/34aYXYOLG61hWQWHKGC+Rcu5DYDEKkwd6GyGMIpFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296918; c=relaxed/simple;
	bh=ruHPjE31c7miDdDPWSBGz2sp4MtuprIInDD1nDC03jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KDnM9BIg3VEhnojt22vK4ch67Rr7UuWHE4jnE24bC3PRXc+z8voTbhA8mkrP6JQNMTmILSTK9LYLY8+cUjer4k+iSBMDDmCwmIzOBKiKIPG9OJiu3z8Wttowiy3U5CgCZmuPNfDOLsApRqD5JcGKZJkkrM9SB2+x9X2zQLUv9vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N+ED+Jn3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N+ED+Jn3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B58021F000E9;
	Wed, 20 May 2026 17:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296917;
	bh=R3J3uJCgcW4775jifyJAo4w1Ji4FKXyL4yzTBFIAeyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N+ED+Jn3EzBC2pq4hAzbMKBESZX7niW74KQarVs//Voyl0UR3bNZNqN+ca5yGHZgz
	 RqZ05FGcJT70/GEtYZLY1vzDrz6Mfo0BvhMedLTr2LpHSjXlBiVEfwFma0EfH5+KYe
	 2/rKWvDbvDWsor62KmSZhOeq02fER68fJhQaUork=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0981/1146] io_uring/napi: cap busy_poll_to 10 msec
Date: Wed, 20 May 2026 18:20:31 +0200
Message-ID: <20260520162210.432959245@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit df8599ee18c0e5fe343ffe0b4c379636b8bb839a ]

Currently there's no cap on the maximum amount of time that napi is
allowed to poll if no events are found, which can lead to kernel
complaints on a task being stuck as there's no conditional rescheduling
done within that loop.

Just cap it to 10 msec in total, that's already way above any kind of
sane value that will reap any benefits, yet low enough that it's
nowhere near being able to trigger preemption complaints.

Fixes: 8d0c12a80cde ("io-uring: add napi busy poll support")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/napi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/napi.c b/io_uring/napi.c
index 4a10de03e4269..8d68366a4b903 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -276,6 +276,8 @@ static int io_napi_register_napi(struct io_ring_ctx *ctx,
 	/* clean the napi list for new settings */
 	io_napi_free(ctx);
 	WRITE_ONCE(ctx->napi_track_mode, napi->op_param);
+	/* cap NAPI at 10 msec of spin time */
+	napi->busy_poll_to = min(10000, napi->busy_poll_to);
 	WRITE_ONCE(ctx->napi_busy_poll_dt, napi->busy_poll_to * NSEC_PER_USEC);
 	WRITE_ONCE(ctx->napi_prefer_busy_poll, !!napi->prefer_busy_poll);
 	return 0;
-- 
2.53.0



