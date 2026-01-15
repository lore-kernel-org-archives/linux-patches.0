Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D371B3BFE20;
	Thu, 15 Jan 2026 17:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499231; cv=none; b=rl5yR/2tsxNXnJfT1hWHK8rvJ7lVjoUdgou40TS74VRETZkdcHcn5m/6TV5Xn/bemhaL2APM1a2MocBXgcCEqK4NdHEDlOlqoAqToRPsb9AMnri3NC8RRidvUFsOPkc38Puq8CS5HJwp8Q6umSbA7r6ixvYcQb9YieAf7V7mhk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499231; c=relaxed/simple;
	bh=gPR8SqMGkvG2pmo+BUC2b6jsGblITIfHHkA/06niQDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e8UNxkfErEvTNbxhefLnaqIW1QAyOzKyr+Z+xmqU/xX34jclSoL2+3e8+W0cZ//61Rn6R2T5IirnBAkmMwVe9E32phnBrIzfNC2/4UNFs4CdGIWrTLf5QPJA0wsljt+DAl5T7iroToBw3YsRdeBs8J4hAJJMQ5lLP5cVSBMJcXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oUMKGZ+Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oUMKGZ+Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 607F2C116D0;
	Thu, 15 Jan 2026 17:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499231;
	bh=gPR8SqMGkvG2pmo+BUC2b6jsGblITIfHHkA/06niQDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oUMKGZ+ZzUW3CWLO5E9C6g6np947HJ3EWuA3irU1V9U6m5FylbNjrTKagJK0whZ/g
	 ONbtiNigg32okKogujDxuxhDMGdyzVDXRkcnsOdoZBe/kY1aqLxax5Hm+EFQrtt0MN
	 PaQmaoOJxnBRpq11RdRyxd2sxpD1jFGp6sAxoi8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Jamie Iles <quic_jiles@quicinc.com>
Subject: [PATCH 5.10 153/451] i3c: fix uninitialized variable use in i2c setup
Date: Thu, 15 Jan 2026 17:45:54 +0100
Message-ID: <20260115164236.448671789@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jamie Iles <quic_jiles@quicinc.com>

commit 6cbf8b38dfe3aabe330f2c356949bc4d6a1f034f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/master.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -2364,8 +2364,13 @@ static int i3c_master_i2c_adapter_init(s
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


