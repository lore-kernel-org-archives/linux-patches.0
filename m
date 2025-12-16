Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0450E258ECC;
	Tue, 16 Dec 2025 12:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888519; cv=none; b=L/oSSTXwz02khHhlN/EeZBlA2ejRPW8LeDKSAbC1eRvK8hEb0U0ZaS29rkfNoOPHsl96fNx5jaI6Mkc1Q/Z0VjV16IMVhyb8rJp5iTpeZOb0AEq1yH8DZBFTDk9ofd8RAj/XqKaLXTXzUauxJN5xGzxLewoErZJtb34CMxxq8G8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888519; c=relaxed/simple;
	bh=E5WUMOSvSkAUkS1NrR8U8Q3ZQ5PuRnPFKvgrbY41WeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mBwP2ZKpX987UwhwRnXVOj3a/bJtThG1N++Rnirk5gBi8k0pO0WKRacaHWWVs5iGaGQYYIAgDOq3Y6/a7XJsow5RVa4qm/un3vgilPyJtVwuyefssgguglMwi3Z3NoXPJ454Up6FGqf03/Glw/cfwcCuaOkBtWwiYwYZVvLrh0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kMV4oWGv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kMV4oWGv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21345C4CEF1;
	Tue, 16 Dec 2025 12:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888518;
	bh=E5WUMOSvSkAUkS1NrR8U8Q3ZQ5PuRnPFKvgrbY41WeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kMV4oWGvqXpmJT0cyYDG3DjCOIrhrm8uF6H/0zuo4mdJc2OXKTS9F1ACms6UUKVKI
	 6GQKqp9rqAhhqV+HtxpMeTTsSPPqS7e/dE88W1PzulkoOE7jgHvEkWSpFwvVbt0JY9
	 1J9AxQ06aiuM9kJIQ0h7oV4C594cw4cPVgnoc01w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 557/614] ASoC: ak5558: Disable regulator when error happens
Date: Tue, 16 Dec 2025 12:15:24 +0100
Message-ID: <20251216111421.560466923@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 683f3e472f500..73684fc5beb1a 100644
--- a/sound/soc/codecs/ak5558.c
+++ b/sound/soc/codecs/ak5558.c
@@ -372,7 +372,15 @@ static int ak5558_runtime_resume(struct device *dev)
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



