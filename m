Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41040344DB5;
	Thu, 12 Mar 2026 20:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346882; cv=none; b=h4sksH+zKh8WdY2SA7PDecanaXAjZvNNkXINMNHTh905Pp564mZzP/P6TAKDLcIQUzqvzSFZ88euHWFMNdxCsi7EW47zAzNPnImvB6UVingOwcG893BFUCIeA9ReYHes4SkvjHJjJ9mwhZMfY9dTReqGSgVCcYnlmEFwjjZVYrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346882; c=relaxed/simple;
	bh=0f4jcX1kcmne5MOuojbe3T1X2cPr+6UyC8Q3MA28HUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OWKRb6GxWLoFc4VhyBeArSbIpjbs8ORRfuqT4CIXmWNN8PIDhwsUEQaT9Z3m9Fb3Du1FD3P5jX/fICJ9nX3loUNRD1wRx9W7FtiSp0TnFvY3rIZmtLZZ/AyHlWv47aOO5SDM+viJgBmJiJ3aRXHjrCJ7JAAeClv9OExOQwYDNfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Frcanx5b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Frcanx5b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E41BCC4CEF7;
	Thu, 12 Mar 2026 20:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346882;
	bh=0f4jcX1kcmne5MOuojbe3T1X2cPr+6UyC8Q3MA28HUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Frcanx5bZnF2XSNqBxtvfQP47nnpFzLrH7M64M37o8JqpXwHp3AB3kJBfpgd6jJHA
	 BpBHT3VhE3tE8fYB1bVhzsvf0Pywc1cSvPbia1ZOUl1mvSdix4OBG4eufY5lBeiOx2
	 +m6bMSnD+RCZIKbhrFHty/QgOQDchW9Zo0pnaWMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 6.12 149/265] RDMA/irdma: Fix kernel stack leak in irdma_create_user_ah()
Date: Thu, 12 Mar 2026 21:08:56 +0100
Message-ID: <20260312201023.642397293@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

commit 74586c6da9ea222a61c98394f2fc0a604748438c upstream.

struct irdma_create_ah_resp {  // 8 bytes, no padding
    __u32 ah_id;               // offset 0 - SET (uresp.ah_id = ah->sc_ah.ah_info.ah_idx)
    __u8  rsvd[4];             // offset 4 - NEVER SET <- LEAK
};

rsvd[4]: 4 bytes of stack memory leaked unconditionally. Only ah_id is assigned before ib_respond_udata().

The reserved members of the structure were not zeroed.

Cc: stable@vger.kernel.org
Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://patch.msgid.link/3-v1-83e918d69e73+a9-rdma_udata_rc_jgg@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/irdma/verbs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -4589,7 +4589,7 @@ static int irdma_create_user_ah(struct i
 #define IRDMA_CREATE_AH_MIN_RESP_LEN offsetofend(struct irdma_create_ah_resp, rsvd)
 	struct irdma_ah *ah = container_of(ibah, struct irdma_ah, ibah);
 	struct irdma_device *iwdev = to_iwdev(ibah->pd->device);
-	struct irdma_create_ah_resp uresp;
+	struct irdma_create_ah_resp uresp = {};
 	struct irdma_ah *parent_ah;
 	int err;
 


