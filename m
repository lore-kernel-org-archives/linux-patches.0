Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A981C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:25:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6911BC433D2;
	Wed, 28 Dec 2022 16:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244745;
	bh=C4wX3t99ML0tdEdnpCMhKL7bGaB9HhxnPsqSwYYhIEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HbDlnVqWFcuvy7fb0RmaJNW6VpB61vnNkwE8F7tMC3yTZT4BmIDHPreQ3hUhaZSD2
	 uKHFm1DIquYSJnWhpYibnxqi/Jn0YtY7eNOY9og61hkD18HVsY5oYu2OlMOZ/5YRaf
	 EeJoLNWWJEUjUzBx4Qd3GKPqKhtpX1FBNT/cXnHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0729/1146] usb: core: hcd: Fix return value check in usb_hcd_setup_local_mem()
Date: Wed, 28 Dec 2022 15:37:48 +0100
Message-Id: <20221228144349.947874725@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 3c347cdafa3db43337870006e5c2d7b78a8dae20 ]

If dmam_alloc_attrs() fails, it returns NULL pointer and never
return ERR_PTR(), so repleace IS_ERR() with IS_ERR_OR_NULL()
and if it's NULL, returns -ENOMEM.

Fixes: 9ba26f5cecd8 ("ARM: sa1100/assabet: move dmabounce hack to ohci driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221125064120.2842452-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/core/hcd.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index faeaace0d197..8300baedafd2 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -3133,8 +3133,12 @@ int usb_hcd_setup_local_mem(struct usb_hcd *hcd, phys_addr_t phys_addr,
 					     GFP_KERNEL,
 					     DMA_ATTR_WRITE_COMBINE);
 
-	if (IS_ERR(local_mem))
+	if (IS_ERR_OR_NULL(local_mem)) {
+		if (!local_mem)
+			return -ENOMEM;
+
 		return PTR_ERR(local_mem);
+	}
 
 	/*
 	 * Here we pass a dma_addr_t but the arg type is a phys_addr_t.
-- 
2.35.1



