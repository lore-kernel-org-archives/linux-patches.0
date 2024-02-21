Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C18C69942;
	Wed, 21 Feb 2024 13:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523422; cv=none; b=GV6prz2kFqjuAUNEg4A8rkY2rTCfyaMztAKaCJ3Lrnw3KtZvca37WR26PMgzlfOWu/GQxJsutOHjVsi57vn3J9qQQB3SsvAS0O5Ghu3og9ewxXvxAxqLvZUJhQHVQL7Aomlr1hgkrFvrOw5NW25QETxS8OBZWKGTZGPbDMDyNH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523422; c=relaxed/simple;
	bh=R7F1Man5LGgsK0FDR3r/7Pk72snPKfrjRjlfsJxrbFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=npgZDdifLN0Xl0mESYPOSbBwFwXOn28BO+UUN54GUpzHQ9nqdmezHcB2NlJ9X4zETFrJu/41mXiuOEtwDcuwBncX6xR3/uoEaf1/wrkfZIxSueQM2/z6mwhnZr0mM53gP+bMDF/MWO89WbazHOTsZ8uRdI4gJmSYlWv98FKS9Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z86S94/D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z86S94/D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23731C433F1;
	Wed, 21 Feb 2024 13:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523422;
	bh=R7F1Man5LGgsK0FDR3r/7Pk72snPKfrjRjlfsJxrbFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z86S94/D38U/DRTRM8q6Fr2Un7aYXBvIW530DQ1fWi9QFTbGdnSnmYmKpeAwLoFkn
	 O8PEQHTNRTUlBiQ+YNBNUnurbaamn3SrB1d8IzExWoVtc6uJVZTTIjubidiFXg9eaq
	 gY0gv1yrhxJw00j49U3gkXuapKfCrOuuB04ElnYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 432/476] crypto: lib/mpi - Fix unexpected pointer access in mpi_ec_init
Date: Wed, 21 Feb 2024 14:08:03 +0100
Message-ID: <20240221130023.988114533@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

[ Upstream commit ba3c5574203034781ac4231acf117da917efcd2a ]

When the mpi_ec_ctx structure is initialized, some fields are not
cleared, causing a crash when referencing the field when the
structure was released. Initially, this issue was ignored because
memory for mpi_ec_ctx is allocated with the __GFP_ZERO flag.
For example, this error will be triggered when calculating the
Za value for SM2 separately.

Fixes: d58bb7e55a8a ("lib/mpi: Introduce ec implementation to MPI library")
Cc: stable@vger.kernel.org # v6.5
Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/mpi/ec.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/mpi/ec.c b/lib/mpi/ec.c
index 40f5908e57a4..e16dca1e23d5 100644
--- a/lib/mpi/ec.c
+++ b/lib/mpi/ec.c
@@ -584,6 +584,9 @@ void mpi_ec_init(struct mpi_ec_ctx *ctx, enum gcry_mpi_ec_models model,
 	ctx->a = mpi_copy(a);
 	ctx->b = mpi_copy(b);
 
+	ctx->d = NULL;
+	ctx->t.two_inv_p = NULL;
+
 	ctx->t.p_barrett = use_barrett > 0 ? mpi_barrett_init(ctx->p, 0) : NULL;
 
 	mpi_ec_get_reset(ctx);
-- 
2.43.0



