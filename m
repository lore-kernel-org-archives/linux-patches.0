Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F414147C74;
	Wed, 19 Jun 2024 13:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802715; cv=none; b=li9QZc4awNIXtauuuN80j82rFODHms/F84jiWbQxN+S58imwOYT4HYYdL9d7VaDgFnIWsSm0TzWn94TTILpKsu91ZMdoFjHEpz7y0Jxc1o8jUDGY9Xi4Wno3STi2j78OpWofrBfoWYD3MVt+C+2eyMBXMHKal33bhuqfEnSd+dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802715; c=relaxed/simple;
	bh=C6f94mmjFhtlAIVGBWUSyMOX1pNiCDEwKtaAHsIcJW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KcZHpthShtXzW6L5w/aOZeKeA6nsIEAOxGwaN9Q7j+0t7WqtFFJ6t6hmTT9qI0lGSNfV9KkptCIGmEs455WXXG8w6+jzR0Yd/41kWSybt1sBpNkrF8/8ZPmKY/YAqM7fVZUMeBvqlDE2UD+QtD/z+CJ3PDY4AErzb1ZTdKPz+DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RtDQ3TGT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RtDQ3TGT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D4EC2BBFC;
	Wed, 19 Jun 2024 13:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802715;
	bh=C6f94mmjFhtlAIVGBWUSyMOX1pNiCDEwKtaAHsIcJW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RtDQ3TGTgzoU/jIGp+S8dpk10deNoQCWiGgtvcl/XYp+JxhTeDHbOMyhJfGcmzOF8
	 4WDRUCgt+PrZ8V0avWIoL04OjqXl3QQ4UL89Kbu9o0hPbzQQRvrwQzPoA3ElWPdj2H
	 fUswagZmAYRs417PbJJGKa1SMty9XdiNMwrGG/+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heng Qi <hengqi@linux.alibaba.com>,
	Jiri Pirko <jiri@nvidia.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 023/281] virtio_net: fix possible dim status unrecoverable
Date: Wed, 19 Jun 2024 14:53:02 +0200
Message-ID: <20240619125610.739375178@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heng Qi <hengqi@linux.alibaba.com>

[ Upstream commit 9e0945b1901c9eed4fbee3b8a3870487b2bdc936 ]

When the dim worker is scheduled, if it no longer needs to issue
commands, dim may not be able to return to the working state later.

For example, the following single queue scenario:
  1. The dim worker of rxq0 is scheduled, and the dim status is
     changed to DIM_APPLY_NEW_PROFILE;
  2. dim is disabled or parameters have not been modified;
  3. virtnet_rx_dim_work exits directly;

Then, even if net_dim is invoked again, it cannot work because the
state is not restored to DIM_START_MEASURE.

Fixes: 6208799553a8 ("virtio-net: support rx netdim")
Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Link: https://lore.kernel.org/r/20240528134116.117426-2-hengqi@linux.alibaba.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 115c3c5414f2a..574b052a517d7 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3589,10 +3589,10 @@ static void virtnet_rx_dim_work(struct work_struct *work)
 			if (err)
 				pr_debug("%s: Failed to send dim parameters on rxq%d\n",
 					 dev->name, qnum);
-			dim->state = DIM_START_MEASURE;
 		}
 	}
 
+	dim->state = DIM_START_MEASURE;
 	rtnl_unlock();
 }
 
-- 
2.43.0



