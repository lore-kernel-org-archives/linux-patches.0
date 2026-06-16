Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D312C0261;
	Tue, 16 Jun 2026 18:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635737; cv=none; b=Xv90HkQ8puJEIyuRY9bpLiuqlmWy1jZUYHfevmtkNx/NSa6aC9FR3kOMI0JISIJYcqwoLlBC2pTeIci1R1a2vsS+SJDDzw7/yYEw7PBs4RCNAtVv+eMuLWfOnjxAz4GAuuY/mqGh9l3eyYOSUz2VzhNvJ2zeDhBaq1Iyz+NpNW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635737; c=relaxed/simple;
	bh=eTXtSdTKItMYdkTHl/QVyCf+bfmKGWUadIEjE0zeEcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mt/qltaCg7+gy+TdYvN7/VKeI1Y0ehwxG158sxl/aQsb4mUSWHGLMAFa9KRx2988f4rR2JLMcL1dzURKxKdhI9eB0nCVK2/lmjEV63nX79a2AS/8EB79xZ9/GIr1A9mGAB6yBoaze1E3isaOGujlNqi8qAmEFz+ZOsaU90l2z14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rO/izfRz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rO/izfRz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B88D1F000E9;
	Tue, 16 Jun 2026 18:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635735;
	bh=OTwE75RFcEDhDTmp+KmBva1q/l9/qHKzFBnJlP/O25w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rO/izfRzqVYbokUPr5CrAbpk+aY6kWiFvB33gWxhib92fY8wIZ8bQZhtVy/DCKpVr
	 U9YPreVFgKG/SXfs/Mg9UnJR74VVkinNmLxLiwOUE1P/FtdMl+dq5LfhNkMxlqYbh9
	 piwUQHdgx+DcojZMHaRCS+8ssiIFZpI2EnUC+INw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Seungjin Bae <eeodqql09@gmail.com>
Subject: [PATCH 5.10 105/342] usb: gadget: dummy_hcd: Reject hub port requests for non-existent ports
Date: Tue, 16 Jun 2026 20:26:41 +0530
Message-ID: <20260616145053.122818531@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2110,6 +2110,8 @@ static int dummy_hub_control(
 	case ClearHubFeature:
 		break;
 	case ClearPortFeature:
+		if (wIndex != 1)
+			goto error;
 		switch (wValue) {
 		case USB_PORT_FEAT_SUSPEND:
 			if (hcd->speed == HCD_USB3) {
@@ -2224,6 +2226,8 @@ static int dummy_hub_control(
 		retval = -EPIPE;
 		break;
 	case SetPortFeature:
+		if (wIndex != 1)
+			goto error;
 		switch (wValue) {
 		case USB_PORT_FEAT_LINK_STATE:
 			if (hcd->speed != HCD_USB3) {


