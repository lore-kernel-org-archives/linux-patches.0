Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B73396FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:53:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 419B3C433D2;
	Mon, 16 Jan 2023 16:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673887984;
	bh=TeGx9OE4jFvILCtiScl1JRq5wR9c3CWZKJSnEQNDCv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=btAXof3X7HP0eRuSq1ZmhL8J53Gjmj44aVHwdL7wDVEK6jcXZLOSjVp0b991d5rx5
	 G0tNNRuZCGvHbpQTSBJyDDlTY2FdDDY2hyvMKVfokAH7fQFfa7lU3xTg8/uyPvcpfI
	 IKmjpWvDtLe6I5dB5lU9ygsi0TBtRkdqumxb5A/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Ferry Toth <ftoth@exalondelft.nl>
Subject: [PATCH 4.19 355/521] usb: dwc3: core: defer probe on ulpi_read_id timeout
Date: Mon, 16 Jan 2023 16:50:17 +0100
Message-Id: <20230116154902.987677881@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ferry Toth <ftoth@exalondelft.nl>

commit 63130462c919ece0ad0d9bb5a1f795ef8d79687e upstream.

Since commit 0f0101719138 ("usb: dwc3: Don't switch OTG -> peripheral
if extcon is present"), Dual Role support on Intel Merrifield platform
broke due to rearranging the call to dwc3_get_extcon().

It appears to be caused by ulpi_read_id() masking the timeout on the first
test write. In the past dwc3 probe continued by calling dwc3_core_soft_reset()
followed by dwc3_get_extcon() which happend to return -EPROBE_DEFER.
On deferred probe ulpi_read_id() finally succeeded. Due to above mentioned
rearranging -EPROBE_DEFER is not returned and probe completes without phy.

On Intel Merrifield the timeout on the first test write issue is reproducible
but it is difficult to find the root cause. Using a mainline kernel and
rootfs with buildroot ulpi_read_id() succeeds. As soon as adding
ftrace / bootconfig to find out why, ulpi_read_id() fails and we can't
analyze the flow. Using another rootfs ulpi_read_id() fails even without
adding ftrace. We suspect the issue is some kind of timing / race, but
merely retrying ulpi_read_id() does not resolve the issue.

As we now changed ulpi_read_id() to return -ETIMEDOUT in this case, we
need to handle the error by calling dwc3_core_soft_reset() and request
-EPROBE_DEFER. On deferred probe ulpi_read_id() is retried and succeeds.

Fixes: ef6a7bcfb01c ("usb: ulpi: Support device discovery via DT")
Cc: stable@vger.kernel.org
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Signed-off-by: Ferry Toth <ftoth@exalondelft.nl>
Link: https://lore.kernel.org/r/20221205201527.13525-3-ftoth@exalondelft.nl
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -914,8 +914,13 @@ static int dwc3_core_init(struct dwc3 *d
 
 	if (!dwc->ulpi_ready) {
 		ret = dwc3_core_ulpi_init(dwc);
-		if (ret)
+		if (ret) {
+			if (ret == -ETIMEDOUT) {
+				dwc3_core_soft_reset(dwc);
+				ret = -EPROBE_DEFER;
+			}
 			goto err0;
+		}
 		dwc->ulpi_ready = true;
 	}
 


