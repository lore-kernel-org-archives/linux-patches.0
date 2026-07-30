Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A8DC3769FD;
	Thu, 30 Jul 2026 15:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425913; cv=none; b=W0/J7tNbzkYcXQxVMrKE85J20zpD9ciwiOjjtFWGv/TFRJo1mP4MBkDgTcPOtdCJZUebmav1iTdcVDnat+3hreAvLhoTXCVYNh1Whbs/oWwsvMMnhQt9XGbGIUPftMC+UKAubPpdgQhDsEfxh5EgXY9FCaujbr3CR2Dsn/Gx40U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425913; c=relaxed/simple;
	bh=ODv9oLFxGLMNW2EK0jtJ1Newn7Wc41p3OZMXrewPH/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bcKiYVU5lLI+cyJ+Jhy0ey3tZGgK+2gyysEKruCsWSa0u0xkzkEKvEHZRKvUyjRaEhObVtkgslJCssmmH6s86sYUJHiG0m4JSMlVfzDgyZHn9JrCR/V7WyKaKOL8PwpFdnLAf1+2ACm1b9e7pbR++1Z/TXHDCw8RPCBC0IizsA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IyV3lQ8A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IyV3lQ8A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B76AA1F000E9;
	Thu, 30 Jul 2026 15:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425912;
	bh=bN3Gw2vdYNXRdl/+3z09RjRAn3aB08iArn8TEjmzD+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IyV3lQ8AuV2P9YrLSS2P53Gg1fC2fZ6ifNlNAMQlMDhGuUn0ZMOKCtibWO3Y+YkJ+
	 jL9qRZhwe8u05Zr1NDKJnhNm3goJou64BDCDwJ7j6rZdIHX11BDD1mLIpbP72eCog5
	 EZADqH3x2Y4mWe/Cp33cghmDP1sghTJA/IgfgLU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	"Nikhil P. Rao" <nikhil.rao@amd.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 191/602] pds_core: fix deadlock between reset thread and remove
Date: Thu, 30 Jul 2026 16:09:43 +0200
Message-ID: <20260730141439.973339468@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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
index 3c60d4cf9d0e17..c99cbb038f5d98 100644
--- a/drivers/net/ethernet/amd/pds_core/core.c
+++ b/drivers/net/ethernet/amd/pds_core/core.c
@@ -597,9 +597,10 @@ void pdsc_pci_reset_thread(struct work_struct *work)
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



