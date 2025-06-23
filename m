Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406564C6E;
	Mon, 23 Jun 2025 13:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686048; cv=none; b=dp5VQsyNu3WXU0nLCC2fdfsAdOZI19ffXxPV+g5cSJ/Iu0ZTRqU+E+E5Ddoc9PkpevNa2dOL5+Kml6tpn1JRGUKPwQYgZclsUway8tZo/iSgFsMLyP/ztoSaxkX6bHgxuhhnsDO/f/rurYF3hkyPOXzHUH4sf5HZ1wfY4c4m8zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686048; c=relaxed/simple;
	bh=N70bXol/GmgBcgBYXLN2DIU3tb0ya+kz5KmpMiZs0dI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LMvz7v0BxB89VzC4KPsRcTuJGbvBiZHPmBmzyH090N6EAk8fAIZ7kltZg2cTSZbDEcIeWV3gWU86gEyMXRFiTeI5fy5sKQMC4Fhn0bRRlOc6y1J4kt9VFbPHs4XqN/cfGvBZqQfmH6rvLC7nMI4dFrsIXe5AnUlgrlmjcOGGl4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NczMbubP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NczMbubP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7664BC4CEEA;
	Mon, 23 Jun 2025 13:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750686047;
	bh=N70bXol/GmgBcgBYXLN2DIU3tb0ya+kz5KmpMiZs0dI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NczMbubP2m1EV6rgfTbJWkK8hr+eueWGYJjs72BBgEl26ZUgtMjOjeSGpQ9ZeNoQa
	 2JPiaPtG/xt7I6sWp075Iad5ke4iMP/d93HHmtBOg1keFspESZSFBGyE4sGO3pujZE
	 7CIdFL/Awk2lsxfln10lZdVHaZSOvRCipfYEIMFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Gavin Shan <gshan@redhat.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 045/508] firmware: psci: Fix refcount leak in psci_dt_init
Date: Mon, 23 Jun 2025 15:01:30 +0200
Message-ID: <20250623130646.351198995@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a44ba09e49d9c..7eddf0912f96c 100644
--- a/drivers/firmware/psci/psci.c
+++ b/drivers/firmware/psci/psci.c
@@ -747,8 +747,10 @@ int __init psci_dt_init(void)
 
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



