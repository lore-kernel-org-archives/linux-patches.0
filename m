Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB201FB4
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:18:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E44DFC433EF;
	Fri,  3 Feb 2023 10:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419481;
	bh=nKMSu285TVhveddBh0dCwodTX06axpBbbD0KXq5OTOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cTBkhZmHDEW20qcKHqGP8KZPLFWhLMJM5sV0y9kQKomvdtVbzbtkPWtnRrQobyXUa
	 745ZLlKGN4fyR9AHLFE1D7hAGxSAGI4EXx2lxUoo8sQeI31vawb+SY5oWa84z4H+fU
	 c7j2N1HaFe6FEk8EzWtEWwrYZ7Gxk2pLr9Qk6zlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Udipto Goswami <quic_ugoswami@quicinc.com>,
	Krishna Kurapati <quic_kriskura@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 20/80] usb: gadget: f_fs: Ensure ep0req is dequeued before free_request
Date: Fri,  3 Feb 2023 11:12:14 +0100
Message-Id: <20230203101016.064154677@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101015.263854890@linuxfoundation.org>
References: <20230203101015.263854890@linuxfoundation.org>
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
index b3489a3449f6..48bdb2a3972b 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1810,6 +1810,8 @@ static void functionfs_unbind(struct ffs_data *ffs)
 	ENTER();
 
 	if (!WARN_ON(!ffs->gadget)) {
+		/* dequeue before freeing ep0req */
+		usb_ep_dequeue(ffs->gadget->ep0, ffs->ep0req);
 		mutex_lock(&ffs->mutex);
 		usb_ep_free_request(ffs->gadget->ep0, ffs->ep0req);
 		ffs->ep0req = NULL;
-- 
2.39.0



