Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AED7314A67;
	Mon, 13 Oct 2025 15:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370168; cv=none; b=EoGp4d9SwjRyYWmy4bp2c3KgsrXdkzq1Z5aGzn9qKS7/jKqZ5cbQEaoLatN7vd2kZCDSyW2by2xHpE3oJNlEIXz3ikhIbpX75CTiEz1zD3QqOE2ldd+vubS2Wq1sjo970hEGwBllS7qn/ESKg4jcl/daCmPVNxxlUB8WG96AlWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370168; c=relaxed/simple;
	bh=NtiS0oRwZk5Q5NxJqAYC6p1Xtae/TP7CsTJxzKlrIgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rmsKboZCBXvCw647UTb92ujmkDFuhSk3keXqL+21GMR/eGjLlss+TPP+EAZIOCHFSDiq7jlDSL6qUgw2mf1mK0jprfQFlb5OPobJAzyS7KnBuVOFHUZ90l6IK7kn73oGaglQnUEBRbkp7NX1gZHQ1LVzwSfMQ49YnRSza8La2mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xd/cDWHF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xd/cDWHF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEE17C4CEE7;
	Mon, 13 Oct 2025 15:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370168;
	bh=NtiS0oRwZk5Q5NxJqAYC6p1Xtae/TP7CsTJxzKlrIgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xd/cDWHFAprXlsnOYtnpJ7r2CBVTfooZ4j9rGQwJTB+Nrz/VouevOfm5tgm6xbjT1
	 JFJpVE3HC+XyOvFzd3nvsS2+9kx8uYbCGmYxtwT4Bm/UiuXr4OngjfcbM5WHx3a+eS
	 JVrByEnbEt+KEcMEnzE+cN9TEqIiyOlojuMRK4EY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bo Sun <bo@mboxify.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 485/563] octeontx2-vf: fix bitmap leak
Date: Mon, 13 Oct 2025 16:45:46 +0200
Message-ID: <20251013144428.862929262@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bo Sun <bo@mboxify.com>

[ Upstream commit cd9ea7da41a449ff1950230a35990155457b9879 ]

The bitmap allocated with bitmap_zalloc() in otx2vf_probe() was not
released in otx2vf_remove(). Unbinding and rebinding the driver therefore
triggers a kmemleak warning:

    unreferenced object (size 8):
      backtrace:
        bitmap_zalloc
        otx2vf_probe

Call bitmap_free() in the remove path to fix the leak.

Fixes: efabce290151 ("octeontx2-pf: AF_XDP zero copy receive support")
Signed-off-by: Bo Sun <bo@mboxify.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index 7ebb6e656884a..25381f079b97d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -854,6 +854,7 @@ static void otx2vf_remove(struct pci_dev *pdev)
 		qmem_free(vf->dev, vf->dync_lmt);
 	otx2vf_vfaf_mbox_destroy(vf);
 	pci_free_irq_vectors(vf->pdev);
+	bitmap_free(vf->af_xdp_zc_qidx);
 	pci_set_drvdata(pdev, NULL);
 	free_netdev(netdev);
 }
-- 
2.51.0



