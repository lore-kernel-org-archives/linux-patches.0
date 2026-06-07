Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A03104071DD;
	Sun,  7 Jun 2026 10:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829550; cv=none; b=ES6ceF4eiZ6S+w94QjQ6UYgMslXUy3k6zjNrgJv5bt7XIWE9sJf0DxX4AlXlwLbDpTWDHDiyLT53HQdORwAk7AvRBRzeBeHOekw1Ox7msbmFLUsNsOZAOKAuNo85brizmqbJvwwRMjzNsymJ4QvHjnttwU+iFB3u1oO4VppfCC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829550; c=relaxed/simple;
	bh=22iFA8fxXF2g7Fi+VSCbbtI7FnHxMlEyx87aMoFo3hQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KEbLStsOX66HlAqLv97TMDID5wQ45xeSObPKkyRigakZ2jLFvAfMOyP2JvMNJGxXbp2wd5uhnqCVq/rRt5KH/Kw2zgBiT+icqzKmh8j8DPPbirziRdn/5jPzWNqTUlEkLi7EYETy3nvCRHTkuYnBqn1MG6IA9K1htN4fIDhlekU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1JKs6Rpa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1JKs6Rpa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47571F00893;
	Sun,  7 Jun 2026 10:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829549;
	bh=sog9J8chauxVxdnnF8v24qBc83A2v3F9N+PN/CovX7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1JKs6RpaY8V1x9LVYYkDdNnNX8W2FULesF1U5M+tl55Lx8hAvFf+jbzv2bYh+4FQw
	 mdxXR5FQBseJ7w8a+kEgtBgWlNpUa4jqPtgcJDxPrLk0W6IF9VjkaFLj1avcEylgjO
	 yPNk+CuNiZuIZGDTK2GnTkWiz7+ilSkvHeWsSI0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Seungjin Bae <eeodqql09@gmail.com>
Subject: [PATCH 6.12 234/307] usb: gadget: dummy_hcd: Reject hub port requests for non-existent ports
Date: Sun,  7 Jun 2026 12:00:31 +0200
Message-ID: <20260607095736.298564870@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2132,6 +2132,8 @@ static int dummy_hub_control(
 	case ClearHubFeature:
 		break;
 	case ClearPortFeature:
+		if (wIndex != 1)
+			goto error;
 		switch (wValue) {
 		case USB_PORT_FEAT_SUSPEND:
 			if (hcd->speed == HCD_USB3) {
@@ -2246,6 +2248,8 @@ static int dummy_hub_control(
 		retval = -EPIPE;
 		break;
 	case SetPortFeature:
+		if (wIndex != 1)
+			goto error;
 		switch (wValue) {
 		case USB_PORT_FEAT_LINK_STATE:
 			if (hcd->speed != HCD_USB3) {


