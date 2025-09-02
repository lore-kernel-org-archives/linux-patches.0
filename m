Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA4B30C343;
	Tue,  2 Sep 2025 13:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820308; cv=none; b=a91Va//TIFnV6lp8Q0nrYy19lzSbDLJrsxenu0ywo//9hg4XfWqEYaVe8x/zqK/yMcTTwZEolGnBVxrNw3FFuNxuoY0hfu7KJkgxVsyfeyYa6hFrjlKfR9h5HTqynSLQeigbloSpU70vXzodxkJ4rNG1/D9zDS/BKfvB+uFXFp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820308; c=relaxed/simple;
	bh=QhA1jSh0gtNdVK0HaS4dv1e/fG5KWrFHrpIQYDhF128=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=moJLjVpTmvFuqQRYVGB/pwseAbYjAPsArYFx88yoWBwHw/porM6lPpYKCXFmFywjKjIRgeImBc4y8My/9pib45BMiNHXu21emX34o4Za1JrqrYJrEiR23piT9cFV3d+s93mNT8utnXuOE9ei0uylX/rcC112wdNL9oGWZiIOD90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ttMInR9k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ttMInR9k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2D64C4CEED;
	Tue,  2 Sep 2025 13:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820308;
	bh=QhA1jSh0gtNdVK0HaS4dv1e/fG5KWrFHrpIQYDhF128=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ttMInR9kT+ragfht8rZ9Bh0BU6matSH84uyXxXVsCLjM675oZtw884o1lkkMDcPu9
	 Ngca+M0HtGihCqrSustIwBzS2Ka94PMiC8JqKuL9eqzt/6YK5yHc5UTTajCC4Z152c
	 1sj3j1qcWLbEOaMpm0S2Z/GiYClU8uO7x2iqk4pw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minjong Kim <minbell.kim@samsung.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.6 63/75] HID: hid-ntrig: fix unable to handle page fault in ntrig_report_version()
Date: Tue,  2 Sep 2025 15:21:15 +0200
Message-ID: <20250902131937.589761701@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131935.107897242@linuxfoundation.org>
References: <20250902131935.107897242@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


