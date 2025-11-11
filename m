Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE78340290;
	Tue, 11 Nov 2025 01:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824598; cv=none; b=MclLvWKarOm6Q34Fxm3fXk7XebpGfMsYrvIshqUU3k2CFfEYGsTmVb7Uz2BfeVVp8v//0AqKsNDH8Jd+ARnSAynPapYNfp1hGZknvTl1ETNx5z4E2PTwr+yHylJyQoiSR3LCQNdL2wrnFkPBXUHC3128POrVxaSj2QyM4HuH3+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824598; c=relaxed/simple;
	bh=bfIWhM6+laCtkEhzeRaw7wPm53qgNxG00CY2mVmBWB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KEX+STWynqMEZaWGaKN3cuXIr+fjCXj7vtNn1P+9c63k59fXrKW7ZEC9IGm1XV6qX32a1bU6ATq0pYzwmmYKJUYRZVreBz5aVj4JfSCgVP1jx52OUPO3xyzVQWjnxbPkzaJaSBW62xz268Xi8ph9K7Y/lewk+DllmJ9GBMENuE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zccXxudp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zccXxudp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D492FC116B1;
	Tue, 11 Nov 2025 01:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824598;
	bh=bfIWhM6+laCtkEhzeRaw7wPm53qgNxG00CY2mVmBWB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zccXxudpZ7ZAEJ1recW7IYnNJpnXxdP5CKTEcHvKI+MCgZH3ylDGi/wrV8PjWsjwO
	 E+L4fJReu5wNLbU9B8VDbbkrND+76kGC0viPU9ZB5LWkprBtiMjMeAlz7Y75pBJO48
	 Ue4Ufz++2SDVYwNDKn9YUkFbfOoiwQilJR/Q66XM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaurav Jain <gaurav.jain@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 531/849] crypto: caam - double the entropy delay interval for retry
Date: Tue, 11 Nov 2025 09:41:41 +0900
Message-ID: <20251111004549.255650232@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gaurav Jain <gaurav.jain@nxp.com>

[ Upstream commit 9048beca9c5614d486e2b492c0a7867164bf56a8 ]

during entropy evaluation, if the generated samples fail
any statistical test, then, all of the bits will be discarded,
and a second set of samples will be generated and tested.

the entropy delay interval should be doubled before performing the
retry.

also, ctrlpriv->rng4_sh_init and inst_handles both reads RNG DRNG
status register, but only inst_handles is updated before every retry.
so only check inst_handles and removing ctrlpriv->rng4_sh_init

Signed-off-by: Gaurav Jain <gaurav.jain@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/caam/ctrl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index a93be395c878c..18a850cf0f971 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -703,12 +703,12 @@ static int caam_ctrl_rng_init(struct device *dev)
 			 */
 			if (needs_entropy_delay_adjustment())
 				ent_delay = 12000;
-			if (!(ctrlpriv->rng4_sh_init || inst_handles)) {
+			if (!inst_handles) {
 				dev_info(dev,
 					 "Entropy delay = %u\n",
 					 ent_delay);
 				kick_trng(dev, ent_delay);
-				ent_delay += 400;
+				ent_delay = ent_delay * 2;
 			}
 			/*
 			 * if instantiate_rng(...) fails, the loop will rerun
-- 
2.51.0



