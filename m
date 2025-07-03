Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65FB12E7649;
	Thu,  3 Jul 2025 15:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555176; cv=none; b=cSZT6iBtMhEtTgw1j3sPGR2fnr4EHOgVYEuiiGn763GlHkOCjmRGXAyWSDCuN3rVVFigVt/LgUDRwyXdKNSt39d2/t1P02EaEG85Ci8DZyAnoc6YZCdw7XN0SaLo/BMYF8iVJF+kjIUF0eMiE0Apbsvir0Kt5XznV4Qp6DKXzL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555176; c=relaxed/simple;
	bh=ZA4FcLIILStwVDKsvYfjb2Z7r+IXLU5LN3Uxf42etM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bGRbmRqGZ32hweqnwI/+TqopaOdswkCNNQzcJRR9F4x3wpQ5ybVbDnJjDv4ReWii3LEGwJiwjV5ZjbaB4THjTykZa823tSaCcFo4MLLmTxyi+mflbPYazqBe/+swp5XGBNRWAJpGMBH6tpp8MaJc3kTPpCxnoIIq0OV9WVS2Epo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AkMmJ9TW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AkMmJ9TW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE0EC4CEEE;
	Thu,  3 Jul 2025 15:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555175;
	bh=ZA4FcLIILStwVDKsvYfjb2Z7r+IXLU5LN3Uxf42etM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AkMmJ9TWnrckM8iyl6v+rod3B4kaPmLfkx3urFHmXph6GVsN8awYZiojofFER1Lf0
	 UrXwz6cibubmKM3jY9pQ4eGjj3p3HuLSPGEl166zEuH6h1rsAq8V9If6gZa60bzvqz
	 sPdRhp9txoTqOhYXWpCeUa7dochQToVp84vRR0uM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	anvithdosapati <anvithdosapati@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.15 199/263] scsi: ufs: core: Fix clk scaling to be conditional in reset and restore
Date: Thu,  3 Jul 2025 16:41:59 +0200
Message-ID: <20250703144012.347327827@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: anvithdosapati <anvithdosapati@google.com>

commit 2e083cd802294693a5414e4557a183dd7e442e71 upstream.

In ufshcd_host_reset_and_restore(), scale up clocks only when clock
scaling is supported. Without this change CPU latency is voted for 0
(ufshcd_pm_qos_update) during resume unconditionally.

Signed-off-by: anvithdosapati <anvithdosapati@google.com>
Link: https://lore.kernel.org/r/20250616085734.2133581-1-anvithdosapati@google.com
Fixes: a3cd5ec55f6c ("scsi: ufs: add load based scaling of UFS gear")
Cc: stable@vger.kernel.org
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/core/ufshcd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7753,7 +7753,8 @@ static int ufshcd_host_reset_and_restore
 	hba->silence_err_logs = false;
 
 	/* scale up clocks to max frequency before full reinitialization */
-	ufshcd_scale_clks(hba, ULONG_MAX, true);
+	if (ufshcd_is_clkscaling_supported(hba))
+		ufshcd_scale_clks(hba, ULONG_MAX, true);
 
 	err = ufshcd_hba_enable(hba);
 


