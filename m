Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7523596F8;
	Tue, 16 Dec 2025 12:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886690; cv=none; b=mjAeQEZPWxuBK3KNoGGdIoAjAyfpY2ERGb7QFhxi+adhVkiYLRmFUQmcJLJ7eQ/iIg7IcAGfzikC2xwCoEso5p4pvUpy4cHohyAnT3KzewAwPK19Z23/6ppI5wiJ1qtLrA6eIih55i4a/2WT4VhBYUgPgkUmiUWO5rXEX12bSqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886690; c=relaxed/simple;
	bh=FqaTvmCTd33Frp9diy3FdsPvShLveskKrQ9l9pXHp+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rzkTP1qDEi6+w3UC3cjGKitf0QbgIlGvhE5pu4r/Ni3c2+rh4JoFU+H2SYGbe/mBwsJOIAjskrLXsvDhvI+DkxXtdiX4gsDZKxDxi2qpC4q7j0jla3j4PB19z8tBgHlyB1rxJmal+JZPtqj1iPZ4vL5MewTZ0UHF+q9sDZzD/qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eHJFLZFI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eHJFLZFI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEE36C4CEF1;
	Tue, 16 Dec 2025 12:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886690;
	bh=FqaTvmCTd33Frp9diy3FdsPvShLveskKrQ9l9pXHp+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eHJFLZFIa3t9j/EJbCNSG/uYL7MVx4BDjMvNj+J7PZpvyCWZu0scIEPAifIhT4e7p
	 bgwsoEWgzts1zqtHsIqXovcHoD1Rdh3fUCf4jXlY0G51X+B5F3wM3Xr+o6EYBB0EbR
	 YHxCc4EipYTqUxcWSSRUYTunHHfc93zIVqkO6dic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Haotien Hsu <haotienh@nvidia.com>,
	Wayne Chang <waynec@nvidia.com>
Subject: [PATCH 6.17 498/507] usb: gadget: tegra-xudc: Always reinitialize data toggle when clear halt
Date: Tue, 16 Dec 2025 12:15:39 +0100
Message-ID: <20251216111403.481446016@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotien Hsu <haotienh@nvidia.com>

commit 2585973c7f9ee31d21e5848c996fab2521fd383d upstream.

The driver previously skipped handling ClearFeature(ENDPOINT_HALT)
when the endpoint was already not halted. This prevented the
controller from resetting the data sequence number and reinitializing
the endpoint state.

According to USB 3.2 specification Rev. 1.1, section 9.4.5,
ClearFeature(ENDPOINT_HALT) must always reset the data sequence and
set the stream state machine to Disabled, regardless of whether the
endpoint was halted.

Remove the early return so that ClearFeature(ENDPOINT_HALT) always
resets the endpoint sequence state as required by the specification.

Fixes: 49db427232fe ("usb: gadget: Add UDC driver for tegra XUSB device mode controller")
Cc: stable <stable@kernel.org>
Signed-off-by: Haotien Hsu <haotienh@nvidia.com>
Signed-off-by: Wayne Chang <waynec@nvidia.com>
Link: https://patch.msgid.link/20251127033540.2287517-1-waynec@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/tegra-xudc.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/drivers/usb/gadget/udc/tegra-xudc.c
+++ b/drivers/usb/gadget/udc/tegra-xudc.c
@@ -1559,12 +1559,6 @@ static int __tegra_xudc_ep_set_halt(stru
 		return -ENOTSUPP;
 	}
 
-	if (!!(xudc_readl(xudc, EP_HALT) & BIT(ep->index)) == halt) {
-		dev_dbg(xudc->dev, "EP %u already %s\n", ep->index,
-			halt ? "halted" : "not halted");
-		return 0;
-	}
-
 	if (halt) {
 		ep_halt(xudc, ep->index);
 	} else {


