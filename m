Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BDC337EFFE;
	Wed, 30 Sep 2026 18:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791855; cv=none; b=mu/1/1O64N0sNtzrkzIpKr2zrvidUtqHpJEVrQpTOlqVZetE6dSgHk/LM+GwMTZ5yTCBiR97M1+6W3uOT9VtLLXcPmGadPM2JC4Er1d9+KPYmjnl7IC2ucVQdkNWpjkx39fdtRPjFPXCnmev8/UXpfqFnytuFo+el7izIw/QLFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791855; c=relaxed/simple;
	bh=w42v+Bl9YtV1dPnDEPgjQDaWt5yIiM+MaaIZilA7TGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cgQ47pdSdUuUgno3H2G+I7hw2ZZLdJLFHH19VWVtrbuja3Lto0JqlM2AdfFULYRl9iu06J/VPAxCVeRQCnTr1RbF3y7lKN+OoF3Zl96MCviC18BEERTdt16TWczFVs9xvz3R7eBDwdAD9b2s9vb3+jWcvOIhS+J2V82WpRt/q5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bm9JUbDo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bm9JUbDo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88D731F000FF;
	Wed, 30 Sep 2026 18:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791854;
	bh=D4qA0sjPX34zB2JimInrT+JDnQB00AgYjekLoMx1xD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bm9JUbDoif7kvMDJTNx/JN0TBBQMF2RrH0+baSiPFL6iCVm7pzcOMTn+IaOX8eBN2
	 EoeKoNVrDhnkw8lRHiLtG20Xdzj9yI3w3lOKOIa21rGFOa8RgRHMgU4oiwFKX4/15c
	 oSVADdhGGQhFmiftWpFiC2iO72BUYILxstXqsDF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xixin Liu <liuxixin@kylinos.cn>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 448/752] firmware: arm_scpi: reject DVFS OPP count above MAX_DVFS_OPPS
Date: Wed, 30 Sep 2026 17:25:18 +0200
Message-ID: <20260930152407.973729209@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xixin Liu <liuxixin@kylinos.cn>

[ Upstream commit 32471d84a487c7fd74532bc96be56f8028cf4a3f ]

scpi_dvfs_get_info() already rejected a zero opp_count, but still trusted
any larger value from the SCP firmware. The shared-memory reply only holds
MAX_DVFS_OPPS entries in buf.opps[]; a bigger count over-reads that array
and then sizes the allocated OPP table incorrectly (garbage OPPs / OOB).
The missing upper bound dates back to the original SCPI DVFS support.

Reject zero and out-of-range counts in one check and return -EINVAL.

Fixes: 8cb7cf56c9fe ("firmware: add support for ARM System Control and Power Interface(SCPI) protocol")
Signed-off-by: Xixin Liu <liuxixin@kylinos.cn>
Link: https://patch.msgid.link/022802f0b38f.v2.1785200642.git.liuxixin@kylinos.cn
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scpi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/arm_scpi.c b/drivers/firmware/arm_scpi.c
index 2d85e783ae267..aa27eb5278520 100644
--- a/drivers/firmware/arm_scpi.c
+++ b/drivers/firmware/arm_scpi.c
@@ -628,8 +628,8 @@ static struct scpi_dvfs_info *scpi_dvfs_get_info(u8 domain)
 	if (ret)
 		return ERR_PTR(ret);
 
-	if (!buf.opp_count)
-		return ERR_PTR(-ENOENT);
+	if (!buf.opp_count || buf.opp_count > MAX_DVFS_OPPS)
+		return ERR_PTR(-EINVAL);
 
 	info = kmalloc(sizeof(*info), GFP_KERNEL);
 	if (!info)
-- 
2.53.0



