Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8460D3314B4;
	Tue, 16 Dec 2025 11:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884965; cv=none; b=PcUqJwEvl7kFBl+h32VCJYHT/pSkK0SqRVMTkl55HD1h818WTgyLqXDPNol/jVcernoMZJi+UqHNW0J+CYLhzI0HFItl4XFvEcHck7zG71KScDvd9I/V83KwnNKwNHx9cl+8CGNEF/oZM5Z1pYwFhtqkxCEOC0pJOxLoH1pwOs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884965; c=relaxed/simple;
	bh=5ALhiXYtH/3P6Z2OKqrmSXL2L4kFxce2kJmsnyxrnQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jc50tsBcEMyQ1/QtGjbzBFxNaOlz6uAF9EY4wCtJNXTLSsjcQIKOoA+aDkJyg4cEsUvSrDOVpxRO0szpfZ5YRHOR22n2uDlY7aydnRFE4xtjSLAXxzBVXrBCRV4gdW2OtV3ySiVUXQpv92InDnXQUV2E9VTatqOFDYrBAUn0jxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QRjuCdPU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QRjuCdPU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD5FFC4CEF1;
	Tue, 16 Dec 2025 11:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884965;
	bh=5ALhiXYtH/3P6Z2OKqrmSXL2L4kFxce2kJmsnyxrnQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QRjuCdPUnEcGRmeIS0qdHwM+XQUAS/5BVFQ+yIwg2qJTiJI4rlSr8yWE18bC2TX0A
	 VprT8fOwf161oqP+IX4zJfWvUnPPVB4efelPm9VF0lhEmbYpgSxRhWx+YF2ZN8L6pS
	 CRC4ollFfP//81Y6lFZBrqTujot3mMkM4VBPBnBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 319/354] ASoC: ak5558: Disable regulator when error happens
Date: Tue, 16 Dec 2025 12:14:46 +0100
Message-ID: <20251216111332.467867422@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 1f8f726a2a29c28f65b30880335a1610c5e63594 ]

Disable regulator in runtime resume when error happens to balance
the reference count of regulator.

Fixes: 2ff6d5a108c6 ("ASoC: ak5558: Add regulator support")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://patch.msgid.link/20251203100529.3841203-3-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/ak5558.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/ak5558.c b/sound/soc/codecs/ak5558.c
index 6c767609f95df..b1797319e4f57 100644
--- a/sound/soc/codecs/ak5558.c
+++ b/sound/soc/codecs/ak5558.c
@@ -372,7 +372,15 @@ static int __maybe_unused ak5558_runtime_resume(struct device *dev)
 	regcache_cache_only(ak5558->regmap, false);
 	regcache_mark_dirty(ak5558->regmap);
 
-	return regcache_sync(ak5558->regmap);
+	ret = regcache_sync(ak5558->regmap);
+	if (ret)
+		goto err;
+
+	return 0;
+err:
+	regcache_cache_only(ak5558->regmap, true);
+	regulator_bulk_disable(ARRAY_SIZE(ak5558->supplies), ak5558->supplies);
+	return ret;
 }
 
 static const struct dev_pm_ops ak5558_pm = {
-- 
2.51.0



