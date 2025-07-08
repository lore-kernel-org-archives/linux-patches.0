Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B111548C;
	Tue,  8 Jul 2025 16:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992492; cv=none; b=EkXzMa8rQlFkQvxB+UCy+agx66/f8u/sy0Wp2xhfBmvMgmYsZxu4w8VnDegRVDZdU3BT5KhMPRJ+7ywS2/l311v80dgIFAGzQW/BdH8e8x6ja+djF2kNj4U8MIsP695jAJ2f6H0k5MK7md2Spnb+OVjrA0+Xt2EP106TNVd3N7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992492; c=relaxed/simple;
	bh=fKHrjSvrufbWNac6nbI0vZo0ACe8+d8zJB1XulStKvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OMnJVt0R/Ps/DrWi2s8mTEQeZp7X+i5kAjEft/mFxSaGh+hfpXrZAb24gWvmnE4463r47poHIfzKujrSAh0mo+Nv91XWglZcyCbeIq5FeIu/aHgXOlrlUwKIhZ9NOyyXLT9hTzmFhQ5Pzpf0KILsYnOGLmMu3l3KpvYm0GFXSLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0giuieg0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0giuieg0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0CDAC4CEED;
	Tue,  8 Jul 2025 16:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992492;
	bh=fKHrjSvrufbWNac6nbI0vZo0ACe8+d8zJB1XulStKvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0giuieg0ftiQpdQdDU56xc37OD5Xk7vDSy6CkhuitKT5ti9bdCAE0T/VQryY9wOKV
	 sHfuYIbU5AVlHfa4QwOamDvB3rY3bkF/SKKoo3NZWmHqfc0sFk6KA40SdLdHfTEwYT
	 OLX5Z8fz1656I3GlnT2TlJFs+CTsQKrxsaIrPLEc=
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
Subject: [PATCH 6.6 108/132] s390/pci: Fix stale function handles in error handling
Date: Tue,  8 Jul 2025 18:23:39 +0200
Message-ID: <20250708162233.754242912@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 arch/s390/pci/pci_event.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/s390/pci/pci_event.c b/arch/s390/pci/pci_event.c
index d969f36bf186f..fd83588f3c11d 100644
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
@@ -264,6 +266,16 @@ static void __zpci_event_error(struct zpci_ccdf_err *ccdf)
 	zpci_err_hex(ccdf, sizeof(*ccdf));
 
 	if (zdev) {
+		mutex_lock(&zdev->state_lock);
+		rc = clp_refresh_fh(zdev->fid, &fh);
+		if (rc)
+			goto no_pdev;
+		if (!fh || ccdf->fh != fh) {
+			/* Ignore events with stale handles */
+			zpci_dbg(3, "err fid:%x, fh:%x (stale %x)\n",
+				 ccdf->fid, fh, ccdf->fh);
+			goto no_pdev;
+		}
 		zpci_update_fh(zdev, ccdf->fh);
 		if (zdev->zbus->bus)
 			pdev = pci_get_slot(zdev->zbus->bus, zdev->devfn);
@@ -292,6 +304,8 @@ static void __zpci_event_error(struct zpci_ccdf_err *ccdf)
 	}
 	pci_dev_put(pdev);
 no_pdev:
+	if (zdev)
+		mutex_unlock(&zdev->state_lock);
 	zpci_zdev_put(zdev);
 }
 
-- 
2.39.5



