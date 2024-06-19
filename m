Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A2282871;
	Wed, 19 Jun 2024 13:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802338; cv=none; b=NLTtTRaSfUWpH1yJ0fIysI0oJTZL1kYJ5U1zwzK3RAZNsiDASlS2BA0U+gB8KovdyOp/FYnyMbR/ngHmF8yG+fwk3TvBH1I3LXVOepRFYpCGk7XJf2lC8kYBk5uIinIenYb1yYpYvdyZjUbZh9ePIyuJbfUp15S4d+ybvlmuJGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802338; c=relaxed/simple;
	bh=EIBne5DbiZYUM3rQvpgPuRV9h3qa5x0QCV3DJvBe9wE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YU+rBBT2O384HX9j4cTjC++Ci/lu9TANRAGk6CdC8f2IXFE1PMhZcxBZvBaWN1gGqzgC4Emv1EUnoVvHft4NPGnr+EAJz2gsKcEhsHIIltJBdwV5qzh14Je6p8ObmR8g3n0Y5UQX4BhGnMtm1VWdqTOalqsFTLPO0OdsIYLN6oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vNYac9Ju; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vNYac9Ju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 833AAC2BBFC;
	Wed, 19 Jun 2024 13:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802337;
	bh=EIBne5DbiZYUM3rQvpgPuRV9h3qa5x0QCV3DJvBe9wE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vNYac9JujSCyeDTh9Jb5HpFzvbieKsjihUyVPo2gwQdXHzGDS53aSxj/H3zZHSIdj
	 VXaMkUOtFi47Rmo7nmRG7Va3UPbAxJ3BOOvkPpJk/VNcjPZQP4Kd8jGTDD7w05GKcE
	 sBVFIoCRvCMTIAypBfYNpYltLMTgsMFYvXA5K/y8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 163/267] block: sed-opal: avoid possible wrong address reference in read_sed_opal_key()
Date: Wed, 19 Jun 2024 14:55:14 +0200
Message-ID: <20240619125612.600065632@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Su Hui <suhui@nfschina.com>

[ Upstream commit 9b1ebce6a1fded90d4a1c6c57dc6262dac4c4c14 ]

Clang static checker (scan-build) warning:
block/sed-opal.c:line 317, column 3
Value stored to 'ret' is never read.

Fix this problem by returning the error code when keyring_search() failed.
Otherwise, 'key' will have a wrong value when 'kerf' stores the error code.

Fixes: 3bfeb6125664 ("block: sed-opal: keyring support for SED keys")
Signed-off-by: Su Hui <suhui@nfschina.com>
Link: https://lore.kernel.org/r/20240611073659.429582-1-suhui@nfschina.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/sed-opal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/sed-opal.c b/block/sed-opal.c
index e27109be77690..1a1cb35bf4b79 100644
--- a/block/sed-opal.c
+++ b/block/sed-opal.c
@@ -313,7 +313,7 @@ static int read_sed_opal_key(const char *key_name, u_char *buffer, int buflen)
 			      &key_type_user, key_name, true);
 
 	if (IS_ERR(kref))
-		ret = PTR_ERR(kref);
+		return PTR_ERR(kref);
 
 	key = key_ref_to_ptr(kref);
 	down_read(&key->sem);
-- 
2.43.0



