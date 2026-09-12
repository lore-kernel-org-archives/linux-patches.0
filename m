Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6106E4BEE56;
	Sat, 12 Sep 2026 12:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215180; cv=none; b=fCMv1KHemNr0l5yyfIZSdf5DMxq/D3IuFlsCC9BOMfcwFKwHTzN6P+3t8af5cyFAJ4TvtLW944aZ3jj6ETxQmSE0SIeX9sA8lp7L6CkcPNice5qOJxQxtbtGvtCTYYfNz8ctROsbuyRe4GaAu/DEZyLIP0FB32vv+zwK1PrN0DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215180; c=relaxed/simple;
	bh=nIYZ5b28BtTDEztAuC3k0cDQrJ6FNj2Wq4uWAUf5cog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IHnfDZmmU4P9yfHffap+u0xC0H7buUWyNjVpy1S9W2xs21lzld27ov7iGPIKqnmoGeh+84U7F/ucaixkOnbl4tx74Tj5kY5Tc13QhCbmjn/GeaEgo3nMFGcGObLuhMZs3OLarFHEAsiTb5RdS7f9N3ZhRnVuYlx9gp6qcfhxc24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pg254sDU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pg254sDU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A421F000FF;
	Sat, 12 Sep 2026 12:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215179;
	bh=ImvA6pCSVtStpUoFPYxVcBu9nlBbdt5U0WTLFkjpxfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pg254sDUaFu1IOf9N7A3wORUijNkBg4SDTV2Yv+ogOoqU8DKEqloEhcqEpU0gjv3l
	 bSh4NpF6HBYRtr4h7VPPl+Xd0ISUj28C+zpOm6Itw2Ms/wNpIoJG5b8cGrgFHkkT/F
	 66G21jVE9pUGGDBOu1S1ARm/cI11qfv7do9+cof8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <gu_0233@qq.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0479/1376] remoteproc: qcom_q6v5_adsp: Fix reference leak for device node
Date: Sat, 12 Sep 2026 08:48:25 +0200
Message-ID: <20260912065618.210555705@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Felix Gu <gu_0233@qq.com>

[ Upstream commit 8c952807c2cebd5e9e9b37146c9383229794c129 ]

When calling of_parse_phandle_with_args(), the caller is responsible
to call of_node_put() to release the reference of device node.
In adsp_map_carveout, it does not release the reference.

Fixes: f22eedff28af ("remoteproc: qcom: Add support for memory sandbox")
Signed-off-by: Felix Gu <gu_0233@qq.com>
Link: https://lore.kernel.org/r/tencent_EDC2253D3B1C22217E1259E07765D269100A@qq.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_q6v5_adsp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/remoteproc/qcom_q6v5_adsp.c b/drivers/remoteproc/qcom_q6v5_adsp.c
index 223f6ca0745d3..80ac739621bed 100644
--- a/drivers/remoteproc/qcom_q6v5_adsp.c
+++ b/drivers/remoteproc/qcom_q6v5_adsp.c
@@ -355,6 +355,7 @@ static int adsp_map_carveout(struct rproc *rproc)
 		return ret;
 
 	sid = args.args[0] & SID_MASK_DEFAULT;
+	of_node_put(args.np);
 
 	/* Add SID configuration for ADSP Firmware to SMMU */
 	iova =  adsp->mem_phys | (sid << 32);
-- 
2.53.0



