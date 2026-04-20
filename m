Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8C0329C6D;
	Mon, 20 Apr 2026 15:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700230; cv=none; b=cUifVGk981AY3Itll88bBWa3cWoexuUbI1cJF4rySJkDd6ZhA5Oo4PNVl75EF8pQEtNCQ9ifybiYpOnw78lZKSN/MRMcnLOePqv96rliqFy5cjI4SZchXpGB1OibimTnXSmOLdC+KZyd21o5HJ+J0RWOBa6nnj+jqRNkZKq1Yr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700230; c=relaxed/simple;
	bh=1xrJ8VjEWmkKt8hu0Os6JbOCtbDbCHgiwLIR6A/6VjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m7oGiUIlE5HMvsszH+ddB/vWkJz/eCLNIE8aoCEhSXHICc/Xuj0TxyRJzCCXaVwruB4owrGA3X/u6KE/rXLn4NYVWLIKQQcnNjlbyV/EmeHFd0qwcRxs3ksriuDWONVIZqlii7S3Elzfe9HrswTPPSNTK1RA/QOVMkpn/NIVTJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KJyFKqa9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KJyFKqa9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12D83C2BCB4;
	Mon, 20 Apr 2026 15:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700230;
	bh=1xrJ8VjEWmkKt8hu0Os6JbOCtbDbCHgiwLIR6A/6VjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KJyFKqa9pSGvJblM3cPP8CifJF1tvRbNvZi4IkZ9p13P2x/wA3wnzQiOlmVUsKFx3
	 N2fVXMJNtoJk6DGw7GV3m1+u3p76j7NHRTIDwtSoiLecnc720xtebcvse6G7t1Y+IK
	 Niey9EppVML7xkRv+C7onT5itauXMVfKHKQwdjSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sahil Chandna <sahilchandna@linux.microsoft.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Saurabh Sengar <ssengar@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 091/220] PCI: hv: Fix double ida_free in hv_pci_probe error path
Date: Mon, 20 Apr 2026 17:40:32 +0200
Message-ID: <20260420153937.311549929@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sahil Chandna <sahilchandna@linux.microsoft.com>

[ Upstream commit b6422dff0e518245019233432b6bccfc30b73e2f ]

If hv_pci_probe() fails after storing the domain number in
hbus->bridge->domain_nr, there is a call to free this domain_nr via
pci_bus_release_emul_domain_nr(), however, during cleanup, the bridge
release callback pci_release_host_bridge_dev() also frees the domain_nr
causing ida_free to be called on same ID twice and triggering following
warning:

  ida_free called for id=28971 which is not allocated.
  WARNING: lib/idr.c:594 at ida_free+0xdf/0x160, CPU#0: kworker/0:2/198
  Call Trace:
   pci_bus_release_emul_domain_nr+0x17/0x20
   pci_release_host_bridge_dev+0x4b/0x60
   device_release+0x3b/0xa0
   kobject_put+0x8e/0x220
   devm_pci_alloc_host_bridge_release+0xe/0x20
   devres_release_all+0x9a/0xd0
   device_unbind_cleanup+0x12/0xa0
   really_probe+0x1c5/0x3f0
   vmbus_add_channel_work+0x135/0x1a0

Fix this by letting pci core handle the free domain_nr and remove
the explicit free called in pci-hyperv driver.

Fixes: bcce8c74f1ce ("PCI: Enable host bridge emulation for PCI_DOMAINS_GENERIC platforms")
Signed-off-by: Sahil Chandna <sahilchandna@linux.microsoft.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Saurabh Sengar <ssengar@linux.microsoft.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-hyperv.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
index 85631c9794db6..7f1c1a2e5c69d 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -3789,7 +3789,7 @@ static int hv_pci_probe(struct hv_device *hdev,
 					   hbus->bridge->domain_nr);
 	if (!hbus->wq) {
 		ret = -ENOMEM;
-		goto free_dom;
+		goto free_bus;
 	}
 
 	hdev->channel->next_request_id_callback = vmbus_next_request_id;
@@ -3885,8 +3885,6 @@ static int hv_pci_probe(struct hv_device *hdev,
 	vmbus_close(hdev->channel);
 destroy_wq:
 	destroy_workqueue(hbus->wq);
-free_dom:
-	pci_bus_release_emul_domain_nr(hbus->bridge->domain_nr);
 free_bus:
 	kfree(hbus);
 	return ret;
-- 
2.53.0



