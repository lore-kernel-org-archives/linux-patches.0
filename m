Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F73331A56;
	Sat, 30 May 2026 18:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166439; cv=none; b=WmktYb99NzOEkg7FuriLqYQ9CrfSxp/tI1blHRix2DunD5rvGurYMQGEgn56s9c6lOPI76ei1KikQUa92KVAqIwFNcLMhUxeECqvKyX0xF306dC0NZbtxRvDFnvWjBcIVDZA57rXAz34buC+r2KP9cKT6i/Feeloeed0H7mjK0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166439; c=relaxed/simple;
	bh=Dz4lMF2rSBQU+4qt4+FuVZk286ru49NZxso8Y7BWZ+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jvOC56TaaBfnTBqLknWANvvNUrmfPqqVv7epcmL0iRn5aM4UZXe3emTFACrBhRKc2LT4O6p3e12RgCTmHQ53s1CAkrlcXM438Q+cHzdrHeJbK9A9McUg9+ZKh7+T1p/H2Qre58nkljTb54uFZJmnmaEY6s+3kZeqLS277FCGrDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nzrhF1GD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nzrhF1GD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 238821F00893;
	Sat, 30 May 2026 18:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166437;
	bh=QpvGpSt6FF/2lFExAwCFEuPm5oAzTq7ezIkrG1hOGv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nzrhF1GD2gozHWQ6ITW626EWvgZX85U3LVaPaBNlKS98wywfVGQcZ7f2uL8y8odx4
	 SGkekJ2/qLMGtgsa7o/sSL8pooxhUVgQh164LRWChrXpDgzmgknnhr2kKIDGawIEl3
	 boSah49638O07mCgFzJni7gZAXxEw1nUI2lt0kGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Hodges <hodgesd@meta.com>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 374/589] ima: check return value of crypto_shash_final() in boot aggregate
Date: Sat, 30 May 2026 18:04:15 +0200
Message-ID: <20260530160234.646023560@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

From: Daniel Hodges <hodgesd@meta.com>

[ Upstream commit 870819434c8dfcc3158033b66e7851b81bb17e21 ]

The return value of crypto_shash_final() is not checked in
ima_calc_boot_aggregate_tfm(). If the hash finalization fails, the
function returns success and a corrupted boot aggregate digest could
be used for IMA measurements.

Capture the return value and propagate any error to the caller.

Fixes: 76bb28f6126f ("ima: use new crypto_shash API instead of old crypto_hash")
Signed-off-by: Daniel Hodges <hodgesd@meta.com>
Reviewed-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/ima/ima_crypto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index b1e5e7749e416..4ce45910b0fd0 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -837,7 +837,7 @@ static int ima_calc_boot_aggregate_tfm(char *digest, u16 alg_id,
 		}
 	}
 	if (!rc)
-		crypto_shash_final(shash, digest);
+		rc = crypto_shash_final(shash, digest);
 	return rc;
 }
 
-- 
2.53.0



