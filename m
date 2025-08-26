Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E96434DCCE;
	Tue, 26 Aug 2025 14:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217567; cv=none; b=HZWaNXGc6dtwu+SMsnzl+LHpgWeNI7ATksGANfd4WYZjdpB7w8jyYSvF9hE/i2DgoruGSjddG8ISJbWOFoJa4x9iJ3A1Si5QdZ6U4Vs1hgtS95hyrvE/DN0zTwVv7cWx7Q8KeB+XngTi+ZALHd9A57s2WaMTo9AKAhH49ieb16s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217567; c=relaxed/simple;
	bh=0ZwH3iIzIPnP5LbV+8xHq+q7vpt9XY/sKJwvxrvnZxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jnq3gAPF7lXQehpicFAs/OnlWihN4GhaL4Pk0wFG/5+2RQrDWX4rkpZo6FofQ3Are0F2fzk6EbCzxtnI62F1FjnmZi/KP/cqSZZFqsBdOO8glVWG8AsShASUbWzWJY3O2VrsoskqNmfMa6PjU7xP3WLkbEvuEqynWTtYgyfhncE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G1wfAjto; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G1wfAjto"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E333FC113D0;
	Tue, 26 Aug 2025 14:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217567;
	bh=0ZwH3iIzIPnP5LbV+8xHq+q7vpt9XY/sKJwvxrvnZxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G1wfAjtoaIJe8ckOh0WjLsvAy5kqrfK1BfSb43wRAenEhUbwPapJRQXlDVVmIss3t
	 O3eGv6s7VY2+K0jKSh1zs4J8WV883+QkXbBPEddouOeb9N2tCYQq7NAPcguNJtoTdl
	 TuIRxk6nk7R95bTut2cLOinUbIHsw3Hxt3tVjMdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Tao Xue <xuetao09@huawei.com>
Subject: [PATCH 5.10 191/523] usb: gadget : fix use-after-free in composite_dev_cleanup()
Date: Tue, 26 Aug 2025 13:06:41 +0200
Message-ID: <20250826110929.161728252@linuxfoundation.org>
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


