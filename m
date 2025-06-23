Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903C319C554;
	Mon, 23 Jun 2025 21:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714074; cv=none; b=pLZ4x79lPqxBGHyk0Zh/KzbZhpTL5GGvPWpgkbLHHTHGV1/sGqD5ZRjqrV9db53PEg1gabBJq6xYuKc+PXvww6WL4LWBb2sqaoG5xyaXvmKIW/6OB4ZE+vHjFCMgOHEpCQogqeramZvJAJTypj1WgF4pN8aXwPQ1JEnN1ZCD/2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714074; c=relaxed/simple;
	bh=rExsFh8giyJuxsj6EKvNjn80rDeRC9PGIhX0h216Xtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gGeJUiIXBG3pAaSSV2xra2BhPRTbm+5SJsKjxevTaLdrGyd1luLByNeZzcO+v2GgshpOXJvflDeCDCPm+A39RDiMvytnTHq+KVNpM3iFX9edUT/hgkwKUTOXhyIhf3duyzUQxVqDD9C68e/XSSLc7eDO8/TmWvBURwyMRzfKf2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fp5Ilopu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fp5Ilopu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FDFBC4CEEA;
	Mon, 23 Jun 2025 21:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714074;
	bh=rExsFh8giyJuxsj6EKvNjn80rDeRC9PGIhX0h216Xtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fp5IlopuBtmD0JgnJ8ze4I0QPDeWpMghlvvKuC3Suz1+XIgDWrpAgPGPaZFTxlgVV
	 MDEAmGN0oEO5M+m8RM7SUmFx0uTZCEQYZCZ5Tp4ZRQmOxQ9rhSEssutkIaqJ82GV9P
	 jCqQi2j+NZgkORan6X0oGGLS/B75WmwFI/oO/V3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 143/508] rpmsg: qcom_smd: Fix uninitialized return variable in __qcom_smd_send()
Date: Mon, 23 Jun 2025 15:03:08 +0200
Message-ID: <20250623130648.805509806@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 5de775df3362090a6e90046d1f2d83fe62489aa0 ]

The "ret" variable isn't initialized if we don't enter the loop.  For
example,  if "channel->state" is not SMD_CHANNEL_OPENED.

Fixes: 33e3820dda88 ("rpmsg: smd: Use spinlock in tx path")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/aAkhvV0nSbrsef1P@stanley.mountain
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rpmsg/qcom_smd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rpmsg/qcom_smd.c b/drivers/rpmsg/qcom_smd.c
index 1044cf03c5422..eb2e66f5ca7b5 100644
--- a/drivers/rpmsg/qcom_smd.c
+++ b/drivers/rpmsg/qcom_smd.c
@@ -746,7 +746,7 @@ static int __qcom_smd_send(struct qcom_smd_channel *channel, const void *data,
 	__le32 hdr[5] = { cpu_to_le32(len), };
 	int tlen = sizeof(hdr) + len;
 	unsigned long flags;
-	int ret;
+	int ret = 0;
 
 	/* Word aligned channels only accept word size aligned data */
 	if (channel->info_word && len % 4)
-- 
2.39.5



