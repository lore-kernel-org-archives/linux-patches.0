Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A1422259F;
	Mon, 20 Apr 2026 15:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700589; cv=none; b=vEzeusWex9ueTQaYMywoC0t+wqpCRn4Zq0X+H8OI7OZPk9r4bU2hLfQtIirb8ALnrX0PclvugHsdcXreKHbHfA4nP3sfL3mPIU94NY+W97RCLm1iYZDNzE1e39hgBAlWtXrCUZjfD39oaTpDErtYlReGNIlRrNMSCAAd5X8cFdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700589; c=relaxed/simple;
	bh=s+wTvAigG/gYwgWzHHMrbWJMXAvvMVaWM3+aOkV9f7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mha4D6fDUUAOiTJxtdSTNkprOaJLqEu3hCwvXRb6ccO557L/0GSifIOHCl6eeOHR9YpNgLeFiAuwgTMqauodpSyIo0lWuDLjf/mwoZGqtnwgQGRpr4kGZpS/yvoK99z7vJsJNhZb6ftcil/ymwr+tUTw4UKbS64Oc2UASkzV1Ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FwK8n/4j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FwK8n/4j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C483EC19425;
	Mon, 20 Apr 2026 15:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700589;
	bh=s+wTvAigG/gYwgWzHHMrbWJMXAvvMVaWM3+aOkV9f7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FwK8n/4jrk6tb62+hfDzZWGlc51Ht0CDOrRm30YyNjICPaNlKsON4TlaVwNz0+hT9
	 iXCu8xzFlrdl5WSgnodf93BCmZVzNR6DVPnazi9CvJjWDfgzPSwPq2RMclSvbSma0m
	 EIbFH1JXrZpFbMbD5KNHv0JoeGeBuyNByJ0JZEoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 011/198] ASoC: SOF: topology: reject invalid vendor array size in token parser
Date: Mon, 20 Apr 2026 17:39:50 +0200
Message-ID: <20260420153936.021209995@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

[ Upstream commit 215e5fe75881a7e2425df04aeeed47a903d5cd5d ]

sof_parse_token_sets() accepts array->size values that can be invalid
for a vendor tuple array header. In particular, a zero size does not
advance the parser state and can lead to non-progress parsing on
malformed topology data.

Validate array->size against the minimum header size and reject values
smaller than sizeof(*array) before parsing. This preserves behavior for
valid topologies and hardens malformed-input handling.

Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Acked-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20260319-sof-topology-array-size-fix-v1-1-f9191b16b1b7@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/topology.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/sof/topology.c b/sound/soc/sof/topology.c
index b6d5c8024f8cf..4c8dba285408a 100644
--- a/sound/soc/sof/topology.c
+++ b/sound/soc/sof/topology.c
@@ -736,7 +736,7 @@ static int sof_parse_token_sets(struct snd_soc_component *scomp,
 		asize = le32_to_cpu(array->size);
 
 		/* validate asize */
-		if (asize < 0) { /* FIXME: A zero-size array makes no sense */
+		if (asize < sizeof(*array)) {
 			dev_err(scomp->dev, "error: invalid array size 0x%x\n",
 				asize);
 			return -EINVAL;
-- 
2.53.0



