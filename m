Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A55239E63;
	Mon, 23 Jun 2025 13:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685047; cv=none; b=WgwcU5tKPAF5TqzQTrbrbEus5tqqbgBy4nqW+XX56+80n36rjMzKoO0MZH+zbFAWvJEF0DbKZda3Tr2icqlVouqc6yWG6brMtKDhQiy6OpMp5CNltOLBdnzu2eTSGYa2gDavoxLith3HEutPC81/MjE0UycOPEmrwR1E74xxocA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685047; c=relaxed/simple;
	bh=HeeYRwpJ/rF03VnGb6+Jcu1MR7xtCNkAlJwXoDIdtb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IXTt1JNyx49KzrYHKls5BcRHRzP24ykwN4HiWqm7FaxC+z2dtsGffRPwpOqd/In1nDEKqbVDMpK9mNwBrp/9RhoNZIq/1ELV1hAtLZlABCm4XmpLMxiKa2i5D/M9sWufRQxuuA2so7BDo6id03stj+ZSXgphOqttTndAPl9Qykw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mlYUiOA7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mlYUiOA7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8910CC4CEEA;
	Mon, 23 Jun 2025 13:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685046;
	bh=HeeYRwpJ/rF03VnGb6+Jcu1MR7xtCNkAlJwXoDIdtb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mlYUiOA7m3sLxu/xdASuwOPUoU3xDaqr6FWeJjCb4iW6HzB0Ip9hgCImZAtvlNuTh
	 vKka/haTw/deev3pi5raK7qzqCmhENW9ebTwYph0RyBIecDt4NNrLUMLg4uv1juOAd
	 qmYcmzfJscidgNh4nflWIJj1WgMIiqAr8AwxNv0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Gavin Shan <gshan@redhat.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 031/411] firmware: psci: Fix refcount leak in psci_dt_init
Date: Mon, 23 Jun 2025 15:02:55 +0200
Message-ID: <20250623130633.936976699@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index cfb448eabdaa2..ec888aba57ffd 100644
--- a/drivers/firmware/psci/psci.c
+++ b/drivers/firmware/psci/psci.c
@@ -619,8 +619,10 @@ int __init psci_dt_init(void)
 
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



