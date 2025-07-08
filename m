Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C4B2A1BA;
	Tue,  8 Jul 2025 16:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992104; cv=none; b=kPJyJ1kt2upaVDqNDNT/Wg9D0dwj4EUjSX7UKGKNM2j6njjGRKAAqKeyDifL9ILNo5ozK/EgcqUoqu+Wr0ontvFQyyU9VZnHZuG7AsiFmvNCFhusgv2RnmetxLZ4v6bcFVcKSVt9u3JKfiEF2SKK/s7hC/jstEu8DQ6j7uDxSVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992104; c=relaxed/simple;
	bh=K1qx208vhqLS0VRIGhGteYTM3cuRdeeRDrw7OjCYYuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yi64LWTOGxPmA7/Ym63YR1b6ILXy/+dbCK3JyzAD73mPHPjfPE4cNIwD6ZRTKPcgfRgR/Wzxk5NxBpi2+Q/PR+B54B1TNc0h6kiyIgnAOboLZG17SkVduPs1V4hh4LD+wzG4tlZbE8yzkh1kefZKYw5gqrqkvrLmcN5XS06WpOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AGTioVvI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AGTioVvI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E96FC4CEED;
	Tue,  8 Jul 2025 16:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992104;
	bh=K1qx208vhqLS0VRIGhGteYTM3cuRdeeRDrw7OjCYYuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AGTioVvIek6PJ2JTR8P5/FWXVf7r/KxX0fGLKeH26aH1jYLz04SYh8h0ND6bAgXmc
	 Mc09tiMye8Cf0j+IcSlCMxoJdQg6iSH0LlS8DRBFNO+M+JfxC99Svb6luCLXKrBhKH
	 FEUElQlJXyfXK0D/TS3cSChESeMcPzYOyDJCcxPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Ruess <julianr@linux.ibm.com>,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Farhan Ali <alifm@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 60/81] s390/pci: Fix stale function handles in error handling
Date: Tue,  8 Jul 2025 18:23:52 +0200
Message-ID: <20250708162226.893789793@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162224.795155912@linuxfoundation.org>
References: <20250708162224.795155912@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Schnelle <schnelle@linux.ibm.com>

[ Upstream commit 45537926dd2aaa9190ac0fac5a0fbeefcadfea95 ]

The error event information for PCI error events contains a function
handle for the respective function. This handle is generally captured at
the time the error event was recorded. Due to delays in processing or
cascading issues, it may happen that during firmware recovery multiple
events are generated. When processing these events in order Linux may
already have recovered an affected function making the event information
stale. Fix this by doing an unconditional CLP List PCI function
retrieving the current function handle with the zdev->state_lock held
and ignoring the event if its function handle is stale.

Cc: stable@vger.kernel.org
Fixes: 4cdf2f4e24ff ("s390/pci: implement minimal PCI error recovery")
Reviewed-by: Julian Ruess <julianr@linux.ibm.com>
Reviewed-by: Gerd Bayer <gbayer@linux.ibm.com>
Reviewed-by: Farhan Ali <alifm@linux.ibm.com>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/pci/pci_event.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/s390/pci/pci_event.c b/arch/s390/pci/pci_event.c
index d969f36bf186f..dc512c8f82324 100644
--- a/arch/s390/pci/pci_event.c
+++ b/arch/s390/pci/pci_event.c
@@ -257,6 +257,8 @@ static void __zpci_event_error(struct zpci_ccdf_err *ccdf)
 	struct zpci_dev *zdev = get_zdev_by_fid(ccdf->fid);
 	struct pci_dev *pdev = NULL;
 	pci_ers_result_t ers_res;
+	u32 fh = 0;
+	int rc;
 
 	zpci_dbg(3, "err fid:%x, fh:%x, pec:%x\n",
 		 ccdf->fid, ccdf->fh, ccdf->pec);
@@ -264,9 +266,23 @@ static void __zpci_event_error(struct zpci_ccdf_err *ccdf)
 	zpci_err_hex(ccdf, sizeof(*ccdf));
 
 	if (zdev) {
+		mutex_lock(&zdev->state_lock);
+		rc = clp_refresh_fh(zdev->fid, &fh);
+		if (rc) {
+			mutex_unlock(&zdev->state_lock);
+			goto no_pdev;
+		}
+		if (!fh || ccdf->fh != fh) {
+			/* Ignore events with stale handles */
+			zpci_dbg(3, "err fid:%x, fh:%x (stale %x)\n",
+				 ccdf->fid, fh, ccdf->fh);
+			mutex_unlock(&zdev->state_lock);
+			goto no_pdev;
+		}
 		zpci_update_fh(zdev, ccdf->fh);
 		if (zdev->zbus->bus)
 			pdev = pci_get_slot(zdev->zbus->bus, zdev->devfn);
+		mutex_unlock(&zdev->state_lock);
 	}
 
 	pr_err("%s: Event 0x%x reports an error for PCI function 0x%x\n",
-- 
2.39.5



