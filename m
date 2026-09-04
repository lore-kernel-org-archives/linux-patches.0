Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3205378838;
	Fri,  4 Sep 2026 06:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501659; cv=none; b=mnqewJFingbDWdopyW6BFZR8DBy94PqvOktqTOC+OSywNirMG4MmqgRorFEiO++atQg2tmsNxyk6rDA1kZR8rLx6FnxfyWqAnZK0f5YbbWmCYQg6SrERFGa9cv/dnEfYOp+X1Yj06CIkeThIvIvnToxe+XsjDurvHPifh1dA4kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501659; c=relaxed/simple;
	bh=tr9iDqHmflwDKSkWTA5acdGfoIE25TQbcrv/Sc2cTFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DR3z8Vq0ybYQL0lzL3DonxdCpcqkNeQBOaLEHszhDjIzhl4qTO+s92CFq4i0Ri7vSD7IEjMEYUElyXKoXeVnAMiEhdDDdy3Clz1BQtrUhdVxHRgxrLwd6cM43D0CK0LzbW47mIRo6cTg1YP3kJvaYFH8e7becFPtgk92pOLNUE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vcasUK2i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vcasUK2i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B321F00A3D;
	Fri,  4 Sep 2026 06:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501658;
	bh=Kvs2i0WhvZv5qrzm94vYbTiN9wTHiQozdeVVh7pCqao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vcasUK2iAIQ0a07aXmajOrNjk2VtwffdNQKL5780rgqPJ67UwftldFcCN8gb4hOUC
	 qkgieB06RoqM+AFJvqhMKn5xBwn0KEqGgU/N2CgzGmKhOxr0cq12dZZoPib++lU09L
	 jLKuS0Aw8HUPzoj4yhtrAQHshRZYT/5yvKkksdtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 444/552] io_uring/query: cap user size passed to copy_struct_to_user
Date: Fri,  4 Sep 2026 07:00:01 +0200
Message-ID: <20260904045800.688670362@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>

commit ba77efee1b95b4ad7559b1cdbe7cd7fa36dca95b upstream.

io_handle_query_entry() clamps hdr.size for the inbound copy_from_user()
but keeps the original user value as usize. copy_struct_to_user() uses
that usize and, when it is larger than the kernel result, clear_user()s
the trailing bytes.

As hdr.size is a __u32, a query can request nearly 4 GiB of zeroing,
including on the error path where res_size stays 0. The interface is
reachable without a ring via IORING_REGISTER_QUERY.

Reject sizes larger than PAGE_SIZE, as recommended for copy_struct_*
interfaces.

Fixes: c265ae75f900 ("io_uring: introduce io_uring querying")
Cc: stable@vger.kernel.org # 6.18+
Signed-off-by: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>
Link: https://patch.msgid.link/20260821103317.91437-1-acharyalaxman8848@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/query.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/io_uring/query.c
+++ b/io_uring/query.c
@@ -36,6 +36,9 @@ static int io_handle_query_entry(struct
 
 	if (copy_from_user(&hdr, uhdr, sizeof(hdr)))
 		return -EFAULT;
+	/* copy_struct_to_user() zeros up to usize bytes */
+	if (hdr.size > PAGE_SIZE)
+		return -E2BIG;
 	usize = hdr.size;
 	hdr.size = min(hdr.size, IO_MAX_QUERY_SIZE);
 	udata = u64_to_user_ptr(hdr.query_data);


