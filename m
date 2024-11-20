Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E831AB539;
	Wed, 20 Nov 2024 12:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107517; cv=none; b=JZ1lGR45tqV5gSypYMxOhmfcEemw0gLM4aysstdlavfoJz5UoXV1ZrKIOadVf1fX0bU34uNM4wXjCvsBhmW0L52hrzz+UwLHb08HSZvuRezL98TXJork90AmC/zj+tNHiOm47mXrjrQSSFI0AEmAjXkezDZGBved2ZdWoQMzzdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107517; c=relaxed/simple;
	bh=UZuO0fDJhqCBm1MvFfoUJSJ0BBvpRJ7N9T9GnERd0Ow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tqlwz3/4G5YFjl0DoQ+1KhS69SYJUVbtiuCyGAQN5iNGATnRpdkZQX8GJzwGE7pwCmX4P5zpvAiwT7Fmkubl8/8489FfPMIwFFVQccbDFghKEPbn6EQteGGX4nEumFqrWUr/pK0m/Ipu6Sp/sTcLLCNk0E+/UbJMkvavwYhWsXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZlqffxxG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZlqffxxG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB4F9C4CED2;
	Wed, 20 Nov 2024 12:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107517;
	bh=UZuO0fDJhqCBm1MvFfoUJSJ0BBvpRJ7N9T9GnERd0Ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZlqffxxGgFfyafFJI7ul9D4qUDGrIXAUjau2HMnTOQY6Ota7ir9Ju7PBBoPHarbVw
	 c34xIqMT4uLJxpKJ0PpbZEiZGfJvRLBt9fqLdn1MYWK4FeNjLgGOBVVF1twtvyPVoB
	 +v7o2ZuFih++5RdBZJa2m2G5D0tnOEohLS346NxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Andrei Vagin <avagin@google.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	David Hildenbrand <david@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	=?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.11 046/107] fs/proc/task_mmu: prevent integer overflow in pagemap_scan_get_args()
Date: Wed, 20 Nov 2024 13:56:21 +0100
Message-ID: <20241120125630.716200451@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 669b0cb81e4e4e78cff77a5b367c7f70c0c6c05e upstream.

The "arg->vec_len" variable is a u64 that comes from the user at the start
of the function.  The "arg->vec_len * sizeof(struct page_region))"
multiplication can lead to integer wrapping.  Use size_mul() to avoid
that.

Also the size_add/mul() functions work on unsigned long so for 32bit
systems we need to ensure that "arg->vec_len" fits in an unsigned long.

Link: https://lkml.kernel.org/r/39d41335-dd4d-48ed-8a7f-402c57d8ea84@stanley.mountain
Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Andrei Vagin <avagin@google.com>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/task_mmu.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -2672,8 +2672,10 @@ static int pagemap_scan_get_args(struct
 		return -EFAULT;
 	if (!arg->vec && arg->vec_len)
 		return -EINVAL;
+	if (UINT_MAX == SIZE_MAX && arg->vec_len > SIZE_MAX)
+		return -EINVAL;
 	if (arg->vec && !access_ok((void __user *)(long)arg->vec,
-			      arg->vec_len * sizeof(struct page_region)))
+				   size_mul(arg->vec_len, sizeof(struct page_region))))
 		return -EFAULT;
 
 	/* Fixup default values */


