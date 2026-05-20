Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D8A29D26E;
	Wed, 20 May 2026 17:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298565; cv=none; b=R8SzVApzN02upuX5tJXIIulCyUW/IKsRP65Fz1NG8vCYpizbuBjwaml3qfnjKsm3g6BnKw3/l6YmcEkjDK8KHSoX4tiQJuQN6VxMdh/l7MG68b4BRI/NMe/bhulK9rX87/Ngw2O1uFLMEl18WmMSpKd2wiWnhV3JhljPZbC5CEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298565; c=relaxed/simple;
	bh=79O3O51JKusMxIjw/DToT7cXsNDbbuzCBa5kL8q8r94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pDRTXgqPwWPrKd7VqpD25RswxBUFI7H0PtbcD0p6u0ynlpomygtz1CGdIJoU2sdF+JhBPYFWlDCB6qxGr2ol9N/EVTHDI1ImQTjFlTcNz1SynPQ4CKtKPEAkHSn5uIaBqMmBw5qrC+lz6pEhDaHw+M9ZBIkMDPbgyiLCv7U9qp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ssto65q8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ssto65q8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BA7F1F000E9;
	Wed, 20 May 2026 17:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298564;
	bh=6vM/971iTzx8UiWqD5cp/8WRWZ95x5rCOV3WoIsPRIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ssto65q8WN3C2vPBn1PlCx84C6d1M/4DeoOGUo/SBnfOKfTMNIu7rE8SD3Aa6eKqx
	 WnbZBnFxB83nnn47gzQMTQMF5Tb+peInbOhmQVseLQsscHCNnFiIGqOcPoh9MIVVcv
	 ivvic0nXZxkdkP+CXoXTOW6ULKIjBSjlp700W6/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Hodges <hodgesd@meta.com>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 459/957] ima: check return value of crypto_shash_final() in boot aggregate
Date: Wed, 20 May 2026 18:15:42 +0200
Message-ID: <20260520162144.477242020@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 6f5696d999d0d..8ae7821a65c26 100644
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



