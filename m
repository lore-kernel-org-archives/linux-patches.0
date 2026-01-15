Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E3D62F619D;
	Thu, 15 Jan 2026 17:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499178; cv=none; b=oivaKrR5rQDbQqG85DR7PbRg9FGMAcOaKbVobltYHsU+cpC2sBwWMiSgj8ksa1diGLI1WjxmrSXhjLlhXUzASaBdNN2PQFLTUCQ4jFc+u6tW1LVGNLzxD3iosfukU1ZfvYLxD1V/4bO2BdY53SKUEw512JNsHhGTPuwBlgxNy+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499178; c=relaxed/simple;
	bh=YLcAimgabLN2S6v/rS35CJmcpsl5FoKeSopVNdAcVqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TXrHQ9E1wkHUDHpk+td2pPPZWEHeC/930HjEpStXVU/apZ8dT2JwCFildfNwIfW2D39HrS1bJYLsJsxYLhqHUVVB5mbx6MXvI7M5XnyXpiGX9o95gGxbO7HOB/4sj1tGCKEqG7YzsFRKmFOfeNYoijlCa4zSVOh0BvF6kVu4uAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KgW5o7aG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KgW5o7aG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC3A5C116D0;
	Thu, 15 Jan 2026 17:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499178;
	bh=YLcAimgabLN2S6v/rS35CJmcpsl5FoKeSopVNdAcVqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KgW5o7aGoDnEdlVennz2tlTiGoZgO6cCqTM/nNvoWbvzqSJthq4zreupdtxmJkgw+
	 /eIDIqOy1FX1TLsEcqSkTkXQgLEAbXo/MUO7hxIjZAddD68UohJ9DDtpDWOX8+Do0C
	 fekoZe+urLDyXCyos9tDKvag9QjFEM4jbw9wzI30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 136/451] ASoC: ak5558: Disable regulator when error happens
Date: Thu, 15 Jan 2026 17:45:37 +0100
Message-ID: <20260115164235.839629233@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index adbdfdbc7a38b..60ca51845d3e5 100644
--- a/sound/soc/codecs/ak5558.c
+++ b/sound/soc/codecs/ak5558.c
@@ -330,7 +330,15 @@ static int __maybe_unused ak5558_runtime_resume(struct device *dev)
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



