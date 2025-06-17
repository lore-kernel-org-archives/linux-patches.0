Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C4CB2ECEA3;
	Tue, 17 Jun 2025 15:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175179; cv=none; b=j/CHj4umoq2k8XUPbWLAQFLEqh9mENY09mOVdPT056utVf8uh4+FriytCReBZD4hLyKhZ33WX6mwxcVi6yfzXBjb6OPUeKkWH8YX30BWrzaxSWG9d0StjL4OdStPGnUV7hubdAkbalugpyrpWRizcN41C+tn3T5ubiPo4MzC5B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175179; c=relaxed/simple;
	bh=depARD+/Lp9PuuYWz/SrMywp67ZsuGXUulpl40lIsdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fyyPDYe1565rf68/GIfAt7a07x9QctjbsUq4EDam0Jl7D3n/frOl8OZQSj6lK5XTOmTjfws/egSjbDFVuHVeH5F1sONQsvEHeXicEyiSgpyFTxumKQNccIia0hLyEfE6l48yZxo7eBFSsjw9RCuDRw7PtvIga6q5YXB0s8k4N78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jxrqLvy1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jxrqLvy1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C13D3C4CEE3;
	Tue, 17 Jun 2025 15:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175179;
	bh=depARD+/Lp9PuuYWz/SrMywp67ZsuGXUulpl40lIsdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jxrqLvy1upIUMeo7vPNCKkcXHCFhXxrLorBy0qZDzf4cBhp+mWICR2PKM9c71Q6AW
	 GhmI3i/76jnEYnou4wP1NEjJA1bGBTCofHomIX7bGRwKxZgc9S2UENRU0ZmQtVaSBW
	 OM6MkxmuqZlBZm5eequHpx+M4R8r8Ea38fq+QEU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Willy Tarreau <w@1wt.eu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 060/780] tools/nolibc: properly align dirent buffer
Date: Tue, 17 Jun 2025 17:16:08 +0200
Message-ID: <20250617152453.943387818@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 0e75768ba24d669dbf76530e21fd51cfe2fbd2a9 ]

As byte buffer is overlaid with a 'struct dirent64'.
it has to satisfy the structs alignment requirements.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Fixes: 665fa8dea90d ("tools/nolibc: add support for directory access")
Acked-by: Willy Tarreau <w@1wt.eu>
Link: https://lore.kernel.org/r/20250419-nolibc-ubsan-v2-4-060b8a016917@weissschuh.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/dirent.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/include/nolibc/dirent.h b/tools/include/nolibc/dirent.h
index c5c30d0dd6806..946a697e98e4c 100644
--- a/tools/include/nolibc/dirent.h
+++ b/tools/include/nolibc/dirent.h
@@ -7,6 +7,7 @@
 #ifndef _NOLIBC_DIRENT_H
 #define _NOLIBC_DIRENT_H
 
+#include "compiler.h"
 #include "stdint.h"
 #include "types.h"
 
@@ -58,7 +59,7 @@ int closedir(DIR *dirp)
 static __attribute__((unused))
 int readdir_r(DIR *dirp, struct dirent *entry, struct dirent **result)
 {
-	char buf[sizeof(struct linux_dirent64) + NAME_MAX + 1];
+	char buf[sizeof(struct linux_dirent64) + NAME_MAX + 1] __nolibc_aligned_as(struct linux_dirent64);
 	struct linux_dirent64 *ldir = (void *)buf;
 	intptr_t i = (intptr_t)dirp;
 	int fd, ret;
-- 
2.39.5



