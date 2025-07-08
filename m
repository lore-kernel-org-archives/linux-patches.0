Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC572045B5;
	Tue,  8 Jul 2025 16:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993370; cv=none; b=YoI2vrkkCMsv2PLk6ZTCBvlXsnb+nX+6jGDo5Po19DcJdmUl5DIMRp067dH5081d3d3eNiVnPVpWPg0v70bEmG8f0p5dE8GbuSlCpQPQoBGvTrQwjbzJGd9nnm6RQ68Hf3Rsb08FIo/qLiT4ajjUEQfKpTHXiAcqQn8wRiOWNqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993370; c=relaxed/simple;
	bh=REN3WwYQh3BYhKrnkO+4BHCFd1aRrOI5SEGFh+T7mhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KeSvyon3ujrqMZ8+rxtN80WuoqA3ePgfwc4gvvm6/DPw4x4EC46I7RwfOcAswB5ZQk3xb8aYXIf+FMIj7h2nFjTPOE7DyaWX7HeixsSTVw8yaZDMOH2Y72gvjllbSPLllrmwedKS+0cB2sVcUv31OwMQr4yNHrfFwjPAM20ql8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iz9ALWsL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iz9ALWsL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCEC5C4CEED;
	Tue,  8 Jul 2025 16:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993370;
	bh=REN3WwYQh3BYhKrnkO+4BHCFd1aRrOI5SEGFh+T7mhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iz9ALWsLiCYugOiQM8+p9giDi9Gm8OrV0QsB0DXZ+ju/kfSCnWUf5yY9werqEG8Mo
	 +ldbyjuH8KrI5xwX5N1imW02j6VPbI1erHwGOD9z7QIsjKFB7tjSL3grZZzxizQULp
	 wPkNBQXjlXBB20QYURzeor5H+LyB9PuFKZBboP9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	jackysliu <1972843537@qq.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 051/178] scsi: sd: Fix VPD page 0xb7 length check
Date: Tue,  8 Jul 2025 18:21:28 +0200
Message-ID: <20250708162238.016304365@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

From: jackysliu <1972843537@qq.com>

[ Upstream commit 8889676cd62161896f1d861ce294adc29c4f2cb5 ]

sd_read_block_limits_ext() currently assumes that vpd->len excludes the
size of the page header. However, vpd->len describes the size of the entire
VPD page, therefore the sanity check is incorrect.

In practice this is not really a problem since we don't attach VPD
pages unless they actually report data trailing the header. But fix
the length check regardless.

This issue was identified by Wukong-Agent (formerly Tencent Woodpecker), a
code security AI agent, through static code analysis.

[mkp: rewrote patch description]

Signed-off-by: jackysliu <1972843537@qq.com>
Link: https://lore.kernel.org/r/tencent_ADA5210D1317EEB6CD7F3DE9FE9DA4591D05@qq.com
Fixes: 96b171d6dba6 ("scsi: core: Query the Block Limits Extension VPD page")
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 950d8c9fb8843..89d5c4b17bc46 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3384,7 +3384,7 @@ static void sd_read_block_limits_ext(struct scsi_disk *sdkp)
 
 	rcu_read_lock();
 	vpd = rcu_dereference(sdkp->device->vpd_pgb7);
-	if (vpd && vpd->len >= 2)
+	if (vpd && vpd->len >= 6)
 		sdkp->rscs = vpd->data[5] & 1;
 	rcu_read_unlock();
 }
-- 
2.39.5



