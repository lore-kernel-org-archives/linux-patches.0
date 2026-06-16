Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6C53D88F2;
	Tue, 16 Jun 2026 18:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633704; cv=none; b=cIMLakZWkv1Bd4KikC7RhVYuY4+fNFHsy1RUFTaVz3mTb7htGGVaarqC1MfbpevKmwzV0uqUhVzg5BWkAmRzjXMKqVto44D0zj13mUz+koBOpbOzNvrkhmxRA9sE0dEPtLbVv4XErpS+m+/KvWdrXg6YgrD4fn+wBXESdGTODGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633704; c=relaxed/simple;
	bh=LkUBZeS4Uue6RpjehinfpK5Ev3UAssqDVAt/LvEpGoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ERKiLqs7KxRKM9MgPHK2ldAxtw+Tvld44ViekjPG7kJano/3bwxjSBc43Sm2drefXAVAtVqb1F344XNHPg5lep0TKptnCeQHnsI9hySa5Kij5LY56t32wwqlAYzfK2Hgxv3XrRJLsQCR4o+KouxaguhWcwcK8RST0UaeOPTvBFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r5aRpaKZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r5aRpaKZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DA451F000E9;
	Tue, 16 Jun 2026 18:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633703;
	bh=hVFsG7vv6y6Pe5JrU0l/MjDz5KBq+PAf1rE4KdGeDqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r5aRpaKZtGJcS/yxtuH1CCdKnIMUYgBMxDAzkAQRtckSgPoql/qwC+TBp23xsIRzw
	 uCMthFLiT2JT2m7Wn/WiaZaJJPheIno9Pggdk49hUduavggLAaLSKaPRjArYxWdlCZ
	 7ivOD/9MOsy8hEV1h7bGBumm7KxXH2x/XArHtgWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Seungjin Bae <eeodqql09@gmail.com>
Subject: [PATCH 5.15 122/411] usb: gadget: dummy_hcd: Reject hub port requests for non-existent ports
Date: Tue, 16 Jun 2026 20:26:00 +0530
Message-ID: <20260616145106.809739702@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Seungjin Bae <eeodqql09@gmail.com>

commit 7d9633528dd40e33964d2dc74a5abbf5c4d116ce upstream.

The `dummy_hub_control()` function handles USB hub class requests
to the virtual root hub. The `GetPortStatus` case returns -EPIPE for
requests with `wIndex != 1`, since the virtual root hub has only a
single port. However, the `ClearPortFeature` and `SetPortFeature`
cases lack the same check.

Fix this by extending the `wIndex != 1` rejection to both cases,
matching the existing behavior of `GetPortStatus`.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable <stable@kernel.org>
Suggested-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Seungjin Bae <eeodqql09@gmail.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20260518234314.1889396-1-eeodqql09@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/dummy_hcd.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/gadget/udc/dummy_hcd.c
+++ b/drivers/usb/gadget/udc/dummy_hcd.c
@@ -2122,6 +2122,8 @@ static int dummy_hub_control(
 	case ClearHubFeature:
 		break;
 	case ClearPortFeature:
+		if (wIndex != 1)
+			goto error;
 		switch (wValue) {
 		case USB_PORT_FEAT_SUSPEND:
 			if (hcd->speed == HCD_USB3) {
@@ -2236,6 +2238,8 @@ static int dummy_hub_control(
 		retval = -EPIPE;
 		break;
 	case SetPortFeature:
+		if (wIndex != 1)
+			goto error;
 		switch (wValue) {
 		case USB_PORT_FEAT_LINK_STATE:
 			if (hcd->speed != HCD_USB3) {


