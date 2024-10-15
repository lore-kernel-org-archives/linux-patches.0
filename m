Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D311C7274;
	Tue, 15 Oct 2024 11:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992689; cv=none; b=Juw54ywiyvytVti6SeM7N0VO2z9PPmiT2/WusuB8pSofKcLGtT6zYSai855CWE0GsnRu0qMOQnARlHMPod5464s0WgABoUdV6rvmP4vJSNeWraYq9h5KSlcGmb0jxhqiipk6WVQl8KoK21vC4wJpjmjiKS/Jykh9mCe2ozYgvl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992689; c=relaxed/simple;
	bh=BjGESxBClHiHmn/ewr4C/mNqPgfod0GU73JDInT1wQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s1ohHT8B03a+yuSvc7ZfdYnYVurYbfDOdmPGc5PTjWlQ/1p8PLfzlHLSCHfVOE6DCIo8jFBT4JJNeMXJcU9eOR7bPoQ8D06q7MNgZbe8eUDvy1qKGiwguPpVLiIoT+mcBe+asqQoAhoO85Y0/B93DVxYggP/slE+QIuxAHip1dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ONkPz/rg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ONkPz/rg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F34C4CEC6;
	Tue, 15 Oct 2024 11:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992688;
	bh=BjGESxBClHiHmn/ewr4C/mNqPgfod0GU73JDInT1wQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ONkPz/rg5Rh7DxpnyLFEaHKs+JSZeHkG0+qDtTtfJ6yh2p6FsnpoUc0x11BTXN5OU
	 DW1pJmxVqaLp/kUmSn+hz6ThHamNLewWkQmf1AI4elkL1mpImKz05Idz8Qz0721FcD
	 YQvXEGImQlegrvsLUYccVXDVbEnToaGMyJx/gecM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan McDowell <noodles@meta.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 190/691] tpm: Clean up TPM space after command failure
Date: Tue, 15 Oct 2024 13:22:18 +0200
Message-ID: <20241015112447.899313161@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index dc4c0a0a51290..56e56a09cc905 100644
--- a/drivers/char/tpm/tpm-dev-common.c
+++ b/drivers/char/tpm/tpm-dev-common.c
@@ -47,6 +47,8 @@ static ssize_t tpm_dev_transmit(struct tpm_chip *chip, struct tpm_space *space,
 
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



