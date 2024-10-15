Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6BC1D5144;
	Tue, 15 Oct 2024 13:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998119; cv=none; b=tzc0sHQ9DD3ZmN0duagYS5fQODjeM/BUtw4XCG/xeqVLatYVA9Z80j72UtE6mNUQGyCC402lHqNtTtW0Pl/icFzlCRJSDPzS7KtuwahUu1a6cda3hmtPPtjZ4jSj1rYxtS3s1FxJbuMKQiJrrGbTIh19k6ChY3VlqYwdC7N7Qco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998119; c=relaxed/simple;
	bh=RQWxDPVExIuO59pMtv5mfVOKod9f7GXQ9YAkaKMS2Og=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bDUvbG7H1IUYQpmcIkSnDuLCZ0jfvY0NDJN3Vd2gePsjKr94m3cBVVUn/eDtS4ZKXUGEg4JGKAHmNNdWMayvoAA+Cdl6cVMdHxSdT07Pqoxf01n7wXq5JTCv3xfenEUXGJ3D4e2nNAgZIPHDnlZSCzNM18vlCNxuKthLaxs+39o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sXbA9OlF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sXbA9OlF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB7A8C4CEC6;
	Tue, 15 Oct 2024 13:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998119;
	bh=RQWxDPVExIuO59pMtv5mfVOKod9f7GXQ9YAkaKMS2Og=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sXbA9OlF8ivOYPXHju0o84keaBgAAiM2iHGv63H9RAOAg2bI7rNPex279MCwsOUrc
	 KWSNnC9qIWe+T35CfdyElJ6rAX1XkwUH3WPvSsMKSCL6S3tuMhvuDy0ySxR1/qnI2j
	 0d66+Rj9bZb4OjI+WRGdNql14R0T+A4Tb7DnTd7U=
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
Subject: [PATCH 5.10 385/518] mm: krealloc: consider spare memory for __GFP_ZERO
Date: Tue, 15 Oct 2024 14:44:49 +0200
Message-ID: <20241015123931.829546036@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1072,6 +1072,13 @@ static __always_inline void *__do_kreall
 	ks = ksize(p);
 
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


