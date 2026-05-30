Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8559D263F44;
	Sat, 30 May 2026 17:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161417; cv=none; b=TwmX660dGKO1hhckV1wOJ0dn925jmLIG31ryPZwDhWDeqKp2urwk4LPWCjfR4KxGqZlrzJs03peUTSw2etTjVdvitjY7gwN4yu5tmOCB0tTvCPYJv66vHLRRqFVW37BfDa1YGurzWwf3Oj1G5qAPV5kWzuCQmYRQke6tOX7rXXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161417; c=relaxed/simple;
	bh=TIzp0v0G/GviqqRfN9h8oc2FUcKuBv12boOv8bCshgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X1LliavJQIlP8VPEG6NHU3KoQgTyjyn6fAbrcJDlUCecyEkrDlZjsernwd5oF0faUYrbCHllkRDuEn54T06g87xNUJqHTTpVheSvRHHfxDDwnKCcsW3uuzrrSsBzYQr32E30z4F5XRin2bhEx+OJaPMHhnZDGzb8TY5kGhaOpUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qZzCxjli; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qZzCxjli"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 733051F00893;
	Sat, 30 May 2026 17:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161416;
	bh=QdHLNIAO610FUMFIpEZs3dmsg2QqiezBQ/KGDOBC3jQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qZzCxjli6P6DMRfawXae0yQfGZk/r2q9CKyQPPNK9CRPhLzdwlZAM3gwnAAyiY8Rr
	 dfuEftIDTy1hTxlDYdyIHCBcOLDpH4xjitF9WxtToTwblJhFm+jxg7opQwD+G25TO2
	 K/53l9A1DIvXSd1lM1aNddYdODJo932VrwET3xfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Hodges <hodgesd@meta.com>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 600/969] ima: check return value of crypto_shash_final() in boot aggregate
Date: Sat, 30 May 2026 18:02:04 +0200
Message-ID: <20260530160316.991626323@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 64499056648ad..c5153f0d7306d 100644
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



