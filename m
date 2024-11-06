Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E971D86E8;
	Wed,  6 Nov 2024 12:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897991; cv=none; b=oSUwzzdd6k2swHwPnCTBLOupw8pib/teQvSB/tVktWKerllXrUedw5oktR3JlmcoeYl660sOCeJW1tWypG4NB/rhW9lqxs+3O3wWToYarT7ZZV9yJ2/XTsJ54bm9cNSxmmtwpD4ta56bu76fM0GkOvU08AQpuwmHFjeAxVjTxqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897991; c=relaxed/simple;
	bh=9uKRLZJ5fdhAGg+BqRxw0m8thvf1GI5swHNzOSBe2D0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KdVyCBZs4E86yrwa6OQsTTZA9HZD/iPOciGdEfj2+dZpokPNVpnRpCrdzEM38FkCGd5UR0yu8Bh063ryFIlIR/RpatBMun7tnemcVW7xEu4x9U8rABpFl8Edc1gd8VM04BvY+fLtVovfDc3Bv+YgsDEKdjrwICmwf0N9Zz2PLU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mZh5RJ8/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mZh5RJ8/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE49DC4CECD;
	Wed,  6 Nov 2024 12:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897991;
	bh=9uKRLZJ5fdhAGg+BqRxw0m8thvf1GI5swHNzOSBe2D0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mZh5RJ8/Ln/UoAWxuVCeiYqRHR5jhTba0q/qINsXbtCtvCu/cZ1foxzEH8FxUERLu
	 iWgZA0OLQL2XUAhFO3TbXEqoSepOMVJksAQ5V2p+J9S9687DAmUAF0FWAZasYruUPT
	 G8YWE+R3bgp2TIqDHNfYu6wasalYV93As9xQN8mg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan McDowell <noodles@meta.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 087/462] tpm: Clean up TPM space after command failure
Date: Wed,  6 Nov 2024 12:59:40 +0100
Message-ID: <20241106120333.654361491@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan McDowell <noodles@meta.com>

[ Upstream commit e3aaebcbb7c6b403416f442d1de70d437ce313a7 ]

tpm_dev_transmit prepares the TPM space before attempting command
transmission. However if the command fails no rollback of this
preparation is done. This can result in transient handles being leaked
if the device is subsequently closed with no further commands performed.

Fix this by flushing the space in the event of command transmission
failure.

Fixes: 745b361e989a ("tpm: infrastructure for TPM spaces")
Signed-off-by: Jonathan McDowell <noodles@meta.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm-dev-common.c | 2 ++
 drivers/char/tpm/tpm2-space.c     | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/drivers/char/tpm/tpm-dev-common.c b/drivers/char/tpm/tpm-dev-common.c
index b99e1941c52c9..fde81ecbd6a3b 100644
--- a/drivers/char/tpm/tpm-dev-common.c
+++ b/drivers/char/tpm/tpm-dev-common.c
@@ -48,6 +48,8 @@ static ssize_t tpm_dev_transmit(struct tpm_chip *chip, struct tpm_space *space,
 
 	if (!ret)
 		ret = tpm2_commit_space(chip, space, buf, &len);
+	else
+		tpm2_flush_space(chip);
 
 out_rc:
 	return ret ? ret : len;
diff --git a/drivers/char/tpm/tpm2-space.c b/drivers/char/tpm/tpm2-space.c
index ffb35f0154c16..c57404c6b98c9 100644
--- a/drivers/char/tpm/tpm2-space.c
+++ b/drivers/char/tpm/tpm2-space.c
@@ -166,6 +166,9 @@ void tpm2_flush_space(struct tpm_chip *chip)
 	struct tpm_space *space = &chip->work_space;
 	int i;
 
+	if (!space)
+		return;
+
 	for (i = 0; i < ARRAY_SIZE(space->context_tbl); i++)
 		if (space->context_tbl[i] && ~space->context_tbl[i])
 			tpm2_flush_context(chip, space->context_tbl[i]);
-- 
2.43.0



