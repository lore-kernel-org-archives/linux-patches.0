Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E4DD8F58;
	Mon,  4 Mar 2024 21:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588358; cv=none; b=tpC6JNBAabZdgDyU0Tk8zfP24VhYGcRkbLsRLeH9FqeHVkBKbLGcw2lBCgifGCuMY0Sqf3CrxyKGk1SMTOTMeSCX/aN/V27HgUBa3vsLMdDJkd2BtASP7exT4JnP4HpPQIYwxpWAGoQTadM5qXu8rsnBYrb7hdTDsIYoo0vfMH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588358; c=relaxed/simple;
	bh=RWo58TPYdsKPj8G3RtrCRcTVCkCjHsM8Z7GaN06gIog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nha1QOwWxdA3qUWoss9ykJe8PL7pMY2VJkG93D38PRlSXVg2jZreoibw5IlLhn4MvARedNXMm0fRn9uHCmrtLrV8WuebIp2qp+9IrBrkur3a7+Qd8ohRcOzOcvgcKa0Y5VSO20ktzDOxSxf+h9C0ntdb30PnkpoBp1iExfpoibk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gW+P4FST; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gW+P4FST"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 119D8C43390;
	Mon,  4 Mar 2024 21:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588358;
	bh=RWo58TPYdsKPj8G3RtrCRcTVCkCjHsM8Z7GaN06gIog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gW+P4FSTqvt9mEXVUKerIdwhxK0aaFS4vzOnk4J+ZvGrcGlwT2TvvfI+90Yv70ri7
	 0AZPVUTCcCPA19OkjPuewXvYNd+MMkGCvEQ5u37C001pwtD0xIV2YbbawDhKUMrtpN
	 ohl3TtMNc1WCFj2yGyZpj7fqY9YCNLTm280Ta4GM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 052/143] ASoC: cs35l56: Dont add the same register patch multiple times
Date: Mon,  4 Mar 2024 21:22:52 +0000
Message-ID: <20240304211551.593890199@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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

[ Upstream commit 07687cd0539f8185b6ba0c0afba8473517116d6a ]

Move the call to cs35l56_set_patch() earlier in cs35l56_init() so
that it only adds the register patch on first-time initialization.

The call was after the post_soft_reset label, so every time this
function was run to re-initialize the hardware after a reset it would
call regmap_register_patch() and add the same reg_sequence again.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: 898673b905b9 ("ASoC: cs35l56: Move shared data into a common data structure")
Link: https://msgid.link/r/20240129162737.497-6-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l56.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/cs35l56.c b/sound/soc/codecs/cs35l56.c
index 1d0a2948f533b..6d42442a29448 100644
--- a/sound/soc/codecs/cs35l56.c
+++ b/sound/soc/codecs/cs35l56.c
@@ -1159,6 +1159,10 @@ int cs35l56_init(struct cs35l56_private *cs35l56)
 	if (ret < 0)
 		return ret;
 
+	ret = cs35l56_set_patch(&cs35l56->base);
+	if (ret)
+		return ret;
+
 	/* Populate the DSP information with the revision and security state */
 	cs35l56->dsp.part = devm_kasprintf(cs35l56->base.dev, GFP_KERNEL, "cs35l56%s-%02x",
 					   cs35l56->base.secured ? "s" : "", cs35l56->base.rev);
@@ -1197,10 +1201,6 @@ int cs35l56_init(struct cs35l56_private *cs35l56)
 	if (ret)
 		return ret;
 
-	ret = cs35l56_set_patch(&cs35l56->base);
-	if (ret)
-		return ret;
-
 	/* Registers could be dirty after soft reset or SoundWire enumeration */
 	regcache_sync(cs35l56->base.regmap);
 
-- 
2.43.0



