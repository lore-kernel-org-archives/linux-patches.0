Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C422E9753;
	Tue, 17 Jun 2025 15:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174420; cv=none; b=ASM/U/W43bSj3TtiAS4PMJij8vcVH0A8naInFNckxUarWP99UMBRNitEYP1KWwJ95zCiEWov5Um5QKb7j+L+BwwSvNIj9moASuIWX9bmYTNBB1ZnSJUBQav58teluMYAAYFz1/8uQ8DdnXZZ0vWCtc3rgynMPpb+kX6nlSlqeWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174420; c=relaxed/simple;
	bh=LJiXHQY43mhKMl0Q57+S5j7cG4nVscbotSL2IjepqRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=II/NWdR9Ff4Hlq7AFO0len87ynym2HFEOWfNm5sp7BE/UDlK3dbNKpTHBs+BTzfr9BICK8gYmMV3rPv4CChOk+sJPfa7LDaUY1Cca9omxkRi+h4TIqn/6qOpvDN0mdzq6oIDrt/K/01bXeITupQyJAlj3aXUL8SLx6rwAOEJF9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RQnOLIpC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RQnOLIpC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3159CC4CEE3;
	Tue, 17 Jun 2025 15:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174420;
	bh=LJiXHQY43mhKMl0Q57+S5j7cG4nVscbotSL2IjepqRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RQnOLIpCiTLZGj3GrJ7HeuVA18pCogkyxnEJVuQ1/v95u0M3zbom17mOP8I/u88jZ
	 k+MCQQnjHlS9X012odcQrDuv4XCaUaiTs1vqqhr797ptf/oHvcFz3NJIgbvr+2zOoP
	 4Wy6EEIXy6g7k0quB3nYkwcgNtu7EWMbO6aiBEEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Gavin Shan <gshan@redhat.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 066/356] firmware: psci: Fix refcount leak in psci_dt_init
Date: Tue, 17 Jun 2025 17:23:01 +0200
Message-ID: <20250617152340.886166982@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 7ff37d29fd5c27617b9767e1b8946d115cf93a1e ]

Fix a reference counter leak in psci_dt_init() where of_node_put(np) was
missing after of_find_matching_node_and_match() when np is unavailable.

Fixes: d09a0011ec0d ("drivers: psci: Allow PSCI node to be disabled")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Link: https://lore.kernel.org/r/20250318151712.28763-1-linmq006@gmail.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/psci/psci.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/psci/psci.c b/drivers/firmware/psci/psci.c
index 2328ca58bba61..d6701d81cf680 100644
--- a/drivers/firmware/psci/psci.c
+++ b/drivers/firmware/psci/psci.c
@@ -759,8 +759,10 @@ int __init psci_dt_init(void)
 
 	np = of_find_matching_node_and_match(NULL, psci_of_match, &matched_np);
 
-	if (!np || !of_device_is_available(np))
+	if (!np || !of_device_is_available(np)) {
+		of_node_put(np);
 		return -ENODEV;
+	}
 
 	init_fn = (psci_initcall_t)matched_np->data;
 	ret = init_fn(np);
-- 
2.39.5



