Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 300521A6192;
	Tue, 30 Jul 2024 17:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359039; cv=none; b=qjZmtPgTtoMD1AOd15W9Zt7QjI+Rb+JGhH0Joou2VXCSXGP4yZXJcRlALKHH4rGXsG7fbZZCelvJcm5xW8VMQgR5otK0yhSpp4Imf6s/sNT4vgmhCkCaZMHd/RtTFBtsQ/YPmphTKPjX69KblGthlGS+nr0Xw/qqlmdod6URAkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359039; c=relaxed/simple;
	bh=rvkacaQj+hoLWNKJA1aRi4lSEqPtnUJ+jRM/AGUlc6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jsUvBMou08FxL/9sO40FEuZ8vI4E3r7VmHtHkQSMGeAh1kbDwKw077Dih3+uuXAh+AKnQH7HLEPyeRikaTM3T4eEPf7LPtq3WTuONzXmgnq0JJI5SFfpxu71dihIfhQAR+pA89zhJTW5BGzIpVf3YGbj3vH9pZZr1pV7+FW+UIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oRIXVLc3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oRIXVLc3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 946DAC32782;
	Tue, 30 Jul 2024 17:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359039;
	bh=rvkacaQj+hoLWNKJA1aRi4lSEqPtnUJ+jRM/AGUlc6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oRIXVLc3au3t34RPkmYzmLjnfE41ImKm2K4swE882lgaCZRRJc3jPDv7t1AT3vCt4
	 hGA9eWDJPMtCwMlELoAkOuw3FxSyEQq5s1UsLelaSPyYKDwHOGna+T0WBNGdoMVGeN
	 LgbGxLc4bxGJkXlsfc3s4HflX5tKAYikanpC6lI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Rund <Christian.Rund@de.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 425/809] hwrng: core - Fix wrong quality calculation at hw rng registration
Date: Tue, 30 Jul 2024 17:45:01 +0200
Message-ID: <20240730151741.482557593@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harald Freudenberger <freude@linux.ibm.com>

[ Upstream commit 95c0f5c3b8bb7acdc5c4f04bc6a7d3f40d319e9e ]

When there are rng sources registering at the hwrng core via
hwrng_register() a struct hwrng is delivered. There is a quality
field in there which is used to decide which of the registered
hw rng sources will be used by the hwrng core.

With commit 16bdbae39428 ("hwrng: core - treat default_quality as
a maximum and default to 1024") there came in a new default of
1024 in case this field is empty and all the known hw rng sources
at that time had been reworked to not fill this field and thus
use the default of 1024.

The code choosing the 'better' hw rng source during registration
of a new hw rng source has never been adapted to this and thus
used 0 if the hw rng implementation does not fill the quality field.
So when two rng sources register, one with 0 (meaning 1024) and
the other one with 999, the 999 hw rng will be chosen.

As the later invoked function hwrng_init() anyway adjusts the
quality field of the hw rng source, this adjustment is now done
during registration of this new hw rng source.

Tested on s390 with two hardware rng sources: crypto cards and
trng true random generator device driver.

Fixes: 16bdbae39428 ("hwrng: core - treat default_quality as a maximum and default to 1024")
Reported-by: Christian Rund <Christian.Rund@de.ibm.com>
Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 4084df65c9fa3..f6122a03ee37c 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -161,7 +161,6 @@ static int hwrng_init(struct hwrng *rng)
 	reinit_completion(&rng->cleanup_done);
 
 skip_init:
-	rng->quality = min_t(u16, min_t(u16, default_quality, 1024), rng->quality ?: 1024);
 	current_quality = rng->quality; /* obsolete */
 
 	return 0;
@@ -545,6 +544,9 @@ int hwrng_register(struct hwrng *rng)
 	complete(&rng->cleanup_done);
 	init_completion(&rng->dying);
 
+	/* Adjust quality field to always have a proper value */
+	rng->quality = min_t(u16, min_t(u16, default_quality, 1024), rng->quality ?: 1024);
+
 	if (!current_rng ||
 	    (!cur_rng_set_by_user && rng->quality > current_rng->quality)) {
 		/*
-- 
2.43.0



