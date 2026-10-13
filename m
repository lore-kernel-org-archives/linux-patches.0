Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F41D24F68C1;
	Tue, 13 Oct 2026 12:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895175; cv=none; b=a9OmOVQOXsscOsqKvhU8P9AlNzGi02atGDDmlsZ0jjm26FmCfSn0JBwbWe4WY8Gr7raBx2vy0J394Ud7jPr9giWZpRvKt+iV8t5u7BxYrq2Ho0URM2wgMyUzoortZTVVSC0pIxtuHS8I/5Wj/BfWLAloQ8hajsUzp12YW1Q4wyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895175; c=relaxed/simple;
	bh=ne55yw1gPQeaZG7203Drqn2KeeHjBzFtTIdK9nghapg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pPy1Xuba2XTStEkFfuM/S9Fc/mF8Mf8ImEtp+U0hE/n0ZqWGm/tJQfy+dXOd8WxMwgFZpa/TtD35OeqIkYY+kUm23ChuJheT4DYgN4aK+lzUpYUVRQQedcGdLK3caZ80wUDEu95ytJ5Ke6lZygZMEr3R+6LDO29qNza4WmKMQfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=msi19qPf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="msi19qPf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28A151F000FF;
	Tue, 13 Oct 2026 12:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895170;
	bh=/2JQhRBJVFHpLortFj6M4bFSxq4wLZqsVE2Q3eGunC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=msi19qPfz0UIcvpSdcM5PwMk/tZsKgTnJNiyHddVi6GTso1wYEMYa6cAfkMoisRW1
	 fu4QI8Tl17tpX21526K4GadEJlMcsWu9w8XeajU3bNGJRBV8QKIBa4afx6NwePmK9T
	 cHlry72Vj5UX7vEgYkmIJDUVkFx0WfIxWtepR8gs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhaofeng Chen <zhaofeng.chen@certik.com>,
	Yuxiao Wang <yuxiao.wang@certik.com>,
	Alexander Graf <graf@amazon.com>
Subject: [PATCH 6.12 131/497] nitro_enclaves: fix use-after-free on SLOT_ALLOC failure
Date: Tue, 13 Oct 2026 13:34:58 +0200
Message-ID: <20261013112911.000994096@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuxiao Wang <yuxiao.wang@certik.com>

commit 9bc184a2eda8b773c88ecbff934001ad649b9cc1 upstream.

When ne_create_vm_ioctl() fails the SLOT_ALLOC request after
anon_inode_getfile() has succeeded, the error path calls
fput(enclave_file) and then frees ne_enclave.

In normal userspace context, fput() defers the final __fput() via
task_work. ne_enclave_release() therefore runs after ne_enclave has
already been freed and dereferences ne_enclave->slot_uid, causing a
use-after-free: KASAN: slab-use-after-free in ne_enclave_release.

The enclave has no slot allocated and is not yet linked into the
enclaves list on this error path, so ne_enclave_release() is expected
to return early when slot_uid is zero. However, reading slot_uid
already accesses the freed object.

Clear enclave_file->private_data before fput() on the error path.
ne_enclave_release() then returns immediately when private_data is
NULL, leaving the ioctl error path as the sole owner of ne_enclave.
This is safe because the file has not been fd_install()'d yet.

Tested on an AWS EC2 m5.2xlarge with CONFIG_KASAN=y. Without the
patch, the reproducer triggers a KASAN slab-use-after-free on every
SLOT_ALLOC failure. With the patch, no KASAN report is produced and
the SLOT_ALLOC error is still returned. Normal enclave creation and
teardown are unaffected.

Fixes: 9c8eb50fe9e2 ("nitro_enclaves: Add logic for terminating an enclave")
Cc: stable@vger.kernel.org
Co-developed-by: Zhaofeng Chen <zhaofeng.chen@certik.com>
Signed-off-by: Zhaofeng Chen <zhaofeng.chen@certik.com>
Signed-off-by: Yuxiao Wang <yuxiao.wang@certik.com>
Reviewed-by: Alexander Graf <graf@amazon.com>
Link: https://patch.msgid.link/20260909124400.27857-1-graf@amazon.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/virt/nitro_enclaves/ne_misc_dev.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
@@ -1710,6 +1710,7 @@ static int ne_create_vm_ioctl(struct ne_
 	return enclave_fd;
 
 put_file:
+	enclave_file->private_data = NULL;
 	fput(enclave_file);
 put_fd:
 	put_unused_fd(enclave_fd);


