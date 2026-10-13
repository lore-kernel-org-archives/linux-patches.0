Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836A91DF98F;
	Tue, 13 Oct 2026 12:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791896013; cv=none; b=MHw+fgG1XqdTk+4Tuo9VFFv3Wa0ozmtUnoXE8vmFOuJeBXpdH9mYTISNvLsvHeca0mrqKSs9P0QDormZL51iOuwkXR1+nEUjX6KJ4+ZumplErmfHW+vcIRi6sFxZZI964m+e3oyH6OVk0QDD9fDqh+YCFinVQT2hFJ5L3GwGmxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791896013; c=relaxed/simple;
	bh=uPrANX9Wf3p+jsdXvPO0G5RfVKrgBDJhcLSeDSEgg9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hHunEBKEQv31x5oid/g9GEJ5bDXg+RGSLXU+ju1vEtJ6pyfyK2PfS5ujkVzYwpYf20et8U1w3iMvQr1aTiV9k2LLcCFjTKfoXW6b+G0+pEsCyuT5VysLrdOe5T+anllrvzc7Ol1SnFLIlTxsJ47+aYv7E9+LTARv5uPsy3hKAEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0KM+lLFu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0KM+lLFu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB4931F000FF;
	Tue, 13 Oct 2026 12:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791896012;
	bh=VR28V/fFvZ/UJrhGK52Z80na0+i8XXztD6aVmXhNNIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0KM+lLFuY9Mhtd1sp0TKxBG7hDANuOvAZY+uRsQ3r1NVpbfpMa2z/AJCQ3rLzVCcI
	 u30K3VNy/5+GRuQBzU/xqKLXQS03QyrOb0W953uefYcV+EDhOvbvglm7anMeeHqlY9
	 J9yks07rgXlYkicS3YeDQehq5GF3r3yYOlM/onQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Changyul Lee <lcy8047@gmail.com>,
	Maurizio Lombardi <mlombard@redhat.com>,
	Sang-Hoon Choi <csh0052@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 461/497] nvmet: use the local P2P device on metadata allocation failure
Date: Tue, 13 Oct 2026 13:40:28 +0200
Message-ID: <20261013112918.823221342@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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
index 6267c6d576db9..5950635d6f58d 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -1099,7 +1099,7 @@ static int nvmet_req_alloc_p2pmem_sgls(struct pci_dev *p2p_dev,
 
 	return 0;
 out_free_sg:
-	pci_p2pmem_free_sgl(req->p2p_dev, req->sg);
+	pci_p2pmem_free_sgl(p2p_dev, req->sg);
 out_err:
 	return -ENOMEM;
 }
-- 
2.53.0



