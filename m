Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952231990D2;
	Thu,  6 Jun 2024 14:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683141; cv=none; b=Yq5ZrnIhDdDEZsAbJEaXBpDMmOQPP14xo446QHQeHHp3GvvzaqJ7Gui8XEslpf02O66QbEQa+JMqRb5KTgP/yZusN+RZfNySLvWPtIfkVyxmV+7xcTD8jwXAXVgaBi2NJVdoOXaYfk5fjBTf2M2nx8qsQ1GuUHYru0Rxx8jKtsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683141; c=relaxed/simple;
	bh=ZWQ0Wt7pPmErSLsyfyMF/COvKYYReALwKZy87UIaf3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cMHmEwQH5Uqe3IL57XcaAYhLKOPhkeT/2PuOnyfA3PgqxoHJhpuYOj7HcH9uFNUNY2EVhV2m5itaWXiuMPk++st8vrvPkgHF52ejLQvytKA+4JjnxmfTVUn9kvD9nO+/yeqxPqOTkRYyDVS3xbXqR2CrCHCb6OD7KNy69YU2ehs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ezdxVV9O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ezdxVV9O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 777C3C2BD10;
	Thu,  6 Jun 2024 14:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683141;
	bh=ZWQ0Wt7pPmErSLsyfyMF/COvKYYReALwKZy87UIaf3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ezdxVV9O4YWvUZezj8aoDdlPqGNsmEyGUwLB38JMcKpPJDYm9v9awEASmktPVu02X
	 nF+750/yPjVKLFTmuS69EuF3YI8HVHLtXjbSYQXZUcLrzPz/irZtnqdL1NZlBe+fJS
	 Kyxr7RKoGgJPemxcPtwH9n4KH7XXESHJa8ybI3Yk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brennan Xavier McManus <bxmcmanus@gmail.com>,
	Ammar Faizi <ammarfaizi2@gnuweeb.org>,
	Willy Tarreau <w@1wt.eu>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>
Subject: [PATCH 6.1 013/473] tools/nolibc/stdlib: fix memory error in realloc()
Date: Thu,  6 Jun 2024 15:59:02 +0200
Message-ID: <20240606131700.267215815@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -166,7 +166,7 @@ void *realloc(void *old_ptr, size_t new_
 	if (__builtin_expect(!ret, 0))
 		return NULL;
 
-	memcpy(ret, heap->user_p, heap->len);
+	memcpy(ret, heap->user_p, user_p_len);
 	munmap(heap, heap->len);
 	return ret;
 }


