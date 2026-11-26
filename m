Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704413;
	b=BIeq4Cja1VpbYdEuQxHxUKsM2wu7KppSWKJ4aGKyXXPWJhjkxYk+qX8ttYxE7gXiUW9a
	 kXGYYyLdmYiozJnMDQ8btfcAtTJc+CCSYIYsb5kThIa0FWaa2Urbuw8aHfPaDciHhrU9F
	 CpU5fSCa4djwnSEN09G+X6YOv28qseP/MkvMTDd089gp4rs2S+b1XRlpUjz92V/yU3iJP
	 7t3n8+rYlgoP7jUvlieMTgqJqR6xXIcVona1P8kfCMHk3omjykEMC19xQJJI383jgy9Yl
	 zgE5GuAevK2F9zMGwhaMhTr74/C1y1cnEXsw6eImt7lLDa6qBk55YnujGw0Z/D/tv9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704413;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PFC8gVmGOgYLcZSZDPJBiMgKNbg2uvUFMdAUVIq2YOg=;
	b=AMX5HIvth+/7oP6tShtIpqdFo9bRGTqR1Lgn/AA0DXug6K3nMmW5pa6S+NkYYjQO67+c
	 An3y/zOVDNBXBlChytzJtSs2vJjPAnYZvE9LYPf82UTBB6bxDIGiF6RaMLx8qzGD5YHX5
	 jm/NFvlhKBqy5++Qfj5yBXz9WmGxWN5WDR5zLpenneBb/FTQAn2t2Yh1iTOHBS4CEU5oI
	 T8stYOySYC/nrLAaRpEX82pblZG3Hc/6irf6E2xt3jlMs1awHksrgKu0XMg7W7Gwh91NK
	 I0qBG2Cq7Pvsu+JFUO7WlshOrzD7naBMkqyNFs/qxLiAxmVok+G2ejTaZt5ZdKWwExg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bG6qoZl4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D611606A31C;
	Thu, 26 Nov 2026 14:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bG6qoZl4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 450671F000C6;
	Thu, 26 Nov 2026 14:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704412;
	bh=PFC8gVmGOgYLcZSZDPJBiMgKNbg2uvUFMdAUVIq2YOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bG6qoZl4xCbSQ3UNNz1L9c0z9OBqqpWUCmnLHGjJj3vpI9ZqKgMbEK6N2Wq0f7SOw
	 d80ii9QMurGW11SVmWuhFUWVRogxbQSZ3dS7pGuqPEdMHPFRxYNZvEJBgdgORoigGo
	 X/Vt/dmcJoeE5zAlNLjRQ2DCIgJ+DQObBHEi6jxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 116/265] NFSv4.1: retain MDS I/O until both thresholds are met
Date: Thu, 26 Nov 2026 15:37:26 +0100
Message-ID: <20261126143613.124230205@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit eab627dcd18a18a44a2cbee47df3058d3637ba0d ]

When both size and I/O thresholds are configured,
pnfs_within_mdsthreshold() uses size && io to decide whether to
keep I/O on the MDS. Both variables indicate an unmet threshold,
so reaching only one threshold returns false and may trigger
pNFS layout acquisition while the other threshold remains unmet.

Use logical OR instead of AND to stay with MDS I/O until both
thresholds are met, as recommended by RFC 8881 Section 5.12.6.
The new RFC contains the same threshold selection rule as RFC
5661 which is referenced in function comment.

Fixes: d23d61c8d351 ("NFSv4.1 test the mdsthreshold hint parameters")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/pnfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index 3ca1599982872..b5581eb94cb3f 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -1906,7 +1906,7 @@ static bool pnfs_within_mdsthreshold(struct nfs_open_context *ctx,
 		break;
 	}
 	if (size_set && io_set) {
-		if (size && io)
+		if (size || io)
 			ret = true;
 	} else if (size || io)
 		ret = true;
-- 
2.53.0



