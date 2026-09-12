Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1777F3AEF51;
	Sat, 12 Sep 2026 12:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214795; cv=none; b=WR5a+wZAHQNJVQZs9dHCq3ngdx+jiTXX+2hl2SG1Pv2LWghlXGQA7fuJ7CS8zTGmTErvH6mJ1wg7EQGTErqcPAu2phz6C+uIEGaAH1UbNqMcSeT36/d7KZ/nl5ZIXp8LgjdRR5HqUL7IyZ4RRFMrLyju3uc15xnTdCY8BbQVn+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214795; c=relaxed/simple;
	bh=dng9QUF3N03j63hTH6qB1J+yW/oHxhOsa+WqRGVLfcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ENP3IEwSGfoVd7QItFGDLl382L3Jss9nbSqXreeTpsNl0AoSSPKagPUGyoVPi/pavy4arCbsFJHRO1gACQ72Nx4IHt73ATAeA6JaiaJy7Yo3iJxTCJZ24vDsFbyh091tbBt3wPQ9Ix/6YyEMQFP6mGWQirkwqr29NiiY2L8ciCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gLXCniJZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gLXCniJZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D73721F000FF;
	Sat, 12 Sep 2026 12:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214794;
	bh=C3QaKSXPIPQz7y36u/t/iH/pfj6y+G2yrfNbzUH9aAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gLXCniJZoQeopfaIrc/7IBeXiKCDJr8bnP5UD5+s0QgKZtDeoEbT/sSN1k6vWifnK
	 NBeX52MqbW83plVSdJIf0nnyRjXwCJw82u7psR+s4fY2qjbaFzpKViMFtbBy1dj964
	 tiRcZFeNl4LNdq2ZkVgGJENJjE8uPWE9JJ4uklK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manos Pitsidianakis <manos@pitsidianak.is>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0399/1376] hwrng: core - fix rng list on registration error
Date: Sat, 12 Sep 2026 08:47:05 +0200
Message-ID: <20260912065616.436592794@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index c6e913497e1df..008f81a82131d 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -597,11 +597,13 @@ int hwrng_register(struct hwrng *rng)
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



