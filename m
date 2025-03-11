Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A2225DD00;
	Tue, 11 Mar 2025 15:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705559; cv=none; b=mQ5h+OLQf8H7GRWmPlo6NonMQHHCqcJTdk93WlALl1ppdOEGdLoksPNusHLUkIAqSGBUG6/FBY1b90YMWd0vFUmyPKMHQzx8zKfx0kCB+SEtACYVLPA4sWOOdk/30Ng0cvjyU4ltNWwNR4ilDtjaA95+6/KtsqfNXyb4Y7lnWAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705559; c=relaxed/simple;
	bh=5VYs5xgPIIRDictuIV/raeswaguBI3p7oDhpMSJ8f7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QDpJdzDwSZaJ6xlK8PIANT4XBVan8QrUeEujkJ3hZKQNm1zuoEJww71IpvUzmvr0r2Ez96Ktby2rikOH/5OAp+rWqd17iPRJLRNIO8z1n/AONYNN3IOB0BXcChg9PannN4Fq2f+019zwl+/hQh9wg5Glh8Y9aX5AQlemVxr5NCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0X2VH6hc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0X2VH6hc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AC34C4CEE9;
	Tue, 11 Mar 2025 15:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705558;
	bh=5VYs5xgPIIRDictuIV/raeswaguBI3p7oDhpMSJ8f7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0X2VH6hcbaV6QLQBKWzOf1Bc9f4sXeCEQtGfQ/Ps/YR5zNsgWwwhtY5c7VgU+SP8X
	 nuSoEb0asycG3Krgq7aEdXThE60r3NDsJK+shwPOi83td1T/FLMOvllJTnix7vio2y
	 fpjCeG3KrQg0T0y1O9B3wwpmcKL+LJ6j90DrEK10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Avri Altman <avri.altman@wdc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 057/328] scsi: ufs: bsg: Delete bsg_dev when setting up bsg fails
Date: Tue, 11 Mar 2025 15:57:07 +0100
Message-ID: <20250311145717.162687420@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit fcf247deb3c3e1c6be5774e3fa03bbd018eff1a9 ]

We should remove the bsg device when bsg_setup_queue() fails to release the
resources.

Fixes: df032bf27a41 ("scsi: ufs: Add a bsg endpoint that supports UPIUs")
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Link: https://lore.kernel.org/r/20241218014214.64533-2-kanie@linux.alibaba.com
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufs_bsg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ufs/ufs_bsg.c b/drivers/scsi/ufs/ufs_bsg.c
index bad366e491591..78e72a1aec9b1 100644
--- a/drivers/scsi/ufs/ufs_bsg.c
+++ b/drivers/scsi/ufs/ufs_bsg.c
@@ -213,6 +213,7 @@ int ufs_bsg_probe(struct ufs_hba *hba)
 	q = bsg_setup_queue(bsg_dev, dev_name(bsg_dev), ufs_bsg_request, NULL, 0);
 	if (IS_ERR(q)) {
 		ret = PTR_ERR(q);
+		device_del(bsg_dev);
 		goto out;
 	}
 
-- 
2.39.5



