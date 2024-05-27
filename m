Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5FE2161936;
	Mon, 27 May 2024 18:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836357; cv=none; b=Sp4X7pgZ/oHhZ5PPNpYWw9d1teDq2+3199hzeLUi3R7u78B9hjv8+neH37nE7b+aKk7HA1E02iB3ZbJ2BKI1AiPctwfYj3spNvssJBSpTAUppq0n6OHjb9bDVMof47/JmFtkANTM9/MbELNg7zKoxRxFNY8/YgC+l2TjGO0yIxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836357; c=relaxed/simple;
	bh=gNHCS4trCU5zanBEn18ktXQhoGQsfUwt+llQyjULhWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XU4DJFAAPdKNKryDbGaB3bChol32UeiPOak8tJbygqTfsLpXAEewhyDAZ5IsCCPT+8JaNADGy+2AyWDdlfmaJNYeI8wWwSqa9vFoAylOKMaeQbr07XluzwFLA2WGGusfnA9ZBUnIpHYWQaTBZ+IM9Swrd7Wm+YhSuuDIqUzgwmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GK4qOJOk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GK4qOJOk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D00AC2BBFC;
	Mon, 27 May 2024 18:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836357;
	bh=gNHCS4trCU5zanBEn18ktXQhoGQsfUwt+llQyjULhWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GK4qOJOkxEa8I4hllK1I73GzyZyTnaeknFaelpp+f3C9UlDziwPK1/W/MWL5VY3N/
	 XIacHSeMWfu5NVVYLo6NprUQQ26D3Sm3D6lYYrVPUTyKPvOOxiaHJ/9Ab16N4mT2O1
	 /nFfLZzbROhX6jVzbg+o88SD+c1OWF0i+CMe9Teo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brennan Xavier McManus <bxmcmanus@gmail.com>,
	Ammar Faizi <ammarfaizi2@gnuweeb.org>,
	Willy Tarreau <w@1wt.eu>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>
Subject: [PATCH 6.9 022/427] tools/nolibc/stdlib: fix memory error in realloc()
Date: Mon, 27 May 2024 20:51:09 +0200
Message-ID: <20240527185603.815313831@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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


