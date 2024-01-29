Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A0BB7375F;
	Mon, 29 Jan 2024 17:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548549; cv=none; b=eb15PF/FDquGzB1gkaQUgL1DD3V2e+apLtxq5/+1/H1uGDpoHzcxtKzhZ1rEacN8Egs8k6jUDgSu/9drzyK3P91Pz3+lJhfxOlu6HVW3FcTY0vPSWR67E6zseFZwOeNR97BoEFa+GC4klQ5Dwmv1Fy+wREj3L1tc/ueebPXFI88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548549; c=relaxed/simple;
	bh=2LWEzyWVA5Igj/JsCANDi27/ujQqQ9Jcf/nC2PiBAF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k6zSKkeEsOpxFLO6S7PzbUiddcLWnWJ/rR0I84K82B5NsrNSFfox+ZGIxiZFivw/yBTuxGr1F+Fsd0M7IYy4kBkAUzXo7+hhqUzxsa/8vcCNfnBpEVedmROZe7Jam/eYd7pRFOtvn+5wESzhcfszBHY4rMUWCi0vM0tFhoUYJp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=02Y7mnRV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="02Y7mnRV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 006DCC43394;
	Mon, 29 Jan 2024 17:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548549;
	bh=2LWEzyWVA5Igj/JsCANDi27/ujQqQ9Jcf/nC2PiBAF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=02Y7mnRVPMJoVSRzvG5LQtB5RnhLHhpvkp82pV3jWqmMNJD9a6l4R/j+cAdQtXxb9
	 RtZtcWXGfusfWnZ9UmmvilZVA6mvs2TgcXl3QIJ3vB5c740Rlv8W0rVmI7I88nmfAa
	 wL4Dgao7xLM0fJRKiZLo0HJMB+iL3Ej7hiwme7eg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Stach <l.stach@pengutronix.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 167/331] SUNRPC: use request size to initialize bio_vec in svc_udp_sendto()
Date: Mon, 29 Jan 2024 09:03:51 -0800
Message-ID: <20240129170019.805577606@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucas Stach <l.stach@pengutronix.de>

[ Upstream commit 1d9cabe2817edd215779dc9c2fe5e7ab9aac0704 ]

Use the proper size when setting up the bio_vec, as otherwise only
zero-length UDP packets will be sent.

Fixes: baabf59c2414 ("SUNRPC: Convert svc_udp_sendto() to use the per-socket bio_vec array")
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/svcsock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index 998687421fa6..e0ce4276274b 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -717,12 +717,12 @@ static int svc_udp_sendto(struct svc_rqst *rqstp)
 				ARRAY_SIZE(rqstp->rq_bvec), xdr);
 
 	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, rqstp->rq_bvec,
-		      count, 0);
+		      count, rqstp->rq_res.len);
 	err = sock_sendmsg(svsk->sk_sock, &msg);
 	if (err == -ECONNREFUSED) {
 		/* ICMP error on earlier request. */
 		iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, rqstp->rq_bvec,
-			      count, 0);
+			      count, rqstp->rq_res.len);
 		err = sock_sendmsg(svsk->sk_sock, &msg);
 	}
 
-- 
2.43.0



