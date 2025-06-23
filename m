Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77FD31E1A05;
	Mon, 23 Jun 2025 21:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715070; cv=none; b=cRwDgIzghtWPIr/PJo9Dk6oVeQO1SW2fUctFkfpu8d+H75zeKI0CJxc0sAPwWHSScCv0BbmbvZSkyKlnVsnC0asukuSu+mRn3JdNG/Lim/Y2PLVRn4jAgXpydX2gCCuHMYWZDudRNknfsootUTT8NaX+++H8x71EhRC9f1akMHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715070; c=relaxed/simple;
	bh=qgjwA4oJLSq0JjFPwZuHuiZCKLWeLqI3/+VZ7mZknHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fhd7cZM5DCVko6G4Pfep3j1Fi7q5SPY7yx5YYnJLHvgNhuux4YsPe+MGp1ZVCr2rxy3fMX7Wl5p0oRsjH/P9digVSN7kH3s3c3lnruDXn/V9uw6rVyiH/Rhd+aUXEZ5pmQ+5qdxaIwxmi4i9YJJZTDYJ62GrFPtrCmM7EuLvERU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a3djqo4X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a3djqo4X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 111B7C4CEEA;
	Mon, 23 Jun 2025 21:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715070;
	bh=qgjwA4oJLSq0JjFPwZuHuiZCKLWeLqI3/+VZ7mZknHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a3djqo4X0sVLbAkGM50Ipxu5WesiYhe2bqtfrffhq1pc5+p/1okX5apx/i3Vb6ILr
	 mcpNPKfSMw9fqmj+gwMTfbL3wVROUJgT5bY3kucUFH/f6A8j2KgHQuZKtJl8PcvlhF
	 QYoumnWSODtv5ESc2iaVVfqKb/P6z/eJWn74WoK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 435/592] platform/x86/amd: pmc: Clear metrics table at start of cycle
Date: Mon, 23 Jun 2025 15:06:33 +0200
Message-ID: <20250623130710.782955713@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 4dbd11796f3a8eb95647507befc41995458a4023 ]

The area of memory that contains the metrics table may contain garbage
when the cycle starts.  This normally doesn't matter because the cycle
itself will populate it with valid data, however commit 9f5595d5f03fd
("platform/x86/amd: pmc: Require at least 2.5 seconds between HW sleep
cycles") started to use it during the check() phase.  Depending upon
what garbage is in the table it's possible that the system will wait
2.5 seconds for even the first cycle, which will be visible to a user.

To prevent this from happening explicitly clear the table when logging
is started.

Fixes: 9f5595d5f03fd ("platform/x86/amd: pmc: Require at least 2.5 seconds between HW sleep cycles")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20250603132412.3555302-1-superm1@kernel.org
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmc/pmc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/platform/x86/amd/pmc/pmc.c b/drivers/platform/x86/amd/pmc/pmc.c
index 0329fafe14ebc..f45525bbd1549 100644
--- a/drivers/platform/x86/amd/pmc/pmc.c
+++ b/drivers/platform/x86/amd/pmc/pmc.c
@@ -157,6 +157,8 @@ static int amd_pmc_setup_smu_logging(struct amd_pmc_dev *dev)
 			return -ENOMEM;
 	}
 
+	memset_io(dev->smu_virt_addr, 0, sizeof(struct smu_metrics));
+
 	/* Start the logging */
 	amd_pmc_send_cmd(dev, 0, NULL, SMU_MSG_LOG_RESET, false);
 	amd_pmc_send_cmd(dev, 0, NULL, SMU_MSG_LOG_START, false);
-- 
2.39.5



