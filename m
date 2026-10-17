Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA29D36B93B;
	Sat, 17 Oct 2026 16:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254089; cv=none; b=LSKchVBSyMzA0GBBG7mz/h8WHVoBfjc3IOETXrh3AEsWDMi8we1qakA9yevhUKnbMlFzpRW/oXJOUmOaatIY3uEmBKT09gtAAVyKREm6j9s0+izZ3U5QxjBbnXag034RsUVafwUFYYonUUggfCOErXMmznzuS5uJDcKpuh3/Rxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254089; c=relaxed/simple;
	bh=5HPI7+E6ZrU6Su9LWZIncnk8BvVf89VTh2BNabICU0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XH5XXX3+4OjFc4YjM1FY+FCTCuPApMfTXP6ZWjeEn3jMXjOKzp0URBNdk2Pt3SSX3mpfzlYEHgIaYGNU8KUfZC5FrNWMuGHQHe2oilheMx0SBVhMJBW4EVAu9ArGZvoD5KpqD03FirZ6gIiIML2Ty1e1krDAeyXh0PWkAkEQKhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AZLu2ZQ0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AZLu2ZQ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CCCD1F000C4;
	Sat, 17 Oct 2026 16:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254088;
	bh=x2g8c0ZMpV9kF1+S0xdcni/JQIe+y4hmGM/o2nXx4XE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AZLu2ZQ0DwkL8S5z6XsxKDkooZ6txFlrqhfl4/Rjhmg3VjrXpB3NRuiOpRKJeKu4w
	 ZAIYkfaxhngy8/+WHvs5alnvK0+1uXLBa1VuYrm+VeMhj15zu9215eV3Os4HwmRrZt
	 8kgmcaOvehmc2NemmDX5mMqL0fb4K574LBGswtJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olivier Langlois <olivier@trillion01.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 330/869] io_uring/napi: protect concurrent io_napi_entry timeout accesses
Date: Sat, 17 Oct 2026 17:52:51 +0200
Message-ID: <20261017160045.539560658@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olivier Langlois <olivier@trillion01.com>

[ Upstream commit 2f3cc8e441c9f657ff036c56baaab7dddbd0b350 ]

io_napi_entry timeout value can be updated while accessed from the poll
functions.

Its concurrent accesses are wrapped with READ_ONCE()/WRITE_ONCE() macros
to avoid incorrect compiler optimizations.

Signed-off-by: Olivier Langlois <olivier@trillion01.com>
Link: https://lore.kernel.org/r/3de3087563cf98f75266fd9f85fdba063a8720db.1728828877.git.olivier@trillion01.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: df8599ee18c0 ("io_uring/napi: cap busy_poll_to 10 msec")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/napi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/napi.c b/io_uring/napi.c
index fa959fd320429..921de9de8d753 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -60,7 +60,7 @@ void __io_napi_add(struct io_ring_ctx *ctx, struct socket *sock)
 	rcu_read_lock();
 	e = io_napi_hash_find(hash_list, napi_id);
 	if (e) {
-		e->timeout = jiffies + NAPI_TIMEOUT;
+		WRITE_ONCE(e->timeout, jiffies + NAPI_TIMEOUT);
 		rcu_read_unlock();
 		return;
 	}
@@ -155,7 +155,7 @@ static bool __io_napi_do_busy_loop(struct io_ring_ctx *ctx,
 		napi_busy_loop_rcu(e->napi_id, loop_end, loop_end_arg,
 				   ctx->napi_prefer_busy_poll, BUSY_POLL_BUDGET);
 
-		if (time_after(jiffies, e->timeout))
+		if (time_after(jiffies, READ_ONCE(e->timeout)))
 			is_stale = true;
 	}
 
-- 
2.53.0



