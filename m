Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C6D2ECEBF;
	Tue, 17 Jun 2025 15:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175803; cv=none; b=Km9RF0G+w9XbTqWszFQK1+LElv2ZV6t/NF5MI0sTBby8zkFMZCyumvdLpIJvmRraTfsR5W0TKjyU+7LnsjSpM52R7pJv+R08xOEofMiZsQgD9IZdCbaPBT05HFaOPERrbANeSg0f7+mBv68kehS89bqqoF8+eDyyZnnrmMDp9vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175803; c=relaxed/simple;
	bh=6fooma9v2TOt3SyBCPDekQy6exVyN1tjniWPL1EPdLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X9DtRtKbAshrEmdY1vErxUcOoIyMQtq9GqvjpZFBUCCQmw1lbrBRGTJwwDS/sMkB1hFZRDUTg9F4vkfR1KT+ehtBgpYNoDxqu0MCseTt7qCs5oC+ag4+NUeBW6xS89RFfNwaLsIZWteUEunHucT8uvVu/WnKOt/rQJkDjJEgoOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lxWDnWCa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lxWDnWCa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D3D6C4CEE3;
	Tue, 17 Jun 2025 15:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175802;
	bh=6fooma9v2TOt3SyBCPDekQy6exVyN1tjniWPL1EPdLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lxWDnWCaeBhBLz5uR0tGN0rqbuDgLGKYr18wYS4EqkXxvfZuuZmH1JXpS/Q51vPr4
	 1QhMaxDKCc5hiHKBPjoHHXeEsOVrxseKc+/rVYBsdFH2wKZCjmOYaLNdIDngbvpZlP
	 JPWXudZQ+GhFbt6HZLAEY3Bej4ipQaqRJ24X3pqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Gavin Shan <gshan@redhat.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 124/780] firmware: psci: Fix refcount leak in psci_dt_init
Date: Tue, 17 Jun 2025 17:17:12 +0200
Message-ID: <20250617152456.564184194@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index a1ebbe9b73b13..38ca190d4a22d 100644
--- a/drivers/firmware/psci/psci.c
+++ b/drivers/firmware/psci/psci.c
@@ -804,8 +804,10 @@ int __init psci_dt_init(void)
 
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



