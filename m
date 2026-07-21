Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33BDD3B6BE3;
	Tue, 21 Jul 2026 20:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666276; cv=none; b=s5RSjioet8g3J2FaXNIBPm6eq34ifjaPY+eeBWcjNJmMqiPnWJ05Y1wjPTPxhw24trbFSgxMOghQiyXbEkJv1HaDwwKKwWWZv9zgUbkw1Fu26FJepR1no6bJ1zUjxeV1zBdVIybDP+aIiBabYlu4uCb+uhQHfPM4nwJUdfnvtG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666276; c=relaxed/simple;
	bh=Y+CDNEGpNqZ8cTKCTb0/FlothAhuZcfeLAT0L+tN+Ww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HW2KdXHg1QSx/QMUo0jxnfJzeb8wAeAWjyJYhveqwBperCm6DCWrnxJgZtHWz2f+72oxcRoSOtlzLWgOKOYT8ELJxkH/XgQM5CF+9dOKuBs/1P1hbVO4nv+UvMGU1/z4ZYoV8kxsdF3hmTFUBIxlGIESmrFvDkSq/HzSO1XIfQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vh5gwqY7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vh5gwqY7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E78F1F000E9;
	Tue, 21 Jul 2026 20:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666272;
	bh=cu7D8qDGqRG8ZLcDEIOp4Kyfpu7GXMiHIN6mwEAGs0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vh5gwqY7myAUPbqmIxw9Hlg2qDdhYhh1Gs49gxpgzrG0zHon6oAmEcLYMT3+dszfH
	 eCgdryctUZvpSM8oOARMg1ZHvQBkKfxHYSamzLvTwNHhy21NgIbJG935crN5xJafrh
	 zVFQxnOKwFyZAq90/PD2GwQ1STJNyJabWsj/BBLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Seungjin Bae <eeodqql09@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0620/1266] usb: host: max3421: Reject hub port requests for non-existent ports
Date: Tue, 21 Jul 2026 17:17:37 +0200
Message-ID: <20260721152455.738972918@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Seungjin Bae <eeodqql09@gmail.com>

[ Upstream commit 11b5c101e2fd206104b05bc92554d356989423a8 ]

The `max3421_hub_control()` function handles USB hub class requests
to the virtual root hub. The `GetPortStatus` case correctly rejects
requests with `index != 1`, since the virtual root hub has only a
single port. However, the `ClearPortFeature` and `SetPortFeature`
cases lack the same check.

Fix this by extending the `index != 1` rejection to both cases,
matching the existing behavior of `GetPortStatus`.

Fixes: 2d53139f3162 ("Add support for using a MAX3421E chip as a host driver.")
Suggested-by: Alan Stern <stern@rowland.harvard.edu>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Seungjin Bae <eeodqql09@gmail.com>
Link: https://patch.msgid.link/20260518224901.1887013-3-eeodqql09@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/max3421-hcd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/host/max3421-hcd.c b/drivers/usb/host/max3421-hcd.c
index af82e88e148ecd..d410e3206e2df0 100644
--- a/drivers/usb/host/max3421-hcd.c
+++ b/drivers/usb/host/max3421-hcd.c
@@ -1685,6 +1685,8 @@ max3421_hub_control(struct usb_hcd *hcd, u16 type_req, u16 value, u16 index,
 	case ClearHubFeature:
 		break;
 	case ClearPortFeature:
+		if (index != 1)
+			goto error;
 		switch (value) {
 		case USB_PORT_FEAT_SUSPEND:
 			break;
@@ -1728,6 +1730,8 @@ max3421_hub_control(struct usb_hcd *hcd, u16 type_req, u16 value, u16 index,
 		break;
 
 	case SetPortFeature:
+		if (index != 1)
+			goto error;
 		switch (value) {
 		case USB_PORT_FEAT_LINK_STATE:
 		case USB_PORT_FEAT_U1_TIMEOUT:
-- 
2.53.0



