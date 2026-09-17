Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB994CA787;
	Thu, 17 Sep 2026 16:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660862; cv=none; b=EbkeOHOoMRINim2upfQnK+G1Kg0E3/ndyhd8mRw+dIHtiZjJ9W7yFIfgJsxWg8ZsPGq7dJnP02RjE6ljCvbEyIHEBDs/0YET9geheYSbkSYZ5RGDCFGa91cOVAm/0eSvleItO8Ne1t0fBW49LU2MxrUNepZ1b5JXqg/BIC+BsUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660862; c=relaxed/simple;
	bh=bfAXjmxOagsYU0mkW3uPpaV33gyH+TM5JI/nVQhak+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BCOmpwK7+ksXzeh159qsoQMe4Drlm61KVXZhkUwKlQpZFGs0iApVBCPJwB8c6NtIMEJ8pEwImW7HfR+ZYb2m989p8w2fmZMHQZ8Y6D7RXUsnONKQrad3m6F5N6k05qC8sicDyVDlbGsMl14s8PHICZ1JWcWfWKYfC+rQYHZT0xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pUoo03gI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pUoo03gI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 222671F000FF;
	Thu, 17 Sep 2026 16:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660861;
	bh=xZa2uk/6QsyKypxl95auJRb6aMBx1DxEMknCedy6Hgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pUoo03gIp6Ctfz4ZrQzrkuKPwXBKax6ANxWqphh/Lpif8Dh5uNSY4iWdvsYWO0AMy
	 kGY27rvyRSSAm0BDOYzjg+/Yqan3Juvu3wccSCghY11efM2mmXalKHLYCXxWOjRGC7
	 YxU8SkYpYt5biA1dbYuABsxXM3Dt1Nl6SLL6wF90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Naveen Krishna Chatradhi <naveenkrishna.chatradhi@amd.com>,
	Akshay Gupta <Akshay.Gupta@amd.com>,
	Griffin Kroah-Hartman <griffin@kroah.com>
Subject: [PATCH 7.2 732/733] misc: amd-sbi: Add null check for devm_kasprintf()
Date: Thu, 17 Sep 2026 16:17:20 +0100
Message-ID: <20260917151411.237093912@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Griffin Kroah-Hartman <griffin@kroah.com>

commit 1bb5c324b872c2e71fa1b12a5f59615b994501da upstream.

Add two checks for devm_kasprintf() errors in create_misc_rmi_device(),
returning -ENOMEM if the function failed.

Assisted-by: gkh_clanker_t1000
CC: Arnd Bergmann <arnd@arndb.de>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Naveen Krishna Chatradhi <naveenkrishna.chatradhi@amd.com>
CC: Akshay Gupta <Akshay.Gupta@amd.com>
Signed-off-by: Griffin Kroah-Hartman <griffin@kroah.com>
Link: https://patch.msgid.link/20260709132052.211683-1-griffin@kroah.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/amd-sbi/rmi-core.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/misc/amd-sbi/rmi-core.c
+++ b/drivers/misc/amd-sbi/rmi-core.c
@@ -581,6 +581,8 @@ int create_misc_rmi_device(struct sbrmi_
 							 GFP_KERNEL,
 							 "sbrmi-%x",
 							 data->dev_static_addr);
+	if (!data->sbrmi_misc_dev.name)
+		return -ENOMEM;
 	data->sbrmi_misc_dev.minor	= MISC_DYNAMIC_MINOR;
 	data->sbrmi_misc_dev.fops	= &sbrmi_fops;
 	data->sbrmi_misc_dev.parent	= dev;
@@ -588,6 +590,8 @@ int create_misc_rmi_device(struct sbrmi_
 							 GFP_KERNEL,
 							 "sbrmi-%x",
 							 data->dev_static_addr);
+	if (!data->sbrmi_misc_dev.nodename)
+		return -ENOMEM;
 	data->sbrmi_misc_dev.mode	= 0600;
 
 	return misc_register(&data->sbrmi_misc_dev);


