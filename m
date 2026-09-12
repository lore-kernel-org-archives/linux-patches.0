Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 329B33DE431;
	Sat, 12 Sep 2026 07:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197702; cv=none; b=KEEDqOoYMpBNrnG6qLkZSQNTB5u3jRd5yJALFUs7TSpm4/6PB+5UYpTvh0AWb1IrCgwHhajUl3qcfmMye5B2u5WCERQdQfeMyQIjoTqmWQ3OP7Y97asxc2KDhuMQ+iGMs/UpPsDMbgkD5CvWwTRj8yVWdC6/etQTlRSTRdy7OM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197702; c=relaxed/simple;
	bh=BUGi1K+QCkHmy3Ur2vkX1BnQMBCUATko+ou45tNoT4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oNUConxHG/9AwNfNoXXTbe05G1JGPvFjalhLVYCrL8K/QLnVdG4iLIKgVg8H06ztJwf3p9FB8nVOayQlb/LrxR2qmPErP8jyMJ8aaAexJbYDO7lR74/HFj0XboMGBeq0ABrzK/baC32zcc5qIWCixj5H/OsWjM85+z9hr7q4xSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GsIyqAXk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GsIyqAXk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4EF11F000FF;
	Sat, 12 Sep 2026 07:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197700;
	bh=gMW2gRJ/2NQyl0HxQtSd8NY4IJkk/24xX70u2rAtSnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GsIyqAXkOd1EEgFoEPbIApKlt11aOb3aO7+o+FPM5mGTJMOLFQAMec1zttP3Frmv2
	 Eip1NQS9wc2Hwznzs13ovxj58MhKghsIMQEAIzq7mYV1QF3HxQaiS+kMEo6ded4dve
	 ETh6rHEn4RQakEx3y2x/ryg1r82Fnbq+b0o2lMMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manos Pitsidianakis <manos@pitsidianak.is>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0187/1815] hwrng: core - fix rng list on registration error
Date: Sat, 12 Sep 2026 08:32:17 +0200
Message-ID: <20260912065653.397584264@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manos Pitsidianakis <manos@pitsidianak.is>

[ Upstream commit 3a5834db2b1ce25649f330e78efe1ccde78967fd ]

hwrng_register(rng) does the following:

1. Checks if rng has name and read methods set
2. Checks if the name already exists
3. Adds rng to global rng_list
4. May try to set rng to current_rng

If step 4 fails, it returns an error. However, it does not remove the
rng from rng_list, causing a dangling reference which can result in
use-after-free if the caller frees rng, since registration failed.

Add a list_del_init() cleanup step.

Fixes: 2bbb6983887f ("hwrng: use rng source with best quality")
Signed-off-by: Manos Pitsidianakis <manos@pitsidianak.is>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 6931657ad2caa..e77af6578ab50 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -596,11 +596,13 @@ int hwrng_register(struct hwrng *rng)
 			 */
 			err = set_current_rng(rng);
 			if (err)
-				goto out_unlock;
+				goto out_list_del;
 		}
 	}
 	mutex_unlock(&rng_mutex);
 	return 0;
+out_list_del:
+	list_del_init(&rng->list);
 out_unlock:
 	mutex_unlock(&rng_mutex);
 out:
-- 
2.53.0



