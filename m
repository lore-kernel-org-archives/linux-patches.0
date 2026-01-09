Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88C935BDD8;
	Fri,  9 Jan 2026 12:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962966; cv=none; b=raOQlRN88dXixjyP4TxpQy4cXiHoCjXG4XUdlWQjAxp/zZ24gH9KOkhvGTlEHNV5V1/MdO1D7VGS01jOgyUeOQhuipASAndeEAmyrLUWwXkvOJl4yC9ZCFQfwDUmwPaWGqNELYYAbR0nwd87DBegTwf9t6w6xPDjnOI4PR8LlkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962966; c=relaxed/simple;
	bh=7FFJVKUacC6QCpcjPyyJhCShU1RlSJFNnK7ssimBJSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nbakh9vVob7nBjzkAHnuCLRK9Ug82HLZG89sw+WPZd78+ExQqAS/jPzj9+e7FAUROwEQPtjLMVGZo3QIfS5bHjTasNKEoi35wEfM0Jg8RRF+Ut9MymUoaQ8oYyOd1EtyEGux3Ar4NBMJbr71mRR9TAvzJ9aS79VZKjFfuTUNyrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UzQbrurj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UzQbrurj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1346DC4CEF1;
	Fri,  9 Jan 2026 12:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962966;
	bh=7FFJVKUacC6QCpcjPyyJhCShU1RlSJFNnK7ssimBJSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UzQbrurj/D+/ivoqKaavRo2uhrhR273iE5EQejsGyfcziItSWooTJBa6l8D7wwXTq
	 MRfvK1HTtU5uu2cqAAMBsxtzX74zVamgeTJE2ULdpQ/hsILO9T9SinsnG40ihnvci3
	 Gg6Uj3BqtV5P0JnaQ8nGUw8aKcwaIk8Rq6HNb3As=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seunghwan Baek <sh8267.baek@samsung.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 550/634] scsi: ufs: core: Add ufshcd_update_evt_hist() for UFS suspend error
Date: Fri,  9 Jan 2026 12:43:48 +0100
Message-ID: <20260109112138.287717961@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Seunghwan Baek <sh8267.baek@samsung.com>

[ Upstream commit c9f36f04a8a2725172cdf2b5e32363e4addcb14c ]

If UFS resume fails, the event history is updated in ufshcd_resume(), but
there is no code anywhere to record UFS suspend. Therefore, add code to
record UFS suspend error event history.

Fixes: dd11376b9f1b ("scsi: ufs: Split the drivers/scsi/ufs directory")
Cc: stable@vger.kernel.org
Signed-off-by: Seunghwan Baek <sh8267.baek@samsung.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Link: https://patch.msgid.link/20251210063854.1483899-2-sh8267.baek@samsung.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/core/ufshcd.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9437,7 +9437,7 @@ static int ufshcd_suspend(struct ufs_hba
 	ret = ufshcd_setup_clocks(hba, false);
 	if (ret) {
 		ufshcd_enable_irq(hba);
-		return ret;
+		goto out;
 	}
 	if (ufshcd_is_clkgating_allowed(hba)) {
 		hba->clk_gating.state = CLKS_OFF;
@@ -9448,6 +9448,9 @@ static int ufshcd_suspend(struct ufs_hba
 	ufshcd_vreg_set_lpm(hba);
 	/* Put the host controller in low power mode if possible */
 	ufshcd_hba_vreg_set_lpm(hba);
+out:
+	if (ret)
+		ufshcd_update_evt_hist(hba, UFS_EVT_SUSPEND_ERR, (u32)ret);
 	return ret;
 }
 


