Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9866C14A60D;
	Tue,  8 Jul 2025 16:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992483; cv=none; b=TNi+njlQuGI8xM5L7uUshjzowyItPZX9dWVUmx86INgjXUgW63TPsv9ria2kIeipE4iCtisXcSnDGi4MXQinUGQbcRw1oHQzMeukO22+C07oAe/3r1pgyLNRb9NpcEm4Xt4f/nqVw2zOVvusXV/WCVlNPwkYrb/fpsQZSlmvkgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992483; c=relaxed/simple;
	bh=LHlvoroiG6GX8o5OjPzGR5DZ0RU/wtkqEIi7yU6MCgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jOd8tL9UbwVaKAm5Y9mGXOfyq369ZDbwhuUDEcm8TmYQD7cM9PDr5A44+9ug4EGtnbmiSdcmyT09W+2oA/f/Ma1GrD5ZDn8ObUR25eyRLiLcPkxaNv00LHbTsG4HcZLdIaxSmcgF2BqCK6OfMRUcLYfC49Z7UXgk1plTZNzfepc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fXobbMMx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fXobbMMx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14B0DC4CEED;
	Tue,  8 Jul 2025 16:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992483;
	bh=LHlvoroiG6GX8o5OjPzGR5DZ0RU/wtkqEIi7yU6MCgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fXobbMMxxBvvfhuHxwkGSA7EdyWvvdTclX8D/PCFMzbaRzO0Go6/N2F2sGRtk1KVs
	 fObgs0A2k8U3rE75pO20AnLyfebUZxLk0gfrsURioRY47qaIOGAVN8rxiMnB44Gj2h
	 hznrxq9Agb7hwLWTKZWOnroxf0auyS8yVq4pNYKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	anvithdosapati <anvithdosapati@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 079/132] scsi: ufs: core: Fix clk scaling to be conditional in reset and restore
Date: Tue,  8 Jul 2025 18:23:10 +0200
Message-ID: <20250708162232.944781312@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: anvithdosapati <anvithdosapati@google.com>

[ Upstream commit 2e083cd802294693a5414e4557a183dd7e442e71 ]

In ufshcd_host_reset_and_restore(), scale up clocks only when clock
scaling is supported. Without this change CPU latency is voted for 0
(ufshcd_pm_qos_update) during resume unconditionally.

Signed-off-by: anvithdosapati <anvithdosapati@google.com>
Link: https://lore.kernel.org/r/20250616085734.2133581-1-anvithdosapati@google.com
Fixes: a3cd5ec55f6c ("scsi: ufs: add load based scaling of UFS gear")
Cc: stable@vger.kernel.org
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index fa86942efd11f..da20bd3d46bc7 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7780,7 +7780,8 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
 	hba->silence_err_logs = false;
 
 	/* scale up clocks to max frequency before full reinitialization */
-	ufshcd_scale_clks(hba, ULONG_MAX, true);
+	if (ufshcd_is_clkscaling_supported(hba))
+		ufshcd_scale_clks(hba, ULONG_MAX, true);
 
 	err = ufshcd_hba_enable(hba);
 
-- 
2.39.5



