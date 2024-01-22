Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BCEA59B7D;
	Tue, 23 Jan 2024 01:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974110; cv=none; b=CwKbdkWaYSxtDCPcxzlXg6pEqfOVU5xb8yLH93rS8JSOZLX2WW8tZuQAETFZXO5jyUy+D+1W1JzSAdCCNY2duV3xwcOTpW8zOmehfJAeaeVRQLRgJQzzpxky4v17157tP7NPz5gPFAWKss2fwb4ElmMeuqghaIxwDAgmBo9ZiV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974110; c=relaxed/simple;
	bh=6igz5nsUDKnFOsILAESoVPTGAR/nsmJQJC9d76SYgS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fHsVFfzGBLRkBq8OEKGE8T//q0uEp/8ZOJRYZY9lF+y2EKbXAU4gPRB+OUVMFKFdWr27N+koDEc+sVhsMKRDd/N0e49QWw3gyE90yuoLbYSPgzVYgSi9Oo+zcWnxs9DkkFcjbwdqXHPiOuIbwR+2OxzeLHsdVzbl8D5WDpVxE1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=09Fhu65V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="09Fhu65V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16AE9C433C7;
	Tue, 23 Jan 2024 01:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974110;
	bh=6igz5nsUDKnFOsILAESoVPTGAR/nsmJQJC9d76SYgS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=09Fhu65V0zwZ/MG9HgtX8xgehmceuTWLeSLlS4WJ2yApFRJlkD1Zfbc/Wo/agI3fj
	 Vk3k5fDIXqd48hSxvleMt5qULTgXXeTDzhdJsVO4SUQN27IFn9ZcCanYrMDoJ/5Di9
	 yDo2USLa58VAmUelwIuj/pK55tIVWPXONvMwqn3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 042/583] crypto: rsa - add a check for allocation failure
Date: Mon, 22 Jan 2024 15:51:33 -0800
Message-ID: <20240122235813.434189588@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit d872ca165cb67112f2841ef9c37d51ef7e63d1e4 ]

Static checkers insist that the mpi_alloc() allocation can fail so add
a check to prevent a NULL dereference.  Small allocations like this
can't actually fail in current kernels, but adding a check is very
simple and makes the static checkers happy.

Fixes: 6637e11e4ad2 ("crypto: rsa - allow only odd e and restrict value in FIPS mode")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/rsa.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/crypto/rsa.c b/crypto/rsa.c
index c79613cdce6e..b9cd11fb7d36 100644
--- a/crypto/rsa.c
+++ b/crypto/rsa.c
@@ -220,6 +220,8 @@ static int rsa_check_exponent_fips(MPI e)
 	}
 
 	e_max = mpi_alloc(0);
+	if (!e_max)
+		return -ENOMEM;
 	mpi_set_bit(e_max, 256);
 
 	if (mpi_cmp(e, e_max) >= 0) {
-- 
2.43.0



