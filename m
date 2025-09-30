Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3405F1F4C8E;
	Tue, 30 Sep 2025 15:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245330; cv=none; b=C/lhjWGq+dxhlUxyNRnbx8FsuU9SY/7rj5KyuKp1YUWmK0Wqn4xLS0ccq0d38Y/pOUQ72WuHCB9gVrGRNdAZSGMqbzw71lk219t827H/F//FuaUcjcr+nm1NqLncEzcZbLllwQHhvHt5k9fmGebBrulkQMOzN5LqehHA+EcEYxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245330; c=relaxed/simple;
	bh=72X6PSkU0rVgeHi+Lk9c3lue2gX7biLN5XBClS7Rh1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fgS6QE5u+IKcHYRbcqcybaSbpg+s3cZkjor9p8Qo3DTaaFEIV1xeE8EMS/3WR3LH70r0OFnhotsWKtEzU0clhVoSQpXk0hQDkg6L9TQv+aiV5CmeDZrIlSshWjJxZUTxiqNL5l4xEoNwMiOGWvol283mvNNhHa/5aUpP9VAHH48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gV9cC2KU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gV9cC2KU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FF6CC113D0;
	Tue, 30 Sep 2025 15:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245329;
	bh=72X6PSkU0rVgeHi+Lk9c3lue2gX7biLN5XBClS7Rh1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gV9cC2KUWNhgfBURZNNyC0jzQAPJriPxC5bq5qdzn6WjxraVWmhWIn2OBoTIdCTnB
	 rKAUML+F7w1Ei3ZE0CZICUWQaQNABKjjZP+wSk/ZEpx9rm+BftH58BF0qSgAMGHwkC
	 PVFXVkTC2+qm1G0MYn4G2hq7MJ20aFU8uJEQ6kc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 137/151] crypto: af_alg - Fix incorrect boolean values in af_alg_ctx
Date: Tue, 30 Sep 2025 16:47:47 +0200
Message-ID: <20250930143833.055000362@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



