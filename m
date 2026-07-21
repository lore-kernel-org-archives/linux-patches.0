Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB9D30EF9A;
	Tue, 21 Jul 2026 19:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662426; cv=none; b=X+xmAN2ffE6QHDwC3kWwUHxiE+9Fpz4Zxnhe7LIdEOLBTb7lszX+svc/J7oG1LLkJzRhbztn4ya2h2M5Js8yLysAztWG/U9wxak58CPGyd8WBn8JXUlKomMh5RhkVWv7PX6yJ/SsJIUvdXijzGnM0OFHJiaB5UniqhSzAD643xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662426; c=relaxed/simple;
	bh=BQ+2Q/HNOxSB/jX76vh+dT9nW12ccCAw65RVu5HkAY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gIQMkM9lfShY5/R7rVA2jtses8eLlRxmk3r6dZqoZsbYt4tflt+0jpuW0BEl3eoen9tX8QT1XsGMGiq7rB/LKu6KvTPZBiDl1E0RI4Hm+BdnAUW5a8BCbu4+XXtA4ui2sl66ATkyRWAa4DlhbChztEDXp+FZCaE55qj/KmOlqf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XKZZ6lCL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XKZZ6lCL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F301F000E9;
	Tue, 21 Jul 2026 19:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662425;
	bh=NK2BwOO/Kzte6k0b3uzSTE9quhpHEr4NXPJzM8Xjmrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XKZZ6lCLOsr9AaG+lzsfvum8Nn31Caj1m1wUTFslSo4E0pLvKj19+Snq9fGTRYWQ4
	 8E0FlBai5qpJehkcppiqQB8ZO+HVQJb5AYjttzr2Q80iuWtxH/7i4uvUXZpMS8D7fd
	 l04mXHtf6BRvn32mjBoRLdQJzO61WkK5OU/X40bQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Seungjin Bae <eeodqql09@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0440/1276] usb: host: max3421: Reject hub port requests for non-existent ports
Date: Tue, 21 Jul 2026 17:14:43 +0200
Message-ID: <20260721152455.947604870@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
index 823dc61d31e86b..8fbbf9e195b0a4 100644
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



