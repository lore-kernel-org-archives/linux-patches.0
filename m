Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C790C1922EF;
	Wed,  6 Nov 2024 13:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898497; cv=none; b=AAC6Kcqg7WphaThredTunatG0rMcuYoP7MceKYhcV4iz90xyTOH+VFdGmAUVRTP4CzsXcBI+mbUonZ53TfzDw3pnZ0DHyjBT8VblUYES67qdV0+Pj2PdxcZZSun7imcf7UjszwNtK+6BYIOf/VtzusyfX7gPiFev/hK0BBv6m1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898497; c=relaxed/simple;
	bh=UGHjZZ7AhAW2m6qR4JuCS27vqYYy++G22PRxwCDZhr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NZQDdUJ0eoltoOiwCLj5V03weP6mCpHllKo0s2cuGTFtMCY5UJlzBsvRaB7xgsksnBVVPShLa5Y8045hJfS/stNd5fL3uJ7vrijelWxfl5TzSkh2cWg9GYbIaCspRVYWsh2jBMCY6XUGMbGzMqXGo1iZHv5DeJpWPPXEOUTgrDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LKAHR8G+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LKAHR8G+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 508E6C4CED3;
	Wed,  6 Nov 2024 13:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898497;
	bh=UGHjZZ7AhAW2m6qR4JuCS27vqYYy++G22PRxwCDZhr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LKAHR8G+gGVsu+bcjFcu3Y5DumZE5MWqQAIcllGM7LOIVjfaN3DmMYXrSN636ZTf7
	 c4PM9sResmIZJgdB0o9hbkSksLoWvTRVMQdsuo4eKAV4AInK4tpEAHDp3SWtRrBubP
	 3aK6znRXyO8XdiTRrlnXbjFtt2u2gbfEjM9NbRJg=
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
Subject: [PATCH 5.4 257/462] mm: krealloc: consider spare memory for __GFP_ZERO
Date: Wed,  6 Nov 2024 13:02:30 +0100
Message-ID: <20241106120337.873902874@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1680,6 +1680,13 @@ static __always_inline void *__do_kreall
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


