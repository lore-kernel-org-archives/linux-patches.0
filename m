Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A71A38F629
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302145; cv=none; b=Ot0Ct0CRCWJuux7wJQxqPSNDw7qTUKz2La/HN13lDfWyJUIaK9DruXbpqZw9PM9Mu3CiHNCHwH7L8vVeCT77NbMK7ZPANCgiw2gtdUmP+ZgZwBrMpYU+Y/pM52f00JAErvSFwBMcRymVtlA+5D9Lzoxe9wbW8WHqLjg75jEEWIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302145; c=relaxed/simple;
	bh=mpcUwL1rLfTmnPdJ2tSjYQVZkcWYKlhpdB9/zrOqmqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rfBZ+eXwwZqmaxPckz9FYOx+jh7ThCIn65HKuroDqKsni38gflD3a1X2oFpN8koAudED8M0IVwZ6rja1uEirEXbt47C/nfPgni1pS3wkLnjJBxFwcEiyJ5uqNKiWXJWULmgkfMDfCreFQZzw0Sta9CJhIvD+yQMubo0bUAZiUes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jwpIc4d5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jwpIc4d5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB614C2BC87;
	Sat, 28 Feb 2026 18:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302145;
	bh=mpcUwL1rLfTmnPdJ2tSjYQVZkcWYKlhpdB9/zrOqmqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jwpIc4d5yv+s2BKpbl8RSaQI8Xb28qhXGCR4N7VQphvG3AvnYV96pkUEvm6l4Tnuh
	 mqBu7CTlOskSk283ckB7/hMIKRtuhg9qzr3aQwm0gK0G/ZSpBcg3L38o9rDP30Ht77
	 rZ8gAzOIhMKnfyWD5n2Q4j5L52izbyW8ypHk1ZpBGUq1rzffxEEZGTwKCUc6t8NGX0
	 7ouTD7Xs+3Bd2E6toMjJnoLPxlk/YIwFKY1qK197xiRvrzZlXX/q0cb18ZRsXk0vzx
	 B+GBdiVpvj1hnOq0VBeRyVcyLbJpWiY42yK+pHzi0Zv/CN2sUCZBE/WbSZzfUZ+Fud
	 +tH7zSEldI0Hg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Tuo Li <islituo@gmail.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 139/283] of: unittest: fix possible null-pointer dereferences in of_unittest_property_copy()
Date: Sat, 28 Feb 2026 13:04:41 -0500
Message-ID: <20260228180709.1583486-139-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Tuo Li <islituo@gmail.com>

[ Upstream commit d289cb7fcefe41a54d8f9c6d0e0947f5f82b15c6 ]

This function first duplicates p1 and p2 into new, and then checks whether
the duplication succeeds. However, if the duplication fails (e.g.,
kzalloc() returns NULL in __of_prop_dup()), new will be NULL but is still
dereferenced in __of_prop_free(). To ensure that the unit test continues to
run even when duplication fails, add a NULL check before calling
__of_prop_free().

Fixes: 1c5e3d9bf33b ("of: Add a helper to free property struct")
Signed-off-by: Tuo Li <islituo@gmail.com>
Link: https://patch.msgid.link/20260105071438.156186-1-islituo@gmail.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/unittest.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/of/unittest.c b/drivers/of/unittest.c
index aae4e8ef9e365..4b7e663feee3d 100644
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -800,11 +800,13 @@ static void __init of_unittest_property_copy(void)
 
 	new = __of_prop_dup(&p1, GFP_KERNEL);
 	unittest(new && propcmp(&p1, new), "empty property didn't copy correctly\n");
-	__of_prop_free(new);
+	if (new)
+		__of_prop_free(new);
 
 	new = __of_prop_dup(&p2, GFP_KERNEL);
 	unittest(new && propcmp(&p2, new), "non-empty property didn't copy correctly\n");
-	__of_prop_free(new);
+	if (new)
+		__of_prop_free(new);
 #endif
 }
 
-- 
2.51.0

