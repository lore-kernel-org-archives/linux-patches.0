Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BAB6267722;
	Tue, 25 Mar 2025 12:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905833; cv=none; b=m4Sx9ALi4xT7O5DUKK+RsLTUC+fq4JEOw2noywoSQ2ybbynSPLHt7WmtOQc3HDm1pbAXtj7xAqpoP0rxEFRTRCcpyzBIhMHRBv7Jp/2i4oeDBb6W7lnAGizr7GblLQj39QywlCcu3xdijzZbILgpxz5WLIHr1XVi4/xMY+gmhTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905833; c=relaxed/simple;
	bh=NYZQAmNNLgu1b6AUqEa9C1TbNIIkZOERHObZYwY/X5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fmtKlX+HWhn1fZLZj3OBNZeokovkqiLJysNuo6nyWQOd2u47NGgCO6BdgVWoa/NMy09DvbOC/v14uPESCBQUgMKUU3HItBhkAJERzMpJse+7p1bevL8cWDlDh6ya4w2DDTlQuS8IK8g8MxHhW6sVOFXksW6EiWflCe3XOxg4Bq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ap/V5rL2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ap/V5rL2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23296C4CEED;
	Tue, 25 Mar 2025 12:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905833;
	bh=NYZQAmNNLgu1b6AUqEa9C1TbNIIkZOERHObZYwY/X5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ap/V5rL2CFp/n/NbnDhBJjUZvPTS3x/zBdr9NDExLmBKkpDNo6KnbvhdVfMEuqMHH
	 VYtKPvSLAyrf34D7uiiIQLE2DwPaS/MqWjFbSVSmQ1vy47Y++KMuOLmR4YsGfVmpQE
	 Dy/FL9c5pFZ+6UJUkCMLGVQvuCfMEJMbT3c3dViE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <frank.li@nxp.com>,
	Haibo Chen <haibo.chen@nxp.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.1 171/198] can: flexcan: disable transceiver during system PM
Date: Tue, 25 Mar 2025 08:22:13 -0400
Message-ID: <20250325122201.133060949@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

From: Haibo Chen <haibo.chen@nxp.com>

commit 5a19143124be42900b3fbc9ada3c919632eb45eb upstream.

During system PM, if no wakeup requirement, disable transceiver to
save power.

Fixes: 4de349e786a3 ("can: flexcan: fix resume function")
Cc: stable@vger.kernel.org
Reviewed-by: Frank Li <frank.li@nxp.com>
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Link: https://patch.msgid.link/20250314110145.899179-2-haibo.chen@nxp.com
[mkl: add newlines]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/flexcan/flexcan-core.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/net/can/flexcan/flexcan-core.c
+++ b/drivers/net/can/flexcan/flexcan-core.c
@@ -2230,6 +2230,10 @@ static int __maybe_unused flexcan_suspen
 
 			flexcan_chip_interrupts_disable(dev);
 
+			err = flexcan_transceiver_disable(priv);
+			if (err)
+				return err;
+
 			err = pinctrl_pm_select_sleep_state(device);
 			if (err)
 				return err;
@@ -2262,10 +2266,16 @@ static int __maybe_unused flexcan_resume
 			if (err)
 				return err;
 
-			err = flexcan_chip_start(dev);
+			err = flexcan_transceiver_enable(priv);
 			if (err)
 				return err;
 
+			err = flexcan_chip_start(dev);
+			if (err) {
+				flexcan_transceiver_disable(priv);
+				return err;
+			}
+
 			flexcan_chip_interrupts_enable(dev);
 		}
 


