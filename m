Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC5D433A8;
	Tue, 22 Jul 2025 13:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753191994; cv=none; b=TQV2TGuXl0VzUy5OGmd7GVsx1CJ02VHCdMhTkuFxTPtaE5V3mXKHbtBo3OXS7ko4waKJ49gt7NJ5Pn5v2MQKw9tUlsXqhbW2w538QDH8nJNHY2KJeUFD7FAQl0fvMKfyS0oLFwEwMP6riNbhquQ29pgqbi9jaTN0CIedkjaZR08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753191994; c=relaxed/simple;
	bh=j6I+g7mlNa2HfYX6lec4s9vkrMhmgeK/M5ddaZnBnSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kYMGX/SGN1eq2CvZp4IJ8OZAVz56dNIWN7T4e22KUSWA7/VGOIXEeb5tItpOZEe5MWD75hs2PQIfJSjJ6jQy1jEZbuIV6bJBIre1tsynGepi3WGvlKqnJF3ffxhaJNIE6Bt7NVEbQV17DPTataH5hbw+ZTV8KugJaX8WNOBEU9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nB7vKYwh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nB7vKYwh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E1BEC4CEEB;
	Tue, 22 Jul 2025 13:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753191994;
	bh=j6I+g7mlNa2HfYX6lec4s9vkrMhmgeK/M5ddaZnBnSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nB7vKYwhoYqCN5+GC4B/jJKvnZcpaPGwgPaTz7gzc407jVVf6Nx95KAByKWFsEAbX
	 4DK6KpSmg8lmPP9gemEdcMjZ0aR1D6GkOr6m7KiRSUG6bcYxQ9GncEAW85objnqeyS
	 7I+xn3Em1bN7Hk8xv4iNXMIVR9iAVsSnXEydgGZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xinyu Liu <katieeliu@tencent.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.1 05/79] usb: gadget: configfs: Fix OOB read on empty string write
Date: Tue, 22 Jul 2025 15:44:01 +0200
Message-ID: <20250722134328.581659771@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134328.384139905@linuxfoundation.org>
References: <20250722134328.384139905@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/usb/gadget/configfs.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/gadget/configfs.c
+++ b/drivers/usb/gadget/configfs.c
@@ -862,6 +862,8 @@ static ssize_t os_desc_qw_sign_store(str
 	struct gadget_info *gi = os_desc_item_to_gadget_info(item);
 	int res, l;
 
+	if (!len)
+		return len;
 	l = min((int)len, OS_STRING_QW_SIGN_LEN >> 1);
 	if (page[l - 1] == '\n')
 		--l;


