Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5CC9255E52;
	Mon, 12 May 2025 17:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072611; cv=none; b=GhI+hjASE27RpWRjFIiH8kHI8P3LZD8+7Qe++q3Adfqow12vTrnDknKgM+h9Xkh7Gy6JOJHpMuSQYprh1azcpqMx4YhllhEx660fcu+K+t23tQ2oZDnHkXkbwGyKzxUR0G2RA2orb/UkErspCXKyNTK5BBbHkcvSInx84KjfgeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072611; c=relaxed/simple;
	bh=o30JizzpIO9IGK2aMDeo4Ykl/N/8jrBsFw7MIW3YoxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EQx2LfuPRO/0J6tpD6HCn1qcY5vmxmJ3KSIduaJc4ahnDp2c7iRzOIArlUHLOFZbVbbw3i5d+pYBPOJiEkF1aMoRGFa4jTVUtAK/+PTHnoX/pAn1zamdSfo921YsP/Tp1tmoyOJFwsI7Ns8oGq4nE6HNEDjcB8Xq5t0Vr/ezQok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BrqfThhg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BrqfThhg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74D8EC4CEE7;
	Mon, 12 May 2025 17:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072610;
	bh=o30JizzpIO9IGK2aMDeo4Ykl/N/8jrBsFw7MIW3YoxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BrqfThhgpbi9Ji68axGInMAdzTQMtBTb23/0Gb9doDEVT5oRALlQWbZZDB3kc0c0H
	 CulgrVSDehT0X1GWljWid6pHJeuTDHRw7YlAQzPSXUGaHhw3DxU4uQJSpW+x1hXH90
	 GQC/atd7Yao7Hk1RsaUIptbYRoHwBttaKtChTj2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Andrei Kuchynski <akuchynski@chromium.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Benson Leung <bleung@chromium.org>
Subject: [PATCH 6.1 55/92] usb: typec: ucsi: displayport: Fix NULL pointer access
Date: Mon, 12 May 2025 19:45:30 +0200
Message-ID: <20250512172025.357586082@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172023.126467649@linuxfoundation.org>
References: <20250512172023.126467649@linuxfoundation.org>
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

From: Andrei Kuchynski <akuchynski@chromium.org>

commit 312d79669e71283d05c05cc49a1a31e59e3d9e0e upstream.

This patch ensures that the UCSI driver waits for all pending tasks in the
ucsi_displayport_work workqueue to finish executing before proceeding with
the partner removal.

Cc: stable <stable@kernel.org>
Fixes: af8622f6a585 ("usb: typec: ucsi: Support for DisplayPort alt mode")
Signed-off-by: Andrei Kuchynski <akuchynski@chromium.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Benson Leung <bleung@chromium.org>
Link: https://lore.kernel.org/r/20250424084429.3220757-3-akuchynski@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/displayport.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/typec/ucsi/displayport.c
+++ b/drivers/usb/typec/ucsi/displayport.c
@@ -296,6 +296,8 @@ void ucsi_displayport_remove_partner(str
 	if (!dp)
 		return;
 
+	cancel_work_sync(&dp->work);
+
 	dp->data.conf = 0;
 	dp->data.status = 0;
 	dp->initialized = false;


