Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B4C25771;
	Wed,  2 Oct 2024 13:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875185; cv=none; b=YbKeJzneVtK3B3FLk/BTx3cIDLPafL86sWXayaPx9jowe21eqsAviDkvCTzOvPPCqby48/pygUFoJyc85hRqmoz4k4tMIxjCFpXA2XeBzA4Yo/idVPTeO0lEAvEHkG75d0IUnmCfbRYpUd5HEJHuw0dy5NoCqz8fYWo2LXQvecA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875185; c=relaxed/simple;
	bh=TmuZGRX8MAHhvddlxjoWnXyQxviE5xgPo8cvdqkWKIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cf/VzAmln3wEeF6kwJAu8SROoM8fGoVAU7WNJ8HgF4ypEzD9bFuMmadStWqBcM8GUxZZR4Ore1SloGjQdaG8SyY3jfBrqXFKuk9VTC12i5SeKAKWobNVjj/E9RKXqPMw9ictzMLvPmJdLfCyIpQPnd0uJkJrfrMJXYAnwTIfDSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b6Ed1Ihe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b6Ed1Ihe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C095C4CEC5;
	Wed,  2 Oct 2024 13:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875184;
	bh=TmuZGRX8MAHhvddlxjoWnXyQxviE5xgPo8cvdqkWKIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b6Ed1IhejOftNR+0fyDF6idsgWzDH2xdNGAABSqrwN493h63XS2gxQ9cwRlg2c7BB
	 1QXkOc9VDXO6qh24sE6TtTKK+350l29JIjVV4PVNzB+W5ZCAYc8nLxhZuMAXS7NJaL
	 l8LrbzKL+Nbb+Ky4y2g+W2SjdVTMlqtiWi/99YpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Tom Zanussi <tom.zanussi@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 008/695] crypto: iaa - Fix potential use after free bug
Date: Wed,  2 Oct 2024 14:50:06 +0200
Message-ID: <20241002125822.819170399@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit e0d3b845a1b10b7b5abdad7ecc69d45b2aab3209 ]

The free_device_compression_mode(iaa_device, device_mode) function frees
"device_mode" but it iss passed to iaa_compression_modes[i]->free() a few
lines later resulting in a use after free.

The good news is that, so far as I can tell, nothing implements the
->free() function and the use after free happens in dead code.  But, with
this fix, when something does implement it, we'll be ready.  :)

Fixes: b190447e0fa3 ("crypto: iaa - Add compression mode management along with fixed mode")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Tom Zanussi <tom.zanussi@linux.intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index e810d286ee8c4..237f870000702 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -495,10 +495,10 @@ static void remove_device_compression_modes(struct iaa_device *iaa_device)
 		if (!device_mode)
 			continue;
 
-		free_device_compression_mode(iaa_device, device_mode);
-		iaa_device->compression_modes[i] = NULL;
 		if (iaa_compression_modes[i]->free)
 			iaa_compression_modes[i]->free(device_mode);
+		free_device_compression_mode(iaa_device, device_mode);
+		iaa_device->compression_modes[i] = NULL;
 	}
 }
 
-- 
2.43.0



