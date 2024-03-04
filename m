Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A2B07D08F;
	Mon,  4 Mar 2024 21:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587902; cv=none; b=isIym9+8t/scFIwfEXZL/73EUGt8Z1sce/HABaokVS7/2+MUCC4WwwuO9FpgMAjeak0j9q9MkbaQlCY9rMYojkHVcSJFuZWNVKtY4HLNk60ctXT2O1DeVpaXn81hw0M2OO5UBo8iBRHEHvA1dymkEfI0PKU2yA4O5aJQX+d1FY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587902; c=relaxed/simple;
	bh=zl252ctplfA2cLZq520kPwnZQj6UB5eikx6YLwMbNSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C6uDa4rBzuOSHQEAW6QabtfEJjUFiY8jmXp7Eg1CzmK7yaEacLATTYqDEU/750a3agt04gJoAIFM4xIKFDpEUaY7sG9iY1NP1uIP2tgVhE/LDn7PYP93a/mq845gefb7j12F7onGT4PhXIJG1QUOSryZMzVtWYoIJAbOLhDAV6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bJzg7fOC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bJzg7fOC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D743C433F1;
	Mon,  4 Mar 2024 21:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587901;
	bh=zl252ctplfA2cLZq520kPwnZQj6UB5eikx6YLwMbNSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bJzg7fOCv+ey+HUJMzC5br+SuYsb7t0ybw0EojyvDutyyAiQffUVQMsI5ZewxR++a
	 cYYVi4GAJW07owe+kcWffz/OEHAlIOw3704DN4I6peM6zvBP6qm9DWZcgYh/D4ox4j
	 RXSJFadEAPzYyCt+yfNTQtmLt6975jQ525EjQlSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.7 134/162] ASoC: cs35l56: fix reversed if statement in cs35l56_dspwait_asp1tx_put()
Date: Mon,  4 Mar 2024 21:23:19 +0000
Message-ID: <20240304211556.013515702@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 4703b014f28bf7a2e56d1da238ee95ef6c5ce76b upstream.

It looks like the "!" character was added accidentally.  The
regmap_update_bits_check() function is normally going to succeed.  This
means the rest of the function is unreachable and we don't handle the
situation where "changed" is true correctly.

Fixes: 07f7d6e7a124 ("ASoC: cs35l56: Fix for initializing ASP1 mixer registers")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://lore.kernel.org/r/0c254c07-d1c0-4a5c-a22b-7e135cab032c@moroto.mountain
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/cs35l56.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/cs35l56.c
+++ b/sound/soc/codecs/cs35l56.c
@@ -175,7 +175,7 @@ static int cs35l56_dspwait_asp1tx_put(st
 
 	ret = regmap_update_bits_check(cs35l56->base.regmap, addr,
 				       CS35L56_ASP_TXn_SRC_MASK, val, &changed);
-	if (!ret)
+	if (ret)
 		return ret;
 
 	if (changed)


