Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C672E11B9;
	Tue,  8 Jul 2025 16:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751991869; cv=none; b=mbwRhfK69dUYdKq1dlEHH4bLyzUbphJ1tuupwRBj+MogLkB4uPHfUS89WrrlgBQv+elCimmfc0KhYEO98738qsHJOcdvb8Da40VxGdfBnxI2hXV0BDsARjzrgmPGTS7NMcwU5frXzQfZuNbUJmrH1eyZBwXCKvXdL7EpNAlQx6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751991869; c=relaxed/simple;
	bh=XMw1SINHR1gLnwzgtRdnP3HFNvHNLeMMDBYkVJyv6c4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bariajgTdcYgGles4U4opXBxELOg2Y2Br86114KOA6lFJRKLhKu8yCAQHuecCFzj68XI7hZq2djTX1NkNQNL8Ql+yDtn2qQoTwvr7wrwfiYBu6ud/9f49c74X/dyy8/R+yqVFFSrinlZa5jTIQFfXT4WVnACr7YcOblil79IrBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TEW3OGoV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TEW3OGoV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB582C4CEED;
	Tue,  8 Jul 2025 16:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751991869;
	bh=XMw1SINHR1gLnwzgtRdnP3HFNvHNLeMMDBYkVJyv6c4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TEW3OGoVM1Xn9M53h3YeMJNu5QUMF445Vx/VWpF4SfYt15qwdU84nMg2G0Zyu/zjl
	 zrztUhQuycyk1lU3chyGNJ8fbI1b5zHQCyuLkyKk7hpDNjuo6syQVB/roy547QEh6e
	 80vsyiaZyx41StaudusAAPMgj0+bHkdspBBsAlos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhan Ali <alifm@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 6.1 02/81] s390/pci: Do not try re-enabling load/store if device is disabled
Date: Tue,  8 Jul 2025 18:22:54 +0200
Message-ID: <20250708162224.901528639@linuxfoundation.org>
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


