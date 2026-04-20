Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C74A3368AE;
	Mon, 20 Apr 2026 15:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700019; cv=none; b=iDM26i7owp9WuKJ1WSVLWNnkor3akwAsjZnfxUKUyyeqz9Kk2EgSuLpWRgwFVafc7ttC3Xt1XW87X1lyFfqG45Y79esz9KMyTZD/vmOHlDI6gIRDnvN5QW64MyEcYDxPI9kYYUxe/oslD1zNxeuzSDJ0ncduGwZXPmeeqsk7GV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700019; c=relaxed/simple;
	bh=R7K6HvWBSn1ljIuWDKqQ1oTVUgFk9dk8z0oDhpSiRoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GVZI+OlzzB3yFf/V00eeyiC5WtQJiJikq4YGeFJrumcvMvQMDnOnhHa53VbYtEGoEIuaNqKYnGt7jqycGkjlNyCb2Srwzh4+gaP3TFUvMUMr1ch/Y7EWa2u+y/HaLTZaKmrNJo/E4Ha6dXwjUo2gf4DZ7nWj+y4+S0hIqOGa3+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V4ulPiHz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V4ulPiHz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13655C2BCB6;
	Mon, 20 Apr 2026 15:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700019;
	bh=R7K6HvWBSn1ljIuWDKqQ1oTVUgFk9dk8z0oDhpSiRoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V4ulPiHzT1uNl9QtdtKAeVA9/LRBg9gdEyrt/sOIbj8uWYPTf8sdV6c5dAbpqMokU
	 6TKQU3sd5/Wqrjn2jzWMhxpqrKbnExRFHm9vDYlg4ltANFluYryVlr4ZDe0GfF3i6g
	 y8QE4gvjVlJThg8X9gsodyAX1noCxcxBBqHfI7gE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 011/220] ASoC: SOF: topology: reject invalid vendor array size in token parser
Date: Mon, 20 Apr 2026 17:39:12 +0200
Message-ID: <20260420153934.430944002@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 9bf8ab610a7ea..8880ac5d8d6ff 100644
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



