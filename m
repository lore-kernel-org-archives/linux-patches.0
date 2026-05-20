Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 340763E2AAD;
	Wed, 20 May 2026 18:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302315; cv=none; b=rUDTev9i18jMXyGSlm7zup+gGpxOQakf/7u7HM0myxZwqPMpN7cKktpLcLU3jVxGZTsQrEvdCoiGv96UCQG8HnW0QZw+vqpNVKoWQTJ/n6CBliSiyhdVNc4UNqddFt6aYIOMq6PxNNjuN37SyO2Ha+qULS0aqWjsEUI6UpFKKj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302315; c=relaxed/simple;
	bh=NGFEOI48nVvzudXj8ktnmtGwvyw1JxXNviw8SOEaQqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XT6W7faYrZiyeTnOBnCYO0umY8lpDtRi0UbXjwRvrpDhNXArQBDBoAlAHc/8lvIwF8Is2rpv4JMD3LvdKcOW7BBI0cgqIqR3hg1ub+2AKEOILf62BGYHCxSdhxkCvHpc/pZp/Lzn2uMtEjaFX9jikOPUa3wZ4gkPjlo81pVmhu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fxA2F9S+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fxA2F9S+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 999841F00897;
	Wed, 20 May 2026 18:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302314;
	bh=L+fjxv4O16ZZs6WqoUzaOs5lrowhqm/y0ONbHhUJjQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fxA2F9S+PASU5umIXN1ukrJ+mvicsBlJO0GKGQq8EqvXy1XsCC4mS1rk/nPR/nQSf
	 Tp1qBi/ddFWdHLVJoRUAmnXsYS8pJaXUQDsRp6uogs44TLX5x90B1bCwjaLWSWntW5
	 BOfi2uJRDL7E1yy6ftMda5XAXb+Oo2Y04aXr51+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Hodges <hodgesd@meta.com>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 221/508] ima: check return value of crypto_shash_final() in boot aggregate
Date: Wed, 20 May 2026 18:20:44 +0200
Message-ID: <20260520162103.427853523@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 51ad29940f05c..2b611bf169dd9 100644
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



