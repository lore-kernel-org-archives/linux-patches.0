Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056491;
	b=FdHLYN/YjpuNEx3aG6Nhohnmg2ohMbeWxq1SYzfjhVqQ1F8IQII3BTaxpLW81vWsjHGv
	 SlteZFDZQ20JXiN9mDLGY0BLcYsCDOyyfCi79Cz5pH6srY5MYUV/m9IQhSybnTvDEwv1/
	 So/iamjKu2FzuzgNMSlx1DiGlrVD5nfUFrzzMKrH6Ajruesi8//5ATMMUUZUiMxf3PT3a
	 3goDajECCF4EeKLfVHXlilhv4vXrx+6Yw8xpSKNJMjRYIcKSr0Iljf58K8IZytVqXGD3d
	 MoVX/RBa8GOjFZdTEBLY2XfD2czaa5s34IWTHCNhIdby3bkfyHl/McWDDcVLDLXh/9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056491;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wZOFFerVDKjJRlvZx8HR3J6CSSzHiPp4ifIykKV9K28=;
	b=ewD4TaOc/AaKRy3KtPEuACoyKl0bo1xplWFDE6DNKLIzyS8iNhd6OmD9GobhrGWIxd4/
	 OAEgIIS0DebK4x5TjCetUlSfaaDj4CFWGS09v80r83nnmVrHmcH1PGbYoPOAOkPZyPdM+
	 3Vrw5E6cimbcfSAQkU1Y8Y1PLfQLPl4B+nPOs0Y3Jthh1jFeLlbxv1TMbKnGjwDE4U8hQ
	 mK6Ks96mElQrUw/aH8XXO4dx+dpg94/ba57JWpxP848vBxu1oIHh66hek09xNQTdMcJq0
	 ztNJT7Axzc3Nci8y9ryfWILcqNzpjCsD0B+gs+AJjeEzd1thm/8JSTe4XEBffm5RCPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SgoCXJb6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12954606A32C;
	Thu, 19 Nov 2026 02:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SgoCXJb6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E1CA1F000C6;
	Thu, 19 Nov 2026 02:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056490;
	bh=wZOFFerVDKjJRlvZx8HR3J6CSSzHiPp4ifIykKV9K28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SgoCXJb6SuGYODXOg/VPVjkN61cMJS46BJDZCozM26tPkClHRVE9t9g++0zc+RzOc
	 NugHYBY/QpAEKI8AWfTTtiB+8jFyRSm+E9iYlQzgUOnlbw9AJkzppROzcBLt3Y6wIJ
	 9UQ6a4zosXqDNe/3Jun+rYlT+dThdFYs6r7uzQh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Cui <cuitao@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2008/2214] blk-iocost: charge zone appends as writes
Date: Wed, 18 Nov 2026 16:01:24 +0100
Message-ID: <20261118150131.080026585@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tao Cui <cuitao@kylinos.cn>

[ Upstream commit febdbf5682fa7e8f325b07a2c115e7632c4252bd ]

Zone append is a primary write operation for zoned devices; zoned xfs
and btrfs use it for data writes.  It is priced at zero, so the zone
append portion of zoned workloads runs outside the controller: a
1%-weight cgroup issued 16000 appends at zero cost on a zoned null_blk.

Treat REQ_OP_ZONE_APPEND the same as REQ_OP_WRITE so it goes through
the existing seq/rand classification and charging.

Fixes: 0512a75b98f8 ("block: Introduce REQ_OP_ZONE_APPEND")
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://patch.msgid.link/20260922043856.2020116-3-cui.tao@linux.dev
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-iocost.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index eb19e92e8e5bc..0206fc577e84a 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2537,6 +2537,7 @@ static void calc_vtime_cost_builtin(struct bio *bio, struct ioc_gq *iocg,
 		coef_randio	= ioc->params.lcoefs[LCOEF_RRANDIO];
 		coef_page	= ioc->params.lcoefs[LCOEF_RPAGE];
 		break;
+	case REQ_OP_ZONE_APPEND:
 	case REQ_OP_WRITE:
 		coef_seqio	= ioc->params.lcoefs[LCOEF_WSEQIO];
 		coef_randio	= ioc->params.lcoefs[LCOEF_WRANDIO];
-- 
2.53.0



