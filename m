Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 788D4429802;
	Thu, 30 Jul 2026 14:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421932; cv=none; b=Co0UZHGoPyy9ZlGlPfPDW3ZDt0137f8HWZFc04aKUt3EyRokUzdQvXf7CqNK5e8mKZj+sjlZfm8AWIjH60u937BQAi1vXM1MTxQn0E3jy6uDGGqNodd4fn3jKaxeth5BqTrftXTyeS6v0Wq5rv7PHhR/bczDV+V1bOC9sdf8wz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421932; c=relaxed/simple;
	bh=dkGvygfVVt/AHxmjIF6I/cB0bQhjpVr6y2N1CuqRwhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r+YjjA+8Zf78NUMbyD1Kepk43wrWNLQGoA2Rw2o+gR48G0tDd1+c3lxR4eVyc6zlprBw3XRzzjfJz78dmNxQIgcW+LFA0vCvgXnQo4iWMyLHICX5CUpekF/qm8N2YBsptxds2Dumr1vxi6Yqw8L1edb2jxA05RZ93nNnK2xOXp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jm8saP/R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jm8saP/R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB3A11F000E9;
	Thu, 30 Jul 2026 14:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421931;
	bh=EgMd953lpjatdDDXZkWemz54hihCBfXkjaG9XT41Y38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jm8saP/RVb7cElfa8Hct+ZW2cssPNUnATtgVOKf3JmR81xwktCZLJjbpztBdjNwnR
	 6pthfaEEHeTtx3dRxY9Hd3TFdeGxqOVmvK3efH8m4U2rP6RHEPZxPvCi7u95s8XvsU
	 2M+oKPDtZwqAg6wZIJoM/PKDtLQ2qNZ85V+eqG3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	"Nikhil P. Rao" <nikhil.rao@amd.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 266/744] pds_core: fix deadlock between reset thread and remove
Date: Thu, 30 Jul 2026 16:08:59 +0200
Message-ID: <20260730141449.948509779@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 705cab7b07273d..b6d4b30147232a 100644
--- a/drivers/net/ethernet/amd/pds_core/core.c
+++ b/drivers/net/ethernet/amd/pds_core/core.c
@@ -602,9 +602,10 @@ void pdsc_pci_reset_thread(struct work_struct *work)
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



