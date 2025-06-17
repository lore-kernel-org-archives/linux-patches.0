Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1C01E8332;
	Tue, 17 Jun 2025 15:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175000; cv=none; b=sp1T8zf4N5ucRh2IPBXqx7n1JmtQ5wywN5F3HLx5ZGlUbZZRT4/Ww6X9wTZwfNySrKpdZp0z/qOYvWUQfR7WGY3CLi/lbGO3f6Sul2ibsOrCh+Q4tH/HVwgMPg0IMxPQ3DIrsVTIwFwhjhbSlTZwd4azdPJcLg30o5zZaQePW1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175000; c=relaxed/simple;
	bh=Ub4DUF4Gb48xUApRVoLh78sZ4Sb6PMZusYFfayp2MuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mw3swleOQ6UpO1szCWvUTeyMO2cHyW8tgTK7mIoFulhBOrFWyTdU10ePkCk+Gn5KKFbrC14Qos/YaKkpoxZowglMnPGpO2KRtmSszCpVqYuPgReW7DdpUJxQeP9qZUnt7E7vSPtZCNQw5HNFti3Y5xCljX5HOaVEdIZmN74oZ0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VKG09RUY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VKG09RUY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1F6BC4CEE7;
	Tue, 17 Jun 2025 15:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175000;
	bh=Ub4DUF4Gb48xUApRVoLh78sZ4Sb6PMZusYFfayp2MuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VKG09RUYAQUdqqXbxCbXbuq9H6gdbi4gXhi1W0zl9e5+CkQBtKc8gA11wlg/R+Mim
	 jlIsro+x8A7rIiKPU627mVmVzEgMbKTYHeK4AP0sGBOujfo0x6QP7D9eH5Z4cOQvVp
	 hn/PmjOW3D0x3L9JLBgo8hfPnQJ5VmcqQaRmPWrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Gavin Shan <gshan@redhat.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 083/512] firmware: psci: Fix refcount leak in psci_dt_init
Date: Tue, 17 Jun 2025 17:20:49 +0200
Message-ID: <20250617152422.940058074@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



