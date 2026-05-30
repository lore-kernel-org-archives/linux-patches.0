Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D8A72E7379;
	Sat, 30 May 2026 17:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162813; cv=none; b=GG88i/ahLFKMi3e3HxJqDbg/vtsRF5EWG90xdEVSxnzosagBaOLdec/UkWnCQInL62AlPimKPRE8L1U2uSaEqXOxP7YZ7ioLjn0hxF62PCn9iFbR5qGKq0mTU09JFk1rAISGJPzspsiD2CYEfwaR6YbLoexT6g4v42csg/pd1b0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162813; c=relaxed/simple;
	bh=ob3I+h753WRpWvlvQplWuw4yJ5dcZLXauqepdmssAbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hv72AI/3Bq0hqS/9AKmyD6cOqtzNYKLEgaNXYBtdFBH/bfqa74vWnxbbmfNQjscu+2g62I+ms2CsNAdaTBwkXo7PeCches8R18Y0JHDA/Pv0Vdl2LxHzjq8qWfGlYWG8rqt2+kvLxr9MO8e/4vgeaPosnp8FQ2Hu6hC/WFcR3I4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kL3V+QYk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kL3V+QYk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FC521F00898;
	Sat, 30 May 2026 17:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162811;
	bh=pIinjg6STCPaemDyMCO9ferLnNEkGEENNtPtlMkYiEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kL3V+QYkEBtrJ8x1r51NDE8tXU6kmoe4HgaB/pmXzCY/CfaHu66vXGiUBtcZNwG3d
	 gOjZZdCekFOKh1dTS8MwiMaLzBpL5Ek1M6VjAXAnPHWci05KCVtDnm2QadoZtArqc1
	 Xy/XN2nw4BqmdajOLBGM7ksYC20AlchuxqLhV0PE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 041/776] i3c: fix uninitialized variable use in i2c setup
Date: Sat, 30 May 2026 17:55:55 +0200
Message-ID: <20260530160241.359570855@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jamie Iles <quic_jiles@quicinc.com>

[ Upstream commit 6cbf8b38dfe3aabe330f2c356949bc4d6a1f034f ]

Commit 31b9887c7258 ("i3c: remove i2c board info from i2c_dev_desc")
removed the boardinfo from i2c_dev_desc to decouple device enumeration from
setup but did not correctly lookup the i2c_dev_desc to store the new
device, instead dereferencing an uninitialized variable.

Lookup the device that has already been registered by address to store
the i2c client device.

Fixes: 31b9887c7258 ("i3c: remove i2c board info from i2c_dev_desc")
Reported-by: kernel test robot <lkp@intel.com>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Jamie Iles <quic_jiles@quicinc.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20220308134226.1042367-1-quic_jiles@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index dee694024f280..5df943d25cf0a 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -2199,8 +2199,13 @@ static int i3c_master_i2c_adapter_init(struct i3c_master_controller *master)
 	 * We silently ignore failures here. The bus should keep working
 	 * correctly even if one or more i2c devices are not registered.
 	 */
-	list_for_each_entry(i2cboardinfo, &master->boardinfo.i2c, node)
+	list_for_each_entry(i2cboardinfo, &master->boardinfo.i2c, node) {
+		i2cdev = i3c_master_find_i2c_dev_by_addr(master,
+							 i2cboardinfo->base.addr);
+		if (WARN_ON(!i2cdev))
+			continue;
 		i2cdev->dev = i2c_new_client_device(adap, &i2cboardinfo->base);
+	}
 
 	return 0;
 }
-- 
2.53.0



