Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CCE028E03
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hXm+xa87"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F023C433C8;
	Mon, 16 Oct 2023 14:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697468274;
	bh=R5eZ6vNQFWDTrHRb93RTjgeX4CCLZZUCEuHy+dyzXv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hXm+xa875tMyYF2GxtvwiwOixh/66MIyYbsTXjFRcZv20q6Rvy6XOsLoDz6M9iJXf
	 TWyhW5UXR85i0D5bdq1zdHal9eXUx9p8reP52IwfGCDkeAWEJblQU6BQMmFa1IH/TO
	 TAe5HTtLrqAumFwNEEcHD0RqIStLJCkASrqDv8OM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawel Laszczak <pawell@cadence.com>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 6.5 178/191] usb: cdnsp: Fixes issue with dequeuing not queued requests
Date: Mon, 16 Oct 2023 10:42:43 +0200
Message-ID: <20231016084019.529526362@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawel Laszczak <pawell@cadence.com>

commit 34f08eb0ba6e4869bbfb682bf3d7d0494ffd2f87 upstream.

Gadget ACM while unloading module try to dequeue not queued usb
request which causes the kernel to crash.
Patch adds extra condition to check whether usb request is processed
by CDNSP driver.

cc: stable@vger.kernel.org
Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Acked-by: Peter Chen <peter.chen@kernel.org>
Link: https://lore.kernel.org/r/20230713081429.326660-1-pawell@cadence.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdnsp-gadget.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/cdns3/cdnsp-gadget.c
+++ b/drivers/usb/cdns3/cdnsp-gadget.c
@@ -1125,6 +1125,9 @@ static int cdnsp_gadget_ep_dequeue(struc
 	unsigned long flags;
 	int ret;
 
+	if (request->status != -EINPROGRESS)
+		return 0;
+
 	if (!pep->endpoint.desc) {
 		dev_err(pdev->dev,
 			"%s: can't dequeue to disabled endpoint\n",


