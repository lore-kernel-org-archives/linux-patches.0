Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 599732FE582;
	Tue, 12 Aug 2025 19:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026941; cv=none; b=KGrAQnRgBV84kaIuMUE2l7LY7ViwPYtPYpV0XAhxxF8kDTVy5OMv7Qi2aCroUQ+iSh/Y3jQQwr+Xqu+uldOgHI0D4WtrJlFUxZHjUWWStHbaPhyeVCmzfN7wxJtAI8f0nUkAhe4dAdej9XAXCpKJeIEEMGnuADqLJwIgJ0vbh/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026941; c=relaxed/simple;
	bh=NjIxeV+r6SvwbrnQKEtdYyyt/1Rje2bBga+Lsv7TNgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Snl8wCgpwHf2naTiUAQDdJwWNS4T9brutLfXMJ1dI4GB3cZS1pJT/OJhR6kNjWIBpywZ5GNLrizwNipKqcUh95NaBap8eXXzUwBeaMZ+TboPT1Y/Ykegqpog0ZidSmxmd3Oxkgdq4AR215A4HuhtJdqAhbVah8y2b65FYGW1m0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Za26lRHB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Za26lRHB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1210C4CEF0;
	Tue, 12 Aug 2025 19:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026941;
	bh=NjIxeV+r6SvwbrnQKEtdYyyt/1Rje2bBga+Lsv7TNgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Za26lRHBZqDSQLXurA6ghKGCkJ5TF2o4EegCmYO92TBkAXenUxFt3NAiAStAPEKiP
	 boUXP0NjlFncD1A1A6wSdw4kKFxK4MGQfiLUKJrCvjdwL23UN3Z5EvgqQ48AW9D/sZ
	 ENvi0x4WIg1GLMk+EMgHydGg2Nnzed5pVfi/dqUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Tao Xue <xuetao09@huawei.com>
Subject: [PATCH 6.15 479/480] usb: gadget : fix use-after-free in composite_dev_cleanup()
Date: Tue, 12 Aug 2025 19:51:27 +0200
Message-ID: <20250812174417.127111508@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2489,6 +2489,11 @@ int composite_os_desc_req_prepare(struct
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


