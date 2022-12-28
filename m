Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 789361863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:30:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00432C433EF;
	Wed, 28 Dec 2022 15:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241440;
	bh=k4hU1/mZkG+kZTABAbAXY9jw9zBkfOiRU/c1YsitHUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WZn5yHjTUQC3Os+Nrs6kgWqRrrBkriXqGKpFM2TauavP/xFySCMvMCrnG6Ogtg8np
	 UebIHt9wLb+B280nLZN4VSP+r6shL2BgBfmByIrzyodg811TPqvSuRUqVbZBcN4yf5
	 akBv3Xx3JjP+6THpFPMtSyh0viRywHhujCzWbuQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
	John Keeping <john@metanate.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 482/731] usb: gadget: f_hid: fix refcount leak on error path
Date: Wed, 28 Dec 2022 15:39:49 +0100
Message-Id: <20221228144310.521881432@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: John Keeping <john@metanate.com>

[ Upstream commit 70a3288a7586526315105c699b687d78cd32559a ]

When failing to allocate report_desc, opts->refcnt has already been
incremented so it needs to be decremented to avoid leaving the options
structure permanently locked.

Fixes: 21a9476a7ba8 ("usb: gadget: hid: add configfs support")
Tested-by: Lee Jones <lee@kernel.org>
Reviewed-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Reviewed-by: Lee Jones <lee@kernel.org>
Signed-off-by: John Keeping <john@metanate.com>
Link: https://lore.kernel.org/r/20221122123523.3068034-3-john@metanate.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_hid.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/gadget/function/f_hid.c b/drivers/usb/gadget/function/f_hid.c
index 8b8bbeaa27cb..6be6009f911e 100644
--- a/drivers/usb/gadget/function/f_hid.c
+++ b/drivers/usb/gadget/function/f_hid.c
@@ -1292,6 +1292,7 @@ static struct usb_function *hidg_alloc(struct usb_function_instance *fi)
 						 GFP_KERNEL);
 		if (!hidg->report_desc) {
 			put_device(&hidg->dev);
+			--opts->refcnt;
 			mutex_unlock(&opts->lock);
 			return ERR_PTR(-ENOMEM);
 		}
-- 
2.35.1



