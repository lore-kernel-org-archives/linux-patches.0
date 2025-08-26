Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E743352FD2;
	Tue, 26 Aug 2025 14:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217140; cv=none; b=UI2bd/2IvAC1HJ5WdiBGjZsPcD2wAjDHmyFrb3uP44vqqO+BohVqDnyo66T4gl2QSw+MI2YYvkRqL4vbBzfYLb0DSD4ksbF6bgVAyVPMVCZX1jVgJIDOAa4f+foVwAvbVDmAflfHfVhwK0HWGtGgq3qXJNhzIiNA+KL/YCBsIpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217140; c=relaxed/simple;
	bh=xgMfy3fV7jCv+AxR53VpPRBsAuYkbigCTGgY4BdrjrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YEnmPa0KwKeSGMQDUXD7qr3e73Zrji3rMGOmhp7IrB/CrV0NSISnnOl0z/v5mrkWb+bSJojQcoXdE1jp6SzAkaldbUgnuruJ/DC4q9qnLBif6WCRMtwIZy//yxwAVKkRJcV3b4cHEFThW+vTe6E7fbNnDZ4ydv19E6c3VKS2Er8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HkZeoguf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HkZeoguf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADBFFC4CEF1;
	Tue, 26 Aug 2025 14:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217140;
	bh=xgMfy3fV7jCv+AxR53VpPRBsAuYkbigCTGgY4BdrjrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HkZeoguf2AHP75pU3ednJKmagPTqSZwlgrQmMuRk4ASEIIaY++PgfH0JU1qBULWVD
	 PA3bFeNauI675AfsWn7kSgigW3ASBvAHBFBCSnR+6rAtjBbklMvFvcwouIJOtG4Osl
	 9V9FBbbgkJzyrMCDeO2Eeb9WlR2ueJGFAzXBLCDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xinyu Liu <katieeliu@tencent.com>,
	stable <stable@kernel.org>
Subject: [PATCH 5.10 005/523] usb: gadget: configfs: Fix OOB read on empty string write
Date: Tue, 26 Aug 2025 13:03:35 +0200
Message-ID: <20250826110924.707774542@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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
@@ -855,6 +855,8 @@ static ssize_t os_desc_qw_sign_store(str
 	struct gadget_info *gi = os_desc_item_to_gadget_info(item);
 	int res, l;
 
+	if (!len)
+		return len;
 	l = min((int)len, OS_STRING_QW_SIGN_LEN >> 1);
 	if (page[l - 1] == '\n')
 		--l;


