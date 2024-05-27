Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A3D0168C4;
	Mon, 27 May 2024 19:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837464; cv=none; b=S3fhEzAMPK1MlxR4GDivxLXTZfUZQHCqcOpTiHJbalBsSQJi+9RNkXFrJhbCoXzHpojssaFGvxKYbNmFjCvHjplHlcQsBXvecLjrhmPCE35hwSo/Th6ln/7xsq4JJX59EFo0micr6pmackUo62CVTjp0ZyufRRNaQgx7vCS5mKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837464; c=relaxed/simple;
	bh=+S2fy+vyMIdX4DYkDCjMh5VNINPgWYEC27H5i2oH3ZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ACqh20AqQy70zGfqT30wIEYyhotWvmDclayMp/rhdPrlLYzFWzNzB3NEO2hGzK8ncP4sDktG/Rp5IbpatRrjDHDTzK82FctRVr2D8NqcJra5w4oKDrUf1vXCd40rPnLPAL8kRPpYKu231sWMsHoUvmqVzCJZIf5OqdTOOp8GvKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T9HlJF/c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T9HlJF/c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D82D5C2BBFC;
	Mon, 27 May 2024 19:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837464;
	bh=+S2fy+vyMIdX4DYkDCjMh5VNINPgWYEC27H5i2oH3ZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T9HlJF/cDwKn4N8LW+fclkUkk2FkgpdOBwQuorOY3JBAdRSf9cH5UYg81x3xU76s9
	 ngPc56XwKd9V7+fNErsFYQPm5d3qxmg7Mn/VtLRBUwhlLq5vnl/PbbAqGP5KguOuWr
	 221NlaoOjfWrgBBnRK7/WvsR1o7XBq3nfrs6eZa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brennan Xavier McManus <bxmcmanus@gmail.com>,
	Ammar Faizi <ammarfaizi2@gnuweeb.org>,
	Willy Tarreau <w@1wt.eu>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>
Subject: [PATCH 6.8 021/493] tools/nolibc/stdlib: fix memory error in realloc()
Date: Mon, 27 May 2024 20:50:23 +0200
Message-ID: <20240527185628.620704189@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brennan Xavier McManus <bxmcmanus@gmail.com>

commit 791f4641142e2aced85de082e5783b4fb0b977c2 upstream.

Pass user_p_len to memcpy() instead of heap->len to prevent realloc()
from copying an extra sizeof(heap) bytes from beyond the allocated
region.

Signed-off-by: Brennan Xavier McManus <bxmcmanus@gmail.com>
Cc: stable@vger.kernel.org
Reviewed-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Fixes: 0e0ff638400be8f497a35b51a4751fd823f6bd6a ("tools/nolibc/stdlib: Implement `malloc()`, `calloc()`, `realloc()` and `free()`")
Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/include/nolibc/stdlib.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/include/nolibc/stdlib.h
+++ b/tools/include/nolibc/stdlib.h
@@ -185,7 +185,7 @@ void *realloc(void *old_ptr, size_t new_
 	if (__builtin_expect(!ret, 0))
 		return NULL;
 
-	memcpy(ret, heap->user_p, heap->len);
+	memcpy(ret, heap->user_p, user_p_len);
 	munmap(heap, heap->len);
 	return ret;
 }


