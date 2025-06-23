Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E3671ACEDA;
	Mon, 23 Jun 2025 21:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750712926; cv=none; b=Ylusarokf9Ih4Tp2mT7Ix9HVPde1Mfi6Mqexqxn9ETE24hKKKR9WhVgEXhDhxOt40DRkJraiL4UBdk9ijJrg+dT7aOaFhh/GvpvYKp3V/DTBFXvZycIhFORPixkuLUsw2TG5pRci/nZkKvegG1PNEzA8K+LpZuivdBsGQFE0vh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750712926; c=relaxed/simple;
	bh=Q2Cx9rok8Bl/3GGEgx6jIGJLLYKBOHz2pPF94fWYU9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kDmew+bpBFPhxL/zwrG6T9tPGglvsllK1GkRuXRstxOlGhKXgkkkg2jIYG9CnpHIqLa2eqfB8YIrKm+VAhiAN+l4NCOoVcj1lilLGcP0g8+JwWLnPaxhzXbz6VkKrkk1udkn97DoOqIGgbgfVkMa8ud1neuPbhvFNR6cKbVxrko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T/UDRvxR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T/UDRvxR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD31DC4CEEA;
	Mon, 23 Jun 2025 21:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750712926;
	bh=Q2Cx9rok8Bl/3GGEgx6jIGJLLYKBOHz2pPF94fWYU9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T/UDRvxRF8FIdL+Ye9RCWfT5QWlmXDdO0iWOJ01i5Thmtstv+1WZKa50NxNIEv91x
	 M1dls5F31jPGIQXCSl+zSG3F8H04pwf8SCWlN2wE7MOOGSaq0tozvHczilccwHWFgt
	 jjOPqnuNKlLLiM1+gAtOnnTRWlru18A3xckMS3Mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 096/411] rpmsg: qcom_smd: Fix uninitialized return variable in __qcom_smd_send()
Date: Mon, 23 Jun 2025 15:04:00 +0200
Message-ID: <20250623130635.896258268@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 56bc622de25e5..74546b5f18817 100644
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



