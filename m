Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F4E612D7;
	Tue, 20 Feb 2024 21:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463245; cv=none; b=ASILhNv0jKR/3B8pRFnci0OSAjUEllzmUKQQtUr7I8dfUuA2zcO3/4zCP0gwX11tLx6E87IhcsYi32cQjAfwTxNuqsh0FOCDbswOSEo1aDZyxIc9E35yS/FaKfViK9wZFjjMloJfXbVrxCshwyu0wDkSQlxwcw2QRm9J3qcY/Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463245; c=relaxed/simple;
	bh=0GSL+1fOEWYX99j3dfHN85vPMoq+ajeuFbRcBHE8+tM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BXrOGSlqJAJmaEVlZMtv/AgqTEcl/4sl+xfhIx8xdjFGN6o4C9cnYXe260k9yuC3HWYyDqOzerCb/7p+EiM1AtrcyEwK5gHUNBjsWrQYFjE/PKHNmFumlkcdtkRCWzGHrCa8TH6EH1NdWbuQfo3XV8ScxIPp8vbuBlFCT85v4Kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yE6Oiize; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yE6Oiize"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34CF6C433C7;
	Tue, 20 Feb 2024 21:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463245;
	bh=0GSL+1fOEWYX99j3dfHN85vPMoq+ajeuFbRcBHE8+tM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yE6Oiizev4HdCIbh4lv5tq8AYFaTxLqfgjvPgQb4xVhNDRCsueyt7EYFCH0ohJHnV
	 xfhuKQjTDkkVeTUYe2EQ6CqpVIzkyFEpba7aSDTBQZKYRnq00daaJtdV0LAXcWtKRe
	 hqyJ1SLpYVLkSOXZh6qbC6gzziJJ4B1gpjFalrKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 182/197] crypto: lib/mpi - Fix unexpected pointer access in mpi_ec_init
Date: Tue, 20 Feb 2024 21:52:21 +0100
Message-ID: <20240220204846.522889225@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



