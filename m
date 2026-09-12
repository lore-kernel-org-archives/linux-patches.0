Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A851DA62E;
	Sat, 12 Sep 2026 10:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208951; cv=none; b=GlFUcNMYflJehnU0C6eP+mS82tPhYq0oqqN0ecIYhAnj7DhE1hR+rECELbnhVL6qi85EE5lAnOjECr1sSh29QgAr274Lm0SCSnnRQcXQ4oLCmp3YMCIbR7xwe6AWXwhgWhnJJQrT4wkL7dj0EK/+nXXhDoTb543kJjPX+pq9u/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208951; c=relaxed/simple;
	bh=gZaFXI2KX1ueYDuP44g0D0nY1OOaTDh7eLftZ9fdJTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ag5T9SGd5gp2zJy0qYaSMkz/IlEJZbqhbj5LCi8mNJUPt99WGlyDH0H6v8d6YKCQMtyOuCguqYWq9/yBMqZalISjtkGtnGP0EbAjJE7HWFL+bSevHNZzlgZllLCilGn0l3fhjYFmQk+gLQUYZKhnMfROjexsYjtO6U8oUe/MN68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lk6LWbZm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lk6LWbZm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDEF61F00893;
	Sat, 12 Sep 2026 10:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208949;
	bh=882H2+T7OmyKHvRbwJXmqeVt8+fPjagMGWY2Q6N4ezM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lk6LWbZmn9wtMdIbTy7Jj6cHAes2a965zrU2h83WA4xdWwceJcTc210Rh3Uh3bjei
	 0eTO0DhZ//Rzu77E9VuCm1JtQAxYmmFPy9i+wG+IdaYaiLndvKqiSZTWyBEZS+AKdC
	 U+O/4+huullp9PjfDfzkRo1OXIUHjFKwre2p31qM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0721/1518] powerpc/crash: Fix possible memory leak in update_crash_elfcorehdr()
Date: Sat, 12 Sep 2026 08:48:10 +0200
Message-ID: <20260912065639.745819127@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 4cc4b586007fbbf8edba4f1d0849e9a06b0cf6c3 ]

In get_crash_memory_ranges(), if crash_exclude_mem_range() failed
after realloc_mem_ranges() has successfully allocated the cmem
memory, it just returns an error but leaves cmem pointing to
the allocated memory, nor is it freed in the caller
update_crash_elfcorehdr(), which cause a memory leak, goto out
to free the cmem.

Fixes: 849599b702ef ("powerpc/crash: add crash memory hotplug support")
Reviewed-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260729012948.2797865-2-ruanjinjie@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kexec/crash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kexec/crash.c b/arch/powerpc/kexec/crash.c
index e6539f213b3d1..a520f851c3a6b 100644
--- a/arch/powerpc/kexec/crash.c
+++ b/arch/powerpc/kexec/crash.c
@@ -502,7 +502,7 @@ static void update_crash_elfcorehdr(struct kimage *image, struct memory_notify *
 	ret = get_crash_memory_ranges(&cmem);
 	if (ret) {
 		pr_err("Failed to get crash mem range\n");
-		return;
+		goto out;
 	}
 
 	/*
-- 
2.53.0



