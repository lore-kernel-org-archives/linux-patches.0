Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE106471265;
	Tue, 21 Jul 2026 18:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659021; cv=none; b=gzE/EPUQCkPypCbrMk2wjTrBxAj60kRXd7kvejEXAu8bA2NXPLqoZQAMVml0sXw6EIp8lWig+p8pSW7aMHLNGRKd34RBLjGzbprXsAfySPDD0pIm2wHMXeYvulXOMtq3RR3fIWMJ1zoBx7Mz3I8A4nuWwhdSCxPtDc3EdikC7Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659021; c=relaxed/simple;
	bh=LYzWbWce1lkiG0MUJHDneWfly1HgxggkcWNUplWwp3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kAmU9R39oUQMKYI4hS7NjlJMh9gsrLw0Ft5sULwM4dmAXNFa/ZxDLkjitwf1nfHJcj3a/5Rdy9iwU7Tp9fYLe42ixg0YfD6K9Y1rtT5IKq0K6mWeZTr7zDCZjtCunuQKcvXM8oNj3KqtOJYFp12UNGkvXRYGeoy01LIKtrmN6PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ad8n1Dlt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ad8n1Dlt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 449E01F000E9;
	Tue, 21 Jul 2026 18:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659019;
	bh=6QUhaLKExui1o68n7zXk0jHJOrIr/iOXzzs8tpaxP1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ad8n1DltRUfeumLq7gSc8vdfx9MSf8T6wdFkthpbIygnuXyxjBJrRfv6cZANrTlZg
	 kZh2Sd+ElUx9jG/GzPkfD7fiiu7Q7c1YYwWX3wMDsri3viRlexVgbzCrlrXXO2aE6y
	 o0v/3PZ1QQWWOTrO0siHnxL8DiMBitqmXz87bHXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Lizhi Hou <lizhi.hou@amd.com>
Subject: [PATCH 6.18 1363/1611] accel/amdxdna: Fix use-after-free in amdxdna_gem_dmabuf_mmap()
Date: Tue, 21 Jul 2026 17:24:39 +0200
Message-ID: <20260721152546.111079893@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit 63bbf9ac5dde2ba85e7b39d0a0b7d540e6252ba4 upstream.

When vm_insert_pages() fails, the error path calls vma->vm_ops->close(vma)
which internally calls drm_gem_vm_close() → drm_gem_object_put(),
releasing the GEM object reference acquired at the start of the function.
However, the close_vma label then falls through to put_obj, which calls
drm_gem_object_put() a second time on the same object.

If the first put releases the last reference, the object is freed and the
second put accesses freed memory, causing a use-after-free.

Fix by returning directly from close_vma instead of falling through to
put_obj, since the close handler already performs all necessary cleanup
including the object put.

Cc: stable@vger.kernel.org
Fixes: e486147c912f ("accel/amdxdna: Add BO import and export")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Lizhi Hou <lizhi.hou@amd.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260625113239.49764-1-vulab@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/amdxdna/amdxdna_gem.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/accel/amdxdna/amdxdna_gem.c
+++ b/drivers/accel/amdxdna/amdxdna_gem.c
@@ -374,6 +374,7 @@ static int amdxdna_gem_dmabuf_mmap(struc
 
 close_vma:
 	vma->vm_ops->close(vma);
+	return ret;
 put_obj:
 	drm_gem_object_put(gobj);
 	return ret;


