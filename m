Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A943B19BC;
	Fri,  4 Sep 2026 05:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499971; cv=none; b=qnBilK1lqTZMGBK/3KGYs59BKTVV45s0iKlirERniOm9wwI7duQkP8yq8oq0kemT+N+LFWiedqfNbayKOJYwCXt3wPf5GU190/B1xAnzX79H+QKBLoZfe8M9NWbKhGVmQsxO/7dFqop8/xo5NiDEPy7NrH9k5Ia85/oZK0sYlDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499971; c=relaxed/simple;
	bh=k8/Pq+XJ/AHUOUQ/MupnnRE55z4PtbCdXABwGCoifSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F91V51TA0JiIUv8Mj9ul2LrexxgGGPkyZNRLk86MS4Jl1G3bB2Vz1WGhNDGbo49Enu60hMAYQ+kT21CNBuH34J2duQkHwDthovJTF+NyR+f33pwlP0X+aFIUuh9Dtx5kaM0rS6E8q+7eCKQwcMw07RdOyNTgBraJ1Z3veYSqnpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aT3Jvm2w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aT3Jvm2w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEF9A1F00A3D;
	Fri,  4 Sep 2026 05:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499970;
	bh=2RUUjgfCUfCff9wnUJSw7CHFJt7gkZQqetnX+VZkj90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aT3Jvm2wi2k7d5CyvqsYfq/EyMiMFK5lzlVsWrUGIUBHkcF289LRdw4IlHrojBkEg
	 +lxwRfSiAYVX1ikmKKtt8QbasDLgsbXHmj/1SxZ5b4uE4OQZ7mOdZQ6NM+jzJLMkCC
	 I3J3wvGtnjUykx+9zQ+O5zDga6FYw0cwQpBaP7N8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 588/713] io_uring/query: cap user size passed to copy_struct_to_user
Date: Fri,  4 Sep 2026 06:59:16 +0200
Message-ID: <20260904045816.998714757@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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
@@ -76,6 +76,9 @@ static int io_handle_query_entry(union i
 
 	if (copy_from_user(&hdr, uhdr, sizeof(hdr)))
 		return -EFAULT;
+	/* copy_struct_to_user() zeros up to usize bytes */
+	if (hdr.size > PAGE_SIZE)
+		return -E2BIG;
 	usize = hdr.size;
 	hdr.size = min(hdr.size, IO_MAX_QUERY_SIZE);
 	udata = u64_to_user_ptr(hdr.query_data);


