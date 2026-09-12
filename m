Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71662DC321;
	Sat, 12 Sep 2026 14:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222994; cv=none; b=bDXX987RLycu/Gs0zwnr7bqgHl6kbF2gqJmmjCazI1HKfufK6zbouZdTh9x+ufa6RsjYr9PZXEay8tOymnX12idFEhAFOgTPvdw6F5Qd9oGQGM5HCUS5t/l0xcnmmWSXTcAObPPm95cnoVKVdU+ZTxp1/Od5r3xMFEl7poZU4ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222994; c=relaxed/simple;
	bh=P4zJ6c2A++2KAIxGiuYejZg+pku8uETdUaiH6Ss9Kb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bSk+1WfFmU8Rf6bZ1rXa/AA7Myp3nkjIslVY654/yYusdhhemRo5HHvmLyY25OhWjeti3Wt+Op1XCciBDxPbXuo8vOYlQSZyNNSu3jbuIBIc6k1xSfnHwV7TeNARwMgZpemJh74ew6LQ1rym+KBmIJKnMmnqSWMTuzu8YJS+n1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nXG/tMvs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nXG/tMvs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACB331F000FF;
	Sat, 12 Sep 2026 14:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222993;
	bh=IDcbqNng802eJbzN4SSU8NgTYlmuDtlmdNrvQ14sxCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nXG/tMvsZHcf6TNF9fZf6/2UQ559W3fIA+PwuO9IvdMHl6FYhg0L/0UZ8EAItXJYU
	 ot6rLi0vR0ggQj2ShDW9udqfLTXFuf73FURRCABlzJ8GtatLz0FLEs5ushUiVWqf2v
	 /kdN7f3ZvDJywbaEKUe5sgvLaTyFsSQ3dVXHaLXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <gu_0233@qq.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0699/1424] remoteproc: qcom_q6v5_adsp: Fix reference leak for device node
Date: Sat, 12 Sep 2026 08:52:11 +0200
Message-ID: <20260912065622.951762339@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6c67514cc4931..00a98de6d112e 100644
--- a/drivers/remoteproc/qcom_q6v5_adsp.c
+++ b/drivers/remoteproc/qcom_q6v5_adsp.c
@@ -362,6 +362,7 @@ static int adsp_map_carveout(struct rproc *rproc)
 		return ret;
 
 	sid = args.args[0] & SID_MASK_DEFAULT;
+	of_node_put(args.np);
 
 	/* Add SID configuration for ADSP Firmware to SMMU */
 	iova =  adsp->mem_phys | (sid << 32);
-- 
2.53.0



