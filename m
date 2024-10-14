Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39CE1AE01F;
	Mon, 14 Oct 2024 15:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919376; cv=none; b=sfl4oO8WEKMnWdOS9dOd4qvh5dMjA/waxU61edeuQ5tB2KBEY+bP1V4OCi1ByJ3dy8zZ9e21lO8rfhLByw4pq4M7KHC9K43wEoqYRiqM3nn5X/eoL+nnN4rTfYxTZUIe9beVbRVqtDrFYS4QdHcUEB00aTgVBS+aA9OYyNfyT8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919376; c=relaxed/simple;
	bh=oPk4u5WjiJ/ecqFm/sdGg/MMdzhuuEDK/ft7rgI06EM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mCNLmwvUkNtjyLIgVHyjYAAZAZerJXolKHxX+CIZl1ovAE3uF6ppLTqZBuR63sHRl7MGcv6meHzfyAaXnlu7o9d+fkstL23F4x9oLgiDFFGMcuZ5R57PwOSdbamZuq4+iYNI7p2X/Gxk/+AUjH6ace0hyV7+/i6qOmKlWMXoAsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=INpsGBeG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="INpsGBeG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE411C4CEC3;
	Mon, 14 Oct 2024 15:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919375;
	bh=oPk4u5WjiJ/ecqFm/sdGg/MMdzhuuEDK/ft7rgI06EM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=INpsGBeGKj5pdvPJ70C7WIeVgPkTiR37k9Gmyh5jKHRS60KCwYrH34xK3/ySA5CNi
	 uZX31IknLJmWclIN2vBrMjUNYYaVT8e605nUp8rroOiMA9fGUA7L2wKp8sy7xpM8b+
	 82GGizMeYPircd9sOIZF05szSSGvQwZoQvv0nkB4=
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
Subject: [PATCH 6.1 565/798] mm: krealloc: consider spare memory for __GFP_ZERO
Date: Mon, 14 Oct 2024 16:18:39 +0200
Message-ID: <20241014141240.194585562@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1322,6 +1322,13 @@ __do_krealloc(const void *p, size_t new_
 
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


