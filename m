Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D862139B2;
	Thu, 12 Dec 2024 15:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016017; cv=none; b=EljyeOEKHgRQY4t4p+7gMz76s6MZHKO6Ynlw5CqT/w03154G6sL8LtKFX+GTjr5Hi64vRgGPR8Ci5AzJNSTDaMTI8F4rdYrImcucEG8Hb/sFBXt9LPry83du4Y+dYV2pFRl9g/ZHFofHVXcUmi4tZASLbVCsIaZwvthY9NYJBH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016017; c=relaxed/simple;
	bh=m//KzxoVHbm6kcz+63yoo9sevjYvxxDf6pAxNBgAdIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JFnK6G+lYAJciTvjez89rvUp0zDixkEPTq3efkCFPbO8drXhbSw5MSS7Dn5sxuT8ZVBwSK8NfluUyTghonQri6/kkIpxlWbF243/37A3XiBytM2YNz8ehyaWaAaNzPhgybzNyIOtnMzAWgIhmfDF3vdkRdxcKmNfXu4CQaFnvuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DrpMZ/XO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DrpMZ/XO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB106C4CECE;
	Thu, 12 Dec 2024 15:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016017;
	bh=m//KzxoVHbm6kcz+63yoo9sevjYvxxDf6pAxNBgAdIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DrpMZ/XOGQx5ioA3/2BXF3yyjgIV18TEzTcVpAHcNWQ7LshsK84jPml5wCejt8v+c
	 F7UWlmxuoky4uek6BdDX16CjzKyKaSZWKIZ9E4Dn33n5x+EtoiD5HRAHuydO8ZJsHl
	 Byiu6GgUuFTcW53AXJR3fI9gdPsZg6RMsKJuR49E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Garry <john.g.garry@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 109/466] scsi: scsi_debug: Fix hrtimer support for ndelay
Date: Thu, 12 Dec 2024 15:54:38 +0100
Message-ID: <20241212144311.124282866@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: John Garry <john.g.garry@oracle.com>

[ Upstream commit 6918141d815acef056a0d10e966a027d869a922d ]

Since commit 771f712ba5b0 ("scsi: scsi_debug: Fix cmd duration
calculation"), ns_from_boot value is only evaluated in schedule_resp()
for polled requests.

However, ns_from_boot is also required for hrtimer support for when
ndelay is less than INCLUSIVE_TIMING_MAX_NS, so fix up the logic to
decide when to evaluate ns_from_boot.

Fixes: 771f712ba5b0 ("scsi: scsi_debug: Fix cmd duration calculation")
Signed-off-by: John Garry <john.g.garry@oracle.com>
Link: https://lore.kernel.org/r/20241202130045.2335194-1-john.g.garry@oracle.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index b52513eeeafa7..680ba180a6725 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6447,7 +6447,7 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 	}
 	sd_dp = &sqcp->sd_dp;
 
-	if (polled)
+	if (polled || (ndelay > 0 && ndelay < INCLUSIVE_TIMING_MAX_NS))
 		ns_from_boot = ktime_get_boottime_ns();
 
 	/* one of the resp_*() response functions is called here */
-- 
2.43.0



