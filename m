Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C2824DFF3;
	Mon, 23 Jun 2025 13:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684759; cv=none; b=RcN1ZkbHl1zy92ESegbzBMUvzl7caGsIqjO0bJi6Az0psAsWwPV8Obag2rwa43BfhKXTipH1ns/l9Yn+avg8NMTi125iReXHOPq1GIKomhA96oPH+MeRKQx7JrmKPsB3YU+LS1DpaCZykrGE6ZeI0ZIblaIN0RT/VVnCp0QxXKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684759; c=relaxed/simple;
	bh=Kj5oT36P3mrOU3JR1z0zU+6GvxOmNgZxdwHf3ImBLtw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mqVdC4Jia4oqLfjQ+B0GbgraNbU72LNo6FXTNUDHXYkJzAVOsvPOAt2CULfgn7eNOR7V/tVk3WEh3SKRMswvC3xfTvCNxTKklmXWC5tYgAxqyhRxWPWZcpDB+/Ir7wNurJzMiD5POSBXvKmK5Fuyq0bogg5BsEz6hFIC6ncIfsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mc6Mx26e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mc6Mx26e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F7AEC4CEEA;
	Mon, 23 Jun 2025 13:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684758;
	bh=Kj5oT36P3mrOU3JR1z0zU+6GvxOmNgZxdwHf3ImBLtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mc6Mx26ehXnt8ZwUwJfkLOJPBBjbRtmJYAIz+VkVGvxqddLtZHrSQRFeNNYHlC6sb
	 PLL2AWxseoS8AzIsScnPO+L8mn1bEPoDX3fOs9jFzczvKUS2oEFcYNJt/KUde1v+6O
	 Pn6RV4i9YVsLmB2rXb3IkCEdssK6irhvUECvVCLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Gavin Shan <gshan@redhat.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 021/222] firmware: psci: Fix refcount leak in psci_dt_init
Date: Mon, 23 Jun 2025 15:05:56 +0200
Message-ID: <20250623130612.539290589@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index eb797081d1596..f1926972b2670 100644
--- a/drivers/firmware/psci/psci.c
+++ b/drivers/firmware/psci/psci.c
@@ -573,8 +573,10 @@ int __init psci_dt_init(void)
 
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



