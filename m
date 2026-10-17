Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC783B8BBB;
	Sat, 17 Oct 2026 17:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257387; cv=none; b=uiG5AQRQ+d5rvVQQD3Xoz5TbcqqixqAVkWnrhlEQKqY9F9j3Rm9MQ/Zk2nEwygV+O+gcMxy6ZOuvNPwzYhVZwfBMiPG0jM1RmzhlOYyno8N4nNufiYWsaR/7c/emQ9gimRixh9pDyl5/7apUTgpb+x24NvBMVbWR7jUseT0DcNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257387; c=relaxed/simple;
	bh=iwB3gEUSg0P+msQYiIZanuvC/JXUJ5MfuwLbwWTzPrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AFuyKFQRkn7fmCmCR8S6NlwuSTMdEyMVoCTiKhh3JZfH/9skOPrsiMlXm/M8w12qdBw8uQAtfcpljoNof062kJnugSmyXNYz2+f6yY2asdRSULGReYwYt0uKlEehgHSYG9gVVeY/Bo174uN7noFe+buHABDDUVZJ8Er8HDvsvf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e4BRhVgU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e4BRhVgU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB9C91F000C4;
	Sat, 17 Oct 2026 17:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257386;
	bh=lqcF5pF9uHKVvgWQdZWlWD0v+/NeJgNePkNSk+bbgGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e4BRhVgU71NflkIUfTOr5lyq99yKrRs3uHGf9LakO5041sDEPpZ93YeMPn4s8UfSr
	 RiXRz2aVdv7N3fMTsUuLZzkrY8Ba5Vaef+n0ngQh4dRbzFI/gC1WftYzTQZOJVPL4s
	 8z87pA7/qWrLj3lBOY3FJULPfhmL+cOnQa8pf+T4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Changyul Lee <lcy8047@gmail.com>,
	Maurizio Lombardi <mlombard@redhat.com>,
	Sang-Hoon Choi <csh0052@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0543/1674] nvmet: use the local P2P device on metadata allocation failure
Date: Sat, 17 Oct 2026 17:46:55 +0200
Message-ID: <20261017160445.037617378@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sang-Hoon Choi <csh0052@gmail.com>

[ Upstream commit 4aa9c0f377a4de5e8fddce76b34ee4529639a1ff ]

nvmet_req_alloc_p2pmem_sgls() assigns req->p2p_dev only after the data
and metadata SGL allocations succeed. If the data allocation succeeds
but the metadata allocation fails, out_free_sg passes req->p2p_dev to
pci_p2pmem_free_sgl() before that assignment has taken place.

Pass the local p2p_dev argument instead, so cleanup uses the same PCI
device as the successful data allocation.

Fixes: bcd9a0797d73 ("nvmet: fix freeing unallocated p2pmem")
Reported-by: Changyul Lee <lcy8047@gmail.com>
Reviewed-by: Maurizio Lombardi <mlombard@redhat.com>
Signed-off-by: Sang-Hoon Choi <csh0052@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 3b1b72022a979..1b7d0d185eb79 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -1054,7 +1054,7 @@ static int nvmet_req_alloc_p2pmem_sgls(struct pci_dev *p2p_dev,
 
 	return 0;
 out_free_sg:
-	pci_p2pmem_free_sgl(req->p2p_dev, req->sg);
+	pci_p2pmem_free_sgl(p2p_dev, req->sg);
 out_err:
 	return -ENOMEM;
 }
-- 
2.53.0



