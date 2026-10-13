Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA443D891D;
	Tue, 13 Oct 2026 12:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894398; cv=none; b=XwEHHi8V4YeuELw3KCAquOs3Tnmpw3i6ZVodNpCVmMub1NmyIu6OREAa3qq6yY2qg0r6UoJUB9M/+VlHiUpgwZ/BLou8a5Kcfp2Sdhs3UfI7iz2fUTEWby8Gyja4FHKCjI+82rbDT8iIUmW+khkXMQ+NC/pLJhiFfnDPHyUShPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894398; c=relaxed/simple;
	bh=YE1Q0XuTFYLmIpCBa/bQLsQOE6lbHiEhrPaBU1nab04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i04wy/Gp/BvUXHhK6aRz8VQ/D2oPWiMEvPDMteykjMZm4YZ8tl9U1aSTbsq7Y7uVmlAfNSgU2BOwcxyjiytGwZ68GxscsAnHq2hoBJoSrcmirdfaZ7y/ebMg8Whz3W/NrOWC9RiKTtNtxbIu+f/AOKMiMry08FnifFumOc8aZ/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ls+rqNrd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ls+rqNrd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF971F000FF;
	Tue, 13 Oct 2026 12:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894397;
	bh=PERGQuOqzs6pRsthGrxdwun92x1qi3uSZJ9D49ByNoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ls+rqNrdbXOtxXfBfMIW9pHoQEKK/TGhvzjGVz9hYeaL5zBfmdOBXB3PDeBTSNEqI
	 uUWMN7V8VEwFXcn8sEOYlnda2BcjV1IWXYantIb74ujElgCTyQ+lOpYF6s/XPob/DS
	 dLxMkZP7CR6IcpTmgKUJf5ofZPWvsRQMB8404Nlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Changyul Lee <lcy8047@gmail.com>,
	Maurizio Lombardi <mlombard@redhat.com>,
	Sang-Hoon Choi <csh0052@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 548/621] nvmet: use the local P2P device on metadata allocation failure
Date: Tue, 13 Oct 2026 13:39:03 +0200
Message-ID: <20261013112933.820468596@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 1a064d1c3af30..9b64c313c7039 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -1301,7 +1301,7 @@ static int nvmet_req_alloc_p2pmem_sgls(struct pci_dev *p2p_dev,
 
 	return 0;
 out_free_sg:
-	pci_p2pmem_free_sgl(req->p2p_dev, req->sg);
+	pci_p2pmem_free_sgl(p2p_dev, req->sg);
 out_err:
 	return -ENOMEM;
 }
-- 
2.53.0



