Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F0F2144C1;
	Wed,  7 May 2025 19:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644980; cv=none; b=lu8DcRjRL/mKQyqDgPIj+i871Xl6L7Vo0GmbSCifII2dfUvi1I4ZcYvGzsy6HqwfaLPbF6MWrQMUAs0ypXayaaLWWcvZz0LQYCJTWDjzd+lEVtDhDsv33pFVLmuklJIUJGfD+gqeQeIPLkOrVq+icfN0b4G9FEnVRtPtQAnewuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644980; c=relaxed/simple;
	bh=oDNjJuvu6YjoEFovsgagvFNihFzs8+xKSaV/Wv2Kle8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZYgTvrW5euVDgJYcJ02YZr/ICqKAWYI1RcOQVr9AFwZ58wZ4mGYRFAF0Xmf+wxG1CLQ5Dv2KFVl5RLMUDLlQE9i2L0p/35fUI/h0gp6pQfFUDCoot7hRFbbp8VJVHnc1h+vFQ8zc1y7LcCoFDwaZZZNWKQRty3+oRsMQDH4tqDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eccizeL4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eccizeL4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 019EDC4CEE2;
	Wed,  7 May 2025 19:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644980;
	bh=oDNjJuvu6YjoEFovsgagvFNihFzs8+xKSaV/Wv2Kle8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eccizeL4Y51mPgQ1aXxllaBUWpTMCq+lt8Rl/AkQPXgPsZeEjKZGenNaC+eRKx3Xc
	 NlEmMFWKPCe1cFTgRm91bEVRnJuW1k5ezTsFkLAEG3coyfFFaQmm36zxS1ju4HgKm2
	 ktjVA9qVbEX8quVx8j+oPp3HNNgSGRyvrQcTAmwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.6 026/129] platform/x86/amd: pmc: Require at least 2.5 seconds between HW sleep cycles
Date: Wed,  7 May 2025 20:39:22 +0200
Message-ID: <20250507183814.588838384@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit 9f5595d5f03fd4dc640607a71e89a1daa68fd19d upstream.

When an APU exits HW sleep with no active wake sources the Linux kernel will
rapidly assert that the APU can enter back into HW sleep. This happens in a
few ms. Contrasting this to Windows, Windows can take 10s of seconds to
enter back into the resiliency phase for Modern Standby.

For some situations this can be problematic because it can cause leakage
from VDDCR_SOC to VDD_MISC and force VDD_MISC outside of the electrical
design guide specifications. On some designs this will trip the over
voltage protection feature (OVP) of the voltage regulator module, but it
could cause APU damage as well.

To prevent this risk, add an explicit sleep call so that future attempts
to enter into HW sleep will have enough time to settle. This will occur
while the screen is dark and only on cases that the APU should enter HW
sleep again, so it shouldn't be noticeable to any user.

Cc: stable@vger.kernel.org
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Acked-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Link: https://lore.kernel.org/r/20250414162446.3853194-1-superm1@kernel.org
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/amd/pmc/pmc.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/platform/x86/amd/pmc/pmc.c
+++ b/drivers/platform/x86/amd/pmc/pmc.c
@@ -823,10 +823,9 @@ static void amd_pmc_s2idle_check(void)
 	struct smu_metrics table;
 	int rc;
 
-	/* CZN: Ensure that future s0i3 entry attempts at least 10ms passed */
-	if (pdev->cpu_id == AMD_CPU_ID_CZN && !get_metrics_table(pdev, &table) &&
-	    table.s0i3_last_entry_status)
-		usleep_range(10000, 20000);
+	/* Avoid triggering OVP */
+	if (!get_metrics_table(pdev, &table) && table.s0i3_last_entry_status)
+		msleep(2500);
 
 	/* Dump the IdleMask before we add to the STB */
 	amd_pmc_idlemask_read(pdev, pdev->dev, NULL);


