Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594E426FA77;
	Tue, 12 Aug 2025 19:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025551; cv=none; b=Yz9/wg4bB3M4icOAgiO86ZkfPNEeIxbSMWlAMd84enlPs0JtrdzTDYY8e7qX3UIoREQCxbpUxUKRSVp+0yN2NjCAUinWEziYRAh0ldeZ6DGDC2VCzIhD+2gQr1xgfojZVOePMpddczITmfsFykxwQbQq2Am8qN5ePvrka31dNZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025551; c=relaxed/simple;
	bh=vfzipKHmMdq7ul3FB9DrvQMiaVuJJEcxkqL/ekiboak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KEzVWrYvzGDDFQnMl8EwUivCcYmXpAvs+G33/gvGouG3hX4UUJKBwzzDNaxMUwwvuk+SY7M9pF7AlJB0D1daEysqdZPhHJnr2Ov1J9M+u/Fe32cook+P9/D0AZS5rod5HhG5GrzaPnB5vm1InzEhnp9B8qkQBqrqOK2VoO2EJxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fnT7LCJ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fnT7LCJ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2C04C4CEF0;
	Tue, 12 Aug 2025 19:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025551;
	bh=vfzipKHmMdq7ul3FB9DrvQMiaVuJJEcxkqL/ekiboak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fnT7LCJ/FZbyCCsAWNtJP7skwzoOUAfBr9dnmXWGPbHankby5YxrICrk+U2eAEyuQ
	 WgxI0XXLQXn7sk8iwvvIUfWWpdehPu/I97jP+4ieoXtlFu5diLIK1LEOpgqCh1XJYI
	 wG911IiZ1tyOKuzzaJn6lJ/Qx2anyIZWdLM447/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 073/480] staging: gpib: Fix error handling paths in cb_gpib_probe()
Date: Tue, 12 Aug 2025 19:44:41 +0200
Message-ID: <20250812174400.442815477@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 1b0ee85ee7967a4d7a68080c3f6a66af69e4e0b4 ]

If cb_gpib_config() fails, 'info' needs to be freed, as already done in the
remove function.

While at it, remove a pointless comment related to gpib_attach().

Fixes: e9dc69956d4d ("staging: gpib: Add Computer Boards GPIB driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/bf89d6f2f8b8c680720d02061fc4ebdd805deca8.1751709098.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/gpib/cb7210/cb7210.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/gpib/cb7210/cb7210.c b/drivers/staging/gpib/cb7210/cb7210.c
index 6b22a33a8c4f..e6465331ffd0 100644
--- a/drivers/staging/gpib/cb7210/cb7210.c
+++ b/drivers/staging/gpib/cb7210/cb7210.c
@@ -1183,8 +1183,7 @@ struct local_info {
 static int cb_gpib_probe(struct pcmcia_device *link)
 {
 	struct local_info *info;
-
-//	int ret, i;
+	int ret;
 
 	/* Allocate space for private device-specific data */
 	info = kzalloc(sizeof(*info), GFP_KERNEL);
@@ -1210,8 +1209,16 @@ static int cb_gpib_probe(struct pcmcia_device *link)
 
 	/* Register with Card Services */
 	curr_dev = link;
-	return cb_gpib_config(link);
-} /* gpib_attach */
+	ret = cb_gpib_config(link);
+	if (ret)
+		goto free_info;
+
+	return 0;
+
+free_info:
+	kfree(info);
+	return ret;
+}
 
 /*
  *   This deletes a driver "instance".  The device is de-registered
-- 
2.39.5



