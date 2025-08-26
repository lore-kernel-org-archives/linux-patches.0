Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0685E2FE069;
	Tue, 26 Aug 2025 11:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207155; cv=none; b=PFfXfI6tA9KpIlZWSk07tPFBD+8U0Pb3GK5V8e/0uxw1RYrvxozTjxO5ehGteAQ6zNi5SRmLn9EcyxvOpbok7n7LUTR1a+vfrimtWCGmi/agyHsScVKZpumAI1Ilq23pfnB2QlHC3n/tp241z8RgQ3IHTk8g69RyAR6NDzBjBOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207155; c=relaxed/simple;
	bh=BtYM3Yi7qT76p4NGaC5BLoLWJvGvVHpBcpNevKLEB2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C+O5S0+9Vb1XafAi0N3sMpO2C4HWa+U5hY2P5XkEA/gC/pTwKIfg/dcuf5HbUGdTVN1h/aIXDmpU3rywA6VsB1voAtT8QwR0PeDUIn67UV4kr51T6nTbG1KFY+YiVmPdXDaA6N/WTAcmsfloQl2rvgp5xpcTUS4l2/1jGNwU5os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZKfSBDbX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZKfSBDbX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AFAFC4CEF1;
	Tue, 26 Aug 2025 11:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207154;
	bh=BtYM3Yi7qT76p4NGaC5BLoLWJvGvVHpBcpNevKLEB2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZKfSBDbX16dS+xwlt2fDPe+CzzK8tyowtX+A6KkHxXx+3TXK7uwO0WtgEibCdQj26
	 Jix5mg7g1cycLct15bYTAl4T1MVmGCe13+BI7Ycccl+DiAEsCWW/RZgFjq7Fhhnm5E
	 eyKcfPcgvuRrMWJecOttPSLoZcXTfPcXYSqgXI1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.16 071/457] scsi: ufs: ufs-pci: Fix default runtime and system PM levels
Date: Tue, 26 Aug 2025 13:05:55 +0200
Message-ID: <20250826110939.126534925@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

commit 6de7435e6b81fe52c0ab4c7e181f6b5decd18eb1 upstream.

Intel MTL-like host controllers support auto-hibernate.  Using
auto-hibernate with manual (driver initiated) hibernate produces more
complex operation.  For example, the host controller will have to exit
auto-hibernate simply to allow the driver to enter hibernate state
manually.  That is not recommended.

The default rpm_lvl and spm_lvl is 3, which includes manual hibernate.

Change the default values to 2, which does not.

Note, to be simpler to backport to stable kernels, utilize the UFS PCI
driver's ->late_init() call back.  Recent commits have made it possible
to set up a controller-specific default in the regular ->init() call
back, but not all stable kernels have those changes.

Fixes: 4049f7acef3e ("scsi: ufs: ufs-pci: Add support for Intel MTL")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20250723165856.145750-3-adrian.hunter@intel.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/host/ufshcd-pci.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/drivers/ufs/host/ufshcd-pci.c
+++ b/drivers/ufs/host/ufshcd-pci.c
@@ -468,10 +468,23 @@ static int ufs_intel_adl_init(struct ufs
 	return ufs_intel_common_init(hba);
 }
 
+static void ufs_intel_mtl_late_init(struct ufs_hba *hba)
+{
+	hba->rpm_lvl = UFS_PM_LVL_2;
+	hba->spm_lvl = UFS_PM_LVL_2;
+}
+
 static int ufs_intel_mtl_init(struct ufs_hba *hba)
 {
+	struct ufs_host *ufs_host;
+	int err;
+
 	hba->caps |= UFSHCD_CAP_CRYPTO | UFSHCD_CAP_WB_EN;
-	return ufs_intel_common_init(hba);
+	err = ufs_intel_common_init(hba);
+	/* Get variant after it is set in ufs_intel_common_init() */
+	ufs_host = ufshcd_get_variant(hba);
+	ufs_host->late_init = ufs_intel_mtl_late_init;
+	return err;
 }
 
 static int ufs_qemu_get_hba_mac(struct ufs_hba *hba)


