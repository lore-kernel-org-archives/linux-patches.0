Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 196A74EE876;
	Tue, 13 Oct 2026 11:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892543; cv=none; b=ZvdfUjQM2K8C16bEhBpXC+nSlixwawCnIIigFZBR+PdHyKbq+DcL3IGZ2Ifzrg9ltLaQD1D1z0ne3kxTTNDDmmu8aVSl240oSNuxTLEbZwsVERUFIwcmPqPTjy364yyhgGZtIljwb63zgJe0MKtw68Q4TAsiu5nhR/G//c6x7z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892543; c=relaxed/simple;
	bh=n7Ee7K/2gOG+xuI6TBGuzsB+Aw5oZXJWIRpAbYoB55M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hGWUo29yzJTpsxucvveTAq/QR9mBHJKuEC1WJI9uUUHyRH+ruhDIi7l/iKnigUSB7HvgUiNpkGyjlbZyxytl7W+6dXeex0zHg5Hlh0mAl2LZ2p6OGOaDEOI6kmNGdPTwc2jY6ipYoxpCSSz74KfF7pS0kLUt9QX9mo7Ww+RoZh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qaWHV+qP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qaWHV+qP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 674ED1F000FF;
	Tue, 13 Oct 2026 11:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892542;
	bh=Ecgj0sE5puelE3Mq5fiwSMMAAyv3QSBTkayCElQ0g3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qaWHV+qPjIxC5TSYVMFqWGqOSs2lZjOI1Q9sCRQPKZlRO9o3vPcZCfMZ7urE8jwkl
	 pma/t429TfL1Fk/ZlJ70Oc+eX29BXBgy4ObSQr8Fa1ZyVjzvpSLsL5F8HoGAu9g4fR
	 ti2S+5zgDWZoDH5zXoOrnyEMH7Cx8K642cKTLn8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Changyul Lee <lcy8047@gmail.com>,
	Maurizio Lombardi <mlombard@redhat.com>,
	Sang-Hoon Choi <csh0052@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 207/281] nvmet: use the local P2P device on metadata allocation failure
Date: Tue, 13 Oct 2026 13:38:43 +0200
Message-ID: <20261013112900.186730780@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 2aa9ded7d5514..0b1f800c6cc8f 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -1310,7 +1310,7 @@ static int nvmet_req_alloc_p2pmem_sgls(struct pci_dev *p2p_dev,
 
 	return 0;
 out_free_sg:
-	pci_p2pmem_free_sgl(req->p2p_dev, req->sg);
+	pci_p2pmem_free_sgl(p2p_dev, req->sg);
 out_err:
 	return -ENOMEM;
 }
-- 
2.53.0



