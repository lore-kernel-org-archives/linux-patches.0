Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1793C3F7884;
	Wed, 20 May 2026 18:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300836; cv=none; b=kxoT4OzhBa0OZksgYsuNf+gFsCIe6QMhQeRWanmg/ZWoWwvDAwJjcDF7zOUoZjOiwGj/cMvnlesCnDsMckGG/ns6Jbn+6JplyktLimX0NAYXnVowHs7QB3cCL9IEjNPEvnEpuUXxBu1OTHVC+1Nqwqx2EIwPETNl6j2UV/YATdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300836; c=relaxed/simple;
	bh=wWwwElKQQfIR1gS9VcNWn9XoiobCLnB+4Ke2mNvxUlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SCYrHOQTxuNc4g+BPKOmx8klNAZXkXc7afTUZDM4AcKFc5Cbc3CCz++6AyAjNgzJLyAbEC+CJOIFkmFUJkhQKOJBNE45uN8WpupkwhZfEvYVJuqw+62WFnHsPw65+0mCPM8TkJ7QzByRqUpgv4XTlrhYuVO7n+zclXzhkr8QVKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yQgz6BX8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yQgz6BX8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD0D1F000E9;
	Wed, 20 May 2026 18:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300835;
	bh=Oj4p9/fC4TUuJ6AGL0rUWcWpM5vLa0GNzGc7vq8awfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yQgz6BX8g1o4TlRp8oq0YxHvfJ3hBOzWbY4f64JV7xYai1GUaLUKiSEhaCDJ+mKB9
	 s5Dsj3YYdOgpRs6LqjNkwJ7dgUsa1pD2C6essuYahrcAjMnqCkVy4e8gSfggvhZZqk
	 JIqUbAGCAXNioPsICsFB5lCwRGD8ToAY3onF1mXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Hodges <hodgesd@meta.com>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 326/666] ima: check return value of crypto_shash_final() in boot aggregate
Date: Wed, 20 May 2026 18:18:57 +0200
Message-ID: <20260520162118.292513365@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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



