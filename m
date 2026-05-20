Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A9B372EED;
	Wed, 20 May 2026 16:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295874; cv=none; b=kbLMx97seX32MwXBmI+Ukeb2mYyjXsUOJXdOVHpImnEmS4XwFLSSjuXh12anNVhirA6uBw7r5DQ+gn9QgsnC+QseG5QOmu1xJjyJaICQ/IXLffOPZ5n12+htlA6yveZWI9fbQxd46FJAa2cIV8beaRuC2WCBxXeRn5xvI1tSYQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295874; c=relaxed/simple;
	bh=k+U0ocEkIl3Gd9X36lT8aN06/LidBBKEroYxrWkutoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VLPHH+k/4A3zMNAha0gXL2TGD70MUVGJLRYsYZrEsjSDPmw3Z7TPMh369/icME1L4qMa3PEFoIlJvesMar1R8AeeotWZecCibom7CPoD4MWF2DGnwThkBk+/2Ay6PjpwJdDtaPRA26TJC/MIlbz5FEVT4SzzrKQn3ENydF0NbI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zz00zZHC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zz00zZHC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07BD21F000E9;
	Wed, 20 May 2026 16:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295873;
	bh=XmASXtY4WmnepyfCWc0PVsrGUL0Oqau4woijphujxY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zz00zZHCcAki1c063Bq7gwDwVCGHTnhDke4cO21ZSMicpl8mCxC5EivQ7Tua//3hV
	 ukV+HfR4qNKE1SDedQcMs43tZ6eQ+m7c2Th6RZRIawammSv0RFF4EnNLM2mBWB78By
	 qchrkGcQBu0Xx9SixNasAYynFhS3zVwlXfOui0hw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Hodges <hodgesd@meta.com>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0585/1146] ima: check return value of crypto_shash_final() in boot aggregate
Date: Wed, 20 May 2026 18:13:55 +0200
Message-ID: <20260520162201.417761808@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index aff61643415de..85c433e39c008 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -832,7 +832,7 @@ static int ima_calc_boot_aggregate_tfm(char *digest, u16 alg_id,
 		}
 	}
 	if (!rc)
-		crypto_shash_final(shash, digest);
+		rc = crypto_shash_final(shash, digest);
 	return rc;
 }
 
-- 
2.53.0



