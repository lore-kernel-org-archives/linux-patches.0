Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A903C6A5C;
	Wed, 20 May 2026 17:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298158; cv=none; b=Fy3d+mUfIherDcBRJIITy7DWBXhscEvpk70KywQslKWCqFnUF+tJ2PSis2JVWSlyfDOipBiSeIRJS29AvNAZNAn7H5URegYMFXqsDvcWoGA4LZBYhburJEMT2Xh1RhMYO5ukw3JD6oMBip0UrctmXFIeIHSmCsl06kq+jzgS7nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298158; c=relaxed/simple;
	bh=J6WJzHHa/D5KPPqNMXAOmLR4eJsyrs3DE0q6Hq1DLWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jQnj1xFyZfHnfs12ZpU7hlI5f1yYafNLUChOj5wYrX3xeyfz7hKW0nqut2KmmkK4VTk0fceG0nDMaLSaHqPFJARheDygqITBGXfa9T7CJwWOvtEMIdGS7iY61PO/5bayp2qfFhLTtRtAIm22Bn16nMHm3xi22H6XumhBIT/66Lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wTKdAtVq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wTKdAtVq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C575F1F000E9;
	Wed, 20 May 2026 17:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298157;
	bh=6Nbne8JMU3asMS6B4UOrE7HM+W+LQJl1r/37IeKEt1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wTKdAtVq1hYLurL6fgUe7To/qAvPEEmhdf/nW0QmaTcmQyV1YK50D5fTxWiuEFWT0
	 H2Z0dl7PpBUIouEUX9zAeLZpc9yw80UZTRk65WGrfJ/R67GGh9K0ipZ5mveNmofCxY
	 KPfUBuFPt22I2oxgT0pU2S9anIvK0KWJbrJYY8l8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 302/957] crypto: iaa - fix per-node CPU counter reset in rebalance_wq_table()
Date: Wed, 20 May 2026 18:13:05 +0200
Message-ID: <20260520162141.082323651@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

[ Upstream commit 590fa5d69c27cfaecd2e8287aec78f902417c877 ]

The cpu counter used to compute the IAA device index is reset to zero
at the start of each NUMA node iteration. This causes CPUs on every
node to map starting from IAA index 0 instead of continuing from the
previous node's last index. On multi-node systems, this results in all
nodes mapping their CPUs to the same initial set of IAA devices,
leaving higher-indexed devices unused.

Move the cpu counter initialization before the for_each_node_with_cpus()
loop so that the IAA index computation accumulates correctly across all
nodes.

Fixes: 714ca27e9bf4 ("crypto: iaa - Optimize rebalance_wq_table()")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index da9b2bc515194..78218f3a3cd06 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -911,8 +911,8 @@ static void rebalance_wq_table(void)
 		return;
 	}
 
+	cpu = 0;
 	for_each_node_with_cpus(node) {
-		cpu = 0;
 		node_cpus = cpumask_of_node(node);
 
 		for_each_cpu(node_cpu, node_cpus) {
-- 
2.53.0



