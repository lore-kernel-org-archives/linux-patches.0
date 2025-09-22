Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 099E62F1FE3;
	Mon, 22 Sep 2025 19:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570285; cv=none; b=eL7j/K2dLK3Wy0WWv4RMGMsaAuAF3Y0d9nhE8oryNiJz0AqiltJ/Uq3tBDS6hc1Q/OEogCWGMzHQgRff6O5PHMOa9vtcyxxJlb7PIg0a3eKgvaXJ5QWwpJj1nE/xMS1Dsa+9AIl8Fe91W85OetwQhUe9TgOacbYbzZTwqVD+aLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570285; c=relaxed/simple;
	bh=Oej1X57aR5DqAwJ3atgr+cUaxl/d8S3pNfjZEMWTZVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JBU6+rL1a+/wqSvw5NTtH5WssEceLULhLlt82DXnmqYRQxW87mfKgzKB7jyLywPd6BeJEtBzPerH0u86TTmx1ZB7FiUjBDOaeEyQIWEtcz+EP/5+3IcZLi+b+9IsAppAkkwVPgyZVJOSymhDUXTLyIw27pUbtZz5gai5/T5KaTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nuXCDNMx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nuXCDNMx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 975DFC4CEF0;
	Mon, 22 Sep 2025 19:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570284;
	bh=Oej1X57aR5DqAwJ3atgr+cUaxl/d8S3pNfjZEMWTZVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nuXCDNMxQq5eUQWGTv7FHhkvnT0HiU25BPx6tOJCzheZA11k3XdJU25e+icuAGXFC
	 HWQEXbw90uQG43BflAcHPiWYMfagHJEXmlxpovfg974eD0NOtwUsIEsh2Cog9rdclr
	 Z614eyocQHKYdBPyVwTfmOBknC6yT8aTSGXuq5EY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cam Miller <cam@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Farhan Ali <alifm@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.16 081/149] iommu/s390: Fix memory corruption when using identity domain
Date: Mon, 22 Sep 2025 21:29:41 +0200
Message-ID: <20250922192414.925672937@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

From: Matthew Rosato <mjrosato@linux.ibm.com>

commit b3506e9bcc777ed6af2ab631c86a9990ed97b474 upstream.

zpci_get_iommu_ctrs() returns counter information to be reported as part
of device statistics; these counters are stored as part of the s390_domain.
The problem, however, is that the identity domain is not backed by an
s390_domain and so the conversion via to_s390_domain() yields a bad address
that is zero'd initially and read on-demand later via a sysfs read.
These counters aren't necessary for the identity domain; just return NULL
in this case.

This issue was discovered via KASAN with reports that look like:
BUG: KASAN: global-out-of-bounds in zpci_fmb_enable_device
when using the identity domain for a device on s390.

Cc: stable@vger.kernel.org
Fixes: 64af12c6ec3a ("iommu/s390: implement iommu passthrough via identity domain")
Reported-by: Cam Miller <cam@linux.ibm.com>
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
Tested-by: Cam Miller <cam@linux.ibm.com>
Reviewed-by: Farhan Ali <alifm@linux.ibm.com>
Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
Link: https://lore.kernel.org/r/20250827210828.274527-1-mjrosato@linux.ibm.com
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/s390-iommu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/iommu/s390-iommu.c
+++ b/drivers/iommu/s390-iommu.c
@@ -1031,7 +1031,8 @@ struct zpci_iommu_ctrs *zpci_get_iommu_c
 
 	lockdep_assert_held(&zdev->dom_lock);
 
-	if (zdev->s390_domain->type == IOMMU_DOMAIN_BLOCKED)
+	if (zdev->s390_domain->type == IOMMU_DOMAIN_BLOCKED ||
+	    zdev->s390_domain->type == IOMMU_DOMAIN_IDENTITY)
 		return NULL;
 
 	s390_domain = to_s390_domain(zdev->s390_domain);


