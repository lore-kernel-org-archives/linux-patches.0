Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A03BE19DF41;
	Wed,  5 Feb 2025 15:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768453; cv=none; b=gFmVjRjJEGr0P0xnkKM/B7C1cxWgg1hDg5lUEUzWAuva9haQ9I6wqSPGu04HokgfViiMYYrn691evz1UxR9sXNIHjoST8Lhtr0kU1J+d4hFIyZu/E8w4y2APQ8QFKCDpcdfFDKw4Rko4zuPhTdfcjiMB7rVkXLl4obVXUn7Ke7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768453; c=relaxed/simple;
	bh=ftkbrEl863TRcoOPlX8Yr1oSiSkwxb22E1S1Zvb0u/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SokT7AVqRa1ChA9lLpCzBqe2Qbr9zyNqmfZhIqLoIMWZv2G8/935d9cRGOFmMFH563GA3KPL+2fqOlHXWuZ7wI9zG4rUr5GsdXkA71lZen10zyDRWix8+dCeNpxR/yYB9TQPQA4sadJtul/ShKhWOlNCU7F+w7uPJKoqYVV47YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cVALwXDs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cVALwXDs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1D9DC4CED1;
	Wed,  5 Feb 2025 15:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768453;
	bh=ftkbrEl863TRcoOPlX8Yr1oSiSkwxb22E1S1Zvb0u/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cVALwXDsOkvUmhOAh2kpgq7LfGvCs80A3PywLCKQjEEfcIis35HT9ZYI1RcuoyujX
	 LOFEFlvf/z6U+IhS7A4MhwOBphHOa8CO0/CQqs9GsonIk9n+Gcspq0rAV7uRkO82c6
	 Zd+EQYMi39XqonybzDwc14tglNu+clFonazvza08=
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
Subject: [PATCH 6.13 562/623] ASoC: amd: acp: Fix possible deadlock
Date: Wed,  5 Feb 2025 14:45:04 +0100
Message-ID: <20250205134517.718523119@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 1f59ee248771c..89e99ed4275a2 100644
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



