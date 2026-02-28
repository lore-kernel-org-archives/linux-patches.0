Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A5547CC8B;
	Sat, 28 Feb 2026 17:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301366; cv=none; b=a8zparBrLIYhU/nj2eaAKsY+bVqhJq03XCFuErysUOvRviuomQ5e8zL3cGTslf4r+wevGuhIxD+AKqsHgx6kcODrxWyXmfm3OWfvlmGumTWz0fyl6aSjm0HNJDnCaDpIH0jMX2noHa1OyDWbkqjh8wCPbZiIHi3/dNJWnMYJOOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301366; c=relaxed/simple;
	bh=Nnv0BEn2zidd7BE8aeB9Ogq/hpoXHcXx6lXHWMMM+aM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rWEWcfgUw6hvMIygGXeTGNybBBSIRzfveKUkRgt71YK+R8V5Y+sVV45ek11K0yEWyv3eVxdIeC+QVDP1hD1XBS9e6p+FQUZBGUzxVeLu90XkALs4nHaTIzHrHl0lhHF1j6FnJqXLb2x/IRk+pSa8FQUkeqF8uYdGd1W317LPV4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ezdGekbl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ezdGekbl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 032C1C19424;
	Sat, 28 Feb 2026 17:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301366;
	bh=Nnv0BEn2zidd7BE8aeB9Ogq/hpoXHcXx6lXHWMMM+aM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ezdGekblRA5w9QMy40thiw/7MGZETWCVuYLSmJlqQhNnTP1zTU1XJKoqljuspdjwY
	 u63cmg1tju6qfXY4pCQbB0PdjZ2ay358Zgs1RpOvaMN3Hq3pxzjLWpbMemJ/YOBwZH
	 dhFOHANsbJlETKFLV++mZCCWB/5mA9SDpvF0Z2ZX5fRL2mFk3izdNZud0XtgIogalp
	 uqsGqjsWycgAQk+V5Es/dbLjRZR08/A7MktSrPJ7XsOXb5IbNrpZWgOT7yV656GO0e
	 HRYzfIjpYiSEXOMNzD+WMLY9GZaxDwM9kawJTVCd+ZqTdtTAnt3tzg43EocwHyboPt
	 NrAqWAmYtS0Tw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Niklas Schnelle <schnelle@linux.ibm.com>,
	stable@vger.kernel.org,
	Benjamin Block <bblock@linux.ibm.com>,
	Farhan Ali <alifm@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 555/752] s390/pci: Handle futile config accesses of disabled devices directly
Date: Sat, 28 Feb 2026 12:44:26 -0500
Message-ID: <20260228174750.1542406-555-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Niklas Schnelle <schnelle@linux.ibm.com>

[ Upstream commit 84d875e69818bed600edccb09be4a64b84a34a54 ]

On s390 PCI busses and slots with multiple functions may have holes
because PCI functions are passed-through by the hypervisor on a per
function basis and some functions may be in standby or reserved. This
fact is indicated by returning true from the
hypervisor_isolated_pci_functions() helper and triggers common code to
scan all possible devfn values. Via pci_scan_single_device() this in
turn causes config reads for the device and vendor IDs, even for PCI
functions which are in standby and thereofore disabled.

So far these futile config reads, as well as potentially writes, which
can never succeed were handled by the PCI load/store instructions
themselves. This works as the platform just returns an error for
a disabled and thus not usable function handle. It does cause spamming
of error logs and additional overhead though.

Instead check if the used function handle is enabled in zpci_cfg_load()
and zpci_cfg_write() and if not enable directly return -ENODEV. Also
refactor zpci_cfg_load() and zpci_cfg_store() slightly to accommodate
the new logic while meeting modern kernel style guidelines.

Cc: stable@vger.kernel.org
Fixes: a50297cf8235 ("s390/pci: separate zbus creation from scanning")
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Reviewed-by: Farhan Ali <alifm@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/pci/pci.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index c82c577db2bcd..c541019d91356 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -232,24 +232,33 @@ int zpci_fmb_disable_device(struct zpci_dev *zdev)
 static int zpci_cfg_load(struct zpci_dev *zdev, int offset, u32 *val, u8 len)
 {
 	u64 req = ZPCI_CREATE_REQ(zdev->fh, ZPCI_PCIAS_CFGSPC, len);
+	int rc = -ENODEV;
 	u64 data;
-	int rc;
+
+	if (!zdev_enabled(zdev))
+		goto out_err;
 
 	rc = __zpci_load(&data, req, offset);
-	if (!rc) {
-		data = le64_to_cpu((__force __le64) data);
-		data >>= (8 - len) * 8;
-		*val = (u32) data;
-	} else
-		*val = 0xffffffff;
+	if (rc)
+		goto out_err;
+	data = le64_to_cpu((__force __le64)data);
+	data >>= (8 - len) * 8;
+	*val = (u32)data;
+	return 0;
+
+out_err:
+	PCI_SET_ERROR_RESPONSE(val);
 	return rc;
 }
 
 static int zpci_cfg_store(struct zpci_dev *zdev, int offset, u32 val, u8 len)
 {
 	u64 req = ZPCI_CREATE_REQ(zdev->fh, ZPCI_PCIAS_CFGSPC, len);
+	int rc = -ENODEV;
 	u64 data = val;
-	int rc;
+
+	if (!zdev_enabled(zdev))
+		return rc;
 
 	data <<= (8 - len) * 8;
 	data = (__force u64) cpu_to_le64(data);
-- 
2.51.0

