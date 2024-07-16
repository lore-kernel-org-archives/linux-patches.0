Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6FE1DDE9;
	Tue, 16 Jul 2024 16:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145667; cv=none; b=DRtAGwEr8rWX4fx7wHs+IWCU8/okdbmKrAseN1jU6AyKhQDOy5eS0xI3mrbzKEe/9Z8oYN+XUksQDNb92ODMYJIZ0zd+0rmBKWIRsn/xi0nG8D7SQykTdOXcg3WmrJaqkcvk0kAtXTw6IO3zHpVPgGeKjNkMs3dXQhwPTezKfMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145667; c=relaxed/simple;
	bh=2hfRZ8sCa0urjZUnLNmerxS2cNFR+ffLRXl9g9nIKn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lsrdVkAfdwAuxM09cSrzH+94fhOjctOXddj6K49uXu3NjSIhZkQsb+tjZcfmLPEA99oQRwRssGzFu9OEkI0bFyOaA8dzJHZtQkndw8Lb49iad/v0O1TcehRrYej5SiAN54nwJF6xv3mUZyF9wAbYgyk6+HkLQZUOLPPFmFimzaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wxt0OjXx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wxt0OjXx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85932C116B1;
	Tue, 16 Jul 2024 16:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145666;
	bh=2hfRZ8sCa0urjZUnLNmerxS2cNFR+ffLRXl9g9nIKn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wxt0OjXxMTGKyT9z7HqoNJYxO4Agu1jvxq4laJ6e0qi05x/B48AlKOPClFql+1X9z
	 V19iUY/8qZFLsCIoU4cbdGZRXKNj+DGhPIepTEPJWUfSb0xtmOWFTHyVgU47qiHRdq
	 gEqu9vp/M+mLKnLKKPrsnyWzYjyw49v+eBjWEcxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 043/121] firmware: cs_dsp: Use strnlen() on name fields in V1 wmfw files
Date: Tue, 16 Jul 2024 17:31:45 +0200
Message-ID: <20240716152752.981348273@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 680e126ec0400f6daecf0510c5bb97a55779ff03 ]

Use strnlen() instead of strlen() on the algorithm and coefficient name
string arrays in V1 wmfw files.

In V1 wmfw files the name is a NUL-terminated string in a fixed-size
array. cs_dsp should protect against overrunning the array if the NUL
terminator is missing.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: f6bc909e7673 ("firmware: cs_dsp: add driver to support firmware loading on Cirrus Logic DSPs")
Link: https://patch.msgid.link/20240708144855.385332-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/cirrus/cs_dsp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/cirrus/cs_dsp.c b/drivers/firmware/cirrus/cs_dsp.c
index 5eba9e913f7c3..bd1651e709365 100644
--- a/drivers/firmware/cirrus/cs_dsp.c
+++ b/drivers/firmware/cirrus/cs_dsp.c
@@ -1128,7 +1128,7 @@ static int cs_dsp_coeff_parse_alg(struct cs_dsp *dsp,
 
 		blk->id = le32_to_cpu(raw->id);
 		blk->name = raw->name;
-		blk->name_len = strlen(raw->name);
+		blk->name_len = strnlen(raw->name, ARRAY_SIZE(raw->name));
 		blk->ncoeff = le32_to_cpu(raw->ncoeff);
 
 		pos = sizeof(*raw);
@@ -1204,7 +1204,7 @@ static int cs_dsp_coeff_parse_coeff(struct cs_dsp *dsp,
 			return -EOVERFLOW;
 
 		blk->name = raw->name;
-		blk->name_len = strlen(raw->name);
+		blk->name_len = strnlen(raw->name, ARRAY_SIZE(raw->name));
 		blk->ctl_type = le16_to_cpu(raw->ctl_type);
 		blk->flags = le16_to_cpu(raw->flags);
 		blk->len = le32_to_cpu(raw->len);
-- 
2.43.0



