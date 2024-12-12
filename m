Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F48B2135C1;
	Thu, 12 Dec 2024 15:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017915; cv=none; b=qp1b6j2i17ernl95nN4whv+ETy+eie2jfCFu6qZrM1xROkIUiY+jnlWhH6uYDudYR8qwGS8pdINdUnv1Bp3MDC/ls6rqeuhDTq7U+cjMf7NE0eoqLqzYSGhqqEYshrVChlnPIaaoKypDTxH14+t2Kgun156ePTuPgPz5Ixuzk70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017915; c=relaxed/simple;
	bh=ZcdjgIkHJFtLugoHfjYwEkPMgON7ktW0QKqp9JrOx+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cBLI2FFMup6A3RwVzg7P0NEWjsTbEqL3Q8qZ3795AQLVg8wlNJ+fD+FLCuoYXA5387naEFC1IXGDgMis8pHrUQp5OXIaa0VEzV9qGBgipOWTGrsV8YianMtz0EXkMVV2D1GkFmMGImwAAoBxDjLkgTjmXlEEwwFYWbmEYJzItQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2irnqQXj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2irnqQXj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCED9C4CECE;
	Thu, 12 Dec 2024 15:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017915;
	bh=ZcdjgIkHJFtLugoHfjYwEkPMgON7ktW0QKqp9JrOx+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2irnqQXj87OMFnJRbs0v011OgAcRtK1w0rFr2SFN4t1n6w3PUcBMP08o2VoTpjdox
	 mxCLQEGwgIvyTWq+iLF4CzMANeqjRj+YOQTvv4fz8WzRTKMCEjwFzIW/coBgnRtk+4
	 Oz4f2joDerG8l8rOCwGmu52qN3OOQZb4smBfEYu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 146/356] tracing: Fix cmp_entries_dup() to respect sort() comparison rules
Date: Thu, 12 Dec 2024 15:57:45 +0100
Message-ID: <20241212144250.409062561@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuan-Wei Chiu <visitorckw@gmail.com>

commit e63fbd5f6810ed756bbb8a1549c7d4132968baa9 upstream.

The cmp_entries_dup() function used as the comparator for sort()
violated the symmetry and transitivity properties required by the
sorting algorithm. Specifically, it returned 1 whenever memcmp() was
non-zero, which broke the following expectations:

* Symmetry: If x < y, then y > x.
* Transitivity: If x < y and y < z, then x < z.

These violations could lead to incorrect sorting and failure to
correctly identify duplicate elements.

Fix the issue by directly returning the result of memcmp(), which
adheres to the required comparison properties.

Cc: stable@vger.kernel.org
Fixes: 08d43a5fa063 ("tracing: Add lock-free tracing_map")
Link: https://lore.kernel.org/20241203202228.1274403-1-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/tracing_map.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/kernel/trace/tracing_map.c
+++ b/kernel/trace/tracing_map.c
@@ -845,15 +845,11 @@ int tracing_map_init(struct tracing_map
 static int cmp_entries_dup(const void *A, const void *B)
 {
 	const struct tracing_map_sort_entry *a, *b;
-	int ret = 0;
 
 	a = *(const struct tracing_map_sort_entry **)A;
 	b = *(const struct tracing_map_sort_entry **)B;
 
-	if (memcmp(a->key, b->key, a->elt->map->key_size))
-		ret = 1;
-
-	return ret;
+	return memcmp(a->key, b->key, a->elt->map->key_size);
 }
 
 static int cmp_entries_sum(const void *A, const void *B)


