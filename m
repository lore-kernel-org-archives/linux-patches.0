Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE2531E0E6;
	Tue,  2 Sep 2025 13:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820738; cv=none; b=qOUaqpw9LGcXyMFKfTVbDoQpHXKBWUkIm/5+pbrtf44RESArqSvHpN/k0PuPYYtDp+g0fwmcpP0waTCZG+mVXzi4Ed3QktZ1UqoNuiaJB20Wo1kW/jNPMsQ/YYCKOw/uUGAXq7SyBcflugPxXTNAW1X8rmPhaYtR9l1xo96M6yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820738; c=relaxed/simple;
	bh=O07XhuHXfhI6Sdg+M+KbKXyL+cPjm3zINrcksIiAntY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PJea1cfaRYAtvxgdHeswQLspQpauIxj+xxkyFlLUUqwGtFA1hM0x5FsGuPCxIujWaJXipxqdOB8SYVnQ678yMjSEDeSMgjIOGV87BfGlMe6tFDJ+ry4E8ipOmdUHJ4SERCj2oq2qdF5SCNHKE+gmrooa7bvwmNN/wk1dTPAc9t0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r/wUg2BR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r/wUg2BR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28D37C4CEF4;
	Tue,  2 Sep 2025 13:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820738;
	bh=O07XhuHXfhI6Sdg+M+KbKXyL+cPjm3zINrcksIiAntY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r/wUg2BRzLhNSK5+qkLZ/T9dhKT03B+asieV6wy0p0bOi2nBfLnx0Mr3/OX8O8bx/
	 Omzj+MssThC09YQRZ0NwGlHsx/Kk2ZBYqKGZgYYTvk3LPQKl2Z/qSQi4s5bfCz/tLn
	 AtPwrZRDcP1F0nlSnGGa0uxhgLlwAKOVE1ChLGiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minjong Kim <minbell.kim@samsung.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 5.10 22/34] HID: hid-ntrig: fix unable to handle page fault in ntrig_report_version()
Date: Tue,  2 Sep 2025 15:21:48 +0200
Message-ID: <20250902131927.503817037@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131926.607219059@linuxfoundation.org>
References: <20250902131926.607219059@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 


