Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74A61D0787;
	Wed,  2 Oct 2024 13:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876427; cv=none; b=q4YXoBjNbHieEp3ElKqJXL7PpRZ3elEGaTSQ55By4xMzbJTJvqbROfvElxheWMLH4TV6Nl/QK4SXU2ShlDQQN6rxntNAmfUS63qvX+yN4FdmPdRD8aTk6E5HAwFDrhuDtOpyrZFivNpLT/mFmFWyMdklEii91SlLAKYG5yOB+ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876427; c=relaxed/simple;
	bh=s6yRsFVAYM91IPnTVSrVjH9ieTDLcu/1wpqzHC37G2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wow8HpZkVMG2ocyYrIE0tx0v6XqPr2ipwIq1esssjT5WiVre9u9WZKQpwxV566sTWr7kxfjJzl3KSMdLgGT7PU8BcHlNzQ/qgM8zVrQZADsZVdN1c12ujSeWMksqrmY3qJh0ZpmnMxH3R7FZqNeHacluuiQN8BSs2mtmm4HrADU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mJ4mlZpi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mJ4mlZpi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1913FC4CEC5;
	Wed,  2 Oct 2024 13:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876427;
	bh=s6yRsFVAYM91IPnTVSrVjH9ieTDLcu/1wpqzHC37G2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mJ4mlZpiRIvbrvsGVRX1CB4JAhqIJT06QXrNad2HDtPTXTeBqBZmByvaklqvX1tsj
	 gnc0773sKL+etpn8rCZmsd2OhtGhCzY2RZnzDPMVwfBrdSEMRPOqtEHnUfXdSAcT/3
	 AwyIRuXhMot+4phEcELjNyj65YzfakhvUH0E3/Wo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Lobanov <m.lobanov@rosalinux.ru>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 423/695] RDMA/cxgb4: Added NULL check for lookup_atid
Date: Wed,  2 Oct 2024 14:57:01 +0200
Message-ID: <20241002125839.338682213@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikhail Lobanov <m.lobanov@rosalinux.ru>

[ Upstream commit e766e6a92410ca269161de059fff0843b8ddd65f ]

The lookup_atid() function can return NULL if the ATID is
invalid or does not exist in the identifier table, which
could lead to dereferencing a null pointer without a
check in the `act_establish()` and `act_open_rpl()` functions.
Add a NULL check to prevent null pointer dereferencing.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: cfdda9d76436 ("RDMA/cxgb4: Add driver for Chelsio T4 RNIC")
Signed-off-by: Mikhail Lobanov <m.lobanov@rosalinux.ru>
Link: https://patch.msgid.link/20240912145844.77516-1-m.lobanov@rosalinux.ru
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 040ba2224f9ff..b3757c6a0457a 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -1222,6 +1222,8 @@ static int act_establish(struct c4iw_dev *dev, struct sk_buff *skb)
 	int ret;
 
 	ep = lookup_atid(t, atid);
+	if (!ep)
+		return -EINVAL;
 
 	pr_debug("ep %p tid %u snd_isn %u rcv_isn %u\n", ep, tid,
 		 be32_to_cpu(req->snd_isn), be32_to_cpu(req->rcv_isn));
@@ -2279,6 +2281,9 @@ static int act_open_rpl(struct c4iw_dev *dev, struct sk_buff *skb)
 	int ret = 0;
 
 	ep = lookup_atid(t, atid);
+	if (!ep)
+		return -EINVAL;
+
 	la = (struct sockaddr_in *)&ep->com.local_addr;
 	ra = (struct sockaddr_in *)&ep->com.remote_addr;
 	la6 = (struct sockaddr_in6 *)&ep->com.local_addr;
-- 
2.43.0



