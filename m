Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8322E11B9;
	Tue,  8 Jul 2025 16:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992199; cv=none; b=nIY1/r2qVT4HmVxGZyYDldrZy2tbvNjDXyW1ham/5n32gF66WxvnzBD77MLFLA3glqLyMAgxVV9BwtnBT451anb62FowM9vAZ0mByzzkXg1vKYUHt5oqdFO+GXVVKk2mRSsbn621mfSJx4wk1dLPGPD17HgM0W1gpxUF+phufB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992199; c=relaxed/simple;
	bh=atGLmWN54pH6e2NvZY2zH55xCJ73bTuZkZzeX6Ngx+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p3upwiEIcCL5SpTpkKW6nusabP+TXPErODn7lsMgf2M6eFeMpN79nwNS30BH/MCWLIRa8sx7KcXDZJ/VL/qLx43X4cC8E/aSjvwNi6tTN3iux/EfDcGg21ZlMN83g132hKna2dytgy6vpEhwCyQMUTPwu3W35DnwbFAa/iO1c9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PHhSiMBU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PHhSiMBU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75F56C4CEED;
	Tue,  8 Jul 2025 16:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992198;
	bh=atGLmWN54pH6e2NvZY2zH55xCJ73bTuZkZzeX6Ngx+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PHhSiMBUQAcY1GnmTKqapLXs0QdBoJdSC9Ec/M7SBX3qbGWk8bpU5hHF7sFKNwuPh
	 Qg8rHwYuKm8Frcmv32/aU2ZMKSxYy01wk6w9b3zf1pVGBhhzGrBany+OPbfDb6idJN
	 OZU9ZoJruSqETtSFeFmSa1O3UjPqpAU2+XZtdgfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhan Ali <alifm@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 6.6 005/132] s390/pci: Do not try re-enabling load/store if device is disabled
Date: Tue,  8 Jul 2025 18:21:56 +0200
Message-ID: <20250708162230.923655896@linuxfoundation.org>
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

commit b97a7972b1f4f81417840b9a2ab0c19722b577d5 upstream.

If a device is disabled unblocking load/store on its own is not useful
as a full re-enable of the function is necessary anyway. Note that SCLP
Write Event Data Action Qualifier 0 (Reset) leaves the device disabled
and triggers this case unless the driver already requests a reset.

Cc: stable@vger.kernel.org
Fixes: 4cdf2f4e24ff ("s390/pci: implement minimal PCI error recovery")
Reviewed-by: Farhan Ali <alifm@linux.ibm.com>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/pci/pci_event.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/s390/pci/pci_event.c
+++ b/arch/s390/pci/pci_event.c
@@ -98,6 +98,10 @@ static pci_ers_result_t zpci_event_do_er
 	struct zpci_dev *zdev = to_zpci(pdev);
 	int rc;
 
+	/* The underlying device may have been disabled by the event */
+	if (!zdev_enabled(zdev))
+		return PCI_ERS_RESULT_NEED_RESET;
+
 	pr_info("%s: Unblocking device access for examination\n", pci_name(pdev));
 	rc = zpci_reset_load_store_blocked(zdev);
 	if (rc) {


