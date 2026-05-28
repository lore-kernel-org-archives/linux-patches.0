Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656FE3164B7;
	Thu, 28 May 2026 20:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998641; cv=none; b=ee8fhdZ2IAG7pXQ3a6CKFKCPUO7F8OKEp9SBQ84WbM7vadQjeq2GKSqKnLKGOb9hIZwb255QXoP3+1pEOMpiCFziVtgkbfPRU8HrAVw3bawbPEVarsr+tQHFw0X/HvraNvMhgnJwzq8CMr/WRZcENFtKoL+3Shz+FbciU6Nk1EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998641; c=relaxed/simple;
	bh=d28YXhRfQ48XsXdAehpMN67cXx9huivHIEekdtphlvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y/n0SXO6B/ksUkvfOAUl1ihAvlFb7seHayawgBtkfJU04rKLlDz56PsMEts3LXR1OzAZTlL2CVQpaF4pZCHWUDpdDz788h/5VlLH31oDCZbztm4lG+eW3VeixME/EBIaCzvHd191NXwUu/QiUDsEw9UpSwj3fMqd03NvTLsK7wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZcfXS/av; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZcfXS/av"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA4A71F000E9;
	Thu, 28 May 2026 20:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998640;
	bh=UXhTAGVQv1DX+bAJEtnnyCOB/6XA0NrwEeFYu0JsqvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZcfXS/av5lPKTOWCjKSU/aaualCRURJ+8H263jeaD2W9lWSVL0XrfRgG1fjTNDuJF
	 yhGVeWrIhZLJ3nVhhn884nDFx2xqaHyiJM4wNaBX2NA4zqbMDsvJoUF19476o0sKDt
	 DzWule0nikydRNgk0x1pBaJ+/zAWyVUyjQ9H6Ua0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 246/461] ASoC: SOF: amd: Fix error code handling in psp_send_cmd()
Date: Thu, 28 May 2026 21:46:15 +0200
Message-ID: <20260528194654.266806898@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 2c7b1227e582e88db7917412dca4e752c1aff691 ]

The smn_read_register() helper returns negative error codes on failure
or the register value on success. When used with read_poll_timeout(),
the return value is stored in the 'data' variable.

Currently 'data' is declared as u32, which causes negative error codes
to be cast to large positive values. This makes the condition 'data > 0'
incorrectly treat errors as success.

Fix by changing 'data' from u32 to int, matching the pattern used in
psp_mbox_ready() which correctly handles the same helper function.

Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/linux-sound/agGES8vWrLOrBu28@stanley.mountain/
Fixes: f120cf33d232 ("ASoC: SOF: amd: Use AMD_NODE")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20260511153638.724810-1-mario.limonciello@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/amd/acp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/sof/amd/acp.c b/sound/soc/sof/amd/acp.c
index 71a18f156de23..f615b8d1c8020 100644
--- a/sound/soc/sof/amd/acp.c
+++ b/sound/soc/sof/amd/acp.c
@@ -223,7 +223,7 @@ static int psp_send_cmd(struct acp_dev_data *adata, int cmd)
 {
 	struct snd_sof_dev *sdev = adata->dev;
 	int ret;
-	u32 data;
+	int data;
 
 	if (!cmd)
 		return -EINVAL;
-- 
2.53.0



