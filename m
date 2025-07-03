Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D1302E62CD;
	Thu,  3 Jul 2025 14:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554315; cv=none; b=CWB5Y4eC98iyHFiK/a4k8YUvDdrPqajrBfI/R78Uuo+Wiw5TkH0JdNpw1A+xyMPzZWXOHIGXYbyEy6UaWuiD9UAbRcRn22AWkDj5l7k6GN9oQyLAx8nenNqyyoxFB2XJo9fGenxc+y1p8vi9GxpaiO11sHachjRwkqdwkq0sag8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554315; c=relaxed/simple;
	bh=QvgI1PLeXZpimtuek8/clhrGq8w4+r5gM27VVJYhWBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WCIbBRrBgBWbduuRVHJJF4HHLfxA1LIFIcxfhVCo5LdsJi5dImJObTxwGobcvmR9wDzcqafCL6TIMmbKjmEVX3njafGRQ51NfGIMz5sXz8I/GMAQGQFWatTw04ZvUre1Kw+1tpyJy8QMj64RL/FAbNmti6+8LD1dR3E99a6Q/V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RrBPKP05; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RrBPKP05"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CF5BC4CEE3;
	Thu,  3 Jul 2025 14:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554314;
	bh=QvgI1PLeXZpimtuek8/clhrGq8w4+r5gM27VVJYhWBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RrBPKP05opsOtFby3NOEt8pduDPA9BtZyFErESltWos03VEnSmgI3gyX/50+tpkZM
	 Hg7Zi7vfLGYvM+8qzWrGp4V3gTTYj2K5WiYzDp4wGErzp9Dq8nGo3jKF0evNIJRQaQ
	 Owa4dGzq4In8gbE6ANTYJrDFPKtTiGZ2FW26V7Tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	anvithdosapati <anvithdosapati@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.12 147/218] scsi: ufs: core: Fix clk scaling to be conditional in reset and restore
Date: Thu,  3 Jul 2025 16:41:35 +0200
Message-ID: <20250703144002.007473973@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -7743,7 +7743,8 @@ static int ufshcd_host_reset_and_restore
 	hba->silence_err_logs = false;
 
 	/* scale up clocks to max frequency before full reinitialization */
-	ufshcd_scale_clks(hba, ULONG_MAX, true);
+	if (ufshcd_is_clkscaling_supported(hba))
+		ufshcd_scale_clks(hba, ULONG_MAX, true);
 
 	err = ufshcd_hba_enable(hba);
 


