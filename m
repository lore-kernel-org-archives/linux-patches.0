Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA017474
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:35:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70C69C433F0;
	Tue, 10 Jan 2023 18:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673375735;
	bh=EGLAa3kA26fPNtKykDB/ST9tLtlNY2jHKz81cKlT5Po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ya483ZWbiDmAh41dULCcCfqAupCktwpZvMmkZd1mBYrSH3yk1rZTDUIGRzdzdkwhd
	 5Fu87Kog7Af1rh7wtuWYpYA6CNEcyXcZIN52oq8EiwFiAiizB/ysltCyhMWfqIk6I8
	 hGjg3zbMjbqbFtJ5OF4ewfymDSKUTqA2SWfTxPg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Wang <wangjie125@huawei.com>,
	Hao Lan <lanhao@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 286/290] net: hns3: fix return value check bug of rx copybreak
Date: Tue, 10 Jan 2023 19:06:18 +0100
Message-Id: <20230110180041.781789957@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jie Wang <wangjie125@huawei.com>

commit 29df7c695ed67a8fa32bb7805bad8fe2a76c1f88 upstream.

The refactoring of rx copybreak modifies the original return logic, which
will make this feature unavailable. So this patch fixes the return logic of
rx copybreak.

Fixes: e74a726da2c4 ("net: hns3: refactor hns3_nic_reuse_page()")
Fixes: 99f6b5fb5f63 ("net: hns3: use bounce buffer when rx page can not be reused")
Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Hao Lan <lanhao@huawei.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3590,8 +3590,8 @@ static void hns3_nic_reuse_page(struct s
 		desc_cb->reuse_flag = 1;
 	} else if (frag_size <= ring->rx_copybreak) {
 		ret = hns3_handle_rx_copybreak(skb, i, ring, pull_len, desc_cb);
-		if (ret)
-			goto out;
+		if (!ret)
+			return;
 	}
 
 out:


