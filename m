Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54AE2198E8F;
	Thu,  6 Jun 2024 14:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683099; cv=none; b=S/vF5QeFVsD+0EDw5/C6xd2mQbQbubFjn2XlJNqZ9tq6ZlW5SbgrybuR9O3Omk7wdgx4B/kWygDMWUswzVVoY6xIm+O9v6djuEZHHsa8ebdi/KKXO0wJN0XC9duPvkl6eysWSahm3DSpl/g4yR11A7FqShuw+btRFkctqS4cyvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683099; c=relaxed/simple;
	bh=EZoimYmmBQOIHeFuVQwb82brNzVg6c+oDKi/VZ1BPcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Uu6yrlA8UqNzxJN0Cn1i+RvxG7G1/dgWBpMeXNNZmEIU/cXfcuWq6P5mdcFoH31F6ITgieKEJrRcXWbXw/jYkiURlDtXYhT4LIh5/Bzl1IsW/FkEIO13En2H76i+hs27DUYAXkKaoTHkxqRamZQMskGJ2VaUICuOd9MTzjAyqgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GfcaB4uC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GfcaB4uC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31B8CC32781;
	Thu,  6 Jun 2024 14:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683099;
	bh=EZoimYmmBQOIHeFuVQwb82brNzVg6c+oDKi/VZ1BPcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GfcaB4uC6IWQAFNDchxdDZEnRy0MsKI4ta8cYGASGCHS0CTT7/iYpqRSug93h/J6q
	 1HZ4hjKYeE8EhE72UyiItNpR3J1B26saQJa0PARI72yWXrbxZyBGsLWgnfNQnlqPXq
	 ER5AYivStOW9m60gkueTnX7CSAf13jxBwEzgsDF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brennan Xavier McManus <bxmcmanus@gmail.com>,
	Ammar Faizi <ammarfaizi2@gnuweeb.org>,
	Willy Tarreau <w@1wt.eu>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>
Subject: [PATCH 6.6 016/744] tools/nolibc/stdlib: fix memory error in realloc()
Date: Thu,  6 Jun 2024 15:54:48 +0200
Message-ID: <20240606131732.971576289@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


