Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1F6217668;
	Mon, 23 Jun 2025 21:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750712854; cv=none; b=G9EieoPTMMPW29WgsvbcP0r3dnRyVcrk5m1Lamat00K21sWkHrFPLxvKRZyjr2XwDtpabEcLAOSmWozpCEPJg1plD8FiyyG6r+emEPGEA/Vbev2aOFzhbwwmFpFmG/FyLMnIken8ldo0WJP5m6ca2OdzUJgJKKVTSTL4g7Lf0So=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750712854; c=relaxed/simple;
	bh=9ni3iwJlcNxsd4O4TBj7FE2EO0rkmKS0rpsOGK/vwYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=teCOgLMq7bDjQEoWKHgfUVUCve1W5UBi6mr+NR/07zb7ct26y5ng8bIO4l7d1Z24p8Ylm58Vhvm+uBoMG003ttRpypjw4qPHpy1F4sH0JpYSVwMc3a43Hac0rfJRim1XVG6LebtN7D5fjLVU/osabIyCrjjnqP/xD91GtrAX9eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pSvhUYZr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pSvhUYZr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA7F0C4CEEA;
	Mon, 23 Jun 2025 21:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750712854;
	bh=9ni3iwJlcNxsd4O4TBj7FE2EO0rkmKS0rpsOGK/vwYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pSvhUYZrGVxGfGL/NOy/76T1tkiuzSCQ8YpfZgV4qfmZxh0zDU3Gtex1Mn05MxQ5C
	 rKD/Exr6vcSfxEFWecaktyfORJkTfIJGEcuFpWKtGsM37fVOB0uNLfSanb2XshdXDT
	 G1QHaRwdQvskALkPIRSYL2L6fpKIlz17D2s96YNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Julian Ruess <julianr@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.12 015/414] s390/pci: Remove redundant bus removal and disable from zpci_release_device()
Date: Mon, 23 Jun 2025 15:02:32 +0200
Message-ID: <20250623130642.408055923@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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
@@ -943,12 +943,6 @@ void zpci_release_device(struct kref *kr
 
 	WARN_ON(zdev->state != ZPCI_FN_STATE_RESERVED);
 
-	if (zdev->zbus->bus)
-		zpci_bus_remove_device(zdev, false);
-
-	if (zdev_enabled(zdev))
-		zpci_disable_device(zdev);
-
 	if (zdev->has_hp_slot)
 		zpci_exit_slot(zdev);
 


