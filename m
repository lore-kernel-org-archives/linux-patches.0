Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC3A4FECD3;
	Tue, 13 Oct 2026 12:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895193; cv=none; b=UHfhOU6znWyVlCO0Cz5fPQNkgjbairnyfBclfEe1TsqUEgpLxr3HqoWAkJwnDu1XTqZ/rm+FtHIjVAcYHWiii7LqgE1KPYOugNgyRg1TQ9LRSRA2QVaFLBJHPIDv/c7xDEs/0INTiPIrrjMXpCV6Xe/DS0DXGU2iCYqEhTuz2GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895193; c=relaxed/simple;
	bh=HvgWgIKJR+BsetEceGf3mQMJRXYD9gxz5WX6xGHsFoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QralsO78GqhbO8PvDnSx/tPpbv0YMpNKo25h4s1HylTctRUR1SPiD+WvFPnrxbI+CfpdxsosHWVgQMHQ+8co/Syk8KzYWdQxdFxJG9chmX5Ypg5HPEaflPIvVN1so+Fndr6YzIDcDQjB7mcp9YKHzegvBLdfJgT1xk/uIJ+PucE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aaW+MDoH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aaW+MDoH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 467F51F000FF;
	Tue, 13 Oct 2026 12:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895191;
	bh=K4ijIOACzS3MlOiPSkxX/JTvLaFQ1hUcMq+SCJyCsi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aaW+MDoHfb+t/GbVIaNs+hQbXQH4AmddOHve6ycYy3jzm/j5OXSfcdoAb+vfdHdS6
	 X7JjnzFl61Ii9mn7ok1mricjjQi9O7Av7mHxD2vPSqX7OrtOvbG/xn/DD22aEBMgUD
	 XxV2xvQBFtTxxQPwbDRwuucSCOtgV4mxypSyfmvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 193/497] tpm: fix off-by-four bounds check in tpm2_get_random()
Date: Tue, 13 Oct 2026 13:36:00 +0200
Message-ID: <20261013112912.472717143@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Jiangshan Yi <yijiangshan@kylinos.cn>

[ Upstream commit 9b522400bf5c082feb9a0037a053ea822a2c7e4d ]

When the response carries the TPM2_ST_SESSIONS tag, tpm2_get_random()
skips the 4-byte parameter size field before locating the random data,
but the bounds check still validates the response length against
TPM_HEADER_SIZE.  A truncated response can pass the check and make
memcpy() read up to 4 bytes past the response end, so stale buffer
contents end up in the caller's random bytes.

Fix this by checking the response length against 'offset', which
already includes the skipped parameter size field.

Cc: stable@vger.kernel.org #  v6.12+
Fixes: 1b6d7f9eb150 ("tpm: add session encryption protection to tpm2_get_random()")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260902074839.417419-1-yijiangshan%40kylinos.cn
Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Link: https://lore.kernel.org/r/20260903035837.219284-1-yijiangshan@kylinos.cn
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm2-cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index c710128f49b11..63d26aebf55db 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -361,7 +361,7 @@ int tpm2_get_random(struct tpm_chip *chip, u8 *dest, size_t max)
 		out = (struct tpm2_get_random_out *)&buf.data[offset];
 		recd = min_t(u32, be16_to_cpu(out->size), num_bytes);
 		if (tpm_buf_length(&buf) <
-		    TPM_HEADER_SIZE +
+		    offset +
 		    offsetof(struct tpm2_get_random_out, buffer) +
 		    recd) {
 			err = -EFAULT;
-- 
2.53.0



