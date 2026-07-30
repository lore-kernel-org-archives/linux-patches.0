Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A89043F4C7;
	Thu, 30 Jul 2026 15:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423997; cv=none; b=p9rT8xhcTn2tvUTs9tsm2D360zyKuthh3Ll6ls1kPHeQ8b6gPW1G7LOThJiHvGASkEiEVDTcW+Rh0EncEU6HjwRq7Gq6JdJRIFbPY//UmorhlNcHFH29CmLTD6Km3IKmHDJvF/sHuj74RrcjjnAsnHuEFK/XfR3gWirAq7ODXgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423997; c=relaxed/simple;
	bh=gEhzeyOOeCTzt+a6lc64ApMLqFVE9TkdOD5MWCHPmfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N18exB+vZhSKua2kOU59uREs9R2Nxhp5X/BO+hHd6jV3xQI42s3j9RBXSfeTtcOAj923sAn4KPRPCwEz5siwdlBjzYHNvLkSoqWzYguaE4MWEaWc1MjbzynYFx+wDQmcjxDHc4+jkL6jgZK0V3UvQKy6ZnWCrCv5jfXvF8fEDAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V5iPedWS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V5iPedWS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2D7F1F000E9;
	Thu, 30 Jul 2026 15:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423996;
	bh=Nmid6L/CZ4NP9N/mlU+QXn/S/Nl/495ZzN3PLXd1d+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V5iPedWSPDgrV/NhGA2AbgK16L8XUVQVgYmB7OVIirTkxQt//R7BGhSV62+nDmvzv
	 80QEF6O8S0TxYbHREvaJNdxjDmId9uJZyXAdmobS9kM9DMOhJR4m6CPBufNygTy3PK
	 lgfa4NkbTE3/3a27sCzwr2KlJ3QSPeUVKCOzrITI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	"Nikhil P. Rao" <nikhil.rao@amd.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 239/675] pds_core: fix deadlock between reset thread and remove
Date: Thu, 30 Jul 2026 16:09:29 +0200
Message-ID: <20260730141450.215274940@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Nikhil P. Rao <nikhil.rao@amd.com>

[ Upstream commit ab0eec0ff0a421737a37f510ceab5c6ea59cd05a ]

pci_reset_function() acquires device_lock before performing the reset.
pdsc_remove() is called by the PCI core with device_lock already held.
If pdsc_pci_reset_thread() is running when pdsc_remove() is called,
destroy_workqueue() will block waiting for the work to complete, while
the work is blocked waiting for device_lock - deadlock.

Use pci_try_reset_function() which uses pci_dev_trylock() internally.
This acquires both the device lock and the PCI config access lock
without blocking - if either lock is contended, it returns -EAGAIN
immediately. This avoids the deadlock while also ensuring proper
config space access serialization during the reset.

The pci_dev_get/put calls are also removed as they were unnecessary -
the driver-owned workqueue is destroyed in pdsc_remove(), guaranteeing
the work completes before remove returns. The PCI core holds its
reference to pci_dev throughout the entire unbind sequence.

Fixes: 81665adf25d2 ("pds_core: Fix pdsc_check_pci_health function to use work thread")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://patchwork.kernel.org/comment/27002369/
Signed-off-by: Nikhil P. Rao <nikhil.rao@amd.com>
Reviewed-by: Harshitha Ramamurthy <hramamurthy@google.com>
Link: https://patch.msgid.link/20260714180223.1642792-2-nikhil.rao@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/pds_core/core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/amd/pds_core/core.c b/drivers/net/ethernet/amd/pds_core/core.c
index 076dfe2910c770..1978287cf275fc 100644
--- a/drivers/net/ethernet/amd/pds_core/core.c
+++ b/drivers/net/ethernet/amd/pds_core/core.c
@@ -603,9 +603,10 @@ void pdsc_pci_reset_thread(struct work_struct *work)
 	struct pdsc *pdsc = container_of(work, struct pdsc, pci_reset_work);
 	struct pci_dev *pdev = pdsc->pdev;
 
-	pci_dev_get(pdev);
-	pci_reset_function(pdev);
-	pci_dev_put(pdev);
+	/* Use try variant to avoid deadlock with pdsc_remove().
+	 * If lock is contended, the watchdog timer will retry.
+	 */
+	pci_try_reset_function(pdev);
 }
 
 static void pdsc_check_pci_health(struct pdsc *pdsc)
-- 
2.53.0



