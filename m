Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E1C304989;
	Tue, 30 Sep 2025 14:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244372; cv=none; b=a+ek9mFJwZFkADE0HKX/st6qgwc6IQvaMnWXmUB2oyE0/MipIhrPbRz41CcgQDf7uuWtJjIz24/mZfDbc5JZoCsmlg0vC0TpX6a58Zw8LP1E5cUhftNOJOsygiTE5mAw4vS4jCAJQnvWQe+zBhF5TW+vT6yKcmYPDsM311Oh6MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244372; c=relaxed/simple;
	bh=Z7exjtIzi3KLBAxA9exneNpyYQ6K93A/Ccn5izeQXHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BPJyc3J/cbxaUg9r8V+9Zm/9F/p+e5C40qPvzbZMVe5SJHfH2gyCjC3HkfgVWNREVF0Gd0ieL4VLvwxhr3tZzKhEXE1AYk3WlFRJKBhrJdRxVlOwJWE6Oqf+oZOZN0B3R8ZauHfppM2+PdhpLhxh2g05oO14vaq2ItSN+kgKysE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QA17LruM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QA17LruM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE8DFC116B1;
	Tue, 30 Sep 2025 14:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244372;
	bh=Z7exjtIzi3KLBAxA9exneNpyYQ6K93A/Ccn5izeQXHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QA17LruM8DzgjH38lHpXiEXSsQOIRWBJJYd6wGUsrwPr62yv30OM6+fDP4lCYTor+
	 DPE/t9PqqO9ZIM8bvuapa0kurYHopSLMlLOfY/50Gy8Q253popZtwQ9MlvLD82HPQ2
	 Tu7GKm+pzQypFrtD/PoI2juTCCNXucmZ3yjwi3nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 109/122] crypto: af_alg - Fix incorrect boolean values in af_alg_ctx
Date: Tue, 30 Sep 2025 16:47:20 +0200
Message-ID: <20250930143827.432567384@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

[ Upstream commit d0ca0df179c4b21e2a6c4a4fb637aa8fa14575cb ]

Commit 1b34cbbf4f01 ("crypto: af_alg - Disallow concurrent writes in
af_alg_sendmsg") changed some fields from bool to 1-bit bitfields of
type u32.

However, some assignments to these fields, specifically 'more' and
'merge', assign values greater than 1.  These relied on C's implicit
conversion to bool, such that zero becomes false and nonzero becomes
true.

With a 1-bit bitfields of type u32 instead, mod 2 of the value is taken
instead, resulting in 0 being assigned in some cases when 1 was intended.

Fix this by restoring the bool type.

Fixes: 1b34cbbf4f01 ("crypto: af_alg - Disallow concurrent writes in af_alg_sendmsg")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/crypto/if_alg.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index 1424200fe88cf..9af84cad92e93 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -152,7 +152,7 @@ struct af_alg_ctx {
 	size_t used;
 	atomic_t rcvused;
 
-	u32		more:1,
+	bool		more:1,
 			merge:1,
 			enc:1,
 			write:1,
-- 
2.51.0



