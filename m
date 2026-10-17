Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81FC13AA9F3;
	Sat, 17 Oct 2026 17:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256572; cv=none; b=P7jA/i0WKa4bf7nVk/bW/xtHcdFKhiNIfuUJZhMrjb0hTTFyeI213ayLtv1i7wk2blsBAu2hGxHGTtq7rrI3/AKKA5ogORfytwHarakd8r4cradORZj0q8F2Jc15AZnyyyz3w4UK8GfdxnImeJJopSeq+lLILBF0fs6T+DzNvjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256572; c=relaxed/simple;
	bh=1EDgHSFkIH1I3trX5FrMG6GZk+BPDck+SLNVWuCTOdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nIUEiu7fZjWQN+b7yk0PwoojYWR4Ee6TMe1LVyGT8/mHKGH22BOtVT+SUnimzLuB4qpGbOFmUaQIYC541VqDAsg1S1q6rjLw2TOBtoyf9Lhb2fZmBGhsN/I0+A1B3Sl1R28XlvQMWUs55Mu3UdKmGIRKlnE3olh/2dAFxOlnmJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2FbQLSyo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2FbQLSyo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D03121F000C4;
	Sat, 17 Oct 2026 17:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256571;
	bh=D0knYL9jBl82qhesrWchCftI7xN59+qn/rNp0dJbnHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2FbQLSyomi4jqB9BZjJp4CvduXSAGgECxcLd1Jn9ukt3I2cEJN9PqsT7ln3JWyul0
	 lDalrLIKS+KHr9yXWChxh3eLxIdnkX+DeU9d/0KIxcqaD9/Lr8ljEGOs1GyhrgbssP
	 OHJvP5568Lg6YTyLEOYfaNNwyNLOU7EAgewShUY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhaofeng Chen <zhaofeng.chen@certik.com>,
	Yuxiao Wang <yuxiao.wang@certik.com>,
	Alexander Graf <graf@amazon.com>
Subject: [PATCH 6.6 0253/1674] nitro_enclaves: fix use-after-free on SLOT_ALLOC failure
Date: Sat, 17 Oct 2026 17:42:05 +0200
Message-ID: <20261017160437.621079349@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


