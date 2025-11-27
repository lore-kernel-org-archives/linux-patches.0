Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A615B28D8E8;
	Thu, 27 Nov 2025 14:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255389; cv=none; b=BNHnZ1kFF8OyaI75ifFN55i6mVURO6nD9mi88PiDjZSiy4/Ir7QGH9qKEKOQe+qMQ0q9I+OujoAzrZJbv6KOWWcWuGeku6a95aavBEVxLiAbquyZ18PnVMohvWf/QHF/ctWSG8Qn3Snf3HnOVrHfNQaJs1oeJXGYeYCs6FD4vvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255389; c=relaxed/simple;
	bh=iT2cSOfvxuEywYU12IKg4mGr6eEZMJ+Caq1sX8XPQus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tLRufENK2KSqaOJZymourMXsoWM3BiFnfjuWMuO9YuIEQ2Qx+5soDTugL5NLgCXJRPzAl1icXdvzHXJWZGyTji9CDw3yoJZb44YI0gI2BfYjAaj4uEuJj2FG4iWES0x/g0jluO8X/Zws+M4KyQMel4I2dli/WMc7RZVPNuEV3vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DvRBT74n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DvRBT74n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C8BCC4CEF8;
	Thu, 27 Nov 2025 14:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255389;
	bh=iT2cSOfvxuEywYU12IKg4mGr6eEZMJ+Caq1sX8XPQus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DvRBT74nYSDzUWcN1eNB7/5zZIZTkdLtxdvAgpeMbMggA8FIsAHELx1xNQ9MDXPGC
	 molKJpUtNANekiK1nboV8JEPsUWQD8q1E+3NETWeKdZuaeebIuvNUgpOTA9tUVIDib
	 WyWMw1ibOz9oCBFv3I6EyHlh3LuJvAOemVNlXkfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Llamas <cmllamas@google.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 089/112] blk-crypto: use BLK_STS_INVAL for alignment errors
Date: Thu, 27 Nov 2025 15:46:31 +0100
Message-ID: <20251127144036.099420909@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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

From: Carlos Llamas <cmllamas@google.com>

[ Upstream commit 0b39ca457241aeca07a613002512573e8804f93a ]

Make __blk_crypto_bio_prep() propagate BLK_STS_INVAL when IO segments
fail the data unit alignment check.

This was flagged by an LTP test that expects EINVAL when performing an
O_DIRECT read with a misaligned buffer [1].

Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/all/aP-c5gPjrpsn0vJA@google.com/ [1]
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Reviewed-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-crypto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-crypto.c b/block/blk-crypto.c
index 4d760b092deb9..7a0bd086a194b 100644
--- a/block/blk-crypto.c
+++ b/block/blk-crypto.c
@@ -282,7 +282,7 @@ bool __blk_crypto_bio_prep(struct bio **bio_ptr)
 	}
 
 	if (!bio_crypt_check_alignment(bio)) {
-		bio->bi_status = BLK_STS_IOERR;
+		bio->bi_status = BLK_STS_INVAL;
 		goto fail;
 	}
 
-- 
2.51.0



