Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020714;
	b=ZHBozE1eFEzeHkRZDKIQShd7zdRTs0+Hj8uEsedCtJTZLJamm+QfWVB/rPth8Rlhkx9X
	 ysdzEc6mgnh1S73efvIs5C+UIZpZuNXiGpgseat/JbzBTJMBk/CxchysxO+tNnFiGHO/+
	 Fs3JHDHd28cKUlq+oWmr+3sS2O3zNefc1Xx67eArl/DL4oMFyrOnD2gDMIEpn+5/F/NWu
	 aJ389YHwonR8fPLEb6lL0FffPsk9vNlQ1iMbpfai50DpOcBErwaYcprT/aop6JBWaAi3q
	 8urkfZ0pziUzndvZOQcejpXEAufvl2i4O/mdyCE3Ce1myX9QlyQRKq/9nNqTaynKSmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020714;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I4w4vYbSpXSi1RgnvmjMJjE3KgejJ6CTmuLB1HOCoOM=;
	b=2Tx0fYRLGsQNAElesrBrMs/VZSbxXTIE8DfNtC/kPVKGg/AAJf/WIltYHdo18eIUiPOz
	 +kJ9WYQ+WGa3OvtgMacXHkI+4finZ19L8g0x91mqFc6TSi/+LKMF67BZGpbp3ZeRT41ST
	 vxOn/eeUH3NCaWfItxT1M0Nezk/yqPgjsJyFv34t+GfDyQBVVwirL3+8P39I8ErW+lFBq
	 yFeRAAZL88aV+vCoW8ZdhGozo1UcpysSV8Xuc9Egcyb+4DjaxueSpJ9wqeIAL9/xR8O0s
	 rSU742W8ckq0b3EXQPTNccraTRQhEbYwILzqITx1LShOY+cJfR1zyssAGEEBnlaxlLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qPK6cp1N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B8A606A336;
	Wed, 18 Nov 2026 16:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qPK6cp1N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4DAB1F000C6;
	Wed, 18 Nov 2026 16:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020714;
	bh=I4w4vYbSpXSi1RgnvmjMJjE3KgejJ6CTmuLB1HOCoOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qPK6cp1NY0vLmz5jw7zXWRGCRf2ygWnATb0ua3kfNCLaFkUGLxxqCHlTEXEIT782T
	 Jnuf64CoZH/p2ITEig6YUahiECBU6o1EUhCR3DwuMo4X8D4BoOprF8oqJQ9X55nK1L
	 vPOZeYAzB/eAReZ99BIBbjCtoD0z2ydEuyX7oxA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Cui <cuitao@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2048/2651] blk-iocost: charge zone appends as writes
Date: Wed, 18 Nov 2026 15:54:48 +0100
Message-ID: <20261118150359.809883481@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 23445d7014334..1ff7ffd7a5258 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2545,6 +2545,7 @@ static void calc_vtime_cost_builtin(struct bio *bio, struct ioc_gq *iocg,
 		coef_randio	= ioc->params.lcoefs[LCOEF_RRANDIO];
 		coef_page	= ioc->params.lcoefs[LCOEF_RPAGE];
 		break;
+	case REQ_OP_ZONE_APPEND:
 	case REQ_OP_WRITE:
 		coef_seqio	= ioc->params.lcoefs[LCOEF_WSEQIO];
 		coef_randio	= ioc->params.lcoefs[LCOEF_WRANDIO];
-- 
2.53.0



