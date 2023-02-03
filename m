Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC621FB9
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:26:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26435C4339B;
	Fri,  3 Feb 2023 10:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419967;
	bh=WrJZLxKAsJXSnZu3DJ31XWez5Jk7/4u3NLjiqEq4ilM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cS8W573iihMKhzUYy1hfUBdJ22tx+bd3rH0B9G89hVZbK4MPTq2Eyh9lUi9RBra8E
	 CkMp7CYA/P7g44bTGXPF16u+2Ti++mzTLPIAvHxjvh+jAgC8IVN+iU38ecbJFA7QHY
	 Go91L0vH1B2LhxQxsuLyYwWhuf0aGOWyr5zZBKVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Udipto Goswami <quic_ugoswami@quicinc.com>,
	Krishna Kurapati <quic_kriskura@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 037/134] usb: gadget: f_fs: Ensure ep0req is dequeued before free_request
Date: Fri,  3 Feb 2023 11:12:22 +0100
Message-Id: <20230203101025.525246578@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
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

[ Upstream commit ce405d561b020e5a46340eb5146805a625dcacee ]

As per the documentation, function usb_ep_free_request guarantees
the request will not be queued or no longer be re-queued (or
otherwise used). However, with the current implementation it
doesn't make sure that the request in ep0 isn't reused.

Fix this by dequeuing the ep0req on functionfs_unbind before
freeing the request to align with the definition.

Fixes: ddf8abd25994 ("USB: f_fs: the FunctionFS driver")
Signed-off-by: Udipto Goswami <quic_ugoswami@quicinc.com>
Tested-by: Krishna Kurapati <quic_kriskura@quicinc.com>
Link: https://lore.kernel.org/r/20221215052906.8993-3-quic_ugoswami@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_fs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 3b7323233b39..431ab6d07497 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1903,6 +1903,8 @@ static void functionfs_unbind(struct ffs_data *ffs)
 	ENTER();
 
 	if (!WARN_ON(!ffs->gadget)) {
+		/* dequeue before freeing ep0req */
+		usb_ep_dequeue(ffs->gadget->ep0, ffs->ep0req);
 		mutex_lock(&ffs->mutex);
 		usb_ep_free_request(ffs->gadget->ep0, ffs->ep0req);
 		ffs->ep0req = NULL;
-- 
2.39.0



