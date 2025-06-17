Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B773D1A9B48;
	Tue, 17 Jun 2025 16:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177032; cv=none; b=cGA6uV5THH1GBnF02DfqYsw2pHl03fyr9BdCZ7avFmxE8bRUlN568Ir6+AehsKCzDARgY1uePnQ3Rihahrgrn+HMnJg8Iz9yweuTipzeDC2gCpHoUV53B1zlo/DiD1Jok4wZ83014kJBSd3Lz2yjVuLTUf8LXKe+/xSqscoOiS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177032; c=relaxed/simple;
	bh=GJk3FbPGf+h8Ue6QCVOCtj7YqmLZSyR+CsM330XSK8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LmZtAMPxNWfcdc5nmZCgQXA2K9O9I+KleWPNyCUjbRzZQ0qxLOQBzzBFz8vRw+TTOzxTeTxlRlCsBfG07CT/PkHEpQBXpTpu+Tmc2dcsj3NVr2dSch47o63XRqJbokAABdx5kfM9rMaVvDcUAh/6gzgaE9LU1oYFoVEguA65DfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=McsZ+EiC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="McsZ+EiC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EADFC4CEE7;
	Tue, 17 Jun 2025 16:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177032;
	bh=GJk3FbPGf+h8Ue6QCVOCtj7YqmLZSyR+CsM330XSK8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=McsZ+EiCzET68K7CrWe7h0MaVz/7dIKMh+aXJdPLEUQfZic9iMbj5rWOyRZxxf8CU
	 PkZGPoMdGISVwmNa2rSfbL7kJEGUJ/i/y98broKMvFipnoxHZw8NbOCKOSStGu85Df
	 gi0mpF9chTitu98LfS+9mG8XFR2vFXTI3z+1UsSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 290/512] rpmsg: qcom_smd: Fix uninitialized return variable in __qcom_smd_send()
Date: Tue, 17 Jun 2025 17:24:16 +0200
Message-ID: <20250617152431.355966102@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 43f601c84b4fc..79d35ab43729e 100644
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



