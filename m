Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 029E175809;
	Mon, 14 Oct 2024 14:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917794; cv=none; b=JcBPEYP2DzFD3y7VDNNJIlx61VILnrgCtUyPMAOGp1XZMZ/PMaqPkNEDVGTPOIYTvm5EmVcSg9z2a4WUlZH8M4veiIDbpGLT1xhA6/Wbv3JHu/qVa92HRm9R2aXIsUGgbCPEach7SiLgV3rh9xnSJn4KIj8UcqTqEZJ97fmV8RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917794; c=relaxed/simple;
	bh=ph1KVbRynKx3kfjg3530qfkFQiCl0kcV/8whah0CS+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sz4ndbRjj0dxmtTGKduy+la9LNIUqfcxSRqdjuVypgEX4oJu/sHU6eN1ewmsU00E3N/povj+CfXhDM5RKPai4jhby2v/Vdx/Qk8GjMgsjZkiYnzAka9jPjJ/uYtvKTd7mT4Twvx9BOAlPm34fxVGiTfEjKt0sjOYYkiX5yRX7kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gCIdpt0+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gCIdpt0+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77203C4CEC7;
	Mon, 14 Oct 2024 14:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917793;
	bh=ph1KVbRynKx3kfjg3530qfkFQiCl0kcV/8whah0CS+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gCIdpt0+Ku4WzdfRIBwItW7BqJx8vApbta87NvVg8pL9MneQ3hvLQ4zWVFDyoSoAO
	 IsKhsrbAAywo+LaeUkUqh0GmJlBOcyvSWo3L0OPj9KOcptaMjzC2Jkb2p6ZfYgbIKa
	 RAni22arfe7tQ2LtVtmKRC8rGu39vI07IrMZAyKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan McDowell <noodles@meta.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 137/798] tpm: Clean up TPM space after command failure
Date: Mon, 14 Oct 2024 16:11:31 +0200
Message-ID: <20241014141223.301741475@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



