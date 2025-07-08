Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD9F2045B5;
	Tue,  8 Jul 2025 16:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993290; cv=none; b=mGCGmP8/8e/TcJimGLXp8c2qJq2fiH8BTy7ZMh18SZGnFaA6BPWeEMVRarvYSX2kcMcg2039LDC+O3dBoTN2xxLdU1mSU78PuDHexqf2X5GHSvsdn6uVv/IUUKjgAf3xE8pdlJLp3yEe4h1kSE1oJPM2B0GGGhWjnMc9beg1ADM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993290; c=relaxed/simple;
	bh=4UneWi24q4JlN9cadXDoK3yT+Q4LUbICQsgEvy+t0qw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bjwVxphPMQ0iTGEm40yUvKwj62vWS+Q4n/+StCZGRGlf2JC6YpmIwgNmC+3sCtfqX58w1fzkQEFCOOyMqfDVUYrAjwa+b61sWGmDjDA7xRJ7V21DFa0mkQqF1kfdjG8249KX/6LQWSrCTrRYXsdbHrQDvtDh0MTFvcMxqdgUhf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JGaRcomK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JGaRcomK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97EE6C4CEF5;
	Tue,  8 Jul 2025 16:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993290;
	bh=4UneWi24q4JlN9cadXDoK3yT+Q4LUbICQsgEvy+t0qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JGaRcomK37R0vNag+KQSa+JffSa6d7tJKqtGXpgepXhIwnohrJD0yFq9i0WI6ooM/
	 wETfdOZeNeEZ0sySvU43dvtD8yJia4lvhJEI9Q0Wj1SC1HKOReZ0F0jJTCKvIoTycE
	 k44sXvuBvjYtNUSm+qOfXhHz6qxAnXWW/+umu2jM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Ruess <julianr@linux.ibm.com>,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Farhan Ali <alifm@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 6.15 006/178] s390/pci: Fix stale function handles in error handling
Date: Tue,  8 Jul 2025 18:20:43 +0200
Message-ID: <20250708162236.720775955@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Schnelle <schnelle@linux.ibm.com>

commit 45537926dd2aaa9190ac0fac5a0fbeefcadfea95 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/pci/pci_event.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/arch/s390/pci/pci_event.c
+++ b/arch/s390/pci/pci_event.c
@@ -273,6 +273,8 @@ static void __zpci_event_error(struct zp
 	struct zpci_dev *zdev = get_zdev_by_fid(ccdf->fid);
 	struct pci_dev *pdev = NULL;
 	pci_ers_result_t ers_res;
+	u32 fh = 0;
+	int rc;
 
 	zpci_dbg(3, "err fid:%x, fh:%x, pec:%x\n",
 		 ccdf->fid, ccdf->fh, ccdf->pec);
@@ -281,6 +283,15 @@ static void __zpci_event_error(struct zp
 
 	if (zdev) {
 		mutex_lock(&zdev->state_lock);
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


