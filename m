Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63BDC238D57;
	Tue, 22 Jul 2025 13:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192332; cv=none; b=c0H1VMXNYS4Tq77py1bH9Xl2JwXbGWc//saOak/O7POPXrGxdZRS/25XPr9LX6U7Bz3SYTlXyzk8AaJDxV2V2ZPqCTfNpFpzgOVSoEAbhZJFxiH3iUYbsB1i2xwHUM6DFwupuXTY5FYA0FCITzcQMPZ5PzDJMSQiVNSklrOFPwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192332; c=relaxed/simple;
	bh=9W+ML65FCce49LduQbYo7b9TbSo51XSEpAxtVbx9rNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xm7LVHBf47gS68ALkBx2hxGX9nPqAu2DcQB/1+Oeo3u6dq6kpdcjM9iy3G89m6QUhBF9JPhw6iuVDzt62JlKhCcHF8eEIS/BzhoUDvp0IaBTs9XCHMVqecBkV3GJZSRojimMUK/oB7M/bvTwshnXijk58YMprTM1CesJSicAU5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rXQt6XIj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rXQt6XIj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C159DC4CEEB;
	Tue, 22 Jul 2025 13:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192332;
	bh=9W+ML65FCce49LduQbYo7b9TbSo51XSEpAxtVbx9rNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rXQt6XIjIOZNdpyDwFjmHeYyfKi2LBFKNAZ4/KrTwPQjdEWVbmDNfmtwHI9KQpwZH
	 SzEfhzdfnRCVbwdl1JTQeSqJD8G3Ct2A9rUeLcSQquXF6/RisxP9t0YipeMZjsUjgj
	 3yPJlVj7X7k9zJvnnctzdzeBth7qkjh/YgbV029M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xinyu Liu <katieeliu@tencent.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.6 008/111] usb: gadget: configfs: Fix OOB read on empty string write
Date: Tue, 22 Jul 2025 15:43:43 +0200
Message-ID: <20250722134333.689989160@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
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

From: Xinyu Liu <1171169449@qq.com>

commit 3014168731b7930300aab656085af784edc861f6 upstream.

When writing an empty string to either 'qw_sign' or 'landingPage'
sysfs attributes, the store functions attempt to access page[l - 1]
before validating that the length 'l' is greater than zero.

This patch fixes the vulnerability by adding a check at the beginning
of os_desc_qw_sign_store() and webusb_landingPage_store() to handle
the zero-length input case gracefully by returning immediately.

Signed-off-by: Xinyu Liu <katieeliu@tencent.com>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/tencent_B1C9481688D0E95E7362AB2E999DE8048207@qq.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/configfs.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/gadget/configfs.c
+++ b/drivers/usb/gadget/configfs.c
@@ -1062,6 +1062,8 @@ static ssize_t webusb_landingPage_store(
 	unsigned int bytes_to_strip = 0;
 	int l = len;
 
+	if (!len)
+		return len;
 	if (page[l - 1] == '\n') {
 		--l;
 		++bytes_to_strip;
@@ -1185,6 +1187,8 @@ static ssize_t os_desc_qw_sign_store(str
 	struct gadget_info *gi = os_desc_item_to_gadget_info(item);
 	int res, l;
 
+	if (!len)
+		return len;
 	l = min((int)len, OS_STRING_QW_SIGN_LEN >> 1);
 	if (page[l - 1] == '\n')
 		--l;


