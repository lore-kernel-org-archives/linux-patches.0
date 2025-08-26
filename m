Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 223CA35335B;
	Tue, 26 Aug 2025 14:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218926; cv=none; b=L12uyUtcfkOD5CgbMpby+IBTM87GvWPJy6bIQgDcAk+T/CpEBGiTUPrmSI5qJyzdZBKaGvYZkl50QR7lhtdhln6bJitjfbZLL8iD2dTV544NUPSucrItzOg32gK9Dw5l1gquUXhBxAyQGee2wBhjS6wP6OdymNmEbVIstIrzYEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218926; c=relaxed/simple;
	bh=/+DrbinamiedXzwnRHAfn6Wt/YnG38r8NpDpqhN5HA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pJGgJrlcErrRqLzpjndN1OqXBL1y7Ul4+oZKX+BNYMY5fkAe/wpbDH0TcYtrfuvhLsbpHxSWXaAXnRE35g4fVuNnPpvDpJ5puUywYv5Zwtr0LtZjPUsln7EQAVjTVdAl2wr+X4NGnrqnRoF4S5+CqOGGBcnhUunmlYhVM6Q3Nho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uLrzm4YY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uLrzm4YY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67B98C4CEF1;
	Tue, 26 Aug 2025 14:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218925;
	bh=/+DrbinamiedXzwnRHAfn6Wt/YnG38r8NpDpqhN5HA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uLrzm4YYhJCpuWIkrbKhl8J7lm2IyYl4/WUqjwkA6a3jklaeUp75wdWUrzGqkPMmI
	 B14EPyIaBL6j+wF6xpA1qiq9+SN1IuYqCWvVOVp0YEcBONT9e6ZrZuWnerhGaUXrbJ
	 lsBzE1h+YKzLPqkWEh+wV+rJk634LFPNpbSU+ni4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Tao Xue <xuetao09@huawei.com>
Subject: [PATCH 5.4 155/403] usb: gadget : fix use-after-free in composite_dev_cleanup()
Date: Tue, 26 Aug 2025 13:08:01 +0200
Message-ID: <20250826110911.162542281@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

From: Tao Xue <xuetao09@huawei.com>

commit 151c0aa896c47a4459e07fee7d4843f44c1bb18e upstream.

1. In func configfs_composite_bind() -> composite_os_desc_req_prepare():
if kmalloc fails, the pointer cdev->os_desc_req will be freed but not
set to NULL. Then it will return a failure to the upper-level function.
2. in func configfs_composite_bind() -> composite_dev_cleanup():
it will checks whether cdev->os_desc_req is NULL. If it is not NULL, it
will attempt to use it.This will lead to a use-after-free issue.

BUG: KASAN: use-after-free in composite_dev_cleanup+0xf4/0x2c0
Read of size 8 at addr 0000004827837a00 by task init/1

CPU: 10 PID: 1 Comm: init Tainted: G           O      5.10.97-oh #1
 kasan_report+0x188/0x1cc
 __asan_load8+0xb4/0xbc
 composite_dev_cleanup+0xf4/0x2c0
 configfs_composite_bind+0x210/0x7ac
 udc_bind_to_driver+0xb4/0x1ec
 usb_gadget_probe_driver+0xec/0x21c
 gadget_dev_desc_UDC_store+0x264/0x27c

Fixes: 37a3a533429e ("usb: gadget: OS Feature Descriptors support")
Cc: stable <stable@kernel.org>
Signed-off-by: Tao Xue <xuetao09@huawei.com>
Link: https://lore.kernel.org/r/20250721093908.14967-1-xuetao09@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/composite.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -2241,6 +2241,11 @@ int composite_os_desc_req_prepare(struct
 	if (!cdev->os_desc_req->buf) {
 		ret = -ENOMEM;
 		usb_ep_free_request(ep0, cdev->os_desc_req);
+		/*
+		 * Set os_desc_req to NULL so that composite_dev_cleanup()
+		 * will not try to free it again.
+		 */
+		cdev->os_desc_req = NULL;
 		goto end;
 	}
 	cdev->os_desc_req->context = cdev;


