Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84D3521345;
	Wed,  5 Feb 2025 15:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768084; cv=none; b=J9kLLnw45BimDJZuhhSQShQtvZqtlqY3D6nEDstp0m5JGGf2k7JrIHWUMwZj+dqmZGoVdpmlZejArXt3LHdwFfR6i+XSrgNcwqpjZ88uobsHUt3rXSQK609vQNlhlium7wFZ6IDFsbzDPpQCf7o9TRpQygXPKXupoksctWHMUGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768084; c=relaxed/simple;
	bh=nBhzGBVgS3kUiQnawUsGCUUdlr1C2utj2qJCrVfbtLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dOIHn12dNFG7CleZHK9lvqa5CEGfszG/NJKxq7912vRqKUC42Pb7otwU9EBwHTX0eBjwA0Ljv7H7jnw7piw1/n65nAmTAFBTFB/7TsLAlYNDKZxKReJFGBt9Lk6RkVyFsrj/pGEfgVKj/aHUuGliG7CsT0ENoGVlp3Db32ISXQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xR2xqEN1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xR2xqEN1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD233C4CED1;
	Wed,  5 Feb 2025 15:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768084;
	bh=nBhzGBVgS3kUiQnawUsGCUUdlr1C2utj2qJCrVfbtLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xR2xqEN1udz5QILrR+rxcmtuWIMut9CVeIh+p/9ju13h0VWy+jsVZBVA0Hri8iih5
	 KorJ/ndBlLT0h7Z6Cml/2vocb5Uy2YKEXVG20ZOBUPPVt+ype+ksIR61LVRSOlAb6l
	 mbmRHrJmSt9ga8TgBixS+j2/LegzYJ64CO+EeIXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 528/590] ASoC: amd: acp: Fix possible deadlock
Date: Wed,  5 Feb 2025 14:44:43 +0100
Message-ID: <20250205134515.464825228@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

From: Daniel Baluta <daniel.baluta@nxp.com>

[ Upstream commit 3ff53862c322aa7bb115d84348d5a641dc905d87 ]

On error path, function acp_i2s_set_tdm_slot returns without releasing
the lock and this could result in potential deadlocks in the future.

Error reported by sparse:
sound/soc/amd/acp/acp-i2s.c:95:12: error: context imbalance in
'acp_i2s_set_tdm_slot' - different lock contexts for basic block

Fixes: cd60dec8994c ("ASoC: amd: acp: Refactor TDM slots selction based on acp revision id")
Signed-off-by: Daniel Baluta <daniel.baluta@nxp.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20250127083422.20406-1-daniel.baluta@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp-i2s.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/amd/acp/acp-i2s.c b/sound/soc/amd/acp/acp-i2s.c
index 56ce9e4b6accc..92c5ff0deea2c 100644
--- a/sound/soc/amd/acp/acp-i2s.c
+++ b/sound/soc/amd/acp/acp-i2s.c
@@ -181,6 +181,7 @@ static int acp_i2s_set_tdm_slot(struct snd_soc_dai *dai, u32 tx_mask, u32 rx_mas
 			break;
 		default:
 			dev_err(dev, "Unknown chip revision %d\n", chip->acp_rev);
+			spin_unlock_irq(&adata->acp_lock);
 			return -EINVAL;
 		}
 	}
-- 
2.39.5



