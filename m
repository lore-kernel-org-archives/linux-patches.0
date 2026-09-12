Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F278E192D8A;
	Sat, 12 Sep 2026 07:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198092; cv=none; b=lsq472ChWDVCk0usPS06KrjrKnQc1uLkMR1AA61EwWp02QVCWSkevvu1Bsn9FPqFrfqu0aPLMRHq0iYY21HskJVi84DvdIaw5+VLmNkXhToeVSCbSIB8BQ7Qkf4RJCe4a4g5n8QM4s5xhoNeyxGVqMwU6RxyA/OVHmWfDP/97Xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198092; c=relaxed/simple;
	bh=gswt6O6f81XRuViparcc2chvBSt+eW9P8BFJR2FfgVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pRbK4Nc9Kza+a1PvPQob42MbOeB1rdMKfjAwQgixxnH4ZuPBw+02dhpiBn+E5fGEIx36h6LW8Mjpfyy771F2gaC7cJiKYL2WSmePeSVEYt/Uu5KBbQneicgk56i9EBdrItz1yoVhm2ngs3beBsy2VI+KWoT3RT84d8wsnq5kyFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WADKbLFx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WADKbLFx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3D9E1F000FF;
	Sat, 12 Sep 2026 07:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198090;
	bh=NZbyYJ3900QHJK/tSiN2uCMfF/HntKOT7U8TFotxDBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WADKbLFxIdCciogO6iIu0Hngy//AVMbBuI8nsopDwdnYsXqkHbR1qAs5DJoZNXyO/
	 cgP/uwkfWm3ipx1lTFLy2FDBV0nOpDA9yU+Md7Z3q+phAbRXKjzuTL8RhVAy5Ac2RN
	 mo8Q+e0EoQE9BCyQy4EMYqDrzKGQo2wHYGEtGy5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <gu_0233@qq.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0308/1815] remoteproc: qcom_q6v5_adsp: Fix reference leak for device node
Date: Sat, 12 Sep 2026 08:34:18 +0200
Message-ID: <20260912065656.176341514@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index b5c8d6d38c9cb..c81e6c33c7479 100644
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



