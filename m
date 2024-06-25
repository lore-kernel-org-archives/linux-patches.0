Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 989C824B34;
	Tue, 25 Jun 2024 09:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309086; cv=none; b=IsK9VWL/7CeDjs1FZj2yduzTLRq0qb/L8V1CmlhXiEhoOUeqh1VH8v3rttyNqUS29lvigiWz2fJ0Vf0hSTftNSBFxEvTB2HcipmgZI98EKmDFjLbQ/N/BkdKdMi7BauZYrfg7oqOVbHUO38JmvRCn5C0wXSC4RJzgSm74XFG53M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309086; c=relaxed/simple;
	bh=Sfno34em+iXa6GB7tCbjVbONl9w9rnsH213fWjxpklM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MA32+jyU4uMzBFqV9KEX8scAxk1Ze/dBAkuQQtuijijSAd3wkCdp/OEX/dPdlrJphWKDYoybVGVKYb1H9BxErZ+E7XfgDHkFx9na+9XhHLZ8TeqGvxcEkFtkS4a4vBoMOT49O+kAgpkMbahkZr893I9XX1FmK8YPJAmqalriE+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T2eI9EGz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T2eI9EGz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E337C32781;
	Tue, 25 Jun 2024 09:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309086;
	bh=Sfno34em+iXa6GB7tCbjVbONl9w9rnsH213fWjxpklM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T2eI9EGzA7c2qEXg1AY0jguHXRqO8JMy9CYlFRdqbaOEvTTqAwA8XXZVrxt23R0Nz
	 4Bg7Je0FDqTgflsiHTZLwpgjfWV7qMNEBO0Cmuv+zED/KBPrAU5DtfyYMtx8nuRuPE
	 iH6m8YotL9T5WLYl7WfZ1+uLUUVH6sfgVCFdVWRM=
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
Subject: [PATCH 6.6 091/192] ptp: fix integer overflow in max_vclocks_store
Date: Tue, 25 Jun 2024 11:32:43 +0200
Message-ID: <20240625085540.669728688@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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
index 34ea5c16123a1..aefc06ae5d099 100644
--- a/drivers/ptp/ptp_sysfs.c
+++ b/drivers/ptp/ptp_sysfs.c
@@ -294,8 +294,7 @@ static ssize_t max_vclocks_store(struct device *dev,
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



