Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624055;
	b=WT4znKjjlm72g0eSncC3IVKLXpJWheQZCl8LxtgaqNLh0r0elHrsPJEgroPkG3sIoKfu
	 wV7aBDJydMFMxo+jRy1DSduJRy6Poi6m75He21XpEpOVIP2/Pmcf6a4s5ax5aS4ms2xxx
	 L4SYqmvBMd7QBkU33lsEvX/LlOJzEsHpepHKoWEXOXPohsAdaDgxX+DjPXdfmlk2VMmqa
	 2EwoOYI707iqRfASk7AeEdI66Ri3pL1hBUY3Ap/kkI9sL439k/0Z5kEFHvmuaRLop65Ha
	 1FTRUEUZzUhQ52PXKieqhhndIGJnfoh8n3hSd+7REim2fWUYRCSZTRWZyj90uPUV/Cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624055;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QjH7KmPtvOXV9ZRbu4BNHB3Ds2xlY8sSIFqJoFeJUtw=;
	b=CxDSiG84J0dHd1IelpCb2tARspx50GgFopqfWOCRwg1O93innBRJvdT/4zXKCtWRT/M1
	 6OwiRh12nKVFSsrQbnP4jKUrVEvRs5BtcD0QDjj/sM4SDGeLxzGfqPDBYy3sQv1KdeSre
	 ac84k7hV6Q88sCsnaj4ZYlA8sYkm4EzpJUeGs+Ba3nu7XaTdZzzG4AuM/swj+gdhzgEcA
	 tI6iRwN9A8aEfSVKItUYymK1qHkG0+V/GWoND6CKWt5hIwiFdvGDHVUGYgI3ma/0YiCU8
	 Mn5NBF1wRjzQiQRf/Ljd8eRbgiWIyoAlQJ2mW9dRupvwd8n3PPSKqiyXhUvHdmQM0tQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gjfpl9Lk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2944C606A321;
	Wed, 25 Nov 2026 16:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gjfpl9Lk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E23A1F000C0;
	Wed, 25 Nov 2026 16:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624054;
	bh=QjH7KmPtvOXV9ZRbu4BNHB3Ds2xlY8sSIFqJoFeJUtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gjfpl9LkO9M3yL25iP8lAOuRM5zjotrDC6YU+pXIavi/KuCLfPYZgavqVTXlOnRvy
	 8+22M3Gl34h+jCxJ6zYmwXW4i1cya8fkjRm22qtizly1iwHHMVDtHCDoB84sDjvfwP
	 8uiFweLGf4k9ORPJ4HX42EeeiBevSHSZIiDAFE7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 034/816] io_uring/futex: fail soft links when cancelling a wait
Date: Wed, 25 Nov 2026 15:26:22 +0100
Message-ID: <20261125143850.008673456@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Xiuwei <yangxiuwei@kylinos.cn>

Commit 9a7cbe50dd95594d6fb3c57b8454ace58d8d8d0a upstream.

__io_futex_cancel() completes the request with -ECANCELED but does
not call req_set_fail(). IOSQE_IO_LINK dependents then still run.

Fixes: 194bb58c6090 ("io_uring: add support for futex wake and wait")
Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
Link: https://patch.msgid.link/20261114072246.741950-2-yangxiuwei@kylinos.cn
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/futex.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/futex.c b/io_uring/futex.c
index 990568baf393a..59b679e1e26f2 100644
--- a/io_uring/futex.c
+++ b/io_uring/futex.c
@@ -108,6 +108,7 @@ static bool __io_futex_cancel(struct io_ring_ctx *ctx, struct io_kiocb *req)
 	}
 
 	hlist_del_init(&req->hash_node);
+	req_set_fail(req);
 	io_req_set_res(req, -ECANCELED, 0);
 	io_req_task_work_add(req);
 	return true;
-- 
2.53.0



