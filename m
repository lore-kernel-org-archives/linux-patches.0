Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD0E6FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:49:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61D6AC433EF;
	Mon, 16 Jan 2023 16:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673887786;
	bh=en2jGy1xQN3/Rhn4olc+0g//kDeJFvf0dMtG0eBM5yQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WfiMqrE3orUQqqofLKqzC4vZ8uknjtCAnLVHGqdSaJo29B/4bqMtsfxfi+LwvDF+H
	 jqgLO67gYJEi/K2rCPDe4KiaUkKJHViW7BW7gTXiiD2IH8DT159d8OscL2RisRI25E
	 zoOsL/6ngjiE6olnq1QprBx7yYG+4ahcflTJ7p6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Andrew Donnellan <ajd@linux.ibm.com>,
	Frederic Barrat <fbarrat@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 281/521] cxl: Fix refcount leak in cxl_calc_capp_routing
Date: Mon, 16 Jan 2023 16:49:03 +0100
Message-Id: <20230116154859.724360378@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 1d09697ff22908ae487fc8c4fbde1811732be523 ]

of_get_next_parent() returns a node pointer with refcount incremented,
we should use of_node_put() on it when not need anymore.
This function only calls of_node_put() in normal path,
missing it in the error path.
Add missing of_node_put() to avoid refcount leak.

Fixes: f24be42aab37 ("cxl: Add psl9 specific code")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Acked-by: Andrew Donnellan <ajd@linux.ibm.com>
Acked-by: Frederic Barrat <fbarrat@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220605060038.62217-1-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/cxl/pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/misc/cxl/pci.c b/drivers/misc/cxl/pci.c
index acb4a339f5fe..8dbb1998c312 100644
--- a/drivers/misc/cxl/pci.c
+++ b/drivers/misc/cxl/pci.c
@@ -391,6 +391,7 @@ int cxl_calc_capp_routing(struct pci_dev *dev, u64 *chipid,
 	rc = get_phb_index(np, phb_index);
 	if (rc) {
 		pr_err("cxl: invalid phb index\n");
+		of_node_put(np);
 		return rc;
 	}
 
-- 
2.35.1



