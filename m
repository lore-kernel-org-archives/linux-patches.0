Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A348F1DE4CD;
	Tue,  8 Oct 2024 13:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392517; cv=none; b=uv2oXgs+eaxbv0yaHxoIdMYnqLq8k6oxebNz9HuEXfRTtnGHi4RI3Z8JEOTW0saz+6vvJNu6HJ7d6L7PKxBzGImWxcixAMj6fLW+O8UfaxdGwnv/d0t1UuHMb3zQDK1vHvfLQO4niL04qtoRwuWhRcXb7K7pIzf42hPYJafHZ9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392517; c=relaxed/simple;
	bh=t7CmQsUWJzOHZPU/1v156No5PKEPZiDi1twdY1QcT7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jRK1iYS8KKsbdUtA6SAKw0wuC4R1bMYJgzHM4D659V3LyfYldPdCQ/w0K2qFWhAHrsjQ9PKd9du4TRrWA/enHH586UsisQL8ovktKV0fuxgqYEXQInoe1+b517NcgIy+atzS3LnqCWmBKwFJ/L5nkiqFpBVX6tBjSTK74BCL2xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nGBx3z98; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nGBx3z98"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EADCC4CEC7;
	Tue,  8 Oct 2024 13:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392517;
	bh=t7CmQsUWJzOHZPU/1v156No5PKEPZiDi1twdY1QcT7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nGBx3z98rTXe0ZWqRHbPLx9GQ9sBRIFFlVC2du/SbGl8DcLsFE3e9rapmg7CGBWT0
	 f9STAI1YwXHQVHa5H2zWzeL9jofiUGpMgiWmz2u9heTlDoNg1W9++IPyagViLkw0Zs
	 GonagkiKoHz2EixZCp4ICloSspXiKHW+c60RqdW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danilo Krummrich <dakr@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	David Rientjes <rientjes@google.com>,
	Christoph Lameter <cl@linux.com>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.11 411/558] mm: krealloc: consider spare memory for __GFP_ZERO
Date: Tue,  8 Oct 2024 14:07:21 +0200
Message-ID: <20241008115718.447737898@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danilo Krummrich <dakr@kernel.org>

commit 1a83a716ec233990e1fd5b6fbb1200ade63bf450 upstream.

As long as krealloc() is called with __GFP_ZERO consistently, starting
with the initial memory allocation, __GFP_ZERO should be fully honored.

However, if for an existing allocation krealloc() is called with a
decreased size, it is not ensured that the spare portion the allocation is
zeroed.  Thus, if krealloc() is subsequently called with a larger size
again, __GFP_ZERO can't be fully honored, since we don't know the previous
size, but only the bucket size.

Example:

	buf = kzalloc(64, GFP_KERNEL);
	memset(buf, 0xff, 64);

	buf = krealloc(buf, 48, GFP_KERNEL | __GFP_ZERO);

	/* After this call the last 16 bytes are still 0xff. */
	buf = krealloc(buf, 64, GFP_KERNEL | __GFP_ZERO);

Fix this, by explicitly setting spare memory to zero, when shrinking an
allocation with __GFP_ZERO flag set or init_on_alloc enabled.

Link: https://lkml.kernel.org/r/20240812223707.32049-1-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slab_common.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1273,6 +1273,13 @@ __do_krealloc(const void *p, size_t new_
 
 	/* If the object still fits, repoison it precisely. */
 	if (ks >= new_size) {
+		/* Zero out spare memory. */
+		if (want_init_on_alloc(flags)) {
+			kasan_disable_current();
+			memset((void *)p + new_size, 0, ks - new_size);
+			kasan_enable_current();
+		}
+
 		p = kasan_krealloc((void *)p, new_size, flags);
 		return (void *)p;
 	}


