Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D970926656B;
	Tue,  8 Apr 2025 12:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115959; cv=none; b=Vn3XSvNDC5bG2xRnYB7z6MnC+iib1p2+ryKmF9mQmoOCEoHyww+7lhFOXyDnOyR6Zuu9eAT4B9mGetriurOI2f+Ag0DUl766fjd7ixwds9VauRL611l7PZPYY26Qlryjo06AExdZqx+LIynuq++llagjNckIrau8Hr6J6I+DCXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115959; c=relaxed/simple;
	bh=ljqYJxyEV7le+IKkbL/mhjUyDS6TAlQoQgpTpN08ac4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WQh+3e3CnosHM3hMdI6MRkKeMbugKLOwAmCiqGM6PzZTix4tkKhGbkAPhMlRgpfUqyhHVKmXLxDwelqtaa92DromaRSU6tVTx3qWxJhtQaZNYj+QXnR5BhmiYGu2xISF5YISbVeVVHG/0tyq+q2olCcsr9YNurxxWv1pkH2dby8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p5XnWO0y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p5XnWO0y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B5B8C4CEE5;
	Tue,  8 Apr 2025 12:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115959;
	bh=ljqYJxyEV7le+IKkbL/mhjUyDS6TAlQoQgpTpN08ac4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p5XnWO0yYY1itoZOq/GKMNmpSfhOsBnMyHtLhIL9HOmNoni7QGoWiFouGKu/+BRTE
	 4aSV/Q/HCy8vrNn4hP2c9Ry6Oc2UE7KGkMmAXJ3FK9n96hhcWutuj6/JLvozsRfo89
	 1o0ztuJbuoGIwX8gTgTmPxR56vtmqBhbKISzr+8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 169/204] io_uring/filetable: ensure node switch is always done, if needed
Date: Tue,  8 Apr 2025 12:51:39 +0200
Message-ID: <20250408104825.279264124@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

No upstream patch exists for this issue, as it was introduced by
a stable backport.

A previous backport relied on other code changes in the io_uring file
table and resource node handling, which means that sometimes a resource
node switch can get missed. For 6.1-stable, that code is still in
io_install_fixed_file(), so ensure we fall-through to that case for the
success path too.

Fixes: a3812a47a320 ("io_uring: drop any code related to SCM_RIGHTS")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/filetable.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/filetable.c
+++ b/io_uring/filetable.c
@@ -98,7 +98,7 @@ static int io_install_fixed_file(struct
 	*io_get_tag_slot(ctx->file_data, slot_index) = 0;
 	io_fixed_file_set(file_slot, file);
 	io_file_bitmap_set(&ctx->file_table, slot_index);
-	return 0;
+	ret = 0;
 err:
 	if (needs_switch)
 		io_rsrc_node_switch(ctx, ctx->file_data);


