Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE00119D8BC;
	Sat, 12 Sep 2026 09:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206905; cv=none; b=RcxhvUwpiLrYTxeSOGKU0r7GdZLzaZwa0ngolUd5x3YmBhO+OGik/ggny4KzUmN9HssmsaKh9N3OYORyQPeWpnJM7sIvvLio90v7EQZ+bQ/dHi9h4RBpeVshlDfdh2l2lblRjpt3eWCE6JUIwV7fdzgMXiOMIHn08dt+4DBuAKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206905; c=relaxed/simple;
	bh=Jc4km2aIQAhjrO0qPaBoDAbCcobTLwXiQSsOrtE/miw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LQabNj+04C5w8B4HunWOSAqYXNz06rbelGcs78GeaYmuz+q9fjfXlXeGR1NExlrjPjSDW5gs8Xg+BBisjIPI5HQbhJDg78f89yeEqsn2igo3rNXe+xNQpHB9tBpMKHQT28EMYGETaaNK+1nwjlCuYGo47wnlltsnmNK8mi4nGVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NHSgmQb6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NHSgmQb6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E42DC1F000FF;
	Sat, 12 Sep 2026 09:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206904;
	bh=nq15fGIl574D1dzoAXw7k0WBy9lWMxxFepZvfQ9fEwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NHSgmQb6PrRoVT2rmv11WKXD5YlgROAAXsLk7CAu6lbAAKUUB/1/Dw8LYKujdHLbN
	 CGWb2Yikk+olqOQW9fTewib9yFMrHu/VoxW172pa0/QqHfnMlsy6b1XWAM+IC5XUVu
	 hEqfiUSUmd7ssejdkM/WSGV18xZC6ZyDJVNMTcrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <gu_0233@qq.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0303/1518] remoteproc: qcom_q6v5_adsp: Fix reference leak for device node
Date: Sat, 12 Sep 2026 08:41:12 +0200
Message-ID: <20260912065630.334081691@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index e98b7e03162c7..b7d472afd5a9b 100644
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



