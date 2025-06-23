Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09EDF225413;
	Mon, 23 Jun 2025 21:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715130; cv=none; b=ICZjoBc2nvqjz+F81CGAed1EauF4dlOykc7Mgpc0RH62d8Cp1B1Jm8hlT3N5AEVBPMr8V5GmW9HlGuTPA8Grvuo7JnNKpIkUyWynjU7m/M6ZUn92hsLfGKWjXk2x9LvGuBryfly+M285Y0eXBNdvT3oaTFEwDRVKrxgxPvLb8as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715130; c=relaxed/simple;
	bh=X84Pgj3Pwt/WXmui1+yB6oiB+j05Hl6w/UdYtbtdyV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lovU0sok8mTt1sfhASQST/rdFKv71x3h6uacEd2Z59Gnj2Afjb8iLxZw1vyOeVUaY+O8vqdMBtdpe9VQ0YCFtbj55gFTnhfRfftJ7AFqRfmpA4g2JJIi5Lzwo54oiJ8o1l15kgArUkgYOUImiGgD3XUMGAfh18cKqAu3/Y+Mg3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tnTfm19W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tnTfm19W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96BC4C4CEF0;
	Mon, 23 Jun 2025 21:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715129;
	bh=X84Pgj3Pwt/WXmui1+yB6oiB+j05Hl6w/UdYtbtdyV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tnTfm19W+0GgMe8E8w6jmgZfNkKD2BVtpc/5tnaXr4s4dgTH+1me0f/muK6Evx9CO
	 HjqYs03apJ2ycj3OZvtvvOiXeyJrFJIuolLJYsT1pOkXWqv2ZVV16923HeRTbsC+hr
	 Cti3qm8dmMK/qnI2u6rE4qb3cQHVS+4ymyZ1DyDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 201/290] platform/x86/amd: pmc: Clear metrics table at start of cycle
Date: Mon, 23 Jun 2025 15:07:42 +0200
Message-ID: <20250623130632.980392672@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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
index 946a546cd9dd0..af5cc8aa7988c 100644
--- a/drivers/platform/x86/amd/pmc/pmc.c
+++ b/drivers/platform/x86/amd/pmc/pmc.c
@@ -332,6 +332,8 @@ static int amd_pmc_setup_smu_logging(struct amd_pmc_dev *dev)
 			return -ENOMEM;
 	}
 
+	memset_io(dev->smu_virt_addr, 0, sizeof(struct smu_metrics));
+
 	/* Start the logging */
 	amd_pmc_send_cmd(dev, 0, NULL, SMU_MSG_LOG_RESET, false);
 	amd_pmc_send_cmd(dev, 0, NULL, SMU_MSG_LOG_START, false);
-- 
2.39.5



