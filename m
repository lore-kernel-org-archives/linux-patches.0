Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057014;
	b=Nw78rEWBoWaJ5bbsJRr6XnJ09s9a7QoVJ+fzCFIvvujkjrRoe08UnTG7AtzDGUD3M22Z
	 U0Zil7TssCPf6T184/3Y7ZDo0nW2ig7LqKXB13uy+1YgqKY99593TEneIKwD4KSgFUglY
	 enc7BuHhwxQgIQWaTRBwzWVoek5xXUqL+vTdeAo8jEmBoVxsMWW6nRaXD8xrrmPGEIfBo
	 dw0NUuYmYbDRfEwsDFi9dxriNmt3Td7YMbPUolia65B4+Wodx3+H3bbsCMpDO2NOOaFlV
	 YFiFpC1fnL1yrFOw/vyf9HWwZk20WyoA3/uVFwWRqI5kOgoeCYsURmLoRKB9bHh1m1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057014;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E9xPk2zpN/1aOQK2x+3P0Ds2uGOzATt/RMm5pRaToiw=;
	b=ijV45bwp9QG4Xg+sUCqR9P1O2OZ5GmEbxeiSICF4pPheJcCopXX0Kk142hoJBH32KGn5
	 FPs75Y+y151/AYgpi5x8Gme0ioFe8rhStbZduWsYLkYlqr2H8p278Wf7XL5bsTCqIbfGh
	 CLodHSqdNcQqugA/LS3PtBPJD+9I1gUa5W7M+x8jg3oZCRbHWQmWGz3Bn+QMQ51bFpE2c
	 ERAfS5+TLiwgdFDejx79MKgr5i28K2HS6d1muD/uKqunNn8SQGhcXSyveQ3Ma7WB+dHmp
	 J0fDj0U67pLnpWh0mQKMJi+1f/Ias+qCiF11ZhQGusPIVt48J8wgqlzweJe/MrTqFqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gfCaor23;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F03160A2600;
	Thu, 19 Nov 2026 02:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gfCaor23
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FF151F000C9;
	Thu, 19 Nov 2026 02:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057013;
	bh=E9xPk2zpN/1aOQK2x+3P0Ds2uGOzATt/RMm5pRaToiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gfCaor23tNn/JiENGr6uFEJ5zQ/eqYQ28RMRdfkPMihMFfkR7t8m4AwoCx3CQLhzX
	 eI+wRgHCBcsMWKArYCCXfOLbaandcXG/QqZh/KLtxkcZ1O+Nx+K6lHWYcQLIuPaxcN
	 PSS7jbSMQs3eu9mf6ijKnoMemebHd5JlJPiT5u44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nickolai Zeldovich <nickolai@csail.mit.edu>,
	Bradley Morgan <brads@mainlining.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2193/2214] ucount: read the parent ucounts before dropping the rlimit count
Date: Wed, 18 Nov 2026 16:04:29 +0100
Message-ID: <20261118150138.049113517@linuxfoundation.org>
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

From: Nickolai Zeldovich <nickolai@csail.mit.edu>

[ Upstream commit 38bf603d1ea5d5a65a9cb277df75327ffec01ff1 ]

do_dec_rlimit_put_ucounts() drops its share of iter->rlimit[type] and
only then loads iter->ns->ucounts. If the decrement leaves the count
non-zero, a concurrent caller can take it to zero and put the last
reference, which frees the ucounts and possibly its user namespace with
kfree_rcu(). An exiting task frees its pending signals without siglock
or any RCU read-side section, so when it is preempted between the
decrement and the load for a grace period it reads freed memory and
then decrements a counter through the pointer it found there.

A pending signal holds no reference on its ucounts: the reference is
taken by whoever moves the count from 0 to 1 and dropped by whoever
moves it back to 0, so the caller's share of the count is all that
keeps iter alive, and only until it is dropped.

Load the parent first; it stays pinned by the caller's share of its
own count.

Fixes: 15bc01effefe ("ucounts: Fix signal ucount refcounting")
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
Link: https://patch.msgid.link/20261024015513.830312-1-nickolai@csail.mit.edu
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/ucount.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/ucount.c b/kernel/ucount.c
index f483f83fc750e..e0ae3e95a7965 100644
--- a/kernel/ucount.c
+++ b/kernel/ucount.c
@@ -288,9 +288,12 @@ static void do_dec_rlimit_put_ucounts(struct ucounts *ucounts,
 {
 	struct ucounts *iter, *next;
 	for (iter = ucounts; iter != last; iter = next) {
-		long dec = atomic_long_sub_return(1, &iter->rlimit[type]);
-		WARN_ON_ONCE(dec < 0);
+		long dec;
+
+		/* Our count pins @iter; once it is dropped @iter may be freed. */
 		next = iter->ns->ucounts;
+		dec = atomic_long_sub_return(1, &iter->rlimit[type]);
+		WARN_ON_ONCE(dec < 0);
 		if (dec == 0)
 			put_ucounts(iter);
 	}
-- 
2.53.0



