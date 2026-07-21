Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A750B395D8E;
	Tue, 21 Jul 2026 19:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660775; cv=none; b=b6kschyfJeolxjKi8fCmOG4rqvRefeDicFGpE6odUke94Cy0uSkBuX8yytQt9n+inAgqTeRyBDt15l+YImGi3v/P9hnDHmc7w2iVWaRUn2P/YOiYV7Lcwusqbb4v1GADqetMOm9D9pAePRUL6VX4EYQ9gw0DjHJgUcZVmwMDCuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660775; c=relaxed/simple;
	bh=U3LRxuwh8D9maQEuegat88IQC9YzRHm28BdRFkwnBg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JPgQUvbRYPlSCbFj9Bb7IIm4/aKTKkBgAQcT5S1PH1Awo8W3opkSwMz0NW6XRpxWKgfD7lFnCBTtRr7MyZ63FXakI/kYBrik0JmMK+E0WGXCGrpII09gKJZnTty1sC33ZiRfGMRGpx8MsPhQM9h7ML9G2PRrT4l1XqeDS2+ZBww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E3t02W7/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E3t02W7/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A26F1F000E9;
	Tue, 21 Jul 2026 19:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660774;
	bh=EVLiIH9pLUJeGUyWt3lltYJ4iYzIPrOJMxW3mbYJKfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E3t02W7/8B2kISyKOJB8R3LCyh/NjRfFimBa98qJsg+uvZsb3j1Hn8wdYeKoQIQZG
	 /IUhDYCsF/tfIuSamsCRDjCt1pzeA4kx7J21LGgCbbhPCthN9P+fSS/9HeUAj5MGd2
	 4ilpvLpRtNbmNZIdByihOldYI7EVlO3NHOnzzXWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1064/2077] i3c: master: Prevent reuse of dynamic address on device add failure
Date: Tue, 21 Jul 2026 17:12:17 +0200
Message-ID: <20260721152617.915719691@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit b3ba8383da4d0cff15810e32ea785eceb0a80813 ]

i3c_master_add_i3c_dev_locked() is called after a device has already
been assigned a dynamic address.  If the function fails, the address
remains marked as free and may be reallocated to another device,
leading to address conflicts on the bus.

Ensure the address is not marked as free on failure, by updating the
address slot state to prevent the address from being re-used.

Emit an error message to inform of the failure.

Opportunistically remove the !master check because it is impossible.

Note, directly resetting the device's dynamic address is no longer
an option, since Direct RSTDAA was deprecated from I3C starting from
version 1.1 and v1.1 (or later) target devices are meant to NACK it.

Fixes: 3a379bbcea0af ("i3c: Add core I3C infrastructure")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260612080107.11606-4-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index c9685379e86867..7952a38ebc3787 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -2324,12 +2324,11 @@ int i3c_master_add_i3c_dev_locked(struct i3c_master_controller *master,
 	bool enable_ibi = false;
 	int ret;
 
-	if (!master)
-		return -EINVAL;
-
 	newdev = i3c_master_alloc_i3c_dev(master, &info);
-	if (IS_ERR(newdev))
-		return PTR_ERR(newdev);
+	if (IS_ERR(newdev)) {
+		ret = PTR_ERR(newdev);
+		goto err_prevent_addr_reuse;
+	}
 
 	ret = i3c_master_attach_i3c_dev(master, newdev);
 	if (ret)
@@ -2451,6 +2450,16 @@ int i3c_master_add_i3c_dev_locked(struct i3c_master_controller *master,
 err_free_dev:
 	i3c_master_free_i3c_dev(newdev);
 
+err_prevent_addr_reuse:
+	/*
+	 * Although the device has not been added, the address has been
+	 * assigned. Prevent the address from being used again.
+	 */
+	if (i3c_bus_get_addr_slot_status(&master->bus, addr) == I3C_ADDR_SLOT_FREE)
+		i3c_bus_set_addr_slot_status(&master->bus, addr, I3C_ADDR_SLOT_I3C_DEV);
+
+	dev_err(&master->dev, "Failed to add I3C device at address %u, error %d\n", addr, ret);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(i3c_master_add_i3c_dev_locked);
-- 
2.53.0



