Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5B263B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:37:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B63C433D2;
	Mon, 20 Feb 2023 13:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676900257;
	bh=Fp4CDM/Vi32XOlKYEzOCY/jpwLd7fMdnKlIzOGdRO90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N0Smrn8LWbMGSQcSJdXfDz6FA6She7JVBWJQzdr1EMCppSAMPp2LJ+/RIHPxCz/Hl
	 eiMbpA763uDxRncSzKdnSD6GsoVKoE5rBhDVbqbF3oK3SIN0Seswi6h30Uh1FlT2nd
	 L3jaoYQf6o7VCgcvTHG/N58221MeLgJrB0E0qySY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Keeping <john@metanate.com>,
	Udipto Goswami <quic_ugoswami@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 11/53] usb: gadget: f_fs: Fix unbalanced spinlock in __ffs_ep0_queue_wait
Date: Mon, 20 Feb 2023 14:35:37 +0100
Message-Id: <20230220133548.581647976@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133548.158615609@linuxfoundation.org>
References: <20230220133548.158615609@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Udipto Goswami <quic_ugoswami@quicinc.com>

[ Upstream commit 921deb9da15851425ccbb6ee409dc2fd8fbdfe6b ]

__ffs_ep0_queue_wait executes holding the spinlock of &ffs->ev.waitq.lock
and unlocks it after the assignments to usb_request are done.
However in the code if the request is already NULL we bail out returning
-EINVAL but never unlocked the spinlock.

Fix this by adding spin_unlock_irq &ffs->ev.waitq.lock before returning.

Fixes: 6a19da111057 ("usb: gadget: f_fs: Prevent race during ffs_ep0_queue_wait")
Reviewed-by: John Keeping <john@metanate.com>
Signed-off-by: Udipto Goswami <quic_ugoswami@quicinc.com>
Link: https://lore.kernel.org/r/20230124091149.18647-1-quic_ugoswami@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_fs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 946cf039eddd..ba9af04ad37a 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -274,8 +274,10 @@ static int __ffs_ep0_queue_wait(struct ffs_data *ffs, char *data, size_t len)
 	struct usb_request *req = ffs->ep0req;
 	int ret;
 
-	if (!req)
+	if (!req) {
+		spin_unlock_irq(&ffs->ev.waitq.lock);
 		return -EINVAL;
+	}
 
 	req->zero     = len < le16_to_cpu(ffs->ev.setup.wLength);
 
-- 
2.39.0



