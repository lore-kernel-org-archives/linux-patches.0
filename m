Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA6D2305062;
	Tue,  2 Sep 2025 13:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820797; cv=none; b=n6yOTWcf/zOGu4YRyrkwrSQs1J73XrOopgj7g1z09bxhAOIIBE1E7yAGibxG7vL/MFpEabrbFRh6rnMn3aXhWXzCgFYZw/FogZApar/OP4eeXKQjARuod2/w8MHMjgmiljmcGJRp67C4v2be8NySJUrz+ZKrsi7fILoEfSaCmWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820797; c=relaxed/simple;
	bh=IC/9yXzUind2LmlDF1qKR5GOtyhdUGzJl4Pb6RGyBbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZfFmbZzHc73w3U41QaYxUX7uP4b+cDwH9zIKqkHo8wtNbkqMAzj+yVk+6DDrRW/81aI3PZ1PrdFsoAgypzs4rl14wiFEJQbE8OdIq33BauZhSjnE6NpeP+YNtgB/brev8mswd+e+KSRqSuAntIHD1aWXfmQCYq6Q90DlQApkrQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FCc3DQng; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FCc3DQng"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF34BC4CEED;
	Tue,  2 Sep 2025 13:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820797;
	bh=IC/9yXzUind2LmlDF1qKR5GOtyhdUGzJl4Pb6RGyBbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FCc3DQngU5nK0Ob6DK/awT1ZQyTWaFY6FPcNymYl3fqxXSmqKyNx03A8nIi2LVd2J
	 E8sXhJQVx40AapqumqTpFn1HmijccUCKuv7hvXiIbtk8Ogx9s1PP9RCN/KXaMq5hj4
	 ADMkx1ItMCWmgS00DDtvJZh5N770Nv1yTsbXJ384=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minjong Kim <minbell.kim@samsung.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 5.4 20/23] HID: hid-ntrig: fix unable to handle page fault in ntrig_report_version()
Date: Tue,  2 Sep 2025 15:22:06 +0200
Message-ID: <20250902131925.537637682@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131924.720400762@linuxfoundation.org>
References: <20250902131924.720400762@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Minjong Kim <minbell.kim@samsung.com>

commit 185c926283da67a72df20a63a5046b3b4631b7d9 upstream.

in ntrig_report_version(), hdev parameter passed from hid_probe().
sending descriptor to /dev/uhid can make hdev->dev.parent->parent to null
if hdev->dev.parent->parent is null, usb_dev has
invalid address(0xffffffffffffff58) that hid_to_usb_dev(hdev) returned
when usb_rcvctrlpipe() use usb_dev,it trigger
page fault error for address(0xffffffffffffff58)

add null check logic to ntrig_report_version()
before calling hid_to_usb_dev()

Signed-off-by: Minjong Kim <minbell.kim@samsung.com>
Link: https://patch.msgid.link/20250813-hid-ntrig-page-fault-fix-v2-1-f98581f35106@samsung.com
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-ntrig.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-ntrig.c
+++ b/drivers/hid/hid-ntrig.c
@@ -144,6 +144,9 @@ static void ntrig_report_version(struct
 	struct usb_device *usb_dev = hid_to_usb_dev(hdev);
 	unsigned char *data = kmalloc(8, GFP_KERNEL);
 
+	if (!hid_is_usb(hdev))
+		return;
+
 	if (!data)
 		goto err_free;
 


