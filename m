Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C5B15EFC3;
	Mon, 27 May 2024 19:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837798; cv=none; b=VnMy2NISrfIqFKl/lnet9rl+XTUFmgSi7DxvCQ05YspK1C5ZsM1YtJk4uHRzd20EpWfZ8PsZ0EAPBik3KkYmKcwMZ4rlAygkciQD6tKMx+3GRRzQz3qSWpu81/KBJZGFIR0VKPyxFaVu6cxJKaOYFpVEQIVTln5gJfkkVbGgaKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837798; c=relaxed/simple;
	bh=gfSWm/6Jv7MA2HUc+cnFuo+8GQv2SkNF3DaV/YPNmzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gbRYO0XUochMP3rbdCQ19JrRh272z+V6iTVxzbxuS5nWay/H9dsiasNerEYV9OOePIuf+dvGN+NdhBBLEmCbmaSnTMGZpo6c/3KKpCkhBmLWcMsRZji2T57LLviybZF7p0+bDuUrCChzVIylHLtyAcY5KTEJ1NSlRshfVuAL9gE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LH0dzeXb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LH0dzeXb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67C62C2BBFC;
	Mon, 27 May 2024 19:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837798;
	bh=gfSWm/6Jv7MA2HUc+cnFuo+8GQv2SkNF3DaV/YPNmzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LH0dzeXb2UwKECV+y9qDoGpr3Dx96PfbjgrQxkdCz6L5rW+3G8ra5i9LvvUt13PCO
	 r1gLQanUei1N0OVAwuonxq+wJEQ9F0Z9V+Quy1xjANGp3cbI7dK/wzp3SJmzWK2SCx
	 TwoRRHdpL8ahjKNH7InyYLwrRTvXbyhn/upQDedY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 149/493] hwrng: stm32 - put IP into RPM suspend on failure
Date: Mon, 27 May 2024 20:52:31 +0200
Message-ID: <20240527185635.311716320@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@denx.de>

[ Upstream commit da62ed5c019cc48648f37c7a07e6a56cf637a795 ]

In case of an irrecoverable failure, put the IP into RPM suspend
to avoid RPM imbalance. I did not trigger this case, but it seems
it should be done based on reading the code.

Fixes: b17bc6eb7c2b ("hwrng: stm32 - rework error handling in stm32_rng_read()")
Signed-off-by: Marek Vasut <marex@denx.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/stm32-rng.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/stm32-rng.c b/drivers/char/hw_random/stm32-rng.c
index 1cc61ef8ee54c..b6182f86d8a4b 100644
--- a/drivers/char/hw_random/stm32-rng.c
+++ b/drivers/char/hw_random/stm32-rng.c
@@ -220,7 +220,8 @@ static int stm32_rng_read(struct hwrng *rng, void *data, size_t max, bool wait)
 				if (err && i > RNG_NB_RECOVER_TRIES) {
 					dev_err((struct device *)priv->rng.priv,
 						"Couldn't recover from seed error\n");
-					return -ENOTRECOVERABLE;
+					retval = -ENOTRECOVERABLE;
+					goto exit_rpm;
 				}
 
 				continue;
@@ -238,7 +239,8 @@ static int stm32_rng_read(struct hwrng *rng, void *data, size_t max, bool wait)
 			if (err && i > RNG_NB_RECOVER_TRIES) {
 				dev_err((struct device *)priv->rng.priv,
 					"Couldn't recover from seed error");
-				return -ENOTRECOVERABLE;
+				retval = -ENOTRECOVERABLE;
+				goto exit_rpm;
 			}
 
 			continue;
@@ -250,6 +252,7 @@ static int stm32_rng_read(struct hwrng *rng, void *data, size_t max, bool wait)
 		max -= sizeof(u32);
 	}
 
+exit_rpm:
 	pm_runtime_mark_last_busy((struct device *) priv->rng.priv);
 	pm_runtime_put_sync_autosuspend((struct device *) priv->rng.priv);
 
-- 
2.43.0



