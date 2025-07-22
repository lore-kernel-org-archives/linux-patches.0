Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632F02EE979;
	Tue, 22 Jul 2025 14:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193513; cv=none; b=UttHSWJ5Tx1z7q2m3LMTW3QsgU97KdjTFuq+5JyAZzskhdrVouuhNbANFNw3CcSeR6kkBotVPe3YaXv5OXo1tEmz8fhOAe37fqyXCrHXmX38oZIV7lAyHjvU8kJnVE/J834GeOKv1L32o9nKgAiQDUKMFUbjJIhZIed/giP++2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193513; c=relaxed/simple;
	bh=i5GyZ6g27Ap7qxNN2vGHX0g/E25TNh3TWWA6uq+Mtmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hYE60QBFj0GqSPoFilzT3qRDHxpxzPN1ehk8TJLxiJMtHAetB3gO0ve6mzIfUh2DD41IK8EG+korq+klj5iLC19VzovgrO5H4W2QV2IOSEz4PVXd2sSkXGKVLav8x5w102jEJgUgGQfFeAbCfqvVcW/dFBKAK/oV6R7dpMvd6DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fXTUYdRT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fXTUYdRT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE5D1C4CEF5;
	Tue, 22 Jul 2025 14:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193513;
	bh=i5GyZ6g27Ap7qxNN2vGHX0g/E25TNh3TWWA6uq+Mtmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fXTUYdRTQj7jPLx5BJPWuU3UTm+BETXGH0mssJSZ4PCU7q9TGqFRjxeZDy9O3ktFS
	 BKCZV08S14t//UNSBtpn2w6rYJiErB29RDljovIbEAu/Ph0mtAbXjjE8MnqTnfrAG3
	 k8t9R8UW0o1QrjjZQPwJm2Z37pvdrCgbyw1B2xuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Qixing <zhengqixing@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 116/187] nvme: fix inconsistent RCU list manipulation in nvme_ns_add_to_ctrl_list()
Date: Tue, 22 Jul 2025 15:44:46 +0200
Message-ID: <20250722134350.079777279@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

From: Zheng Qixing <zhengqixing@huawei.com>

[ Upstream commit 80d7762e0a42307ee31b21f090e21349b98c14f6 ]

When inserting a namespace into the controller's namespace list, the
function uses list_add_rcu() when the namespace is inserted in the middle
of the list, but falls back to a regular list_add() when adding at the
head of the list.

This inconsistency could lead to race conditions during concurrent
access, as users might observe a partially updated list. Fix this by
consistently using list_add_rcu() in both code paths to ensure proper
RCU protection throughout the entire function.

Fixes: be647e2c76b2 ("nvme: use srcu for iterating namespace list")
Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index ae584c97f5284..300e33e4742a5 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3889,7 +3889,7 @@ static void nvme_ns_add_to_ctrl_list(struct nvme_ns *ns)
 			return;
 		}
 	}
-	list_add(&ns->list, &ns->ctrl->namespaces);
+	list_add_rcu(&ns->list, &ns->ctrl->namespaces);
 }
 
 static void nvme_alloc_ns(struct nvme_ctrl *ctrl, struct nvme_ns_info *info)
-- 
2.39.5



