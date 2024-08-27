Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AFC41C4EDC;
	Tue, 27 Aug 2024 15:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772224; cv=none; b=ID6gpS52OaxHw0tSUuaXwDxojV87RgXNqPvQpRpHjmsrHv9sDgtZZGo0j/R2GQNlvOIxOBxiKzEZ1MmzqSFRQX+oUX4CZvttrUwT1pBw1kGFtDOlDfTNop+nft4vVw6cYXByYioP9fRKeB9teEryB8ClykGtKCn92LA36rYb1lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772224; c=relaxed/simple;
	bh=C0Y99lSR3Ne+BpRn+43lxhVHD835UTaLYAo5vb1k83Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HPmYuFVEMrS5jOlL5OvrJNjLPO82bvlVPLxxGm/05B4a4vZJK4DECwOMkHEfF2UVog/DfROkV1Z2XxXh2g1ZIywWFKFhVaoFNsqeX4EMGgodZg7/ovk+/tZ4hEnGI1s8GHsEnKZJeOOF+cmRE+XhfkyFKu2IwH7G/xSlI4SZtfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MEUdkgWl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MEUdkgWl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09A8AC61064;
	Tue, 27 Aug 2024 15:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772224;
	bh=C0Y99lSR3Ne+BpRn+43lxhVHD835UTaLYAo5vb1k83Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MEUdkgWltI7RJ7EW/ow+tUZ4uOODt0oHkF0VDUJXC5QVbeRUNfViJOUop3dnMDs4h
	 BTijffzkSOA49pUeonkDCBCDnjS+5klH36bOcWs+j5vPVcugQuBpOvqTyY6N/7eLR5
	 +46f9P9u3XL/41WvjbUg064NNkjX4Id/Hv++D3G4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashish Mhetre <amhetre@nvidia.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 151/321] memory: tegra: Skip SID programming if SID registers arent set
Date: Tue, 27 Aug 2024 16:37:39 +0200
Message-ID: <20240827143843.983950376@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ashish Mhetre <amhetre@nvidia.com>

[ Upstream commit 0d6c918011ce4764ed277de4726a468b7ffe5fed ]

There are few MC clients where SID security and override register
offsets are not specified like "sw_cluster0" in tegra234. Don't program
SID override for such clients because it leads to access to invalid
addresses.

Signed-off-by: Ashish Mhetre <amhetre@nvidia.com>
Link: https://lore.kernel.org/r/20231107112713.21399-2-amhetre@nvidia.com
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/tegra/tegra186.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/memory/tegra/tegra186.c b/drivers/memory/tegra/tegra186.c
index 7bb73f06fad3e..fd6f5e2e01a28 100644
--- a/drivers/memory/tegra/tegra186.c
+++ b/drivers/memory/tegra/tegra186.c
@@ -74,6 +74,9 @@ static void tegra186_mc_client_sid_override(struct tegra_mc *mc,
 {
 	u32 value, old;
 
+	if (client->regs.sid.security == 0 && client->regs.sid.override == 0)
+		return;
+
 	value = readl(mc->regs + client->regs.sid.security);
 	if ((value & MC_SID_STREAMID_SECURITY_OVERRIDE) == 0) {
 		/*
-- 
2.43.0



