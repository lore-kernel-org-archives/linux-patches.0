Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF5E28383
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gvnwjA8D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3797C433C9;
	Wed, 15 Nov 2023 19:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077452;
	bh=7V48UVWHUZucM74b3709GXpRGSm+Bfgyl/HDStJf+XE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gvnwjA8DL9A+RtQkn4SJutKCN6cwcpwr0OTJstM5gn4vVctj3UT3IDwJj9fvwiETO
	 nglGVPpvcVWBOilpHHNUf6W2MJvTPIhJneDM46jTfWcwr0YwGRJBfEf4DErSMT1rXS
	 DNFDQ3Bzp16PTLaChaIi1w/CVoO9a4lxDl5vFOWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 311/603] firmware: arm_ffa: Allow the FF-A drivers to use 32bit mode of messaging
Date: Wed, 15 Nov 2023 14:14:16 -0500
Message-ID: <20231115191634.952016388@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit 2d698e8b4fd22374dac0a2d5150ab24d57a222ab ]

An FF-A ABI could support both the SMC32 and SMC64 conventions.
A callee that runs in the AArch64 execution state and implements such
an ABI must implement both SMC32 and SMC64 conventions of the ABI.

So the FF-A drivers will need the option to choose the mode irrespective
of FF-A version and the partition execution mode flag in the partition
information.

Let us remove the check on the FF-A version for allowing the selection
of 32bit mode of messaging. The driver will continue to set the 32-bit
mode if the partition execution mode flag specified that the partition
supports only 32-bit execution.

Fixes: 106b11b1ccd5 ("firmware: arm_ffa: Set up 32bit execution mode flag using partiion property")
Link: https://lore.kernel.org/r/20231005142823.278121-1-sudeep.holla@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_ffa/driver.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index 121f4fc903cd5..7cd6b1564e801 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -587,17 +587,9 @@ static int ffa_partition_info_get(const char *uuid_str,
 	return 0;
 }
 
-static void _ffa_mode_32bit_set(struct ffa_device *dev)
-{
-	dev->mode_32bit = true;
-}
-
 static void ffa_mode_32bit_set(struct ffa_device *dev)
 {
-	if (drv_info->version > FFA_VERSION_1_0)
-		return;
-
-	_ffa_mode_32bit_set(dev);
+	dev->mode_32bit = true;
 }
 
 static int ffa_sync_send_receive(struct ffa_device *dev,
@@ -706,7 +698,7 @@ static void ffa_setup_partitions(void)
 
 		if (drv_info->version > FFA_VERSION_1_0 &&
 		    !(tpbuf->properties & FFA_PARTITION_AARCH64_EXEC))
-			_ffa_mode_32bit_set(ffa_dev);
+			ffa_mode_32bit_set(ffa_dev);
 	}
 	kfree(pbuf);
 }
-- 
2.42.0



