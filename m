Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCCF81C291
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nw8hcZFz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51A29C433C7;
	Wed,  4 Oct 2023 18:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444540;
	bh=pXrIHvEMJ8ovsyyoMwAzTAfHfJVw/FP4egT1nmcqZdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nw8hcZFz0uaNCqQhd69e3OLAokH5z8U4LQLsEkVM0b63zrd7SNiEVKtvtJOMb9zJf
	 vXwwz678uwpUWQIqeRWilDAAF3YZEIh7qMj1p6O8Ah+DtwtJOzoYs64DhcVDXssVte
	 l/U0XZlOrWoPTn81ZTl+PcNQ9aOG5YHztYZD/IKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>,
	Robert Richter <rrichter@amd.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 6.5 287/321] cxl/pci: Fix appropriate checking for _OSC while handling CXL RAS registers
Date: Wed,  4 Oct 2023 19:57:12 +0200
Message-ID: <20231004175242.566252356@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>

commit 0339dc39a521ead3dbcf101acd8c028c61db57dc upstream.

cxl_pci fails to unmask CXL protocol errors when CXL memory error reporting
is not granted native control. Given that CXL memory error reporting uses
the event interface and protocol errors use AER, unmask protocol errors
based only on the native AER setting. Without this change end user
deployments will fail to report protocol errors in the case where native
memory error handling is not granted to Linux.

Also, return zero instead of an error code to not block the communication
with the cxl device when in native memory error reporting mode.

Fixes: 248529edc86f ("cxl: add RAS status unmasking for CXL")
Cc: <stable@vger.kernel.org>
Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
Reviewed-by: Robert Richter <rrichter@amd.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/20230823234305.27333-2-Smita.KoralahalliChannabasappa@amd.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cxl/pci.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index 1cb1494c28fe..2323169b6e5f 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -541,9 +541,9 @@ static int cxl_pci_ras_unmask(struct pci_dev *pdev)
 		return 0;
 	}
 
-	/* BIOS has CXL error control */
-	if (!host_bridge->native_cxl_error)
-		return -ENXIO;
+	/* BIOS has PCIe AER error control */
+	if (!host_bridge->native_aer)
+		return 0;
 
 	rc = pcie_capability_read_word(pdev, PCI_EXP_DEVCTL, &cap);
 	if (rc)
-- 
2.42.0



