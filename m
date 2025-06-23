Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861CF1F1522;
	Mon, 23 Jun 2025 13:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684320; cv=none; b=lJGtkL+YSA36UNNIsFkSu1+3roU6S4GWWUFvNNkvBH596+eFu675M6mt6KKZsMPcL2/qIIugo4VpvJAbvhvyYC6L3bkI7Rl3k5TghYhMw/1Blx3HkEax8Zg7940vxugxZADvkC2lbQ+Ow9vtmiCse78KizXK0X4bP4UROsQnP6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684320; c=relaxed/simple;
	bh=/eqF367tx8ZjLiTBvfPMINkku3CiJClieBMXLee8UvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d5VknctFUdvD1EwGTBkhGT3YD/+SVPtZzeAgkPZuQsz3xw7xs4L73FQQWuPxqO4l1ENKYLbMgr0hkNEguoCWryR546nSC3galaJFQE1awqX7cPyzH1eIz7x6hhZcwlGsSTXOpMkni+sA0/M1v1anXdWjA5Pkp+vbUpjRLoWqmoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aS97rzYz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aS97rzYz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3BB5C4CEEA;
	Mon, 23 Jun 2025 13:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684320;
	bh=/eqF367tx8ZjLiTBvfPMINkku3CiJClieBMXLee8UvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aS97rzYzXRJZUer3nKVMxODTtmm4TfKIjKUks0lOOIBzuS+zvHhp/fVQ26hFf+5A5
	 AA4vXYkK9P9HKIugbZNcMtFslgWrfGTWUfgfU5Qj+oVjCmjrZkRRdSAs7R9mciDRF/
	 opOPXIM6f/IGt+b0KGrodOf8VyUXC4adyprxe2/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Julian Ruess <julianr@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.15 023/592] s390/pci: Remove redundant bus removal and disable from zpci_release_device()
Date: Mon, 23 Jun 2025 14:59:41 +0200
Message-ID: <20250623130700.785540845@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

commit d76f9633296785343d45f85199f4138cb724b6d2 upstream.

Remove zpci_bus_remove_device() and zpci_disable_device() calls from
zpci_release_device(). These calls were done when the device
transitioned into the ZPCI_FN_STATE_STANDBY state which is guaranteed to
happen before it enters the ZPCI_FN_STATE_RESERVED state. When
zpci_release_device() is called the device is known to be in the
ZPCI_FN_STATE_RESERVED state which is also checked by a WARN_ON().

Cc: stable@vger.kernel.org
Fixes: a46044a92add ("s390/pci: fix zpci_zdev_put() on reserve")
Reviewed-by: Gerd Bayer <gbayer@linux.ibm.com>
Reviewed-by: Julian Ruess <julianr@linux.ibm.com>
Tested-by: Gerd Bayer <gbayer@linux.ibm.com>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/pci/pci.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -949,12 +949,6 @@ void zpci_release_device(struct kref *kr
 
 	WARN_ON(zdev->state != ZPCI_FN_STATE_RESERVED);
 
-	if (zdev->zbus->bus)
-		zpci_bus_remove_device(zdev, false);
-
-	if (zdev_enabled(zdev))
-		zpci_disable_device(zdev);
-
 	if (zdev->has_hp_slot)
 		zpci_exit_slot(zdev);
 


