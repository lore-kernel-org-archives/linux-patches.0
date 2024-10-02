Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F6F1D1F4B;
	Wed,  2 Oct 2024 14:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877881; cv=none; b=A1ytwQdfmVxuHocwZpVhOQorpa+yaed+oqybDeopgwHylGwdwkY0O3ZnudlpHeZ4skQf7p3LcKyGJR4tMOaM2aK/hXYsihf8m+mWhgVc4ChBt+kObId0t4YTrGYpqTWMK/aIdBJcqhWhFuBQL2wHHsOhgPAm3fpuwhbK7I+oDuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877881; c=relaxed/simple;
	bh=j5V+QpZ74sY61fVzfgzTxBubwqeiiNj/o1WhLzgC2zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eoXhyTU91MI7cH+wCGT+XER8OZfOUdm/IPlK65iMEKD1mAiR/4jQAjIllbWB9kYTD5wuUMiYd74uTMs4joJkMD6OuoCzbS962I7FaHPRdtBHiD3dPFq3195IKsw74LdNxBDvpN3x2wWzy6g4RDjOmYLyMGoKL/h90XpXsRzDnJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1NAVY2BV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1NAVY2BV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F15DC4CECE;
	Wed,  2 Oct 2024 14:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877881;
	bh=j5V+QpZ74sY61fVzfgzTxBubwqeiiNj/o1WhLzgC2zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1NAVY2BVWKrlvRE9OR6B85bRtZTDAZG/v5j5xV0DcdBdUd8BLgCiPNIc3dedizjCf
	 urGwzEW/eQWYIspIQ84HpCFXfutbbO9Dg2uRHtsT+vA0ZHqxDF9OjFSZLezk/a9dmS
	 gUM+cwbKSl/gBKQBwI+C5HA+mhoFWiaxBaCWTJys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan McDowell <noodles@meta.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 226/634] tpm: Clean up TPM space after command failure
Date: Wed,  2 Oct 2024 14:55:26 +0200
Message-ID: <20241002125820.019905123@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 30b4c288c1bbc..c3fbbf4d3db79 100644
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
index 4892d491da8da..25a66870c165c 100644
--- a/drivers/char/tpm/tpm2-space.c
+++ b/drivers/char/tpm/tpm2-space.c
@@ -169,6 +169,9 @@ void tpm2_flush_space(struct tpm_chip *chip)
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



