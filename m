Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1291C68A6;
	Wed, 19 Feb 2025 08:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955152; cv=none; b=WT6bMojJROzulR//EES8/tA4k8b01SNgt631P+nKHjkcrvxogG4ZfpCHxpRJ7xIdGNXjaHWVBAabV3jhpHBaEVAbYFY5hCOuKLvWxsXSIWP8T0/X7yBQ1pNmIQLqoVgFyJZNznPQyzs4Y+YiO8UefGdjS+jU2l/qnz6vVKnkxK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955152; c=relaxed/simple;
	bh=AHb2FDFQA+6X1547yFkj9wI9GiZ2UVTI1wZfG9PHvqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ji155bSXfmBferoXjK4TqVYY2djSaqd+gPo8SMKslWt1tlro8RuKj3sMyGXV+pouEihmX4jsO5EdYsfE8eXIQhtazcGMEOJysWB8qxyTNhVNjabp9j6r0r6LxTXbfbJpoaztSFYORR58PrVV+jKlzOPfrkZlf00OMsNSWC+Yc9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H4O7DrhK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H4O7DrhK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE997C4CED1;
	Wed, 19 Feb 2025 08:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955151;
	bh=AHb2FDFQA+6X1547yFkj9wI9GiZ2UVTI1wZfG9PHvqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H4O7DrhKY2IipkkQF/lacFuWWyOjeWPMlUEfe61c0luTpkxh9Rz2MWhqFJyYiOX3v
	 LrJwFQWazbmHHI6yVBIkYKLIGLgkvJa47UL0gpsSGJDOJf5AJI7KUVD5HMY1Z4xcNF
	 z7tRNBybasnZ35A1RQbdC04C2gls+cWnhYxlmE4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Halil Pasic <pasic@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.12 148/230] s390/pci: Pull search for parent PF out of zpci_iov_setup_virtfn()
Date: Wed, 19 Feb 2025 09:27:45 +0100
Message-ID: <20250219082607.475870222@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Schnelle <schnelle@linux.ibm.com>

commit 05793884a1f30509e477de9da233ab73584b1c8c upstream.

This creates a new zpci_iov_find_parent_pf() function which a future
commit can use to find if a VF has a configured parent PF. Use
zdev->rid instead of zdev->devfn such that the new function can be used
before it has been decided if the RID will be exposed and zdev->devfn is
set. Also handle the hypotheical case that the RID is not available but
there is an otherwise matching zbus.

Fixes: 25f39d3dcb48 ("s390/pci: Ignore RID for isolated VFs")
Cc: stable@vger.kernel.org
Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/pci/pci_iov.c | 56 ++++++++++++++++++++++++++++++-----------
 1 file changed, 42 insertions(+), 14 deletions(-)

diff --git a/arch/s390/pci/pci_iov.c b/arch/s390/pci/pci_iov.c
index ead062bf2b41..c7fdf5e79b3c 100644
--- a/arch/s390/pci/pci_iov.c
+++ b/arch/s390/pci/pci_iov.c
@@ -60,18 +60,35 @@ static int zpci_iov_link_virtfn(struct pci_dev *pdev, struct pci_dev *virtfn, in
 	return 0;
 }
 
-int zpci_iov_setup_virtfn(struct zpci_bus *zbus, struct pci_dev *virtfn, int vfn)
+/**
+ * zpci_iov_find_parent_pf - Find the parent PF, if any, of the given function
+ * @zbus:	The bus that the PCI function is on, or would be added on
+ * @zdev:	The PCI function
+ *
+ * Finds the parent PF, if it exists and is configured, of the given PCI function
+ * and increments its refcount. Th PF is searched for on the provided bus so the
+ * caller has to ensure that this is the correct bus to search. This function may
+ * be used before adding the PCI function to a zbus.
+ *
+ * Return: Pointer to the struct pci_dev of the parent PF or NULL if it not
+ * found. If the function is not a VF or has no RequesterID information,
+ * NULL is returned as well.
+ */
+static struct pci_dev *zpci_iov_find_parent_pf(struct zpci_bus *zbus, struct zpci_dev *zdev)
 {
-	int i, cand_devfn;
-	struct zpci_dev *zdev;
+	int i, vfid, devfn, cand_devfn;
 	struct pci_dev *pdev;
-	int vfid = vfn - 1; /* Linux' vfid's start at 0 vfn at 1*/
-	int rc = 0;
 
 	if (!zbus->multifunction)
-		return 0;
-
-	/* If the parent PF for the given VF is also configured in the
+		return NULL;
+	/* Non-VFs and VFs without RID available don't have a parent */
+	if (!zdev->vfn || !zdev->rid_available)
+		return NULL;
+	/* Linux vfid starts at 0 vfn at 1 */
+	vfid = zdev->vfn - 1;
+	devfn = zdev->rid & ZPCI_RID_MASK_DEVFN;
+	/*
+	 * If the parent PF for the given VF is also configured in the
 	 * instance, it must be on the same zbus.
 	 * We can then identify the parent PF by checking what
 	 * devfn the VF would have if it belonged to that PF using the PF's
@@ -85,15 +102,26 @@ int zpci_iov_setup_virtfn(struct zpci_bus *zbus, struct pci_dev *virtfn, int vfn
 			if (!pdev)
 				continue;
 			cand_devfn = pci_iov_virtfn_devfn(pdev, vfid);
-			if (cand_devfn == virtfn->devfn) {
-				rc = zpci_iov_link_virtfn(pdev, virtfn, vfid);
-				/* balance pci_get_slot() */
-				pci_dev_put(pdev);
-				break;
-			}
+			if (cand_devfn == devfn)
+				return pdev;
 			/* balance pci_get_slot() */
 			pci_dev_put(pdev);
 		}
 	}
+	return NULL;
+}
+
+int zpci_iov_setup_virtfn(struct zpci_bus *zbus, struct pci_dev *virtfn, int vfn)
+{
+	struct zpci_dev *zdev = to_zpci(virtfn);
+	struct pci_dev *pdev_pf;
+	int rc = 0;
+
+	pdev_pf = zpci_iov_find_parent_pf(zbus, zdev);
+	if (pdev_pf) {
+		/* Linux' vfids start at 0 while zdev->vfn starts at 1 */
+		rc = zpci_iov_link_virtfn(pdev_pf, virtfn, zdev->vfn - 1);
+		pci_dev_put(pdev_pf);
+	}
 	return rc;
 }
-- 
2.48.1



