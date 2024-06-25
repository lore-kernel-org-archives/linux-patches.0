Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31CD513C90B;
	Tue, 25 Jun 2024 10:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309677; cv=none; b=VHCV5HByErLhZbGJmu1fztaY0zdZspIEzvcnaW9S1vUp76d4SFM5DhFpaT/NaG+iyqL76VlwzVDYsJF4fEVSeqnUtk8MWnILGlynQq4LMXsPFxQKCp+c8doPOZfjECgJ4aAS4TIGanO+rTAC4f5C3Buoc2NBp5y9lQVIk/SjC0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309677; c=relaxed/simple;
	bh=4Po4KdIdjkO6KZa6nE2OU5atAax/Tw69w0JukLqjC0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sYHid7jgSfDGVMDF/Se7Lpe/qrU25GBrlSEKH25jY3iSfnaaYYC4i6CG62uSSdA49aDl4E2YyOws/Xt+3p+kzxu+DRGOe6pIz8MKUpifH3JjQ5dlghyvdQGtylyp63d7iZ+7nlHAbXKPvG6BiIrx812zRDYwSoGvxbjIwsAiP1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EokfbXmc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EokfbXmc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AACE2C32781;
	Tue, 25 Jun 2024 10:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309677;
	bh=4Po4KdIdjkO6KZa6nE2OU5atAax/Tw69w0JukLqjC0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EokfbXmcBfq4dI2MslTyP0czGbmn2nNh4tjhFlmK35ZsfwLKaWh8lLlUfSI2hwdYu
	 nbuC9zGORR72kMVVuxCWaDWsboVEWUNozdXr4HbV/VjRtIf51RdCPUQ6gRO5gtkMOS
	 XdohNNGIvjRbsVKZNrBHWc9iuWZ3N0vfhxtSCwGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Heng Qi <hengqi@linux.alibaba.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 069/131] ptp: fix integer overflow in max_vclocks_store
Date: Tue, 25 Jun 2024 11:33:44 +0200
Message-ID: <20240625085528.565324220@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 81d23d2a24012e448f651e007fac2cfd20a45ce0 ]

On 32bit systems, the "4 * max" multiply can overflow.  Use kcalloc()
to do the allocation to prevent this.

Fixes: 44c494c8e30e ("ptp: track available ptp vclocks information")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Heng Qi <hengqi@linux.alibaba.com>
Link: https://lore.kernel.org/r/ee8110ed-6619-4bd7-9024-28c1f2ac24f4@moroto.mountain
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_sysfs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/ptp/ptp_sysfs.c b/drivers/ptp/ptp_sysfs.c
index 74b9c794d6363..1263612ef2759 100644
--- a/drivers/ptp/ptp_sysfs.c
+++ b/drivers/ptp/ptp_sysfs.c
@@ -283,8 +283,7 @@ static ssize_t max_vclocks_store(struct device *dev,
 	if (max < ptp->n_vclocks)
 		goto out;
 
-	size = sizeof(int) * max;
-	vclock_index = kzalloc(size, GFP_KERNEL);
+	vclock_index = kcalloc(max, sizeof(int), GFP_KERNEL);
 	if (!vclock_index) {
 		err = -ENOMEM;
 		goto out;
-- 
2.43.0



