Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3192FB973;
	Tue, 11 Nov 2025 01:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823937; cv=none; b=j/OOwAuUMRzMPFeTRPught2LTvdwxSKJkEnJwV2F1q+V6V9rPJmr5i84wUbLIqa7UnuPalOELa5W/vav0uAhq0EoZsYc3LPNzaU3o3dU/3RG6UUStkJqJi9xKExqV8wiT36MLdqf7SVV4kPPDuHXgLUWAaQPtgDIrztmuDcHUs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823937; c=relaxed/simple;
	bh=JLeCKIOHU05gExaPpcEaCw5b7/y105UZMCu9h/MNqSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tq8CW6lDEjlzijqtANLtHpLKMX4imVVl/+7Kp4MYPRyzvEa3o57ECT+IPdTgP8AlF4bvazWWX2fttkiXrdwCHf0T3c3fCwwmqTHiBVandzjkKJAX7J8Uuw8kSKjzZKwn1TY9iKiIaaAoacnUl1nE82Xi8pCl1oBkrUd4IU7AXW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JLgWw9S6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JLgWw9S6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 187C3C4CEF5;
	Tue, 11 Nov 2025 01:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823937;
	bh=JLeCKIOHU05gExaPpcEaCw5b7/y105UZMCu9h/MNqSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JLgWw9S63wifo3Y/BhubML9ipS56N9dF4g73IX8PvarNs2Fmpt9GqoFet3U7RJS06
	 bB+iTamDSd/R3s1yk9un7wAHaBDQTz0rvv6/t4RHyddojj6ucphC274Z7A6rzv74xO
	 G/Bu/1GM51xmEg4GN6zvADswZh8CbNjezgdPYCOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaurav Jain <gaurav.jain@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 353/565] crypto: caam - double the entropy delay interval for retry
Date: Tue, 11 Nov 2025 09:43:29 +0900
Message-ID: <20251111004534.815417039@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 707760fa1978e..d76bc94ba5054 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -702,12 +702,12 @@ static int caam_ctrl_rng_init(struct device *dev)
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



