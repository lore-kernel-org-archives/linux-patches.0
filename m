Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046411;
	b=zOzGWJ1bqeq/BMhnbRDVS8UC8M1LSrWG2kln9seCAARdtG0hwEsPcaBsKGC688BxLeNC
	 yp/9Tzdi4snx7Ih4+vfvNZboJC4trZSvuheli+cctEfEx013FELxu5PMtcNxh5X9fjFLD
	 HldXh4Pg2uodMUGLVIlorStlrVN92/r2eKS1+iABaW/4WzvG6sv/cYUP++sZ8TSjkVV3a
	 bz4nnphEr7UqcWgiYQkcLoZsaTGVn2ouykxil2GeA1kjoshDnnPl8vEs1ZdtyCJOS6bTD
	 xQi4GQOr1CWbdU2I14TkZJckvxw4e7DyaFvbI7SG4asTsHTRpjQmflUsMJz/JSlOmSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046411;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WSWOrzQoYwN3Buh9V1DxtDGukRC9OYoQRP7KjqhpGIY=;
	b=We6Agy9fR4R5BX951S/bIzwobVQBEc+QasEyjjgVFM+s6DxVV8Ri2gUYju5haH023GWz
	 27meruaSyqE16ARjoYEqSoWPGmyEOC1rgrs4Ske0mKVP56Wc9L0rcfSoFLJ0nnYMM1s6/
	 HS+u0qhSt3TDsr4hI+uHX9axhOznI8UGQr+FV2PeLj1KxJ4TEojg3v8h9IPXki4y8P2qo
	 Gou6noDsnFH1kH8gid4lu5W/Y6rCS5ioml1LYn3VEVmLcPJtFEePX1ZGGp7zt1f5XUOwK
	 l0RIfe/9xsVJspWeqiaupLftxPc/m7uf2m6fxSZ8l9Pr1FYpr8a7mkspKURdAfwUKKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yLiNiBES;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6D9606A32A;
	Thu, 19 Nov 2026 00:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yLiNiBES
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E731F000C9;
	Thu, 19 Nov 2026 00:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046411;
	bh=WSWOrzQoYwN3Buh9V1DxtDGukRC9OYoQRP7KjqhpGIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yLiNiBESm1P7WLUVQ2oxECdqukiz9BzOHjwnZ6rK1RBbylmSmbihNCx3FGQgDtgh4
	 j3PNLaTylf1i8hjRPlPfxhWM/Byl5+N5UXSS3tx6yIaJXwsHVX3tGCdc57OyUHHf55
	 hePM2QKkewaRLp7uIHLxJLh4FFfAAQDeyuQLgLdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhe Liu <liuzhe1@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1271/2857] blk-iocost: account flush sequence latency only once
Date: Wed, 18 Nov 2026 15:38:25 +0100
Message-ID: <20261118150247.283188915@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhe Liu <liuzhe1@kylinos.cn>

[ Upstream commit e9804489e27dd6e33aec5511fe3780ff3009f57f ]

A flush sequence with a DATA phase can complete its original request
twice. Both completions invoke ioc_rqos_done(), causing the request to
contribute two latency samples and adding the same queue wait time
twice. This gives such requests disproportionate weight compared to
ordinary writes, distorting the device-wide latency and queue wait
feedback used to adjust iocost's virtual time rate.

Skip requests marked RQF_FLUSH_SEQ in ioc_rqos_done(). The flag is set
when the request enters the flush machinery and is still set when the
data phase completes; blk_flush_restore_request() clears it before the
final completion, so accounting happens only once, after the whole
sequence finishes. The remaining sample covers the request's lifetime
through any postflush, and its queue wait time is accumulated only
once.

Fixes: 7caa47151ab2e ("blkcg: implement blk-iocost")
Cc: stable@vger.kernel.org
Signed-off-by: Zhe Liu <liuzhe1@kylinos.cn>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://patch.msgid.link/20261102061802.408173-1-liuzhe1@kylinos.cn
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-iocost.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 7600aee06f840..1b6cb8d8bf8c6 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2797,6 +2797,9 @@ static void ioc_rqos_done(struct rq_qos *rqos, struct request *rq)
 	if (!ioc->enabled || !rq->alloc_time_ns || !rq->start_time_ns)
 		return;
 
+	if (unlikely(rq->rq_flags & RQF_FLUSH_SEQ))
+		return;
+
 	switch (req_op(rq)) {
 	case REQ_OP_READ:
 		pidx = QOS_RLAT;
-- 
2.53.0



