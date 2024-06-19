Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA9782495;
	Wed, 19 Jun 2024 13:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803164; cv=none; b=Ep2Ypbh363Uxy58doAOtYlNEOS4jVF+dnLoRBYvdbyCVDmPwByOGsdGaXVAh4HJKu3cZEUKfdlO6LdVnCaOEH4Xz2R/Djvwo5GXficduFEwkJFV8W2xwvR8WJQ99URDyW6SvWTI7ES927SnL+Usq6eKIl6ZKnQgYVAHF+jH6kOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803164; c=relaxed/simple;
	bh=t4tDN4V5/iNSOCd2B1J5YWKkIgs0BEoCPFrmPJawXnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I8mnYIK4PqTo3/8gWJJ28VuHy4TRM1nF7RCFOhgzl2VvrMjouw22FN0u7Maez8o7RxUYY/EPX3YN+UTEfPZeCSbFeeWTz1RHF7jCCeNVbt6NsqSGjL+rAucNkATn9jM9nsHM8YvkiDrnlmpGmp2oEjolhqUI+MljxHqUbtrwc3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MSGr64bH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MSGr64bH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5881C2BBFC;
	Wed, 19 Jun 2024 13:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803164;
	bh=t4tDN4V5/iNSOCd2B1J5YWKkIgs0BEoCPFrmPJawXnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MSGr64bHNU4yXbXjhJdq5LNTOiPU6P7J11fD5/sUVuA8FY+bKToa7PtOadetSH8lQ
	 GV8eDy5WgBvL9k/1hurTpmtuClwXWaMp/f+SppLBg+uNlbUIitC3+1W32Bhw3dInaP
	 f0+3skg/jpY0R8wxRpw8p/MlaJFfpAYarvvEM0II=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 173/281] block: sed-opal: avoid possible wrong address reference in read_sed_opal_key()
Date: Wed, 19 Jun 2024 14:55:32 +0200
Message-ID: <20240619125616.493618286@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 14fe0fef811cf..598fd3e7fcc8e 100644
--- a/block/sed-opal.c
+++ b/block/sed-opal.c
@@ -314,7 +314,7 @@ static int read_sed_opal_key(const char *key_name, u_char *buffer, int buflen)
 			      &key_type_user, key_name, true);
 
 	if (IS_ERR(kref))
-		ret = PTR_ERR(kref);
+		return PTR_ERR(kref);
 
 	key = key_ref_to_ptr(kref);
 	down_read(&key->sem);
-- 
2.43.0



