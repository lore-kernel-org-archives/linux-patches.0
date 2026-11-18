Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056374;
	b=gmKkALglKHt/6IJh3uFcN02h1ZnJVEQ7PZ2/AZQfQ7ILzNPGznSK98xZ/Mn44MsI0zsn
	 OkpwqfLYxKl8jVjjawTsx2rV4OFQZBKq0nhUgvO9HI9aWzHKqerspvWvAz89qg6aNvgRi
	 x8uxTmszWQj+MAUbJpGcPYaG88muhstj898O838CMkDV5dQTFc+ArCkOykkn5NH+I+6OU
	 QTYJ1vHz1cK+I/u74SXAMhzAG7C+IRjaDfugIeeau5MKZL4xGzt9s0Kr5O8Gqh/GwxGAT
	 97pa1P0kAMEAlJm12CvQIgJz7sIxyB5r6pXy6rA74uCV7gYodeYBe9d4ayKSnZeyEaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056374;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XioNVX+LGTGzeSM7/XIFyg+wP+TB+qqmJYviKu5OP/4=;
	b=qURxi1Zl34wUpx4V8CO0RE9sAhd9+1kVYfhTmjhf7VIyFOYL483YXl9psGf1f/fWhhfA
	 fGPdt2yGWq4PMjYkGroSOmEBbOGZZV8CfCxdJH3WrjobjyniUpU+qN3PGAkQOVQcWa/Ul
	 h2p7K4NEZr8SwV6DFcsbuVMshjuIgi89YgSKTEx0Vex43EZFkL8kIuIkQO6r/gpsZP/Lr
	 jQJig+WWBp6AxnOjkxrNkY+h18+ZXSxh4SCs9bvI3usLlu4zAxyph/fF/1xc7RwQqVHui
	 hPKNnXo9TTbX9XFBAFljxPxwr12lNqMO0fjak4of/SzOYB3NNjOCJKhGBudPa86wLHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NjQoFvmf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14166606A32A;
	Thu, 19 Nov 2026 02:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NjQoFvmf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 691171F000C4;
	Thu, 19 Nov 2026 02:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056373;
	bh=XioNVX+LGTGzeSM7/XIFyg+wP+TB+qqmJYviKu5OP/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NjQoFvmfjmHbu+vxlsq69VZK2wyOiT2vjlCYoHXGFZB3UbgmO7Hv8k1JEWckO3qPK
	 jevfyJB1JzPd6z66KBsGf06LazyjNisPQH8E30n/9O+px77S96+rZFQMtiNee6uI0O
	 AME59kS9aJaKpAbJiT+Qz1PaGnZs6D9mlua9HF2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Pearson <rpearsonhpe@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1965/2214] RDMA/rxe: Replace ah->pd by ah->ibah.pd
Date: Wed, 18 Nov 2026 16:00:41 +0100
Message-ID: <20261118150129.540312713@linuxfoundation.org>
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

From: Bob Pearson <rpearsonhpe@gmail.com>

[ Upstream commit 4da698eabf0f7c1c1806670d3fd3895512fdf43b ]

The pd field in struct rxe_ah is redundant with the pd field in the
rdma-core's ib_ah. Eliminate the pd field in rxe_ah and add an inline to
extract the pd from the ibah field.

Link: https://lore.kernel.org/r/20211007204051.10086-5-rpearsonhpe@gmail.com
Signed-off-by: Bob Pearson <rpearsonhpe@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: 47a9c0338f2e ("RDMA/rxe: validate inline sge_offset in finish_packet() before indexing inline_data[]")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_verbs.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.h b/drivers/infiniband/sw/rxe/rxe_verbs.h
index 446d14903cec5..eaadff1d543c6 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.h
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.h
@@ -46,7 +46,6 @@ struct rxe_pd {
 struct rxe_ah {
 	struct ib_ah		ibah;
 	struct rxe_pool_entry	pelem;
-	struct rxe_pd		*pd;
 	struct rxe_av		av;
 	bool			is_user;
 	int			ah_num;
@@ -471,6 +470,11 @@ static inline struct rxe_mw *to_rmw(struct ib_mw *mw)
 	return mw ? container_of(mw, struct rxe_mw, ibmw) : NULL;
 }
 
+static inline struct rxe_pd *rxe_ah_pd(struct rxe_ah *ah)
+{
+	return to_rpd(ah->ibah.pd);
+}
+
 static inline struct rxe_pd *mr_pd(struct rxe_mr *mr)
 {
 	return to_rpd(mr->ibmr.pd);
-- 
2.53.0



