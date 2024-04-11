Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D25142624;
	Thu, 11 Apr 2024 10:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831886; cv=none; b=HsQqSn112tKX9SRRlR/znyqi+0c30B8CcQXj4DJqE1cMi4YXzMODBjWsj7r22H5HUwMRGkgEQoirIEe7bvtZYTCYC1ygr0KmvAYk/NYrIABe8xT2HNM/dIHDtNrmThvraNG1KyXXzSJpR30Ljt2gOvXAdy4kk7C4R5Od0J5uudk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831886; c=relaxed/simple;
	bh=5zDK/bkUqyR4O+66I99LCsPTeC4/1T+bnC4sdrwGzqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HlDoRL5SEIYYHxMfdzd4ScBI2/iBg/b5UuSaZGvbsFjrweeCudI0671fakcsZf5Jb+a4WxSh/n7JqK6yVY08iUeVQH92dzFy7EAVR2UAeWyQDr7rfmuWg7wiuc1CA3e+QQokVvHaIJE4kENwikJx402yL5GszP3Am+ZTh90SeAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SArre7Ip; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SArre7Ip"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88A1FC43390;
	Thu, 11 Apr 2024 10:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831885;
	bh=5zDK/bkUqyR4O+66I99LCsPTeC4/1T+bnC4sdrwGzqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SArre7Ip9Cswuar7Se2j6WymS6oQuKNTZBpSnyN57az2AYIZB0J1zv5PqdIjHMLNQ
	 4BXRwbmWrXE1j1Je4Ng0r3qrI3/U5Vs7uul9OC321z+jmLgRg/NU/U0k8tTMsr0b32
	 nIam7xNe13RgvRXWGGX3VQKNePV9LTFaO8wfq8gs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Rapeli <mikko.rapeli@linaro.org>,
	Avri Altman <avri.altman@wdc.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 160/294] mmc: core: Avoid negative index with array access
Date: Thu, 11 Apr 2024 11:55:23 +0200
Message-ID: <20240411095440.461927992@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikko Rapeli <mikko.rapeli@linaro.org>

commit cf55a7acd1ed38afe43bba1c8a0935b51d1dc014 upstream.

Commit 4d0c8d0aef63 ("mmc: core: Use mrq.sbc in close-ended ffu") assigns
prev_idata = idatas[i - 1], but doesn't check that the iterator i is
greater than zero. Let's fix this by adding a check.

Fixes: 4d0c8d0aef63 ("mmc: core: Use mrq.sbc in close-ended ffu")
Link: https://lore.kernel.org/all/20231129092535.3278-1-avri.altman@wdc.com/
Cc: stable@vger.kernel.org
Signed-off-by: Mikko Rapeli <mikko.rapeli@linaro.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Link: https://lore.kernel.org/r/20240313133744.2405325-2-mikko.rapeli@linaro.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/block.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -468,7 +468,7 @@ static int __mmc_blk_ioctl_cmd(struct mm
 	if (idata->flags & MMC_BLK_IOC_DROP)
 		return 0;
 
-	if (idata->flags & MMC_BLK_IOC_SBC)
+	if (idata->flags & MMC_BLK_IOC_SBC && i > 0)
 		prev_idata = idatas[i - 1];
 
 	/*


