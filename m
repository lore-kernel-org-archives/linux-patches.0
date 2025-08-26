Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D03A34A309;
	Tue, 26 Aug 2025 11:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207890; cv=none; b=R7IfBzENNXp5gq+hyYlZtEqsRdGQBKgc26wPMcoeUSEfHxbB9uB8wjWGoKWOD72CDp6Jz2I4FjHulTpKn6rhbxga2lkZ2SsOXGFMw2H9I+K///iAMTwBqIh92meDxVevFqBBuvsJkIMOjQGVCm9X+8meMdNyPsJNemRu8SkVVJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207890; c=relaxed/simple;
	bh=cuICioA197GvLGauqKEUD69IdZeFhCva+HKDDyu0gVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R9TV+GjzrY4vWIxo/r7u0EAnsDgcXnML5hAKKINgdLG8OEG/JNx5Y+joMEzalQmwF1U6AivNeyFwl9ZU8x7TXaSyWTqrlyrSoRFzkw76mB/gen9HUBwghX8R+X8mhnS+8DFPd6+LbTZeo/Qy6+bCIG/x7giG4WWBEZzuKUFcqlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=StK2lK00; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="StK2lK00"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3B7CC4CEF1;
	Tue, 26 Aug 2025 11:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207890;
	bh=cuICioA197GvLGauqKEUD69IdZeFhCva+HKDDyu0gVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=StK2lK00qzt3QmpO83xJyf2xJRdkz+OEqEQdPOQM8CS70H9FdH8jEcqAf4UU0TUAB
	 mwgVAjKzdCkr/P3wef4qsGIzl85eOj1Q4AZfWOVyN03j2WmE24DC9QjLo3akfp5ESQ
	 kWm7RKEmyaOvwDybTjS1LSbB3EP6s+ChQFFXj0rg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suma Hegde <suma.hegde@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 357/457] platform/x86/amd/hsmp: Ensure sock->metric_tbl_addr is non-NULL
Date: Tue, 26 Aug 2025 13:10:41 +0200
Message-ID: <20250826110946.138579409@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suma Hegde <suma.hegde@amd.com>

[ Upstream commit 2c78fb287e1f430b929f2e49786518350d15605c ]

If metric table address is not allocated, accessing metrics_bin will
result in a NULL pointer dereference, so add a check.

Fixes: 5150542b8ec5 ("platform/x86/amd/hsmp: add support for metrics tbl")
Signed-off-by: Suma Hegde <suma.hegde@amd.com>
Link: https://lore.kernel.org/r/20250807100637.952729-1-suma.hegde@amd.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/hsmp/hsmp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/platform/x86/amd/hsmp/hsmp.c b/drivers/platform/x86/amd/hsmp/hsmp.c
index 885e2f8136fd..19f82c1d3090 100644
--- a/drivers/platform/x86/amd/hsmp/hsmp.c
+++ b/drivers/platform/x86/amd/hsmp/hsmp.c
@@ -356,6 +356,11 @@ ssize_t hsmp_metric_tbl_read(struct hsmp_socket *sock, char *buf, size_t size)
 	if (!sock || !buf)
 		return -EINVAL;
 
+	if (!sock->metric_tbl_addr) {
+		dev_err(sock->dev, "Metrics table address not available\n");
+		return -ENOMEM;
+	}
+
 	/* Do not support lseek(), also don't allow more than the size of metric table */
 	if (size != sizeof(struct hsmp_metric_table)) {
 		dev_err(sock->dev, "Wrong buffer size\n");
-- 
2.50.1



