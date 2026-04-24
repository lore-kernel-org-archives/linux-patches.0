Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988BB260566;
	Fri, 24 Apr 2026 13:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037533; cv=none; b=Orw04MIaxrL7kZCjF+Du0ZIapLuOg6QkIY0ZwNmBbhqGSLK9/fU+AwIe3JV1K2DKyW5gve6n8SYezeU9lUVs/CKmJCmM6XdNSuN74ZWXoYV+2Q7q/p7oQ5lygOu9Ki9dsgNgWh2Vk9RWiEUewarn9MrhT5L6Vv/tQV/SZyjYbjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037533; c=relaxed/simple;
	bh=U8BBvqFUS6b4wDGNZF2MA7tfrVQBlGinmFxtWMvHtM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=phOI2nnH3mQTE2rAH5xZAF+vuNh4EAaWSf9T4CaS/qjjGFhaGNGMiKVjepWZZtMqb1sViint6jcvMntvcQ5web6qbZe59lCe09mysvvyoWhNsnnJFmV5PU5RdXFJ5DfxoglKe/Z4/9v9dL5GDonOoqcYxG+E+Gn+ZCievceifkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AGrYw8t5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AGrYw8t5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0955BC19425;
	Fri, 24 Apr 2026 13:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037533;
	bh=U8BBvqFUS6b4wDGNZF2MA7tfrVQBlGinmFxtWMvHtM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AGrYw8t5Yr+GSMrmrqvkEvahPUXuCJYrnsg1DL0xFvBt7MosQo4SV3g3WQjSaThPS
	 G2aiiQQfyryzF01aiCmsouBSWHZbgeYGUn5+gOZ03XXcpUITsMSJnWSyccXwC8IB5y
	 zM0We8gj8SZv1pjdCzYAhEl1WQZFf5vpovb2UNGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Page <sam@bynar.io>,
	Qi Tang <tpluszz77@gmail.com>,
	Zijun Hu <nightu@northwestern.edu>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 7.0 15/42] fuse: reject oversized dirents in page cache
Date: Fri, 24 Apr 2026 15:30:40 +0200
Message-ID: <20260424132423.696405299@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132420.410310336@linuxfoundation.org>
References: <20260424132420.410310336@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Page <sam@bynar.io>

commit 51a8de6c50bf947c8f534cd73da4c8f0a13e7bed upstream.

fuse_add_dirent_to_cache() computes a serialized dirent size from the
server-controlled namelen field and copies the dirent into a single
page-cache page. The existing logic only checks whether the dirent fits
in the remaining space of the current page and advances to a fresh page
if not. It never checks whether the dirent itself exceeds PAGE_SIZE.

As a result, a malicious FUSE server can return a dirent with
namelen=4095, producing a serialized record size of 4120 bytes. On 4 KiB
page systems this causes memcpy() to overflow the cache page by 24 bytes
into the following kernel page.

Reject dirents that cannot fit in a single page before copying them into
the readdir cache.

Fixes: 69e34551152a ("fuse: allow caching readdir")
Cc: stable@vger.kernel.org # v6.16+
Assisted-by: Bynario AI
Signed-off-by: Samuel Page <sam@bynar.io>
Reported-by: Qi Tang <tpluszz77@gmail.com>
Reported-by: Zijun Hu <nightu@northwestern.edu>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Link: https://patch.msgid.link/20260420090139.662772-1-mszeredi@redhat.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/readdir.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/fuse/readdir.c
+++ b/fs/fuse/readdir.c
@@ -41,6 +41,10 @@ static void fuse_add_dirent_to_cache(str
 	unsigned int offset;
 	void *addr;
 
+	/* Dirent doesn't fit in readdir cache page?  Skip caching. */
+	if (reclen > PAGE_SIZE)
+		return;
+
 	spin_lock(&fi->rdc.lock);
 	/*
 	 * Is cache already completed?  Or this entry does not go at the end of


