Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E88F4D598B;
	Fri,  9 Oct 2026 14:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556952; cv=none; b=iLRMZgLPmsuk4Kb3BYmVM8Oj32B7524p65PA8UN06C+w7OuB9mJBW34qsr0IitnrQddSLiznGGqsJE51bfntTIAjbl6GvMXMlcIoEGSoLOIRp3+7bdkjbJt9TRU1Rt1VFuqno+vUV4hTdMnXH4TXdJJhn71gUvspOqgMLuytD/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556952; c=relaxed/simple;
	bh=6LoMXAL15bX1zGnKMBEOKVYtbqrrCLeyu6Fp5hRnEZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eZnkGfaJBXDHC6D9naQDBto4gZtam7m13x9NVs78pRFvQhi5E3CoZMj/rdIxzrobc+EZ94MnGJ6OyLaF2uuU79MgHtU6hV05FwuwVjAhx02aqXoHK5u4nXjQPghGLSP4A3Wk41k4ag7EErkSMm6gDS+IK8iaBYoXgQcxU3sLD54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B33U0pXd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B33U0pXd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 616981F000FF;
	Fri,  9 Oct 2026 14:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556950;
	bh=YlleUV+9C88HaMD0gNixAnTGACiMw12f0JBCjEJ4ckU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B33U0pXdH8cTZrZ0gZ6XoG/DCzVB6mGzFEQXCHW7aePsfnO+7niASwpONoYgP1RsV
	 3ol/iKh3OrZqZ+vLAIEFbnVrn9lJl06+ok2XMCBBfgpU5sN0Y9DP/hUnJjHLW5fc82
	 /KAqwj/MTNDi7WOSDAsNs8wMbjdgGDzzExNbYLqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 7.2 224/428] usb: chipidea: tegra: disable runtime PM on resume failure
Date: Fri,  9 Oct 2026 16:09:21 +0200
Message-ID: <20261009140951.037862211@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

commit f1d6f7d25fe88ee49aaad96c8649e090fc3a4b68 upstream.

tegra_usb_probe() enables runtime PM before resuming the device. If
pm_runtime_resume_and_get() fails, probe returns without disabling runtime
PM. The later error paths reach pm_runtime_force_suspend(), but this early
return bypasses that cleanup.

Disable runtime PM before returning the resume error. Do not use the
fail_power_off path: the failed resume did not retain a usage reference,
so its pm_runtime_put_sync_suspend() would be unbalanced.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: 8b85e11c1a7a ("usb: chipidea: tegra: Add runtime PM and OPP support")
Cc: stable <stable@kernel.org>
Assisted-by: OpenAI:GPT-5.6
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Acked-by: Peter Chen <peter.chen@kernel.org>
Link: https://patch.msgid.link/20260913041033.25144-1-mhun512@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/chipidea/ci_hdrc_tegra.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/chipidea/ci_hdrc_tegra.c
+++ b/drivers/usb/chipidea/ci_hdrc_tegra.c
@@ -306,8 +306,10 @@ static int tegra_usb_probe(struct platfo
 
 	pm_runtime_enable(&pdev->dev);
 	err = pm_runtime_resume_and_get(&pdev->dev);
-	if (err)
+	if (err) {
+		pm_runtime_disable(&pdev->dev);
 		return err;
+	}
 
 	if (device_property_present(&pdev->dev, "nvidia,needs-double-reset"))
 		usb->needs_double_reset = true;


