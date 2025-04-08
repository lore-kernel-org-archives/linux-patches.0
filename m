Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E55126B2BE;
	Tue,  8 Apr 2025 12:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115300; cv=none; b=T13iCcPovly6ZPtQZQAYqgkva9wDF4jlx7ymZc9ULE2DypzFLPE17BKCZM2qCRYCp8Pd5+xrJhEV0r0Vbgasc32T0fpMCbpuO2jQp53BD1YUB54FDUoFj7J56OAVdl9YXAYETcx21kR8H3hnEvXkL8I6U1ISYd9MRPv7EjIixUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115300; c=relaxed/simple;
	bh=OSyR8Acx84E5zi0P2jChqN4R/RLiuqMTzFH6ugcc4xA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uUtgwFeXefS8IAulkw48UG2k8EUQgPlt6YBxbP6MKKACRHNN2PH1SHqnypWZKwtx75tq9JVXQXoKsLiHa4kXl3RL3BkwJmttQg4Xn2FVuS1nHRzgbjqnoYGlghMSH3MOe8UOHlK0HmX4pBOiTBnrplmXpDAV2EZULe4o/m4/Y9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VHVKLVu+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VHVKLVu+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B498C4CEE5;
	Tue,  8 Apr 2025 12:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115300;
	bh=OSyR8Acx84E5zi0P2jChqN4R/RLiuqMTzFH6ugcc4xA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VHVKLVu+hk0ILXf54FwxowXQ6/jcRpMszzk0X165LEsHt2DmLbm3VJwIIgzNhmZMA
	 PC2z5wgQFWq37gWjV2GdhwLjKqXRuDDc/G602i0tveoezSmAAbo9xWcoPDGXY4eYl9
	 nYCqVdQrlXnqo9CWlscdhAeDhAnop6OJMuk5lzjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuying Ma <yuma@redhat.com>,
	Madhu Chittim <madhu.chittim@intel.com>,
	Emil Tantilov <emil.s.tantilov@intel.com>,
	Simon Horman <horms@kernel.org>,
	Samuel Salin <Samuel.salin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 384/499] idpf: fix adapter NULL pointer dereference on reboot
Date: Tue,  8 Apr 2025 12:49:56 +0200
Message-ID: <20250408104900.806142619@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emil Tantilov <emil.s.tantilov@intel.com>

[ Upstream commit 4c9106f4906a85f6b13542d862e423bcdc118cc3 ]

With SRIOV enabled, idpf ends up calling into idpf_remove() twice.
First via idpf_shutdown() and then again when idpf_remove() calls into
sriov_disable(), because the VF devices use the idpf driver, hence the
same remove routine. When that happens, it is possible for the adapter
to be NULL from the first call to idpf_remove(), leading to a NULL
pointer dereference.

echo 1 > /sys/class/net/<netif>/device/sriov_numvfs
reboot

BUG: kernel NULL pointer dereference, address: 0000000000000020
...
RIP: 0010:idpf_remove+0x22/0x1f0 [idpf]
...
? idpf_remove+0x22/0x1f0 [idpf]
? idpf_remove+0x1e4/0x1f0 [idpf]
pci_device_remove+0x3f/0xb0
device_release_driver_internal+0x19f/0x200
pci_stop_bus_device+0x6d/0x90
pci_stop_and_remove_bus_device+0x12/0x20
pci_iov_remove_virtfn+0xbe/0x120
sriov_disable+0x34/0xe0
idpf_sriov_configure+0x58/0x140 [idpf]
idpf_remove+0x1b9/0x1f0 [idpf]
idpf_shutdown+0x12/0x30 [idpf]
pci_device_shutdown+0x35/0x60
device_shutdown+0x156/0x200
...

Replace the direct idpf_remove() call in idpf_shutdown() with
idpf_vc_core_deinit() and idpf_deinit_dflt_mbx(), which perform
the bulk of the cleanup, such as stopping the init task, freeing IRQs,
destroying the vports and freeing the mailbox. This avoids the calls to
sriov_disable() in addition to a small netdev cleanup, and destroying
workqueues, which don't seem to be required on shutdown.

Reported-by: Yuying Ma <yuma@redhat.com>
Fixes: e850efed5e15 ("idpf: add module register and probe functionality")
Reviewed-by: Madhu Chittim <madhu.chittim@intel.com>
Signed-off-by: Emil Tantilov <emil.s.tantilov@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Samuel Salin <Samuel.salin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf_main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_main.c b/drivers/net/ethernet/intel/idpf/idpf_main.c
index b6c515d14cbf0..bec4a02c53733 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_main.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_main.c
@@ -87,7 +87,11 @@ static void idpf_remove(struct pci_dev *pdev)
  */
 static void idpf_shutdown(struct pci_dev *pdev)
 {
-	idpf_remove(pdev);
+	struct idpf_adapter *adapter = pci_get_drvdata(pdev);
+
+	cancel_delayed_work_sync(&adapter->vc_event_task);
+	idpf_vc_core_deinit(adapter);
+	idpf_deinit_dflt_mbx(adapter);
 
 	if (system_state == SYSTEM_POWER_OFF)
 		pci_set_power_state(pdev, PCI_D3hot);
-- 
2.39.5



