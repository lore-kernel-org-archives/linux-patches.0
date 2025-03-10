Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF3E6230BDF;
	Mon, 10 Mar 2025 17:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626656; cv=none; b=WCFilnLOO212cqAyLtiyOjQRaSF041IkhZsCGwBHcUhuKUB1bIP54D43/R9WWxxubLuWkynUujq0AzMH5CNyfvvHqfOwhhzKfTS9aLZv5i7b1goyBpQ5Tr+eIN4K5p8LWk9zmyp02LffGd4Wd+euAC1Mjn/JCOhNjuEP1KTw/qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626656; c=relaxed/simple;
	bh=o1giEUJ3eHLb5IZlvRxgPGJwZrgr7ploI1Aay0tK7pM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IKQGRJVWHuOjm495OnlrGuu5u4rc0JKwjv+GtaB3GLa6NmCMaSdnj7cAJE/Y7WDgn/XAFfGkQ35g2vwWyCsfVd5VDi1cNLM6D+kCSeAX9MVWY/oWfYWiayrmUJMonFBkUa+oSbFmXXJw39MZ55TujTk2/Mayj3RfygYoMiwjcUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tovionPe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tovionPe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47F52C4CEE5;
	Mon, 10 Mar 2025 17:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626656;
	bh=o1giEUJ3eHLb5IZlvRxgPGJwZrgr7ploI1Aay0tK7pM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tovionPedHNs6x+CVNc8KvyGmrm93GryDmevwCU8VziLfZlPNrC4l8MI+INfdxh5U
	 8KxWnM9nYASSDC+2+li2RpPMwK0RlqUpkwOn4T7GC+cwDSNFvX2me703H7HPK3ExrL
	 jEwVhTEsfeFHNj5ozhNQyyYQNYM+FTKpPRFEAm48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Alexandre Bounine <alex.bou9@gmail.com>,
	Matt Porter <mporter@kernel.crashing.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.13 066/207] rapidio: add check for rio_add_net() in rio_scan_alloc_net()
Date: Mon, 10 Mar 2025 18:04:19 +0100
Message-ID: <20250310170450.391649925@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit e842f9a1edf306bf36fe2a4d847a0b0d458770de upstream.

The return value of rio_add_net() should be checked.  If it fails,
put_device() should be called to free the memory and give up the reference
initialized in rio_add_net().

Link: https://lkml.kernel.org/r/20250227041131.3680761-1-haoxiang_li2024@163.com
Fixes: e6b585ca6e81 ("rapidio: move net allocation into core code")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rapidio/rio-scan.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/rapidio/rio-scan.c
+++ b/drivers/rapidio/rio-scan.c
@@ -871,7 +871,10 @@ static struct rio_net *rio_scan_alloc_ne
 		dev_set_name(&net->dev, "rnet_%d", net->id);
 		net->dev.parent = &mport->dev;
 		net->dev.release = rio_scan_release_dev;
-		rio_add_net(net);
+		if (rio_add_net(net)) {
+			put_device(&net->dev);
+			net = NULL;
+		}
 	}
 
 	return net;


