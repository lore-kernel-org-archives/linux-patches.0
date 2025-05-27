Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33DA61A3159;
	Tue, 27 May 2025 17:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365374; cv=none; b=riV4zVStXqHYkscuGYIaz+/HFnDov/E3A0w6lm5UuByfNv8rrKNARo55u84/2+Bni9qjlWOfdUuLL9A1XS68vK/5UpvIhFcqsovOVtlZy2UD5gH/5/9cwzZ5LqPPvERtlNJ6aEXSz14N7y1y/dwU7psy6KBgMt5V8sBt0s5a+Co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365374; c=relaxed/simple;
	bh=7Ww4K2pkaaSpumhTISl2Ubs6b3ZoQpKi/RlBmV97ugY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KWUrxk4JX2bTGTR/hj26EW7iBmwGQHCC5JR6RFbPaJ/fv3q9H1ddrxyZdvJFsDq5ueGnA6C5nVXgprNCA8zlCm0HPU/3MEEisgBbraNR9G8pJHD3f6xCf4unrLym2uMOaFZDVP7Vp4lxBg65CfySkbWflihhHeN8z4CFhxTmxok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TuUelqj7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TuUelqj7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99916C4CEE9;
	Tue, 27 May 2025 17:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365374;
	bh=7Ww4K2pkaaSpumhTISl2Ubs6b3ZoQpKi/RlBmV97ugY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TuUelqj7p/7cPmmSYZ665aeahYOazTUx6kyuwyZ/G5Uzsw+IVMp+RF7FGnNB4sLru
	 KNCedTkQdbs8GWkGx4qjHA9cDi8vfq7eG5a15u3ENQkzvjglk92PnIgkoEWVHbV/PR
	 w7FFwNlbBgndGpj9vfd24SMuUwNBUO91WUonSLxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 356/626] firmware: arm_ffa: Handle the presence of host partition in the partition info
Date: Tue, 27 May 2025 18:24:09 +0200
Message-ID: <20250527162459.481118645@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit 2f622a8b0722d332a2a149794a3add47bc9bdcf3 ]

Currently it is assumed that the firmware doesn't present the host
partition in the list of partitions presented as part of the response
to PARTITION_INFO_GET from the firmware. However, there are few
platforms that prefer to present the same in the list of partitions.
It is not manadatory but not restricted as well.

So handle the same by making sure to check the presence of the host
VM ID in the XArray partition information maintained/managed in the
driver before attempting to add it.

Tested-by: Viresh Kumar <viresh.kumar@linaro.org>
Message-Id: <20250217-ffa_updates-v3-7-bd1d9de615e7@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_ffa/driver.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index 8dc8654f9f4b2..47751b2c057ae 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -1449,6 +1449,10 @@ static int ffa_setup_partitions(void)
 
 	kfree(pbuf);
 
+	/* Check if the host is already added as part of partition info */
+	if (xa_load(&drv_info->partition_info, drv_info->vm_id))
+		return 0;
+
 	/* Allocate for the host */
 	info = kzalloc(sizeof(*info), GFP_KERNEL);
 	if (!info) {
-- 
2.39.5



